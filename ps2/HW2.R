# Stat243, PS2
# Meng Wang, 21706745
# September 18, 2015

set.seed(0);
setwd("./Stat243/Homework/PS2");

############ Part(a) ######################
# read in the data
data<-read.csv("selected_data.csv");
# sample 1000 rows of the data
sample<-data[sample(nrow(data), 1000),];
# save it to sample.csv
write.csv(sample, file = "sample_R.csv");

############ Part(b) ######################
# check the time for read.csv and readLines
system.time(sample1<-read.csv("sample_R.csv"));
system.time(sample2<-readLines("sample_R.csv"));

############ Part(c) ######################
# generate 1000 random number as line numbers to extract the data
randnum <- as.data.frame(sample(1:7219000, 1000));
write.csv(randnum, file="randnum");

############ Part(d) ######################
xtabs(~ TEN + VEH, data=sample);

# creat the pdf file
library(knitr); 
knit2pdf('HW2.Rtex');
