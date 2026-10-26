# Linear Models of Observations
  # 1. t-test
  # 2. regression
  # 3. ANOVA
  # 4. ANCOVA

# Linear Model
  # A fit to a **response variable** based on assumptions about its relationship to one or more predictor variables

  # Inferences about parameters based on assumptions about the conditional distribution of the response variable
    ## Assume the response variable has "true" distribution for any value of the predictor variables

  # A linear model gives the response variable as a linear combination of the parameters it is estimating

  # NOTE: any response to a categorical variable can be encoded as a linear model

# Power
  # Linear models are very efficient
    ## Find the best "least-squares" fit with simple linear algebra

  # Can be powerful at detecting effects
    ## Can also be over-sensitive to outliers

# Assumptions of Linear models
  # 1. Linear-model fits are basically always correct, but can be hard to interperet
  #   a. Can find the "best" parameters
  #   b. Need assumptions to know what that means
  
  # 2. Inferences (parameter estimates P-values, CIs) depend on assumptions about residuals
   
  # 3. A residual is y-y^: the difference between an observed value y and a model prediction y^
   
  # 4. LM inference assumes that residuals are indepdent and normally distributed, with constant variance
  #   a. Mean of residuals is always 0 (otherwise machine would find a better linear model)

# Variables
  # 1. Response
  #   a. Assume response variable is normally distributed (conditional on predictor variables)
  #   b. Must be continuous
     
  # 2. Predictors
  #   a. LM framework provides lots of flexibility to construct a model 
  #   b. Can be of any type (continuous, integer, ordinal, nominal, etc)

# Fitting in R
  # Code: lm(formula, data)
    # formula is in form y~x1+x2+...

  # lm(y~1+x+c)
    # y is response variable
    # x and c are predictors
    # 1 refers to the intercept, which is a constant term

  # lm(y~x+c)
    # Also has an intercept (intercepts are usually good)
    # lm(y~0+x+c) or lm(y~x+c-1) to suppress it 
      ## Forces intercept through origin

# Example of No Predictor: one-sample t-test (what is mean weight of African elephant?)
  # Assumption: population is normall distributed

library(readr)
library(dplyr)
library(ggplot2); theme_set(theme_bw(base_size=15))
library(broom)
library(performance)

children <- read.csv("http://faculty.washington.edu/tathornt/Biost509/DataSets/fev2.csv",header=TRUE)

summary(children)

lmean <- lm(height~1, data=children)

plot(lmean)

summary(lmean)

print(tidy(lmean, conf.int=TRUE))

# Check the assumption
  # Is the sample normally distributed? --> NO
  # Should you consider another test, or another question?
    # Permutation test of the mean
    # Test the median instead
    # Test the mean on a transformed scale

# Interpreting Diagnostics
# 1. Linear model assumptions are not met exactly
#   a. You can't use failure to reject the null hypothesis as evidence that your assumptions are ok

# 2. There is no universally accepted way to decide whether you are close enough
#   a. When sample size gets larget, your ability to reject the null gets stronger
#   b. Concerns often get smaller (particularily normality concerns via the CLT)
  
# Interpreting Results
# 1. Generally avoid R's summary table
#   a. It shows P-values but not CIs
 
# 2. Focus on estimates and confidence intervals
#   a. Interpret via:
#     i. Paying attention to units
#    ii. Using an outside reference
#   iii. Statistics is not magic

# Binary Predictor
  # Two-group test
    # 1. Predictor with two values (could be continuous or categorical)
    #     a. Can men hold their breath longer than women?
    #     b. Are mice more active at 10 degrees or 20 degrees C?
    
    # 2. Generally interested in:
    #     a. The sign of the difference
    #     b. Magnitude (size) of the difference
    # NOTE: statistics is necessary to quantify uncertainty and determing how big the difference might be in the broader populaiton

# Testing Assumptions
  # 1. Residuals should look approximately normal and approximately the same across the two groups
  #   a. Check residuals by comparing how closely the points match the normal distribution line in Q-Q plots (standard diag helps identify variance shifts between groups)
  
  # 2. Otherwise?
  #   a. Permutation test
  #   b. Different scale
  #   c. Medians

# R Model Parameters
  # Intercept (constant) is the estimated value at:
    ## Zero for continuous predictors
    ## "Baseline" for categorical predictors

  # Other parameters
    ## Slopes for continous predictors
    ## Differences for categorical predictors

  # Categorical Variable Naming:
    # R automatically names categorical coefficients
      ## Intercept = baseline group
      ## Coefficient = difference added to reach the other group


