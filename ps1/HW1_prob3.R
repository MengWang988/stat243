
library(knitr); 
knit2pdf('demo.Rnw')
knit2pdf('HW1_prob3.Rtex')

#hist(LakeHuron)
#lowHi <- c(which.min(LakeHuron), which.max(LakeHuron))
#yearExtrema <- attributes(LakeHuron)$tsp[1]-1 + lowHi
#yearExtrema