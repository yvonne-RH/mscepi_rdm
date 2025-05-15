* Swiss TPH - Research Data Management, 2025
* do file for cleaning the survey village data
* 2025-05-15 HL

* Set up your working directory
* YOU NEED TO MODIFY THIS PATH WHEN RUNNING THE CODE ON YOUR LOCAL ENVIRONMENT
cd "C:/Users/langhe/Documents/GitHub/rdm2025/Stata"

***************************************
* Load and clean the village dataset *
***************************************

* Load CSV file
import delimited "../data/village info.csv", clear

* Display structure of the dataset
describe
codebook

* Check unique values in the 'urban' variable
tabulate urban

* Create a cleaned version of the 'urban' variable
gen str1 urban_clean = urban

* Standardize 'urban' values (case-insensitive and variations)
replace urban_clean = "1" if lower(urban) == "urban"
replace urban_clean = "1" if urban == "yes"
replace urban_clean = "0" if urban == "no"
replace urban_clean = "0" if urban == "not urban"

* Optionally overwrite the original 'urban' variable
drop urban
rename urban_clean urban

* Convert altitude_m to numeric if needed
destring altitude_m, replace force

* Summarize the cleaned data
summarize
codebook urban vcode village altitude_m

* Save the dataset
save "../data/village_info_clean2025.dta", replace