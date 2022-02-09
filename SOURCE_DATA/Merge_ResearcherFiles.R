library(tidyverse)
library(dplyr)
library(janitor) #for get_dupes funct

#######################################################################
## Creates CSV with: District data (schools removed), AND 
##                   cohorts: 1(all),11(SWD),15(econ disadvantaged),6(hispanic)
######################################################################
##       ANNUAL UPDATING - directions
##
## 1 - Get new year's data from: https://data.nysed.gov/downloads.php
##     (Assessment Database, get file called - 3-8_ELA_AND_MATH_RESEARCHER_FILE_YYYY)
##
## 2 - If the file is a .xlsx, open it and save it as a .csv (it's faster than doing it in R)
##
## 3 - Update this script to add the new years data.  UPdate the following sections:
##        '#Import NY State Data (no 2020 Data due to COVID):' section through
##          'Merge Data' Sections
##
## 4 - Edit input and output file names (to the dir your working in) (ie, line 24,28, etc below)
##
###################################################

output_file <- "C:/Users/srene/Documents/NY LITERACY REPORT CARD website -local/NYSourceDATA/SOURCE_DATA/SOURCEDATA_ALLDistrictsGrades.csv"

# Import NY State Data (no 2020 Data due to COVID):
# 2016 Data (csv)
inputfile <- "C:/Users/srene/Documents/NY LITERACY REPORT CARD website -local/NYSourceDATA/SOURCE_DATA/3-8_ELA_AND_MATH_RESEARCHER_FILE_2016.csv"
data_2016 <- read.csv(inputfile, blank.lines.skip = TRUE)[,c(1, 4:7, 9:12, 22)]
data_2016$BEDSCODE <- format(data_2016$BEDSCODE, scientific = FALSE)
data_2016$BEDSCODE <- str_replace_all(data_2016$BEDSCODE, ' ', '')   

# 2017 Data (csv)
inputfile <- "C:/Users/srene/Documents/NY LITERACY REPORT CARD website -local/NYSourceDATA/SOURCE_DATA/3-8_ELA_AND_MATH_RESEARCHER_FILE_2017.csv"
data_2017  <- read.csv(inputfile, blank.lines.skip = TRUE)[,c(1, 4:7, 9:12, 22)]
data_2017$BEDSCODE <- format(data_2017$BEDSCODE, scientific = FALSE)
data_2017$BEDSCODE <- str_replace_all(data_2017$BEDSCODE, ' ', '') 

# 2018 Data (csv)
inputfile <- "C:/Users/srene/Documents/NY LITERACY REPORT CARD website -local/NYSourceDATA/SOURCE_DATA/3-8_ELA_AND_MATH_RESEARCHER_FILE_2018.csv"
data_2018 <- read.csv(inputfile, blank.lines.skip = TRUE)[,c(1, 4:7, 9:12, 22)]
data_2018$BEDSCODE <- format(data_2018$BEDSCODE, scientific = FALSE)
data_2018$BEDSCODE <- str_replace_all(data_2018$BEDSCODE, ' ', '') 

# 2019 Data (xlsx)
inputfile <- "C:/Users/srene/Documents/NY LITERACY REPORT CARD website -local/NYSourceDATA/SOURCE_DATA/3-8_ELA_AND_MATH_RESEARCHER_FILE_2019.csv"
data_2019 <- read.csv(inputfile, blank.lines.skip = TRUE)[,c(1, 4:7, 9:12, 22)]
data_2019$BEDSCODE <- format(data_2019$BEDSCODE, scientific = FALSE)
data_2019$BEDSCODE <- str_replace_all(data_2019$BEDSCODE, ' ', '') 

# 2021 Data (xlsx) -- NOTE: This year is missing needed cols: COUNTY_CODE, COUNTY_DESC
#                           This year col name are also different
inputfile <- "C:/Users/srene/Documents/NY LITERACY REPORT CARD website -local/NYSourceDATA/SOURCE_DATA/3-8_ELA_AND_MATH_RESEARCHER_FILE_2021.csv"
data_2021 <- read.csv(inputfile, blank.lines.skip = TRUE)[,c(1:3,5:7,10,19)]
data_2021$BEDSCODE <- format(data_2021$BEDSCODE, scientific = FALSE)
data_2021$BEDSCODE <- str_replace_all(data_2021$BEDSCODE, ' ', '') 

###################################################
# Clean Data by YEAR - Make consistent col names, and add and populate missing 2021 County columns )

# Rename 2021 ColNames to be consistent with prev years
names(data_2021)[names(data_2021) == "subgroup_name"] <- "SUBGROUP_NAME"

# Add missing cols to 2021 Data
data_2021$COUNTY_CODE <- "EMPTY"
data_2021$COUNTY_DESC <- "EMPTY"

# Populate missing County Codes
# Format Cols
data_2021$BEDSCODE <- format(data_2021$BEDSCODE, scientific = FALSE)
#remove spaces
data_2021$BEDSCODE <- str_replace_all(data_2021$BEDSCODE, ' ', '')
        # # Format Year
        # data_2021$SY_END_DATE <- str_replace_all(data_2021$SY_END_DATE, '.+/', '')
# Import BEDSCODE-County LookUp Table
inputfile <- "C:/Users/srene/Documents/NY LITERACY REPORT CARD website -local/NYSourceDATA/SOURCE_DATA/BEDSCODE_County.csv"
BCode2County <- read.csv(inputfile)[,c(2,3)]  # District, districtBedsCode (1st 6 digs), County
#Create lookup key, use it with: getCountyDesc['570101'] (first 6dig of BEDSCODE)
getCountyDesc <- BCode2County$COUNTY_DESC
names(getCountyDesc) <- BCode2County$BEDSCODE

# Get rid of uneeded cols so next step doesn't take as long
data_2021 <- data_2021 %>% 
  filter(str_detect(ITEM_DESC, ".ELA") | str_detect(ITEM_DESC, ".ELA ")) %>%   # Keep ELA data only
  filter(SUBGROUP_CODE ==  1 | SUBGROUP_CODE ==  11 | SUBGROUP_CODE ==  15 | SUBGROUP_CODE ==  6)

# Get missing counties
data_2021$BEDshort <- substr(data_2021$BEDSCODE, 1, 6)
data_2021$COUNTY_DESC <- getCountyDesc[data_2021$BEDshort]

# Remove BEDshort col (col 11), to have same cols as other years
data_2021 <- data_2021[,-11]

##################################################
# Merge Data, and Clean 
data_ALL <- rbind(data_2016, data_2017, data_2018, data_2019, data_2021)
#remove(data_2016, data_2017, data_2018, data_2019, data_2021)

# Use standard NA, convert to correct formats
# Keep Year Only in Date Col
data_ALL$BEDSCODE <- format(data_ALL$BEDSCODE, scientific = FALSE)
data_ALL$BEDSCODE <- str_replace_all(data_ALL$BEDSCODE, ' ', '')  #Does this put it back to sci notation? 
data_ALL$BEDSCODE <- str_replace_all(data_ALL$BEDSCODE, ' ', '')  #Repeat, some still have spaces
data_ALL$SY_END_DATE <- str_replace_all(data_ALL$SY_END_DATE, '.+/', '')
data_ALL$L3.L4_PCT <- gsub('%', '', data_ALL$L3.L4_PCT)
data_ALL$L3.L4_PCT <- strtoi(data_ALL$L3.L4_PCT)
data_ALL$SUBGROUP_CODE <- strtoi(data_ALL$SUBGROUP_CODE)
data_ALL$L3.L4_PCT[ data_ALL$L3.L4_PCT == "-" ] <- NA
data_ALL$TOTAL_TESTED <- strtoi(data_ALL$TOTAL_TESTED)
data_ALL$TOTAL_TESTED[ data_ALL$TOTAL_TESTED == "-" ] <- NA
data_ALL$NAME <- str_replace_all(data_ALL$NAME, ' $', '') 
data_ALL$NAME <- str_replace_all(data_ALL$NAME, ' $', '') # Repeat - some have 2 spaces at the end

# Filter - KEEP ONLY SUBGROUPS BELOW:
data_ALL <- data_ALL %>% 
  filter(str_detect(ITEM_DESC, ".ELA") | str_detect(ITEM_DESC, ".ELA ")) %>%   # Keep ELA data only
  filter(SUBGROUP_CODE ==  1 | SUBGROUP_CODE ==  11 | SUBGROUP_CODE ==  15 | SUBGROUP_CODE ==  6)

# Filter - KEEP ONLY DISTRICT DATA (not individual schools):
data_ALL <- data_ALL %>% 
  filter(str_detect(BEDSCODE, ".0000")) %>%
  # Remove Schools with 'ELEMENTARY' which use same elem and dist code (ending in 0000)
  #filter(!str_detect(NRC_DESC, "Charters")) %>%
  filter(!str_detect(NAME, "ELEMENTARY")) %>%
  filter(!str_detect(NAME, "ELMENTARY")) %>%
  filter(!str_detect(NAME, "CHARTER"))

# Filter - REMOVE BESCODES 0-7 (groupings and charters)(and has annoying NAs in county_desc col)
data_ALL <- data_ALL[(data_ALL$BEDSCODE != "0"),]
data_ALL <- data_ALL[(data_ALL$BEDSCODE != "1"),]
data_ALL <- data_ALL[(data_ALL$BEDSCODE != "2"),]
data_ALL <- data_ALL[(data_ALL$BEDSCODE != "3"),]
data_ALL <- data_ALL[(data_ALL$BEDSCODE != "4"),]
data_ALL <- data_ALL[(data_ALL$BEDSCODE != "5"),]
data_ALL <- data_ALL[(data_ALL$BEDSCODE != "6"),]
data_ALL <- data_ALL[(data_ALL$BEDSCODE != "7"),]


# Filter - REMOVE NYC COUNTIES  (added !comp cases so NAs aren't removed/no cols removed)
data_ALL <- data_ALL[!(startsWith(data_ALL$BEDSCODE, "34")),] # 34*  = QUEENS (county_desc)
data_ALL <- data_ALL[!(startsWith(data_ALL$BEDSCODE, "32")),] # 32* = BRONX
data_ALL <- data_ALL[!(startsWith(data_ALL$BEDSCODE, "33")),] # 33* = KINGS
data_ALL <- data_ALL[!(startsWith(data_ALL$BEDSCODE, "35")),] # 35* = RICHMOND
data_ALL <- data_ALL[!(startsWith(data_ALL$BEDSCODE, "3100")),] # 3100*, 3101*..3106* = NEW YORK
data_ALL <- data_ALL[!(startsWith(data_ALL$BEDSCODE, "3101")),] 
data_ALL <- data_ALL[!(startsWith(data_ALL$BEDSCODE, "3102")),] 
data_ALL <- data_ALL[!(startsWith(data_ALL$BEDSCODE, "3103")),] 
data_ALL <- data_ALL[!(startsWith(data_ALL$BEDSCODE, "3104")),] 
data_ALL <- data_ALL[!(startsWith(data_ALL$BEDSCODE, "3105")),] 
data_ALL <- data_ALL[!(startsWith(data_ALL$BEDSCODE, "3106")),] 

# Fix/Clean School Names 
data_ALL$NAME <- str_replace(data_ALL$NAME, "CENTRAL SCH.*", "CSD ")
data_ALL$NAME <- str_replace(data_ALL$NAME, "UNION FREE SCHOOL DISTRICT OF", "UFSD OF")  #Must be before next replace line
data_ALL$NAME <- str_replace(data_ALL$NAME, "UNION FR.*", "UFSD ")
data_ALL$NAME <- str_replace(data_ALL$NAME, "SCHOOL DISTRICT", "SD ") 
data_ALL$NAME <- str_replace_all(data_ALL$NAME, ' $', '') # Get rid of end space (above subs could have been in the middle)

# Get rid of schools, keep districts only (this gets rid of the remaining schools using its district BEDSCODE)
data_ALL <- data_ALL[(str_detect(data_ALL$NAME, "SD$") | str_detect(data_ALL$NAME, "SD ")),]

# Get rid of duplicates
#record them, just fyi
DUPS <- get_dupes(data_ALL)
# remove them
data_ALL <- unique(data_ALL)

############     DONE, SAVE AS CSV   ####################################
write.csv(data_ALL, output_file)
