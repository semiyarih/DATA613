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





# Here we address the topic of opinion mining or sentiment analysis. 
# When human readers approach a text, we use our understanding of
# the emotional intent of words to infer whether a section of text is
# positive or negative, or perhaps characterized by some other more 
# nuanced emotion like surprise or disgust. 
# We can use the tools of text mining to approach the emotional content of
# text programmatically


#
#

#___________________________________________________________

# Remind me again why we use tidy data? --------
# Tidy data is a data format in which each variable is a column and each observation is a row,
# and there is only one type of data per table. Tidy data is ideal for text mining and sentiment analysis
# because it allows for easy manipulation and visualization of the data.




#___________________________________________________________

# Sentiment Analysis:----------
# One important application of text mining is sentiment analysis, 
# which involves determining the sentiment or emotion expressed in a piece of text.

# One popular approach to sentiment analysis with tidy data is the "tidytext" package 
# in R, which provides a framework for organizing and analyzing textual data. 
# The package includes functions for tokenizing text, calculating word frequencies, 
# and scoring the sentiment of each word using various lexicons.

# The tidytext package provides access to several sentiment lexicons.
# There are three lexicons:
  ## All three of these lexicons are based on unigrams, i.e., single words.
  ## These lexicons contain many English words and the words are assigned scores for
  ## positive/negative sentiment, and also possibly emotions like joy, anger, sadness,
  ## and so forth.
#
# Three general-purpose lexicons are

## 1. AFINN from Finn Årup Nielsen -------------------------
  ### The AFINN lexicon assigns words with a score that runs between -5 and 5,
  ### with negative scores indicating negative sentiment and positive scores indicating
  ### positive sentiment.
get_sentiments("afinn")

## 2. bing from Bing Liu and collaborators, ----------------
  ### The bing lexicon categorizes words in a binary fashion 
  ### into positive and negative categories.
get_sentiments("bing")

## 3. nrc from Saif Mohammad and Peter Turney.--------------
  ### categorizes words in a binary fashion (“yes”/“no”) into categories of positive, negative,
  ### anger, anticipation, disgust, fear, joy, sadness, surprise, and trust.
get_sentiments("nrc") 


#get_sentiments() allows us to get specific sentiment lexicons

#___________________________________________________________





