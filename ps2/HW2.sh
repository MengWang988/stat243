#!/bin/bash
# Stat243, PS2 
# Meng Wang, 21706745
# September 18, 2015

############## Part(a) ####################
# download the file
url="http://www.stat.berkeley.edu/share/paciorek/ss13hus.csv.bz2"
wget ${url}

# Read the fields of the file
bzcat ss13hus.csv.bz2 | head -n 1

# count how many fileds there are for this file
bzcat ss13hus.csv.bz2 | head -n 1 | tr ',' '\n' | wc -l

# cut the file and select the fileds we want and save it into a .csv file
bzcat ss13hus.csv.bz2 | head -n 1 | tr ',' '\n' > field_name

# find out the number of the fields we want in the .csv file
for name in "ST" "NP" "BDSP" "BLD" "RMSP" "TEN" "FINCP" "FPARC" "HHL" "NOC" "MV" "VEH" "YBL" 
do
  grep -wn $name field_name | sed 's/[^0-9]//g'
done

############### Part(c) ###################
# cut the columns we want from bz2 file and save it as a new csv file 
bzcat ss13hus.csv.bz2 | cut -d','  -f8,12,17,18,32,41,49,50,53,64,63,45,47 > selected_data.csv 

# find out how many data points are in the original file
bzcat ss13hus.csv.bz2 | cut -d',' -f1 | wc -l

# exact the second column of randnum.txt 
tail -n +2 randnum | cut -d',' -f2 > randLine

# read the line number in randLine and exact the data
cat randLine | while read line;
do 
  head -n $line selected_data.csv| tail -1 >> sample_bash.csv
done

 
