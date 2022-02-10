# NY Reading Report Card and Graphs  
## SOURCE DATA:
NYSED Data (from: https://data.nysed.gov/downloads.php, but files too large to add to SOURCE DATA folder):
- 3-8_ELA_AND_MATH_RESEARCHER_FILE_2016.csv  
- 3-8_ELA_AND_MATH_RESEARCHER_FILE_2017.csv  
- 3-8_ELA_AND_MATH_RESEARCHER_FILE_2018.csv  
- 3-8_ELA_AND_MATH_RESEARCHER_FILE_2019.xlsx  (saved as .cvs to use)  
(No State 2020 data available due to COVID)  
- 3-8_ELA_AND_MATH_RESEARCHER_FILE_2021.xlsx  (saved as .cvs to use)  
<br></br>

## SOURCE DATA folder contains:
### File of Counties with associated BEDSCODES (being not a required field of NY Source Data/some missing)  
- BEDSCODE_County.csv  

### R SCRIPT (to Merge and Clean NYSED Source Data):  
- Merge_ResearcherFiles.R  

### R OUTPUT (Clean, Merged Data):  
- SOURCEDATA_ALLDistrictsGrades.csv  
<br></br>

## REPORTS folder contains:

### R Scripts/Markdown files (to create various Reading Reports):
- 'R_Scripts_MakeReports' folder, with each R file

### Reading Reports (R Output - HTML or .pdf):
- One folder per Report Report (with sammple output reports)
