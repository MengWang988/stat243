############## Stat 243 ps3 ###################
# Meng Wang, 21706745
# September 27
############# Porblem 2 #######################
library(XML)
library(curl)
setwd("./Stat243/Homework/PS3")
############ part a ########################
# download all content on the page
URL <- "http://www.debates.org/index.php?page=debate-transcripts";
page <- htmlParse(URL);

# extract the all the links on page for future use
allSpeech <- getNodeSet(page, "//a[@title]")
links <- sapply(allSpeech, xmlGetAttr, "href")

# save the XML as string for keyword matching
stringSpeech <- xpathSApply(page, "//a[@title]",saveXML) 

# find the index that contains key word "First" and 
years <- c("1996", "2000", "2004", "2008", "2012")

# function that returns the index of the year
findIndex <- function(year, speechstr=stringSpeech) intersect(grep(year, speechstr), grep("First", speechstr))
  
# find the index for every years' first speech
index <-sapply(years, findIndex) 

################ part b ########################
# function that returns the debate in txt file format
# input: string year = "2000"
# output: string contains the debate content
extractTXT <- function(year = "2012"){
  # Parse the document
  debate <- htmlParse(links[index[year]])
  # extract the debate part
  content  <- xpathSApply(debate, '//div[@id="content-sm"]',saveXML) 
  # change format from HTML to txt
  content <- gsub("<br>|<br/>","\n", content)
  content <- gsub('<(.*?)>', "", content)
  return(content)
}

spokenDebate <- sapply(years, extractTXT)
# test 
# cat(spokenDebate["1996"])

################ part c ########################
## function used to find the candidate by splitting the string to words
## input: year = "1996", data = spokenDebate
## output: name of the speakers
findSpeaker <- function(year , data=spokenDebate){
  # change the '\n' to space for word splitting
  text_no_newline <- gsub("\n", " ", data[year])
  # split the word
  split_word <- strsplit(text_no_newline," ")[[1]]
  # find the names which has the pattern: all capital words followed by a :
  speaker <- split_word[grep("[[:upper:]]:", split_word)]
  speaker <- unique(speaker)
  return(speaker)
}
# test 
findSpeaker("1996")

## function: find whether this string belongs to any speaker or not
checkOwner <- function(allSpeakers, str){
  check = 0;
  for (i in 1:length(allSpeakers)){
    if (grepl(allSpeakers[i], str)) check = check+1
  }
  return(check)
}

## function: exact the speech given by each candidate
## Input: speaker = "CLINTON:", yera = "2006", data = spokenDebate
## Output: speech of the speaker
speakerSpeech <- function(speaker, year, data=spokenDebate){
 # fisrst get rid of "Laughter" and "Applause"
 spokenData <- gsub("Laughter", "", data[year])
 spokenData <- gsub("Applause", "", spokenData)
 # split the string into paragraphs
 split_para <- strsplit(spokenData[year],"\n")[[1]]
 # remove the blank paragraph
 split_para <- split_para[! split_para == ""]
 # for loop to go throught all the paragraphs
 speak_talk = 0 # 1 means this paragraph belong to the speaker
 k = 1
 speak_speech <- c("")
 for (para_num in 1:length(split_para)){
   if (grepl(speaker, split_para[para_num])){
     # this paragrah does belongs to the speaker
     speak_talk = 1;
     speak_speech[k] <- split_para[para_num]
     k = k+1
   }
   else if(checkOwner(findSpeaker(year), split_para[para_num]) == 0){
     if (speak_talk == 1)
     { # the paragrah is a continuing of the last paragraph
       speak_speech[k] <- split_para[para_num]
       k = k+1      
     }
   }
   else{ # this paragraph belongs to someone else
     speak_talk = 0
   }
 }
 # put all paragraph together
 speak_speech <- paste(speak_speech, set="", collapse="")
 # delete the speaker's name due to duplication
 speak_speech <- gsub(speaker, "", speak_speech)
return(speak_speech)
}

# test
#speakerSpeech("CLINTON:", "1996")

# function find all the speeches for one year only
OneYear_SpeakerSpeech <- function(one_year, data = spokenDebate){
  return (sapply(findSpeaker(one_year), speakerSpeech, year = one_year))
} 
# test
#speech1996 <- OneYear_SpeakerSpeech("1996")
#speech1996["CLINTON:"]

# all the years, all the speeches by the candidates
# AllSpeach <- sapply(years, OneYear_SpeakerSpeech)

####################### part (d) #######################################
## function: exact a string to sentences
splitToSentence <- function(str_data = spokenDebate["1996"]){
  # change the '.' to "\n" for sentence splitting
  text_data <- gsub("\\.", "\n", str_data)
  sentence <- strsplit(text_data, "\n")[[1]]
  # remove empty lines
  sentence <- sentence[!sentence == ""]
  return(sentence)
}
# test 
# sentence1996 <- splitToSentence(spokenDebate["1996"])

## function: extract the words from string
splitToWord <- function (str_data = spokenDebate["1996"]){
  text_noline <- gsub("\n", " ", str_data)
  # split the word
  split_word <- strsplit(text_noline," ")[[1]]
  # remove empty elements
  split_word <- split_word[! split_word == ""]
  return(split_word)
}

# test
#word1996 <- splitToWord(spokenDebate["1996"])
 
########################## part (e) ################################### 
## function: do the word statistics and return a list of the data
wordStat <- function (candidate, years, data = spokenDebate){
 # get the speech for the candidate of that year
 candSpeech <- speakerSpeech(candidate,  years, data)
 # split the speech to words
 word <- splitToWord(candSpeech)
 # count the length of the words
 word_number <- length(word)
 # count the length of each word and sum up
 char_length <- sum(nchar(word))
 # get the average
 ave_word_length = char_length / word_number 
 # put the statistics to a list
 result <- list(WordNumber = word_number, CharLength=char_length, AveWordLength=ave_word_length)
 return(result)
}

# test 
wordStat("CLINTON:", "1996")

## function: do the word statistics for each candidate for a year
wordStat_Year <- function (one_year, data = spokenDebate){
  # get the speaker of that year
  candidate <- findSpeaker(one_year)
  # find all the word statistics of the candidates that year
  word_stat_year <-sapply(candidate, wordStat, years = one_year)
  return (word_stat_year)
}

# test
# wordStat1996 <- wordStat_Year("1996")
wordStatAll <- sapply(years, wordStat_Year)

#################### part (f) #######################
## function: do the words counts for a speaker for a specific year
wordsCount <- function (speaker, year, data = spokenDebate){
 # first find the speech by that speaker 
 speech <- speakerSpeech(speaker, year, data=spokenDebate)
 words <- splitToWord(speech)
 num_I = length(words[words == "I"])
 num_we = length(words[words == "we"])
 # number of words contains America/American
 num_America = length(words[grep("America", words)])
 # number of words contains democra
 num_democra = length(words[grep("democra", words)])
 num_republic = length(words[grep("republic", words)])
 num_Democrat = length(words[grep("Democrat", words)])
 num_Republican = length(words[grep("Republican", words)])
 num_free = length(words[(words == "free") | (words == "freedom")])
 num_war = length(words[words == "war"])
 num_God = length(words[words == "God"])
 num_GodBless = length(words[words == "God bless"])
 num_Jesus = length(words[words == "Jesus" | words == "Christ" | words == "Christian"])
 num_words <- list(num_I = num_I, num_we = num_we, num_America = num_we, num_democra = num_democra,
                   num_republic = num_republic, num_Democrat=num_Democrat, num_Republican=num_Republican,
                   num_free = num_free, num_war = num_war, num_God = num_God, num_GodBless= num_GodBless,  num_Jesus = num_Jesus)
 return(num_words)
}
# test 
clinton1996 <- wordsCount("CLINTON:","1996")


## function: do the words count for all the speakers for that year
wordsCount_Year <- function(one_year, data = spokenDebate){
  # get the speaker of that year
  candidate <- findSpeaker(one_year)
  # find all the word statistics of the candidates that year
  word_count_year <-sapply(candidate, wordsCount, year = one_year)
  return (word_count_year)
}

# test 
wordCountALl <- sapply(years, wordsCount_Year)

############# Porblem 3 #######################
############# part a ###############

randomWalkGen <- function(step_num, path_return=FALSE){  
if(is.numeric(step_num) && floor(step_num) == step_num && step_num > 0){ 
   set.seed(0)
    pos_x = 0
    pos_y = 0
    path <- matrix(0, nrow=step_num+1, ncol=2)
    for(i in 1:step_num){
      rand <- runif(1)
      if(rand <= 0.25){
        pos_x = pos_x -1 # left
      }else if(rand <= 0.5){
        pos_x = pos_x + 1 # right
      }else if(rand <= 0.75){
        pos_y = pos_y + 1 # up
      }else{
        pos_y = pos_y - 1 # down
      }
      path[i+1,] <- c(pos_x, pos_y)
    }
   if (path_return == FALSE) return(path[step_num + 1,])
   else return(path)
  }else{
    cat("Invalid Input!")
  }
}
# test
randomWalkGen(3, TRUE)
randomWalkGen(3)
randomWalkGen(0)
randomWalkGen("Hello GSI!")

############# part b ###############
randomWalkGenVector <- function(step_num, path_return=FALSE){  
  if(is.numeric(step_num) && floor(step_num) == step_num && step_num > 0){
    set.seed(0)
    numbers <- runif(step_num, 0, 1)
    pos_x <- matrix(0, nrow = step_num, ncol = 1)
    pos_y <- matrix(0, nrow = step_num, ncol = 1)
    pos_x[numbers <= 0.25] = -1 # move left
    pos_x[numbers >0.25 & numbers <=0.5] = 1 # move right
    pos_y[numbers > 0.5 & numbers <=0.75] = 1# move up
    pos_y[numbers > 0.75 & numbers <=1.0] = -1 # move down
    
    path <- matrix(0, nrow = step_num+1, ncol = 2)
    path[2:(step_num+1),1] = cumsum(pos_x)
    path[2:(step_num+1),2] = cumsum(pos_y)
    if (path_return == FALSE) return(path[step_num + 1,])
    else return(path)
  }else{
    cat("Invalid Input!")
  }
}  
# test
randomWalkGenVector(3, TRUE)
randomWalkGenVector(3)
randomWalkGenVector(0)
randomWalkGenVector("Hello GSI!")

############# part c ###############
# creat a S3 class
myWalk <- list(origin = c(0,0), step = 0, path = matrix(0, nrow =1,ncol = 2))
class(myWalk) <- 'rm'

# build up constructor 
rm <- function(origin = NA, step = NA){
  if(is.numeric(step) && floor(step) == step && step > 0){
    set.seed(0)
    numbers <- runif(step, 0, 1)
    pos_x <- matrix(origin[1], nrow = step, ncol = 1)
    pos_y <- matrix(origin[2], nrow = step, ncol = 1)
    pos_x[numbers <= 0.25] = -1 # move left
    pos_x[numbers >0.25 & numbers <=0.5] = 1 # move right
    pos_y[numbers > 0.5 & numbers <=0.75] = 1# move up
    pos_y[numbers > 0.75 & numbers <=1.0] = -1 # move down
    
    path <- matrix(0, nrow = step+1, ncol = 2)
    path[2:(step+1),1] = cumsum(pos_x)
    path[2:(step+1),2] = cumsum(pos_y)
  }else{
    path = origin
  }
  
  obj <- list(origin = origin, step = step, path = path)
  class(obj) <- "rm"
  return (obj)
}
# initialize an object
aWalk <- rm(c(0,0), 2)

# method print
print.rm <- function(obj){
  return(cat("Random Walk, Start at (", obj$origin, "), after", obj$step, "steps,",
                          "arrive final position at(", obj$path[obj$step+1,], ")"))
}
print(aWalk)

# method plot
plot <- function(x, ...) UseMethod("plot")
plot.rm <- function(obj){
  plot(obj$origin[1],obj$origin[2], xlab="x", ylab="y", main = 'random walk')
  return(lines(x = obj$path[,1], y = obj$path[,2]))
}
plot(aWalk)

# operator overloading
'[.rm' <- function(obj,istep){
  return(obj$path[istep,])
}
aWalk[2]

'start<-' <- function(x, ...) UseMethod("start<-")
'start<-.rm' <- function(obj, value){
  obj$origin = value
  obj$path[1:(obj$step+1),] = obj$path[1:(obj$step+1),] + value
  return (obj)
}
start(aWalk) <- c(5,7)
aWalk

# creat the pdf file
library(knitr); 
knit2pdf('HW3.Rtex')

