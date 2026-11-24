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
  # Validity: what is the probability that the CIs will include the true value?
  # Power: how clearly can I see?
    ## Ex: how small are the CIs?
  # Deal with covariates by blocking or statistical modelling 
    ## Include the ones we think are important and can exlcude the ones we think are not important

  # Blocking: structure the experiment to reduce effects of covariates
    ## Randomize boys and girls separately
    ## Randomize inside each school
    ## Paired t-tests are an example of blocking (study different fingers from same children)

  # Statistical Modelling
    ## Adding covariates to model can help make estimate more precise
      ### lm(res~x+z)
    ## Remember: 5-10 parameters per model

# Observational Studies
  # Why are controlled experiments (as opposed to statistical control) the gold standard?
    ## Statistical control (observational experiments) can never control everything
  # Why do we do observational studies anyway?
    ## Practicality
    ## We can't randomize children to smoke or not smoke
  # In some fields, conlcusions can onyl be based on

# Ex: HIV control
  # Observational studies suggested male circumcision reduced HIV transmission
    ## People who are circumsised have different cultural contexts
    ## Being circumsised as a child may affect behaviour
  # Later, people attempted large, randomized experiments

# Ex: exercise

  # More active people have better health outcomes
  # Is that because:
    ## Exercise imporves health?
    ## People with fewer medical conditions exercise more and have better outcomes?
  # This is an example of confounding
  # How might you test?
    ## Insititution education programs for half of the patients in a group

# What to control for?
  # More control is not always better; the answer depends on causal structure
  # Confounder: causes both predictor and response 
    ## Control for it
  # Mediator: something that lies on path from predictor to response
    # Depends on question we're asking (for if we want to control for it)
  # Collider: something that can be caused by both predictor and response
    ## Don't control for it (this creates an association)

# Natural Experiments
  # A strong kind of observational study
  # Ex: Two similar, nearby communities are in different states
    ## One state has high alcohol taxes, and the corresponding community drinks less alcohol
    ## Problem: only one replicate per treatment
    ## Still potentially useful for exploration
  # What if you have dozens of states with different alcohol taxes?
    ## This is a replicated experiment
    ## But you still can't control for everything

# More natural experiments
  # Streams in areas that have been logged vs. those that haven't
    ## Or upstream and downstream of a development
  # Villages where a health intervention has been implemented vs. those where it is still scheduled for implementation
    ## Better {for statisticians} if this could actually be randomized

# Correlation vs. Causation
  # Correlation is what we observe directly
    ## Children who smoke tend to have lower lung capacity
  # Causation refers to mechanism
    ## Smoking lowers the lung capacity of children
  # Statistical evidence can directly support causation 
    ## Only in a randomized experiment
  # Statistical evidence can indirectly support causation
    ## When combined with scientific evidence

# Simulation
  ## We rarely know the truth about real data
  ## If we make up data, we know the truth, and we can see how our method does
  ## A few lines of R can replace a lot of formulas
  # It also forces us to say waht we think our study looks like

# Simulating a study
  # Choose a truth: effect size, noise, sample size, study structure
  # Generate a fake data set
  # Analyze it exactly the way you plan to analyze the real data
  # Save the estimate, CI, and P-value
  # Repeat many times and count

# Testing validity
  # Set effect to 0, does the method reject <=alpha of the time?
    ## frequentist definiton of validity




# powerTest.R

  # imagine we're estimating mean height of a population
set.seed(1123)
x<-rnorm(20, mean=67, sd=5) # height in inches of Mac students
m<-lm(x~1)
confint(m)
coef(m)

  # what if want to run 1000 times?

study<-function(n, mh, sdh){
  x<-rnorm(20, mean=mh, sd=sdh) # height in inches of Mac students
  m<-lm(x~1)
  ci<-confint(m)
  est<-coef(m)
  return(data.frame(low=ci[[1]],est=est[[1]],high=ci[[2]]))
}

experiment<-function(n,mh,sdh,reps){
  return(replicate(reps,study(n,mh,sdh),simplify=FALSE)
         |> bind_rows()
         )
}

experiment(n=20,mh=67,sdh=5,reps=1000)
    













