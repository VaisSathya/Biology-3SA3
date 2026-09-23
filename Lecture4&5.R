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
  
## making a variable
  
weight <- c(5,6,NA)

print(mean(weight))

print(weight==6)

## working around the NA

print(!is.na(weight))
## dplyr verbs to know ##
  
  # filter() chooses rows based on column values
    ## Based on criteria about variables
    ## Syntax <, <=, ...
    ## == for equals
    ## != for does not equal
    ## the filter() function keeps things that match and drops NAs
    ## filter.out() keeps things that don't match and keeps NAs

  # select() changes whether or not a column is included
    ## Rarely necessary, but often convenient
    
  # mutate() changes the values fo columns and creates new columns
  # summarize()
    # count() collapses each group in a single row

### Types of Data ###
  
  # Nominal: name only
    ## Ex: list of countries
  # Ordinal: order, no differences
    ## Ex: disease stages or grades
  # Interval: differences, no ratios
    ## Ex: temperature in C
  # Ratio: ratio data
    ## Ex: temperature in K

  # * Binary variables don't really fit

## Non-numeric variables ##

# - Have 2 representations:
#   - The name itself is a character variable
#   - A pointer

## put these at beginning bc when restarting you know if you have the package or not
library(readr)
library(dplyr)
  
dat <- read_csv("riparian.Rout.csv")

# summary(dat) is not really part of the script logic
summary(dat)
# filter
conQ <- (dat
      |>filter(conductivity>500)
      )

# select

print(dat
      |> filter(conductivity>500)
      |> select(transect_no, position, plant_species, conductivity)
      )

#
print(dat
      |> filter(position>10)
      |> select(transect_no, position, plant_species, conductivity)
)

## what if we want to know about NAs?
print(dat
      |> filter_out(position<=10)
      |> select(transect_no, position, plant_species, conductivity)
)


# check all seems to work 

print(dat
      |> filter_out(position<=10) | is.na(position)
      |> select(transect_no, position, plant_species, conductivity)
)
