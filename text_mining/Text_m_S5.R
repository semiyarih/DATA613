# #           # #           # #           # #

# # In files Text_m_S1 to Text_m_S5       # #  
# #            sentiment analysis         # # 

# #           # #           # #           # #   

# install.packages("textdata")
# install.packages("tidytext")
library(tidyverse)
library(dplyr)
library(textdata)
library(tidytext)
library(stringr)
library(janeaustenr)
library(tidyr)
library(ggplot2)
library(wordcloud)
library(reshape2)

# Wordclouds ------
# Let's create a Word Cloud !!

# What is a Word Cloud ?

# A word cloud is a collection, or cluster, of words depicted in 
# different sizes. The bigger and bolder the word appears, the more 
#often it's mentioned within a given text and the more important 
# it is.

# We’ve seen that this tidy text mining approach works well with ggplot2,
# but having our data in a tidy format is useful for other plots as well.

#For example, consider the wordcloud package, which uses base R graphics.
# Let’s look at the most common words in Jane Austen’s works as a whole again,
# but this time as a wordcloud.
tidy_books %>%
  anti_join(stop_words) %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 100))


# In other functions, such as comparison.cloud(), you may need to turn the data frame
# into a matrix with reshape2’s acast().

# Let’s do the sentiment analysis to tag positive and negative words using an inner join, 
# then find the most common positive and negative words. 

# Until the step where we need to send the data to comparison.cloud(), this can all be done with joins,
# piping, and dplyr because our data is in tidy format.
tidy_books %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("gray20", "gray80"),
                   max.words = 100)

# We can use this visualization to see the most important positive and negative words,
# but the sizes of the words are not comparable across sentiments.

