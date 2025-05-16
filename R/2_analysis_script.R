#################################################################################
#                                                                               #
# This script is used to conduct the required analysis using the data from the  #
# National Malaria Indicator Survey 2019/2020.                                  # 
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

# Load the gtsummary package to create publication-ready summary tables
# Useful for descriptive statistics and model result tables with clean formatting
library(gtsummary)

#############
# Load data #
#############

# Load the (clean) household-level data 
household_df <- haven::read_dta("../data/cleanR_household_with_village.dta")

# Load the (clean) household-level data 
# ...

#################
# Shell table 1 #
#################

#################
# Shell table 2 #
#################

household_df |>
  dplyr::select(altitude) |>
  gtsummary::tbl_summary(label = list("altitude" ~ "Altitude (m)"))

#################
# Shell table 3 #
#################

##############
# Question 1 #
##############

# How many household interviews were conducted per month? 

count_df <- household_df |>
  dplyr::group_by(month) |>
  dplyr::count()

# Modify this figure

# Step 1: Add color to bars
# Step 2: Add data labels to the bars
# Step 3: Adjust the y-axis limits
# Step 4: Improve x-axis date formatting
# Step 5: Add labels to the axes
# Step 6: Highlight year transitions with a vertical line
# Step 7: Apply a minimal theme
# Step 8: Customize theme elements for cleaner look

count_df |>
  ggplot(mapping = ggplot2::aes(x = month, y = n)) +
  ggplot2::geom_bar(stat = "identity")

##############
# Question 2 #
##############

# Are members of households that own at least one long-lasting insecticidal net (LLIN) less likely to be infected with malaria parasites?

##############
# Question 3 #
##############

# Does prevalence of Plasmodium vivax and P. falciparum differ between altitudinal zones?

##############
# Question 4 #
##############

# What is the sensitivity and specificity of RDTs compared to microscopy (any species)?
