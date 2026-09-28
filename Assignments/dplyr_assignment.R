library(readr)
library(dplyr)

dat <- read_csv("oldRodents.csv")

# Q2
head(dat)

#Q3
print(dat
      |> filter(weight>100)
      )

#Q4
print(dat
      |> filter(weight>100 | is.na(weight))
      )

#Q5

print(dat
      |> filter(!is.na(weight))
      |> summarise(mean_weight=mean(weight), .by = genus)
      )

## !is.na(weight) keeps only the rows where weight is NOT NA
## summarise() provides the summary statistics
## mean_weight = mean(weight) stores the mean_weight under a new column name
## .by = genus groups the data by each unique category in the genus column
  # Creates a hash of row numbers that belong to each genus and then simultaneously
  # applies the mean(weight) to each genus
