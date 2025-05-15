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

#############
# Load data #
#############

# Load the (clean) household-level data 
household_df <- haven::read_dta("../data/cleanR_household_with_village.dta")

# Load the (clean) household-level data 
individual_df <- haven::read_dta("../data/cleanR_individual_with_hh_and_village.dta")

#################
# Shell table 1 #
#################

##############
# Question 1 #
##############

# How many household interviews were conducted per month? 

household_with_village_df |>
  dplyr::group_by(month) |>
  dplyr::count()