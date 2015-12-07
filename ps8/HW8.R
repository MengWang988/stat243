############## Stat 243 ps8 ###################
# Meng Wang, 21706745
# December 5

setwd("./Stat243/Homework/PS8")
############# Porblem 2 #######################
library(actuar)
m <- 1e4
alpha <- 2; beta <- 3;
########## (b) ##########
x <- rpareto(m, shape = beta, scale = alpha)

## h(x) = x ####
hist4 <- x * dexp(x-2, rate = 1) / dpareto(x, shape = beta, scale = alpha)
hist(hist1,main="Hsitogram of x*f(x)/g(x)",xlab="x")
hist5 <- dexp(x-2, rate = 1) / dpareto(x, shape = beta, scale = alpha)
hist(hist2,main="Hsitogram of f(x)/g(x)",xlab="x")
Ex <- 1/m * sum(x * dexp(x-2, rate = 1) / dpareto(x, shape = beta, scale = alpha))
## h(x) = x*x ####
hist6 <- x * x * dexp(x-2, rate = 1) / dpareto(x, shape = beta, scale = alpha)
hist(hist1,main="Hsitogram of x*x*f(x)/g(x)",xlab="x")
Ex2 <- 1/m * sum(x^2 * dexp(x, rate = 1) / dpareto(x, shape = beta, scale = alpha))

print(Ex)
print(Ex2)

########## (c) ##########
x <- rexp(m, rate = 1) + 2

## h(x) = x ####
hist1 <- x * dpareto(x, shape = beta, scale = alpha)/ dexp(x-2, rate = 1) 
hist(hist1,main="Hsitogram of x*f(x)/g(x)",xlab="x")
hist2 <- dpareto(x, shape = beta, scale = alpha) / dexp(x-2, rate = 1)
hist(hist2,main="Hsitogram of f(x)/g(x)",xlab="x")
Ex <- 1/m * sum(x * dpareto(x, shape = beta, scale = alpha) / dexp(x-2, rate = 1) )
## h(x) = x*x ####
hist3 <- x * x * dpareto(x, shape = beta, scale = alpha)/ dexp(x-2, rate = 1) 
hist(hist1,main="Hsitogram of x*x*f(x)/g(x)",xlab="x")
Ex2 <- 1/m * sum(x^2 * dpareto(x, shape = beta, scale = alpha)/ dexp(x-2, rate = 1))

print(Ex)
print(Ex2)

############# Porblem 4 #######################
theta <- function(x1,x2) atan2(x2, x1)/(2*pi)
f <- function(x) {
  f1 <- 10*(x[3] - 10*theta(x[1],x[2]))
  f2 <- 10*(sqrt(x[1]^2+x[2]^2)-1)
  f3 <- x[3]
  return(f1^2+f2^2+f3^2)
}


require(reshape, quietly = TRUE)
library(lattice)
x3 <- c(-1, 0, 1)
for(i in 1:length(x3)){
  x1 <- seq(-1,1,0.1)
  x2 <- seq(-1,1,0.1)
  model = function(a,b){
    f1 <- 10*(x3[i] - 10*theta(a,b))
    f2 <- 10*(sqrt(a^2+b^2)-1)
    f3 <- x3[i]
    return(f1^2+f2^2+f3^2)
  }
  z <- outer(x1, x2, model)
  persp(x1,x2,z,ticktype="detailed") 
}

optim(c(0,0,0), f)$value
optim(c(1,-1,0), f)$value
optim(c(1,1,1), f)$value
optim(c(1,1,1), f)$value
optim(c(1,1,0), f)$value



# creat the pdf file
library(knitr); 
knit2pdf('HW8.Rtex')

