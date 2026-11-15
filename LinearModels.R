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

  # Ex: bengaliDigits

digit <- read_excel("BengaliDigits.xlsx")

# analyze <- (
#   digit
#   |> clean_names()
#   # |> mutate(leftDiff = )
# )

analyze <- (digit
            |> clean_names()
            |> mutate(
              leftDiff = l2d_mm - l4d_mm
              , rightDiff = r2d_mm - r4d_mm
            )
)

summary(analyze)

rdMod <- lm(rightDiff ~ 1, data=analyze)

plot(rdMod)


print(
  tidy(rdMod, conf.int=TRUE)
  |> select(term, estimate, conf.low, conf.high)
)

# Note: you cannot use a P value to confirm that things are normal + nor homoscedastic
# We compare the differences to zero

ldMod <- lm(leftDiff ~ 1, data=analyze)

## This _is_ a paired t-test

with(analyze(t.test(l2d_mm, l4d_mm, paired=TRUE, data=analyze)))

plot(ldMod)

print(
  tidy(ldMod, conf.int=TRUE)
  |> select(term, estimate, conf.low, conf.high)
)

## How big are these differences? We could:
#### divide them by mean finger length
#### divide by a standard deviation of finger lengths
#### Think about ratios (differences on the log scale!)

analyze <- (analyze
            |> mutate(leftLogRat = log(l2d_mm) - log(l4d_mm))
)

ratMod <- lm(leftLogRat ~ 1, data=analyze)

plot(ratMod)

print(
  tidy(ratMod, conf.int=TRUE)
  |> select(term, estimate, conf.low, conf.high)
)

# Compare numbers to the means (for significance)



# interaction model next week and regression and multi category



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
  #   4. Example: fev.R (regression analysis)

summary(children)
view(children)

lheight <- lm(lungCapacity~1+height, data=children)

summary(lheight)
plot(lheight)
print(tidy(lheight, conf.int=TRUE))

## ggplot shows curves with geom_smooth
## alpha is transparency, so we can see the fit better behind all the points
print(ggplot(children)
      + aes(height, lungCapacity)
      + geom_point(alpha=0.4)
      + geom_smooth()
)

# when adding formula, the formula has to be based off the aesthetics
print(ggplot(children)
      + aes(height, lungCapacity)
      + geom_point(alpha=0.4)
      + geom_smooth(method="lm"
                    , formula = y ~ x
      )
)
quartz()
check_model(lheight)
  # Data should somewhat look like posterior predictive check model

# Assumption Checking
  # Independence
  #   1. Most important assumption 
  #     a. Can't be checked statistically
  #   2. Good study design and model construction
  #   3. Observations should not share anything with other observations that's not included in the model
  ## Ex: what should we worry about in the lung example?
    # Is the same child measured twice?
    # Are some groups of children related?
    # Are older children taken from different schools?
  ## Does it depend on our scientific question?
  
# Study Design
#   1. Randomized studies, if done correctly, can address most independence concerns
#     a. Not all studies can be randomized

  # Linearity
    # is a model that's linear in these particular parameters a good fit to the data?
    # If not:
      ## Consider whenther you should transform (the response variable)
      ## Or add curvy terms (polynomial or spline)
      ## Or if you need interactions

  # Homogeneity of variance (also called homo and hetero scedasticity)
    # variance does not change with the predictor variable
    # Expect to see this if you have a large range of positive predictions
    # If variation is proprtional to size, log transformations help
 
 # Normality
  # Least important consideration
  # Most helped by CLT
  # Can often be addressed by moodifying the linerr model
    # robust lm inference
    # permuation based lm inference

## The CLT
  # most distributions converge to a normal distribution if you add up independent random variables and take the mean
    # variables that result from additive processes tend to be normal
    # variables that result from multiplicative processes tend to be lognormal
    # t-tests based on normality assumotions
 
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

# Testing the regression assumptions
  ## Assumptions are never exactly true
  ## We will rarely reject when sample size is small, and often reject when sample size is large
  ## Look for patterns in diagnostic plots and think about options

# Predictive Check
  ## Use check_model from the performance package
  ## Simulates what it should look like if assumptions were true

  ## Outliers
    ## Asks: is there a single point with a lot of influence?
    ## A point far from mean of predictor has more leverage
    ## A point outside curves you say is a point that has a big effect on analysis
    ## Sensitivity analysis
      ### try the analysis without csome combination of outliers just to see
    ### Try to rely less on normal assumption (robust or permutation-based inference)

################ More Complicated Models ###############################

# What if you don't think response is a straight line?
  # transform the response
  # transform the predictor
  # fit a curve
  # can also mean: changing your scientific question to some extent
    # what is the slope on a linear or log scale?
    # what is the average slope across a curved response?

# Categorical Predictor
  ## clasically called ANOVA
  ## We add n-1 new parameters for a variable with n categories
    ### We also add n-1 'lm variables' to the calculation (in addition to the intercept)
    ### called dummy variables vc we code which category each observation is in using 0s and 1s
  ## Ex: chickwts

summary(chickwts)

# what paradigm do we use?
  ## even assuming we are frequentist
  ## we need to fit n-1 parameters; how do we deal with alpha?
    ### the counterfactual probability of seeing something when there's nothing there
  ## at what level should we control alpha?
    ### Experiment
    ### Variable
    ### Parameter

# hypothesis based analysis
  ## best is to focus on a small set of specific questions
  ## associate them with a small number of parameters you can measure
    ### you can use contrasts or interactions to construct the test you are most interested in

# Exploratory analysis
  ## look at large number of effects
  ## which one seem interesting?
  ## should you believe them?
    ### NO
    ### Do a new experiment
    ### Maybe make some hypotheses and construct a hypothesis based q
    ### False discovery rates and p-values corrections should be used sparingly
    ### Can also look at confidence intervals
      #### be aware that some proportion do not contain the answer

# Variables and Parameters
  ## to fit a quadratic, we need two parameters for the response
  ## also means we need two 'lm variables' for the model
    ### x and x^2
  ## we might want to fit other sorts of curves (typically a spline)
  ## like feed (in chicks) this is a 'multi-parameter' variable

# Fitting a quadratic 
  ## Ex: fev
    ### Do we have specific scientific question?
      #### Does it curve up or down?
        ###### test the quadratic term
      #### Can we be confident about the avg trend, in the presence of curvature?
    ### Use R function poly
      #### Beware of overfitting

lheight <- lm(lungCapacity~1+height, data=children)
print(tidy(lheight, conf.int=TRUE))


# Multiple predictor variables
  # LMs can easily handle multiple predictor variables
  # Ex: fev.multi.rout

summary(children)
lSmoke<-lm(lungCapacity~1+currentSmoker, data = children) # why did we do 1+?

quartz()
check_model(lSmoke)

print(ggplot(children)
+ aes(currentSmoker, lungCapacity)
+ geom_boxplot()
)

lSmokeInteraction<-lm(lungCapacity~1+currentSmoker+age, data = children)
print(lSmoke)
print(lSmokeInteraction)
quartz()

# Scientific Question
  # Height can mediate the relationship between age and lung capacity
    ## People might be taller bc they're older
    ## We might want to exclude it to see direct effects of age
    ## Or include it to see total effects
  # Age cannot be caused by height
    ## We should (usually) include it to see the effect of height

# What is the effect of age on lung capacity?

quartz()
ageMod<-lm(lungCapacity~1+age, data=children)
check_model(ageMod)

quartz()
ageHeightMod<-lm(lungCapacity~1+age+height, data=children)
check_model(ageMod)

# Controlling: adding a second variable when our primary. interest is the first
  # We control for age when we study the effects of smoking on lung capacity (maybe also sex)
  # When you control for a variable, you don't necessarily need to interpret the parameters of that variable at all

# Conflation
  # Why do children who smoke have higher lung capacity?
    # Bc they're older
    ## Age 

# Accounting for Variation
  # Even when we don't have conflation, controlling for relevant preditcotrs can make our predictions more accurate
  # Ex: randomized control trial of a blood-pressure drug

# How many parameters?
  # Controlling for too many factors will make our predictions less precise
    ## Add variation, uncertainty
  # ROT: 5-10 solid, continuous data points per parameter
  # When data points are small counts, or yes/no, we need to reduce parameters further

# Which parameters?
  # Its very common to choose predictors based on preliminary analyses
  # Or to throw out interaction or curvature terms based on significance
  # This is accepting the null hypothesis (concluding these things don't matter)
  # Its also introducing confirmation bias
    ## If we choose our final test based on the data, we will be bad frequentists
     ### Will be wrong more than 5% of the time
  # Decide how many parameters you can afford based on the data and 
  # Decide which parameters to use based on scientific judgment
    # Can be based on other data, but not based on data from your study

########## Interactions ################
# So far, each predictor has its own effect, and the effects add up
  # The effect of age on lung capacity is assumed to be the same for boys and girls

# What is an interaction?

  # An interaction means the effect of one predictor depends on the value of another
    ## Ex: does lung capacity increase faster with age for boys than for girls?

  # Interactions are symmetric
    ## If the effect of age depends on sex, then the effect of sex depends on age
    ## We can choose whichever way of saying it matches our question

# Interactions in R

  # lm(y~x+z) is the additive model (no interaction)

  # lm(y~x*z) is the interactive model
    ## Short for lm(y~x+z+x:z)
    ## The new lm variable is made by multiplying x and z
    ## This is still a linear model bc it is linear in its parameters

  # How many parameters does an interaction add?
    ## Multiple the parameters of the two variables
    ## Continuous and two categories: 1
    ## Three categories and four categories: 2*3 = 6

  # General parameter formula: 
    ## Total parameters = 1 + (n-1) + (k-1) + (n-1)(k-1)
  
  # Ex: classPenguins (lmAsn)

summary(penguins)

allmod <- lm(bill_length_mm ~ bill_depth_mm, data=penguins)
quartz(title="allmod")
check_model(allmod)
print(
  tidy(allmod, conf.int=TRUE)
  |> select(term, estimate, conf.low, conf.high)
)

# use augment (from broom) to attach estimates to the original data
augAll <- augment(allmod, interval="confidence")

quartz(title="augAll")
print(ggplot(penguins)
      + aes(bill_depth_mm, bill_length_mm)
      + geom_point(aes(color=species))
      + geom_line(aes(y=.fitted), data=augAll)
      + geom_ribbon(aes(ymin=.lower, ymax=.upper)
                    , data=augAll
                    , alpha=0.4 # make ribbon translucent
                    )
)

######################################################################

spMod <- lm(bill_length_mm ~ bill_depth_mm + species, data=penguins)
check_model(spMod)
print(
  tidy(spMod, conf.int=TRUE)
  |> select(term, estimate, conf.low, conf.high)
)

## use augment (from broom) to attach estimates to the original data!
augSp <- augment(spMod, interval="confidence")

## sometimes need to think carefully about which aesthetic mappings go where; color applies to the points, but not the fit

quartz(title="augSp")
print(ggplot(penguins)
      + aes(bill_depth_mm, bill_length_mm, color=species)
      + geom_point()
      + geom_line(aes(y=.fitted), data=augSp)
      + geom_ribbon(aes(ymin=.lower, ymax=.upper, fill=species)
                    , data=augSp
                    , alpha=0.4 ## make ribbon translucent
      )
)

######################################################################

spIntMod <- lm(bill_length_mm ~ bill_depth_mm*species, data=penguins)
check_model(spIntMod)
print(
  tidy(spIntMod, conf.int=TRUE)
  |> select(term, estimate, conf.low, conf.high)
)

## use augment (from broom) to attach estimates to the original data!
augSpInt <- augment(spIntMod, interval="confidence")

## sometimes need to think carefully about which aesthetic mappings go where; color applies to the points, but not the fit
quartz(title="augSpint")
print(ggplot(penguins)
      + aes(bill_depth_mm, bill_length_mm, color=species)
      + geom_point()
      + geom_line(aes(y=.fitted), data=augSpInt)
      + geom_ribbon(aes(ymin=.lower, ymax=.upper, fill=species)
                    , data=augSpInt
                    , alpha=0.4 ## make ribbon translucent
      )
)

######### Counting Parameters ########

# Ex: 3 species of penguin x 4 islands = 12 combinations
  # intercept 1
  # penguins 2
  # islands 3
  # interactions 2x3 = 6

  # Total: 12 parameters for 12 combinations

# Interpreting parameters
  
  # y = a + bx + cz + dxz, where z is 0 for baseline, and 1 for the other group
    ## baseline gorup: intercept is a, slope is b
    ## Other group: intercept is a+c, slope is b+d
  
  # d = difference between slopes (baseline vs other group)
  # c = difference between (two interceptrs) groups when x is zero
    ## may not be interesting or even make sense
    ## centering x can make it mean something

  # parameters for the other variables are no longer overall effects

######### Main Effects #######

# Model is now estimating many different possible effects for one predictor
  # Effect is different when other predictors change

# Depending on scientific question, you can:
  # Ignore these
  # Average over them

# This confusion is often used as an excuse to throw out non-significant interactions
  # DO NOT DO THAT

########## Is one group changing more than another #######

# Treatment group changes significantly; control group does not
  # Can we say that treatment group changes more?
    ## NO bc significant and not significant are not significantly different
    ## Failing to reject for the control group doesn't mean it didn't change

# The interaction tests the question directly
  # Group x time: how different are the changes?
  # The estimate and CI are for the difference we actually care about

########### Interactions and Scale #########

# If effects combine by multiplying, they look like an interaction on the linear scale
  # A treatment that increases growth by 10% adda more grams to big animals
  # On the log scale, there may be no interaction

# Whether there is an interaction can depend on the scale you choose
  # Decide what scale makes scientific sense before interpreting
  # This is why transformations and interactions both came up under linearity

######### Which interactions? #######

# A non-significant interaction does not mean that there is no interaction
  # Throwing it out is accepting the null-hypothesis

# Same as for other parameters
  # Decide how many you can afford, and choose based on scientific judgement

# Its often good to boil things down to a one-parameter interaction
  # Beyond that, things can get complicated

###### Ex: Comparing to the control group ########

# We test reflex times in two groups of rabbits
  # One exposed to radiation, and one not
  # Usually, the non-radiation group is a sham, where you pretend to expose them to radiation

# Naive method: show that the sham group doesn't change, and the radiation group does

# Better method: show that the sham group changes differently (hypothesis that they will be relatively slower)

# Typically done with interactions
  # Although sometimes it could be done more simply with differences

















