* Swiss TPH - Research Data Management, 2025
* run all do files in sequence
* 2025-05-15 HL

* Set up your working directory
* YOU NEED TO MODIFY THIS PATH WHEN RUNNING THE CODE ON YOUR LOCAL ENVIRONMENT
cd "C:/Users/langhe/Documents/GitHub/rdm2025/Stata"

* Clear memory and any open data
clear all
set more off

* Run village-level cleaning script
do "clean_village.do"

* Run household-level cleaning script
do "clean_household.do"

* Run individual-level cleaning script
do "clean_individual.do"

display "All scripts completed successfully."