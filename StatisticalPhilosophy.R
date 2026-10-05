# Variable: something that we measure
# Statistic: something we calculate from our variables
  # i.e. mean, media, mode
# Parameter: something we estimate using a statistical model
    # Estimated with some uncertainty

####### P-Values and CIs ###########

# P-values are used to say how sure we are that we have seen a positive effect
# CIs are used to say what we think is going on (with a certain level of confidence)

# P-values are over-rated
# Never use a high P-value as (direct) evidence for anything
  # i.e. that an effect is small or that two quantities are similar

# What is a p-value?
  # the porbability of finding a result at least this "exterme" under the null hypothesis

# What does a significant p-value mean?
  # Unlikely that this result was observed due to randomness

# If null hypothesis is known to be false, why test?
  # bc we want to know the direction

# What does a p-value actually measure?
 # The probability, that when the null hypothesis is true, the statistics we see
 # would be equal to or more extreme than actual observed results
 # NOTE: it does NOT measure the probability that the hypothesis is true

# CIs
  # Significance generally means CI does NOT cross 0
  # Things that cross 0 are both positive and negative, whereas if they are not crossing 0, its either

# A high p value means we can't see the signs of the effect clearly
  # A low p value means we can

# You can't prove that you didn't see significance ???


############# Frequentist Paradigm ###############

# Choose an allowable mistake rate (alpha - a)
  # Almost always 0.05

# The paradigm is: our probability of being wrong shoud be <= alpha

# If we do a lot of studies (correctly), we won't be wrong more than alpha of the time

# An approach that correctly limits the probability of being wrong is *valid*

# Frequentist p-value logic
  # Define a p-value as the probability under the null of getting a value at least as extreme as observation
  # If null is true, what should p-value be?
    # alpha of the time, it will be <= alpha
    
# alpha spending
  # In simple situations, its usually equivalent or better to not compare different directions
  # Just ask what's the probability of seeing something this extreme or more in this direction
    # Divide p-value???
    # But you don't want to double probability of being wrong
  # You should divide your cutoff by 2 (spend half of your alpha on each direction)
  # It is more common to multiply p-value by 2

# The most basic frequentist test
  # What would have happened if our treatment had no effect at all? 
  # How does that compare to what we saw? 
  # What's the simplest way to do this?
  # Answer: treat them as if they were all the same (relabel all the groups) a lot of times (scramble them a shit ton)

















