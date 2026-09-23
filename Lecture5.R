### What is an outlier? ###

# A point that is unlike other values of the same variable
# A point that doesn't follow the trend (relating two or more variables)

### Why do we look for outliers? ###

# Outlier might be part of the wrong pattern
# Outliers might skew the data (have a very strong effect on the statistics)
# They might be wrong


### What do we do when we find outliers? ###

### Quality Control ###

# Take notes & double check everything you enter or transcribe
# If you find a mistake only bc its an outlier, then something in system messed up

### Tidyverse ###

# A group of packages designed to allow data maniplation and visualization at a 
# higher conceptual level than base R

### dplyr ###

# Designed to focus on tabular data (columns as var and rows as observations)
# Make simple tasks readable and understandable (uses verb-style functions)
# Uses pipe syntax

  sin(sqrt(7))
  
  7 |>sqrt()|>sin()|>print() # pipe syntax
  
### Multi-line Syntax ###
  
# R guesses when you are done telling it what to do
  
  73*48
  +69*22
  +101*13 # it solves line by line and does not combine
  
  # 2 ways to solve
  
  ## 1. Modern way (force R to find the right way bc function would be broken if read line by line)
  
  73*48 +
  69*22+
  101*13
  
  ## 2. Aesthetic way using parenthesis
  
  print(73*48
        + 69*22
        + 101*13)
  
## dplyr verbs to know ##
  
  # filter() chooses rows based on column values
    ## Based on criteria about variables
    ## Syntax <, <=, ...
    ## == for equals
    ## != for does not equal
  # select() changes whetehr or not a column is included
  # mutate() changes the values fo columns and creates new columns
  # count()

## put these at beginning bc when restarting you know if you have the package or not
library(readr)
library(dplyr)

dat <- read_csv("riparian.Rout.csv")
