library(dplyr)
library(ggplot2)

penguins <- read.csv("Assignments/penguinData.Rout.csv")

print(penguins
      |> summarize(
        bill_depth_mm = mean(bill_depth_mm, na.rm=TRUE),
        bill_length_mm = mean(bill_length_mm, na.rm = TRUE),
        .by = species
      ))

print(penguins
      |> summarize(
        bill_depth_mm = mean(bill_depth_mm),
        bill_length_mm = mean(bill_length_mm),
        .by = species
      ))

help(mean)

# na.rm looks at NA values within the variable. If TRUE, na.rm removes the NA values

View(penguins)

# 1 quantitative and 1 categorical
print(ggplot(penguins)
              + aes(x=species, y = body_mass_g)
              + geom_boxplot() 
      )

# 2 quantitative and one categorical

print(ggplot(penguins)
      + aes(x=bill_length_mm, y = bill_depth_mm, color = species)
      + geom_point()
)
      

