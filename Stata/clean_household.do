* Swiss TPH - Research Data Management, 2025
* do file for cleaning the household-level data
* 2025-05-15 HL

* Set up your working directory
* YOU NEED TO MODIFY THIS PATH WHEN RUNNING THE CODE ON YOUR LOCAL ENVIRONMENT
cd "C:/Users/langhe/Documents/GitHub/rdm2025/Stata"

// Load household dataset (need to replace the provided filepath with your filepath)
use "..\data\hh-data.dta", clear

// Explore the dataset
describe

// Tabulate
tab mosquitonet

// clean village codes
replace villagecode = "IMO" if villagecode == "IM0"

// clean province name - excess spaces
gen province_clean = stritrim(province)

// drop duplicates
duplicates drop   // drops observations that are exactly the same across all variables
duplicates tag villagecode hhid, gen(duplicate) // drop duplicates in hhid and vcode > cannot be merged with individual level

destring hhid, replace

table mosquitonet

// Clean the dataset - to be completed

// Save the dataset
save "..\data\household-data-2025-clean.dta", replace