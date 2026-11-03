library(readr)
library(tidyverse)
library(broom)
dat <- read.csv("penguinData.rout.csv")
view(dat)
lenmd <- lm(bill_length_mm~bill_depth_mm, data = dat)
summary(lenmd)

#?plot.lm
plot(lenmd, which = c(1,2,3,5))

print(tidy(lenmd, conf.int=TRUE))
confint(lenmd)

lenmd2 <- lm(bill_length_mm ~ bill_depth_mm + species, data = dat)
summary(lenmd2)
plot(lenmd2)
print(tidy(lenmd, confint=TRUE))
print(tidy(lenmd2, confint=TRUE))
confint(lenmd2)
