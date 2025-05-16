#################################################################################
#                                                                               #
# This script is used to clean the data from the National Malaria Indicator     #
# Survey 2019/2020.                                                             # 
#                                                                               #
# Author : H. Langet                                                            #
# Date   : 2025-15-05                                                           #
#                                                                               # 
#################################################################################

###########################
# Load required libraries #
###########################

# Load the tidyverse collection of packages for data manipulation and visualization
library(tidyverse)

# Load the haven package to read and work with Stata, SPSS, and SAS data files
library(haven)

# Load the skimr package to quickly summarize and explore data frames
library(skimr)

###################################
# Load and clean the village data #
###################################

raw_village_df <- readr::read_csv("../data/village info.csv",
                                  show_col_types = FALSE)

# Display the structure of the dataset (column types and preview of data)
str(raw_village_df)

# Generate a summary of the dataset (e.g., type, missing values, distributions)
skimr::skim(raw_village_df)

# Inspect unique values in the 'urban' variable to better understand its current format
unique(raw_village_df$urban)

# Clean and standardize the 'urban' variable by recoding different representations
clean_village_df <- raw_village_df |> 
  dplyr::mutate(urban = dplyr::case_when(
    tolower(urban) == "urban" ~ "1",     # Treat "urban" (case-insensitive) as "1"
    urban == "yes"            ~ "1",     # Treat "yes" as "1"
    urban == "no"             ~ "0",     # Treat "no" as "0"
    urban == "not urban"      ~ "0",     # Treat "not urban" as "0"
    .default                  = urban     # Leave all other values unchanged
  ))

# Convert selected variables to factors for proper categorical handling
clean_village_df <- clean_village_df |> 
  dplyr::mutate(
    urban      = as.factor(urban),         # Convert 'urban' to a factor (e.g., urban vs rural classification)
    vcode      = as.factor(vcode),         # Convert 'vcode' (village code) to a factor for categorical use
    village    = as.factor(village),       # Convert 'village' name to a factor
    altitude_m = as.numeric(altitude_m)    # Ensure 'altitude_m' is numeric for any calculations or plotting
  )

# Summarize the cleaned dataset to check structure, types, and distributions
skimr::skim(clean_village_df)

###########################################
# Load and clean the household-level data #
###########################################

raw_household_df <- haven::read_dta("../data/hh-data.dta")

# Display the structure of the dataset (column types and preview of data)
str(raw_household_df)

# Generate a summary of the dataset (e.g., type, missing values, distributions)
skimr::skim(raw_household_df)

# View metadata and variable labels
labelled::generate_dictionary(raw_household_df)

# Convert 'date_final' column to Date format and store in 'date_clean'
# Then remove the original 'date_final' column since it is no longer needed.
clean_household_df <- raw_household_df |>
  dplyr::mutate(date_clean = as.Date(date_final, format = "%B %d, %Y")) |>
  dplyr::select(-date_final)

# Apply additional transformations to relevant columns
clean_household_df <- clean_household_df |>
  dplyr::mutate(
    regcode = as.factor(regcode),         # Region code as categorical variable
    province = as.factor(province),       # Province as categorical variable
    villagecode = as.factor(villagecode), # Village code as categorical variable
    hhid = as.factor(hhid),               # Household ID as categorical variable
    mosquitonet = as.factor(mosquitonet)  # Mosquito net ownership as categorical
  )

# The variable **regcode** is coded on 4 values: 0 = 0 Southern; 1 Highlands; 2 = 2 Momase; 3 = 3 Islands
# We observe that this variable has 5 values in the dataset. 
# To understand what is happening we look at other location information available in the dataset

table(clean_household_df$province, clean_household_df$regcode)

# we notice that all problematic HH interviews belong to the East Sepik region (code 2)
# So that we reallocate these interviews to this region.
clean_household_df <- clean_household_df |>
  dplyr::mutate(regcode = dplyr::case_when(regcode == "20" ~ "2",
                                           .default        = regcode))

# Summarize the cleaned dataset to check structure, types, and distributions
skimr::skim(clean_household_df)

########################################################
# Merge the household-level data with the village data #
########################################################

# Check number of household records before merge
nrow(clean_household_df)

# Merge village information into household data using village codes
household_with_village_df <- clean_household_df |>
  merge(clean_village_df,
        by.x = "villagecode",   # Column in household data
        by.y = "vcode",         # Corresponding column in village data
        all.x = TRUE)           # Keep all household records (left join)

# Check number of records after merge to ensure consistency
nrow(household_with_village_df)

# Create useful variables for analysis
household_with_village_df <- household_with_village_df |>
  dplyr::mutate(month = lubridate::floor_date(date_clean, unit = "month"),
                altitude = dplyr::case_when(altitude_m < 1200                      ~ "<1200",
                                            altitude_m >= 1200 & altitude_m < 1600 ~ "1200-1600",
                                            altitude_m >= 1600                     ~ "1600+",
                                            .default                               = NA),
                altitude = as.factor(altitude),
                urban = factor(urban, levels = c("1", "0"), labels = c("Urban", "Rural")),
                selected = 1,
                interviewed = ifelse(is.na(mosquitonet), 0,  1))

############################################
# Load and clean the individual-level data #
############################################

raw_individual_df <- haven::read_dta("../data/practical_individual.dta")

# Display the structure of the dataset (column types and preview of data)
str(raw_individual_df)

# Generate a summary of the dataset (e.g., type, missing values, distributions)
skimr::skim(raw_individual_df)

# View metadata and variable labels
labelled::generate_dictionary(raw_individual_df)

clean_individual_df <- raw_individual_df

#######################
# Save clean datasets #
#######################

# Save household-level data merged with village info
haven::write_dta(household_with_village_df, "../data/cleanR_household_with_village.dta")

# Save individual-level data merged with household-level data
# ...