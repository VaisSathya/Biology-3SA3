library(readr)
library(dplyr)
library(tidyverse)
library(ggplot2); theme_set(theme_bw(base_size=15))
library(broom)
library(performance)
library(readxl)

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
    # Format: RV~PV 

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

children <- read_csv("fevData.Rout.csv")

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

# R Model Parameters (attaches a parameter to a predictor)
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

# Continuous vs Categorical Predictor in Mice Activity Example

  # Categorical View: temperature is a label (cold or warm); R turns it into 0/1 code
  #   Intercept = mean of baseline group (cold)
  #   Coefficient = how much to add to get to the other group (warm-cold)
  # 
  # Continuous View: temperature is a number (10 or 20)
  #   Slope = change in CO2 per degree
  #   Intercept = predicted CO2 at 0 degrees

# Effect Sizes
  # Units of parameters in mouse activity example = ml CO2/h for mouse activity (temp difference) and (ml CO2/h)/degC
    ## Children example: inches for height; L for volume
  # How do we know if our units should be thought of as large or not?
    # Compare to population statistics, not inferential statistics
    # Want to know if the value is large compared to something real, not compared to our own uncertainty
      ## Ex: total value, variation in population, difference between sexes, difference between species,...

    # Compare to a value with same units (student)
    # Specific scientific knowledge often needed (student)

mice <- read_csv("mouseActivityData.Rout.csv")
summary(mice)

twoGroup<-lm(activity~treat, data=mice)
# Indicator = treatment = 0 for cold or 1 for warm
# y = a+b*indicator

# Conversion = slope*gap = group difference

plot(twoGroup)

print(
  tidy(twoGroup, conf.int=TRUE)
  |> select(term, estimate, conf.low, conf.high)
)

hist(residuals(twoGroup))

twoCont<-lm(activity~temp, data=mice)
# temp = 10 or 20
# Activity = a+b*temp

# Conversion = group difference/gap = slope
plot(twoCont)

print(
  tidy(twoCont, conf.int=TRUE)
  |> select(term, estimate, conf.low, conf.high)
)

######################################




# Measures of Size (in 2 ways)
  # 1. Certainty (of parameters sign)
  #   a. p-values, t-value
   
  # 2. Effect
  #   a. unit-ed value, ratio of value to something with same unit
  #   b. or a log-ratio
   
  # 3. Ratios are also good

# Measures of Spread
  # 1. Standard Deviation 
  #   a. Measure of variation of population
  #   b. Compares this to understand effect estimate
  #   c. How important is what we see?
   
  # 2. Standard Error (or confidence interval)
  #   a. How much variation we would expect to see if estimated the parameter again
  #   b. How confident are we at what we see?
  
  ## Increasing sample --> SD changes only a little bit (typically), but SE decreases
  
    # Scientifically, are you more interested in knowing how big an effect is or how certain you are about its sign?
      ## Usually how big an effect is 
    # Why is there so much emphasis on p-values?
      ## Some people are afraid of statistics
      ## Some people want statistics to be magic

# Standard Deviation
  # Measures variability of a variable
  # Uses same units as the variable
  # Variance is the square (of SD)
  # Estimate divided by within-group SD can help understand biological importance
    ## Ex: effect of temperature treatment is 1.2x the amount of natural variability
    ## Often called d or g (JD thinks its usually better to use scientific judgement)

# Standard Error
  # Measures uncertainty of a parameter
  # Same units as the parameter
  # Same units as the response variable, if the predictor is categorical
  # Estimate divided by SE is a measure of certainty
    ## Directly related to p-value
    ## Often reported (in R's summary as the t-statistic)
      ### Won't use it in this class
    
# Parameterizing
  # Different two-group models have the same fit and same:
    # Predicted mean for each observation
    # Estimated SD???
  # But different parameterizations
    ## Baseline and difference (default for categorical variables)
    ## intercept and slope (default for continuous variables)
    ## mean and difference
  # lm does not work with too many parameters
    # based on how much data you have and types
    # two-group model takes only 2 parameters, with categorical variable associated with 1 predictor?
      ## Add 2 cat predictor, adds only 1 parameter to model
    
# Paired t-test
  # Ex: do people have more joint erosion on their dominant hand?
    ## What's missing?
      ### Missing Person ID (who does each hand belong to)
        #### Need to know which dominant hand goes with which non-dominant hand
      ### Can't use a two-group test bc the two groups are not independent; both hands belong to the same body
    
    ## How to do it?
      ### the paired t-test is equivalent to a one-sample test on the differences
      ### Procedure is the same, but now we're interested in the sign of the estimate

      ### Turn it back into a no predictor case
      ### diff = dominant = non-dominant
      ### interecept = average difference

digit <- (read_excel("BengaliDigits.xlsx"))

clean_df <- digit
analyze<- (digit
           |> clean_names()
          ## |> mutate(leftDiff = )
          )
summary(clean_df)

# Compare numbers to the means (for significance)



# interaction model next week



# lm Questions
  # t-test vs. anova vs. regression
    ## make sure predictor variables are coded correctly, and then don't worry
  # Different-size groups
    # Don't worry about it
  # lm is kind-of magic






# Continuous Predictor
  # 1. Regression analysis
  # 2. Typically focus on the slope
  # 3. Pay attention to baseline as well as intercept
  #   4. Example: fev.R

# Assumption Checking
  # Independence
  #   1. Most important assumption 
  #     a. Can't be checked statistically
  #   2. Good study design and model construction
  #   3. Observations should not share anything with other observations that's not included in the model
  # Study Design
  #   1. Randomized studies, if done correctly, can address most independence concerns
  #     a. Not all studies can be randomized

# Homogeneity of Variance
  
  # The residual spread should be the same at every value of the predictor (same in both groups)

  # When would you expect to see this?
    ## Measurement noise > spread
    ## Treatment is a small shift in mean
    ## Groups come from same homogenous population
    ## Situations where variance grows with mean
  # Consider a data transformation
    # 1. log or square root
    # 2. Welch's t-test



























########################################
# plot(regression_model)
# tidy(regression_model, conf.int = TRUE)

# Assumption Checking

# 1. Independence
# The most important assumption; it cannot generally be checked by a statistical test alone
# Good study design and appropriate model construction are essential
# Observations should not share unmodelled influences with other observations
# They should be conditionally independent given the predictors/model
# In a lung/FEV example, consider whether observations from the same person or family are related
# Repeated measurements from one individual are not independent just because they are in separate rows

# Study Design
# Properly conducted randomized studies can address many independence concerns
# Not all studies can be randomized
# When randomization is not possible, account for the structure of the data in the model/design

# Linearity
  # Ask whether a model that is linear in its chosen parameters is a good fit to the data
  # If the relationship is not adequately described:
  # 1. Transform the response
  # 2. Transform the predictor
  # 3. Add curved terms, such as polynomial terms or splines
  # 4. Consider interactions if the relationship depends on another predictor
  # These choices can change the scientific question being asked
  # Example questions:
  # What is the slope on the original linear scale?
  # What is the slope on the log scale?
  # What is the average slope over a curved relationship?

# Homogeneity of Variance
# Residual spread should be approximately constant across predictor values/groups
# Think about whether the residual variance appears to change with the fitted values or predictor
# Situations where similar variance may be expected:
# 1. Measurement noise is larger than the natural spread
# 2. Treatment creates a small shift in the mean
# 3. Groups come from the same homogeneous population
# In some situations, variance grows with the mean
# Possible approaches:
# 1. Transform the response (e.g., log or square root, when appropriate)
# 2. Consider Welch's t-test for a two-group comparison

# Normality
# Least important of these considerations
# It is often helped by the Central Limit Theorem (CLT), especially as sample size grows
# Check the distribution of residuals using diagnostic plots, including a Q-Q plot
# If needed, consider:
# 1. Robust linear-model inference
# 2. Permutation-based linear-model inference
# NOTE: Normality concerns do not override the need for independence or an appropriate model

# The Central Limit Theorem (CLT)
# Many distributions of sums/means of independent random variables tend toward a normal distribution
# Variables arising from additive processes may therefore be approximately normal
# Tests based on normality assumptions may be less sensitive to departures from normality with more data
# This is because adding and averaging occur within many statistical procedures

# Testing Regression Assumptions
# Be careful about using P-values to test assumptions
# Look for patterns in diagnostic plots and think about what those patterns imply
# A predictive check can:
# 1. Simulate data under the fitted model/assumptions
# 2. Compare simulated data with the actual data
# Outliers:
# 1. Ask whether one observation has a large influence on the overall conclusion
# 2. Consider how the conclusion changes if that observation is handled differently
# 3. Use sensitivity analysis
# 4. Where appropriate, try methods that rely less on normality assumptions

# More Complicated Models

# What if the Response Does Not Follow a Straight Line?
# Options:
# 1. Transform the response
# 2. Transform the predictor
# 3. Fit a curve
# These choices may change the scientific interpretation/question
# What is the slope on the original linear scale?
# What is the slope on the log scale?
# What is the average slope across a curved relationship?

# Categorical Predictor: ANOVA
# ANOVA can be represented as a linear model with a categorical predictor
# For a variable with n categories, the model adds n - 1 parameters relative to a baseline
# These are often represented by n - 1 dummy/indicator variables
# Dummy variables use 0s and 1s to encode which category each observation belongs to
# The intercept is the baseline category's estimated mean
# Each categorical coefficient is a difference from the baseline
# ANOVA tests whether there is evidence of differences among group means

# General example:
# anova_model <- lm(response ~ group, data = data_name)
# anova(anova_model)
# summary(anova_model)
# broom::tidy(anova_model, conf.int = TRUE)

# Variables and Parameters: Fitting a Quadratic
# To fit a quadratic relationship, the model needs parameters for x and x^2 (plus an intercept)
# The corresponding model terms are x and I(x^2)
# Example:
# quadratic_model <- lm(response ~ x + I(x^2), data = data_name)
# Other curved relationships can be fitted, often using splines

# Multiple Predictor Variables
# Multiple regression includes more than one predictor in the same model
# General form:
# multiple_model <- lm(response ~ predictor1 + predictor2, data = data_name)
# Each coefficient describes the association with that predictor while holding the other included predictors constant
# Interpret each coefficient in the context of the other variables in the model

# Interactions
# An interaction allows the relationship between one predictor and the response to depend on another predictor
# In R, use * to include both main effects and their interaction:
# interaction_model <- lm(response ~ predictor1 * predictor2, data = data_name)
# The formula predictor1 * predictor2 expands to:
# predictor1 + predictor2 + predictor1:predictor2
# The interaction term describes how the effect/slope of one predictor changes across values/groups of the other predictor

# Final Reminders
# 1. Check study design and independence first
# 2. Inspect residual/diagnostic plots for model problems
# 3. Interpret estimates and confidence intervals, not only P-values
# 4. Keep units and scientific relevance in mind when judging effect size
# 5. A statistically detectable effect is not automatically a scientifically important effect

