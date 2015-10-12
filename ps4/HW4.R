############## Stat 243 ps4 ###################
# Meng Wang, 21706745
# October 10
setwd("./Stat243/Homework/PS4")
rm(list = ls())
############# Problem 1(a) ###################
set.seed(0)
print(.Random.seed[2])
runif(1)
print(.Random.seed[2])

save(.Random.seed, file = 'tmp.Rda')
runif(1)
print(.Random.seed[2])

load('tmp.Rda')
runif(1)
print(.Random.seed[2])

# print out the global varaible before and after the function call
print('Before tmp is called, the global variable .Random.seed is' )
print(.Random.seed[2])
tmp <- function(){
  load('tmp.Rda')
  runif(1)
  ## print the local varaible .Random.seed
  print('In tmp function, the local variable .Random.seed is' )
  print(.Random.seed[2])

}
tmp()
print('After tmp is called, the global variable .Random.seed is' )
print(.Random.seed[2])

############# Problem 1(b) #####################
rm(list = ls())
set.seed(0)
runif(1)

save(.Random.seed, file = 'tmp.Rda')
runif(1)

load('tmp.Rda')
runif(1)

tmp <- function(){
  load('tmp.Rda',envir = parent.frame())
  runif(1)
}
## check the result
tmp()

############# Problem 2(a) ###################
p <- 0.3; phi <- 0.5
# function to compute each f(k)

# compute the demoninator 
comp_denom1 <- function(num){
  f <- function(k, n = num, p = 0.3, phi = 0.5){
    if(k == 0){
      result = n*phi*log(1-p)
    }else if(k == n){
      result = n*phi*log(p)
    }else{
      result = lgamma(n+1) - lgamma(k+1) - lgamma(n-k+1)+
        k*(1-phi)*log(k) +(n-k)*(1-phi)*log(n-k) - n*(1-phi)*log(n) +
        k*phi*log(p) + (n-k)*phi*log(1-p)
    }
    return(result)
  }
  return(sum(sapply(0:num, f)))
}
comp_denom1(100)

############# Problem 2(b) ###################
# compute the demoninator
comp_denom2 <- function(num, p = 0.3, phi = 0.5){
  f2 <- function(k, n = num, p = 0.3, phi = 0.5){
    result = lgamma(n+1) - lgamma(k+1) - lgamma(n-k+1)+
      k*(1-phi)*log(k) +(n-k)*(1-phi)*log(n-k) - n*(1-phi)*log(n) +
      k*phi*log(p) + (n-k)*phi*log(1-p)
    return(result)
  }
  return(num*phi*log((1-p)*p) + sum(f2(1:(num-1)))) 
}
comp_denom2(100)

## test for time
library(rbenchmark)
benchmark(comp_denom1(10));benchmark(comp_denom2(10))
benchmark(comp_denom1(100));benchmark(comp_denom2(100))
benchmark(comp_denom1(1000));benchmark(comp_denom2(1000))
benchmark(comp_denom1(2000));benchmark(comp_denom2(2000))

############# Problem 3(a) ###################
# load data
load("mixedMember.Rda")
# pick up a i and a Case, we use Case A as example
comp_oneElementA <- function(i){
  return(sum(unlist(wgtsA[i])*muA[unlist(IDsA[i])]))
}
#sapply(1:length(IDsA), comp_oneElementA)

comp_oneElementB <- function(i){
  return(sum(unlist(wgtsB[i])*muA[unlist(IDsB[i])]))
}
#sapply(1:length(IDsB), comp_oneElementB)

############# Problem 3(b)(c) ###################
# vectorize the code and use matrix computation
# Case A
num_obs_A <- length(wgtsA)
num_m_A <- nrow(do.call(cbind, wgtsA))
# create the matrix
matrix_w_A <- matrix(0, nrow = num_obs_A, ncol = num_m_A)
matrix_mu_A <- matrix(0, nrow = num_m_A, ncol = num_obs_A)
# get the value for matrix
for (i in 1:num_obs_A){
  mi = length(unlist(wgtsA[i]))
  matrix_w_A[i,1:mi] <- t(as.matrix(unlist(wgtsA[i])))
  matrix_mu_A[1:mi,i] <- as.matrix(muA[unlist(IDsA[i])])
}

# Case B
num_obs_B <- length(wgtsB)
num_m_B <- nrow(do.call(cbind, wgtsB))
# create the matrix
matrix_w_B <- matrix(0, nrow = num_obs_B, ncol = num_m_B)
matrix_mu_B <- matrix(0, nrow = num_m_B, ncol = num_obs_B)
# get the value for matrix
for (i in 1:num_obs_B){
  mi = length(unlist(wgtsB[i]))
  matrix_w_B[i,1:mi] <- t(as.matrix(unlist(wgtsB[i])))
  matrix_mu_B[1:mi,i] <- as.matrix(muB[unlist(IDsB[i])])
}

# Case A
# use sapply
system.time(sapply(1:length(IDsA), comp_oneElementA))
# use matrix
matrix_mul_A <- function(i) return(matrix_w_A[i,]%*%matrix_mu_A[,i]) 
system.time(sapply(1:num_obs_A, matrix_mul_A))

# Case B
# use sapply
system.time(sapply(1:length(IDsB), comp_oneElementB))
# use matrix
matrix_mul_B <- function(i) return(matrix_w_B[i,]%*%matrix_mu_B[,i]) 
system.time(sapply(1:num_obs_B, matrix_mul_B))

############# Problem 4(a) ###################
library(pryr)
mem_used()
# generate the data
y <- rnorm(1e6); x1 <- rnorm(1e6)
x2 <- rnorm(1e6);x3 <- rnorm(1e6)
# check the total memroy use after data generation
mem_used()
# fit the model and check memory again
lsm <-lm(y ~ x1 + x2 + x3)
mem_used()

############# Problem 4(b) ###################
ls.sizes <- function(howMany = 10, minSize = 1){
  pf <- parent.frame()
  obj <- ls(pf) # or ls(sys.frame(-1)) 
  objSizes <- sapply(obj, function(x) {
    object.size(get(x, pf))
  })
  # or sys.frame(-4) to get out of FUN, lapply(), sapply() and sizes()
  objNames <- names(objSizes)
  howmany <- min(howMany, length(objSizes))
  ord <- order(objSizes, decreasing = TRUE)
  objSizes <- objSizes[ord][1:howMany]
  objSizes <- objSizes[objSizes > minSize]
  objSizes <- matrix(objSizes, ncol = 1)
  rownames(objSizes) <- objNames[ord][1:length(objSizes)]
  colnames(objSizes) <- "bytes"
  cat('object')
  print(format(objSizes, justify = "right", width = 11),
        quote = FALSE)
}
ls.sizes()


# creat the pdf file
library(knitr); 
knit2pdf('HW4.Rtex')

