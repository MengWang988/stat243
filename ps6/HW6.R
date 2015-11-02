############## Stat 243 ps6 ###################
# Meng Wang, 21706745
# October 31
setwd("./Stat243/Homework/PS6")
rm(list = ls())
############# Problem 1 ###################
library(RSQLite)
db <- dbConnect(SQLite(), dbname="DB_Airline.sqlite")

dbWriteTable(conn = db, name = "Table_Airline", value = "./ReplacedData/1987_replaced.csv",
             row.names = FALSE, header = TRUE, 
             colClasses = c(rep("numeric", 8), "factor", "numeric",
                            "factor", rep("numeric", 5), rep("factor", 2), rep("numeric", 4),
                            "factor", rep("numeric", 6)))
for(year in 1988:2008){
  print(year)
  dbWriteTable(conn = db, name = "Table_Airline", value = paste("./ReplacedData/", year, "_replaced.csv", sep=""),
               row.names = FALSE, header = FALSE, append = TRUE, 
               colClasses = c(rep("numeric", 8), "factor", "numeric",
                              "factor", rep("numeric", 5), rep("factor", 2), 
                              rep("numeric", 4), "factor", rep("numeric", 6)))
}
# dbListTables(db)
dbListFields(db, "Table_Airline")
# auth <- dbSendQuery(db, "select * from Table_Airline")
# fetch(auth, 5)
dbDisconnect(db)

############# Problem 2(a) ###################
library(RSQLite)
db <- dbConnect(SQLite(), dbname="DB_Airline.sqlite")
dbBegin(db)
Table_Airline_filter <- dbSendQuery(db, "CREATE view Table_Airline_filter as 
                                    SELECT * FROM Table_Airline 
                                    WHERE DepDelay <> 'NA'")


############# Problem 2(b) ###################
## for Key DayofWeek
#proportion of flights more than 30 minutes late,
table_DayofWeek_30min_late <- dbGetQuery(db, "SELECT DayofWeek 
                                    FROM Table_Airline_filter 
                                    WHERE ArrDelay > 30" )

table(table_DayofWeek_30min_late)/nrow(table_DayofWeek_30min_late)

############# Problem 2(d) ###################
system.time(Indexed_Table <- dbGetQuery(db, "CREATE INDEX AirportID 
                                        ON Table_Airline_filter(Origin)"))



############# Problem 3 ###################
library(foreach)
library(doParallel)
library(iterators)
library(RSQLite)
Fun <- function(){
  Avg <- dbSendQuery(db, "SELECT DayofWeek 
                     FROM Table_Airline_filter 
                     WHERE ArrDelay > 30")
  result <- fetch(Avg, -1)
  dbClearResult(Avg)
  return(result)
}

nCores <- 4
registerDoParallel(nCores)
out <- foreach(i = 1:100, .combine=rbind)%dopar%{
  outSub = Fun()
  outSub
}


# creat the pdf file
library(knitr); 
knit2pdf('HW6.Rtex')





