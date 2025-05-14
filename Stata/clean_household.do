* Swiss TPH - Research Data Management, 2025
* do file for cleaning the household-level data
* 11.04.2022 MAH

// Load household dataset (need to replace the provided filepath with your filepath)
use "..\rdm2024_data\hh-data.dta", clear

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
save "..\rdm2024_data\household-data-2024-clean.dta", replace