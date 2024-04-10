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

#library(tidyverse)
#library(dplyr)
#library(textdata)
#library(tidytext)
#library(janeaustenr)
#library(stringr)


# https://www.tidytextmining.com/tidytext.html


if (!require("pacman")) install.packages("pacman")

# Load contributed packages with pacman
pacman::p_load(tidyverse, dplyr, textdata, tidytext, janeaustenr, stringr)

# Textmining ONLY ONE Document ----------

## Let’s use the text of Jane Austen’s 6 completed, published novels from
# the janeaustenr package (Silge 2016), and transform them into a tidy format.
# The janeaustenr package provides these texts in a one-row-per-line format
# 

 austen_books()



#________________________________________________________

## Step 1: Craete DATA FRAME------------ 


original_books <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text, 
                                     regex("^chapter [\\divxlc]",
                                           ignore_case = TRUE)))) %>%
  ungroup()

original_books

# Question: -----------------------------
# What does the following mean?
        # regex("^chapter [\\divxlc]"

# Answer:
# This regular expression pattern would match any chapter heading in Jane Austen's novels 
# that starts with the word "chapter" followed by a space and then one of the Roman numerals
# I, V, X, L, or C, or the lowercase letter 'd'.
# \d is a metacharacter that matches any digit from 0 to 9




#________________________________________________________

## Step 2: Tokenization and remove stop_words------------ 


tidy_books <- original_books %>%
  unnest_tokens(word, text)

tidy_books   # there are 725,055 rows

# We separated each line of text in the original data frame into tokens.
# Now that the data is in one-word-per-row format, we can manipulate it with
# tidy tools like dplyr. Often in text analysis, we will want to remove stop words;
# stop words are words that are not useful for an analysis, typically extremely common
# words such as “the”, “of”, “to”, and so forth in English.

# A data frame with 1149 rows and 2 variables:
# word An English word
# lexicon The source of the stop word. Either "onix", "SMART", or "snowball"
#Source
#• http://www.lextek.com/manuals/onix/stopwords1.html
#• https://www.jmlr.org/papers/volume5/lewis04a/lewis04a.pdf
# • http://snowball.tartarus.org/algorithms/english/stop.txt

head(stop_words)

unique(stop_words$lexicon)
# "SMART"    "snowball" "onix"  

tidy_books <- tidy_books %>%
  anti_join(stop_words)

tidy_books # now it has 217,609 rows


#________________________________________________________

## Step 3:  Find frequencies for each word-------

# We can also use dplyr’s count() to find the most common words in all the books as a whole.

tidy_books %>%
  count(word, sort = TRUE) 



#________________________________________________________

## Step 4:  Visualize-----------------


tidy_books %>%
  count(word, sort = TRUE) %>%
  filter(n > 600) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col() +
  labs(y = NULL)










