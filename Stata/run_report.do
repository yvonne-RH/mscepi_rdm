* Swiss TPH - Research Data Management, 2024
* do file for rendering the automated report "report.txt" in HTML and DOCX
* 11.04.2024 HL

* Set up your working directory
* YOU NEED TO MODIFY THIS PATH WHEN RUNNING THE CODE ON YOUR LOCAL ENVIRONMENT
cd "C:/Users/langhe/Documents/GitHub/rdm2025/Stata"

* Render the automated report in HTML
dyndoc report.txt, saving(report.html) replace

* Render the automated report in DOCX