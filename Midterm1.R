library(dplyr)
library(ggplot2)
library(readr)

#1

x<-23
print(x)

x+17
print(x) # x remains unchanges

y<-x+17
y

#2

num <- 3
str(num)

char<-"Hello World"
str(char)

logic <- TRUE
str(logic)

words<-c("Mary","had","a","little","lamb")
str(words)

v<-1:5
str(v)

#3

?runif()
## arguments are (n,x,q); x and q are vector quantities, and n is number of observations

runif(3)

runif(3,2,10)

runif(3,6,7)

dat<-read_csv("riparian.Rout.csv")

summary(dat)

print(dat
      |> summarise(
        transect_no=mean(transect_no)
        , position = mean(position)
      )
)
