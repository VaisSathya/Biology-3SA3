library(readr)
library(dplyr)
library(tidyverse)
library(ggplot2); theme_set(theme_bw(base_size=15))
library(broom)
library(performance)
library(readxl)
library(janitor)
library(splines)
library(performance)


children <- read_csv("fevData.Rout.csv")
digit <- read_excel("BengaliDigits.xlsx")
mice <- read_csv("mouseActivityData.Rout.csv")
penguins <- read_csv("penguinData.Rout.csv")

# Prediction vs Inference (we focus on inference in this course)
  
  # Prediction: will the model give good answers for new observations?
    ## Parameters only matter as a means to that end
  # Inference: what can we say about a particular effect, and how sure are we?
    ## Estimates and CIs need to be honest 
  # A lot of model choice advice is built for prediction 
    ## Dropping  predictors that don't look important (significance, or infromation criteria like AIC)
    ## Bad for frequntism, lead to over-confidence

# Ex: if we want to use a small data set to figure out how to estimate lung capacity without measuring it, we might drop age or height
  ## Prediction (can throw things out if predicting)
  ## If we want to understand the effect of height, we can't drop age
    # An example of inference

####### Study Design ########

# The most important statistical decisions are made before there are any data
  ## Analysis cannot fix a study that's not designed to answer the research question

# Start with the question: what quanity do I want to estimate, and for what population?

# How small an effect can I afford to miss?
  ## How big an effect is important?
  ## Based on scientific understanding, not the study data

# Experiments
  
  # Gold standard for scientific inference

  # Control
    ## Compare different treatments
  # Replicate
    ## More than one independent unit in each group
  # Randomize
    ## Breaks the link between treatment and everything else

# Controlled Experiments
  # Compares different treatment groups
    ## You don't need a control group
    ## In some circumstances, its unethical to have a control group
      ### Ex: flu mask example --> control group: not allowing people to wear a mask in disease setting
  
  # Groups should be as similar as possible, except for the thing that we want to compare
    ## We don't keep the two groups of rabbits separate; we only separate them for the trip to the radioactive room
    ## If we are giving village children vitamin A, we give the control group a similar pill without vitamin A
    ## We usually don't do one treatment in one neighbourhood and another treatment in another neighbourhood
      ### If we do, we need a statistical model that doesn't tret children in the same neighbourhood as independent

# Blinding or Masking 
  # Human subjects should not know what group they're in
  # Ideally, researchers should know as little as possible about who is in which group
    ## Esp important for researchers making measurements, esp qualitative measurements
    ## Also important for statisticians who need to make decisions during the study
      ### We can also try to make all of the statistical decisions before the study
      ### And journal any decisions we need to make during the study

# Replication
  # Units of replication under the same treatment (replicates) are independent
    ## Different units should have nothing in common except the treatment itself
    ## Must be randomized independently 
    ## Avoid treating them together or assessing them together

# Pseudo-replication
  # Have one radioactive rabbit and one non-radioactive rabbit
    # Measure each 12 times and do a linear model
  # This is a valid test of difference between two rabbits but an invalid test of the effects of radioactivity
  # Or I have two radioactive rabbits and two non-radioactive rabbits
    # Measure each of them 12 times and do a linear model on the combined data of each treatment
    # Invalid
  # Mixing levels is called pseudo-replication

# Randomization
  # People are very bad at randomizing and very good at unconscious bias
  # Randomize with a coin or computer
  # Make as many choices as you can before randomizing
    ## Divide your mice randomly into groups before deciding which group gets which treatment
  # Trying to pick randomly using your brain is called haphazard sampling
    ## Catching animals and tagging them for a particular treatment group
    ## Don't do this

# Covariates
  # In a randomized experiment, covariates don't make your experiment less valid, but they can make it less powerful
  # what makes an experiment valid?
    













