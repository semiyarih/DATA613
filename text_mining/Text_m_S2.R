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

#___________________________________________________________
# Sentiment analysis with inner join -----------------------

# Let’s look at the words with a `joy score` from the NRC lexicon. 
    ## What are the most common joy words in Emma? 

###  Step 1:---------------------------- 
# we need to take the text of the novels and convert the text
# to the tidy format using unnest_tokens(),


# Get the books
tidy_books <- austen_books() 


# Group them by the book
tidy_books <- tidy_books %>%
  group_by(book)


# Now create a column that keeps the row numbers. We want to detect the 
# Chapter numbers 
tidy_books <- tidy_books %>%
  mutate(
    linenumber = row_number(),
    chapter = cumsum(str_detect(text, 
                                regex("^chapter [\\divxlc]", 
                                      ignore_case = TRUE)))) 
# Line 1 to 9 has the chapter 0 and Chapter 1 starts in line 10.



# Now we need to ungroup it
tidy_books <- tidy_books %>%
  ungroup()

# Now this is the time to tokenization
tidy_books <- tidy_books %>%
  unnest_tokens(word, text) 
# The text now is in a tidy format with one word per row.
#### A Nice Question-----
#### Why we use the name `word` for output  column from unnest_tokens()?
# Answer: 
# This is a convenient choice because the sentiment lexicons and stop word datasets
# have columns named word; performing inner joins and anti-joins is thus easier.


# we are ready to do the sentiment analysis
### Step 2: ------
# Let’s use the NRC lexicon and filter() for the joy words.

nrc_joy <- get_sentiments("nrc") %>% 
  filter(sentiment == "joy")


### Step 3: ------
# let’s filter() the data frame with the text from the books
# for the words from Emma 

tidy_books %>%
  filter(book == "Emma") ->
  Emma_joy


### Step 4: ------
# then use inner_join() to perform the sentiment analysis. 

Emma_joy %>%
  inner_join(nrc_joy) ->
  n_E_joy


### Step 5: ------
n_E_joy %>%
  count(word, sort = TRUE)

# We see mostly positive, happy words about hope, friendship,
# and love here.




#___________________________________________________________
## Sentiment changes throughout each novel.------
# We want examine how sentiment changes throughout each novel.


### Step 1: ------
# Find a sentiment score for each word using the Bing lexicon and inner_join().

bing_lex <- get_sentiments("bing") # get bing lexicon
tidy_books # We get the tidy format of jane austen books in previous part step 1.

tidy_books %>%
  inner_join(bing_lex) ->
  b_a


### Step 2:------
# Next, we count up how many positive and negative words there are in defined sections
# of each book. We define an index here to keep track of where we are in the narrative;
# this index (using integer division) counts up sections of 80 lines of text.

jane_austen_sentiment <- b_a %>%
  count(book, index = linenumber %/% 80, sentiment) # (x %/% y is equivalent to floor(x/y))

#### Question: -----
# Why 80 lines?
# 
# Small sections of text may not have enough words in them to get a good estimate of
# sentiment while really large sections can wash out narrative structure. 
# For these books, using 80 lines works well, but this can vary depending on individual texts,
# how long the lines were to start with, etc.


### Step 3: ----
# then use pivot_wider() so that we have negative and positive sentiment in separate columns,

jane_austen_sentiment <- jane_austen_sentiment %>% 
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0)


### Step 4: ----
# and lastly calculate a net sentiment (positive - negative).

jane_austen_sentiment <- jane_austen_sentiment %>% 
  mutate(sentiment = positive - negative)

### Step 4: -----
 # Now we can plot these sentiment scores across the plot trajectory of each novel.
# Notice that we are plotting against the index on the x-axis that keeps track of 
# narrative time in sections of text.

jane_austen_sentiment %>% 
  ggplot( aes(index, sentiment, fill = book)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~book, ncol = 2, scales = "free_x")

#### Question:----
# What does `scales = "free_x"` mean? 
# 
# The default, ("fixed") : scales shared across all facets 
#  ("free_x"): scales are vary across rows
# ("free_y"): scales are vary across columns 
#  ("free"): scales are vary both across columns and rows

#### Question:-----
# What can we see from the plots?
#
# how the plot of each novel changes toward more positive or negative sentiment
# over the trajectory of the story.
