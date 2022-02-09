## NY Reading Report Card and Graphs  
### SOURCE DATA:

A) NY Source Data from: https://data.nysed.gov/downloads.php:  
- 3-8_ELA_AND_MATH_RESEARCHER_FILE_2016.csv  
- 3-8_ELA_AND_MATH_RESEARCHER_FILE_2017.csv  
- 3-8_ELA_AND_MATH_RESEARCHER_FILE_2018.csv  
- 3-8_ELA_AND_MATH_RESEARCHER_FILE_2019.xlsx  (saved as .cvs to use)  
(No State 2020 data available due to COVID)  
- 3-8_ELA_AND_MATH_RESEARCHER_FILE_2021.xlsx  (saved as .cvs to use)   
  
B) File of Counties with associated BEDSCODES (being not a required field of NY Source Data/some missing)  
- BEDSCODE_County.csv  

### R SCRIPT (to Merge and Clean Source Data):  
- Merge_ResearcherFiles.R  

### R OUTPUT (Clean, Merged Data):  
- SOURCEDATA_ALLDistrictsGrades.csv  
<br></br>

## Reading Report Card (by Selected County and Year):

### R MARKDOWN (to create HTML Report)
- ReadingReportCard_County_HorizBarGraph.Rmd  
(Change County and Year Selection near top, that you want)

### Example Reading Report Card (R Markdown HTML output):
- ReadingReportCard_County_HorizBarGraph.html
- .pdf of Report: New York - Reading Report Card - 2019, NASSAU.pdf
