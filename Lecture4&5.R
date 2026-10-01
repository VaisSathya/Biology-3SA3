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
  ### filter_out gets rid of the things it knows you don't want (it keeps NAs)

# check all seems to work 

print(dat
      |> filter_out(position<=10) | is.na(position) # brings us back to filter()
      |> select(transect_no, position, plant_species, conductivity)
)

###############################################################################
# September 28, 2026

dat1 <- read_tsv("provinces.tsv")

print(dat1)

## mutate - working making new variables and overwriting old variables

dat1 <- print(dat1
      |> mutate(
        TotalArea = Land + Water
        , density = Population/TotalArea
        , check = TotalArea - Total
        )
      )

summary(dat1)

## sumaarise()
 # Calculate statistics
 # Break things into groups (use .by=)
 # summarise and take mean gives diff value than summary then take the mean

 # summarise() is meant to be used in the overall workflow
print(dat
      |> summarise(
        transect_no=mean(transect_no)
        , position = mean(position)
      )
    )

summary(dat) # summary is meant to be quick

meanBySpecies <- print(dat
      |> summarise(
        conductivity=mean(conductivity)
        , wet = mean(wet)
        , .by = plant_species
      )
    )

# ggplot2

  # Must describe:
    # Data (always the first argument)
    # aes (aesthetic mapping)
    # geometries (geom_)

  # May also describe:
    # Scales
      # Log scales, color scales, ...
    # Facets
      # Break your plot into many plots
    # Themes
      # Look and feel (not directly related to data)

  # Data will have the shape of:
    # Rows for observations
    # Columns for variables

  # Ways to map data to visual elements
    # 1. Colour
    # 2. Shape
    # 3. Axes
    # 4. Line type
    # 4. Transparency

    # You can construct good graphics by using what people have learned by 
    # communicating graphical info

library(ggplot2) # add the other libraries generally
        
scatter<-print(ggplot(dat)
      + aes(conductivity, wet, color=plant_species)
      +geom_point()
      )

# Bar plots: for straight counts
# Histograms: are for counting things in bins

## Example

bar<-print(ggplot(dat)
      + aes(transect_no) # we only have distinct transect_no, so histograms 
      # wouldn't be great here
      +geom_bar()
)

print(ggplot(dat)
      + aes(position) # bad
      +geom_bar()
)

histogram<-print(ggplot(dat)
           + aes(position) # we only have distinct transect_no, so histograms 
           # wouldn't be great here
           +geom_histogram()
)

# Boxplots are not doing statistical tests
 ## They use stat ideas for guidance
 ## Use them for guidance

print(ggplot(dat)
      +aes(y=wet, x=plant_species)
      +geom_boxplot()
      )

# Smooth geom
 ## Uses stat ideas for guidance
 ## Use for exploration

print(scatter + geom_smooth())

# Scales
 ## If you have ratio data, you should think carefully about what scale is best

# Facets: breaking a single plot into many plots

## all log scales are basically the same (look at ratios instead of intervals)
## the 10 in log10 looks at how intervals are chosen
print(scatter + scale_x_log10())

print(scatter + facet_wrap(~plant_species))

# Themes: the best way to control non-mapping aesthetics
 ## How plot looks, not how it maps the data
 ## About 30 built-in themes
 ## Can control specific elements

## Not necessary if a global theme is defined (library(ggplot2); theme_set(theme_bw(base_size=15)))
###print(scatter + facet_wrap(~plant_species) + theme_bw())





