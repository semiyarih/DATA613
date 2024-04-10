# In files Text_m_1 to Text_m_5
# we explored in depth what we mean by the tidy text format and
# show how this format can be used to approach questions about word frequency.
# This allowed us to analyze which words are used most frequently in documents and
# to compare documents

#
#

#__________________________________________________________



#install.packages("textdata")
# install.packages("tidytext")
#install.packages("janeaustenr ")

library(tidyverse)
library(dplyr)
library(textdata)
library(tidytext)
library(janeaustenr)
library(stringr)


# https://www.tidytextmining.com/tidytext.html


# Textmining ONLY ONE Document ----------

## Let’s use the text of Jane Austen’s 6 completed, published novels from
# the janeaustenr package (Silge 2016), and transform them into a tidy format.
# The janeaustenr package provides these texts in a one-row-per-line format
# 




#________________________________________________________

## Step 1: Craete DATA FRAME------------ 
o_books <- austen_books() 



#________________________________________________________

## Step 2: Tokenization and remove stop_words------------ 


t_books <- o_books %>%
  unnest_tokens(word, text)

t_books   # there are 725,055 rows

# Remove stop words

t_books <- t_books %>%
  anti_join(stop_words)

t_books # now it has 217,609 rows


#________________________________________________________

## Step 3:  Find frequencies for each word-------

# We can also use dplyr’s count() to find the most common words in all the books as a whole.

t_books %>%
  count(word, sort = TRUE) 



#________________________________________________________

## Step 4:  Visualize-----------------


t_books %>%
  count(word, sort = TRUE) %>%
  filter(n > 600) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col(color = "red", fill = "darkblue") +
  labs(y = NULL)










