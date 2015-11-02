## Stat243A, PS6 ###
# Meng Wang, SID: 21706745

##### Problem 2(a) #####
from operator import add
import numpy as np

#lines = sc.textFile('/data/airline/1987.csv.bz2').cache() # for testing
lines = sc.textFile('/data/airline').cache()
def screen(vals):
    vals = vals.split(',')
# 0 field is Year
# 15 field is DepDelay
# 18 field is Distance
# 3 field is DayOfWeek
    return(vals[0] != 'Year' and vals[15] != 'NA' and vals[18] != 'NA' and \
        vals[3] != 'NA')

lines = lines.filter(screen).repartition(192).cache()
lines.saveAsTextFile('/data/airline_filter')

##### Problem 2(b) #####
from operator import add
import numpy as np
#lines = sc.textFile('/data/filter_1987').cache() # for testing
lines = sc.textFile('/data/airline_filter').cache()
def select_table(vals):
    vals = vals.split(',')
# 6 field is ArrDelay
# 3 field is DayOfWeek
    return(vals[6] >30 and vals[3] != 'NA')

lines_filter = lines.filter(select_table).repartition(192).cache()


#import time
#start_time = time.time()
#def stratify(line):
#    vals = line.split(',')
#    return("mean_value", float(vals[15])/numLines)

#meanResults = lines.map(stratify).reduceByKey(add).collect()
#elapsed_time = time.time() - start_time
