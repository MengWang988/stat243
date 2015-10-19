############## Stat 243 ps5 ###################
# Meng Wang, 21706745
# October 18
setwd("./Stat243/Homework/PS5")
rm(list = ls())
library(pryr)
############# Problem 1(a) ###################
# check the base and smallest float it can reach
.Machine$double.base
.Machine$double.ulp.digits

# check whehter 1e-16 is reachable or not
num <- 1.000000000001
options(digits = 16)
num
############# Problem 1(b) ###################
x <- c(1, rep(1e-16, times = 10000))
options(digits = 20)
sum(x)

############# Problem 1(d) ###################
# use for loop, first 1 is at the first beginning
d1_sum <- 0.0
for(i in 1:length(x)){
  d1_sum = d1_sum + x[i]
}
options(digits = 20)
d1_sum

# now add 1 at the end
d2_sum <- 0.0
for(i in 1:10000){
  d2_sum = d2_sum + 1e-16
}
d2_sum = d2_sum + 1.0
options(digits = 20)
d2_sum


############# Problem 2 ###################

int_A <- matrix(as.integer(13), nrow = 1e4, ncol = 1e4)
double_A <- matrix(as.numeric(13.0), nrow = 1e4, ncol = 1e4)
# matrix transform
system.time( t(int_A))
system.time(t(double_A))
# find the max value
system.time( max(int_A ))
system.time( max(double_A) )

# creat the pdf file
library(knitr); 
knit2pdf('HW5.Rtex')





