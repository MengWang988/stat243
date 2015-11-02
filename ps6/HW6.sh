#!/bin/bash
# Stat243, PS6
# Meng Wang, 21706745
# October 31, 2015

############## Problem 1 ####################
# download the file
url="http://www.stat.berkeley.edu/share/paciorek/1987-2008.csvs.tgz"
wget ${url}

# extract the file
tar -xvzf 1987-2008.csvs.tgz

# make the folder
mkdir ReplacedData

# replace the NA with -999
for filename in $(eval echo {1987..2008});
do
  echo "$filename"
  bzip2 -d "$filename".csv.bz2
  awk -F, '{ $16 = ($16 == "NA" ? -99999 : $16) } 1' OFS=, "./"$filename".csv" > "./ReplacedData/"$filename"_replaced.csv"
done

############ Problem 2 #####################
## setup HDFS
export PATH=$PATH:/root/ephemeral-hdfs/bin/
#HDFS mkdir
hadoop fs -mkdir /data
hadoop fs -mkdir /data/airline
#local mkdir
df -h
mkdir /mnt/airline
#cp files 
scp wangmeng@184.23.19.240:/home/meng/Stat243/Homework/PS6/*bz2 /mnt/airline
#cp files from local to HDFS
hadoop fs -copyFromLocal /mnt/airline/*bz2 /data/airline
# check files on the HDFS, e.g.:
hadoop fs -ls /data/airline

## launch pyspark
# pyspark is in /root/spark/bin
export PATH=${PATH}:/root/spark/bin
# start Spark's Python interface as interactive session
pyspark


############ Problem 4 #####################
start=`date +%s`
awk -F',' '{
  if($17 == "SFO") 
    print $0 > "subset_SFO"
}' ./*.csv 
end=`date +%s`

runtime=$((end-start))
echo $runtime



