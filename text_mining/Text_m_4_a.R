# In files Text_m_1 to Text_m_5
# we explored in depth what we mean by the tidy text format and
# show how this format can be used to approach questions about word frequency.
# This allowed us to analyze which words are used most frequently in documents and
# to compare documents

#
#

#__________________________________________________________

# The gutenbergr package
# The gutenbergr package provides access to the public domain
# works from the Project Gutenberg collection.
#                     https://www.gutenberg.org/

#
#
# In this book, we will mostly use the function 
#                  gutenberg_download()
# that downloads one or more works from Project Gutenberg by ID, 
# but you can also use other functions to explore metadata, 
# pair Gutenberg ID with title, author, language, etc.


#       Load and install packages
#install.packages("gutenbergr")
library(gutenbergr)
library(tidyverse)
library(dplyr)
library(textdata)
library(tidytext)

# Novels by H.G. Well--------

# First, let’s look at some science fiction and fantasy novels by H.G. Wells,
# who lived in the late 19th and early 20th centuries. Let’s get 
# The Time Machine,
# The War of the Worlds, 
# The Invisible Man, and 
# The Island of Doctor Moreau. 
# We can access these works using gutenberg_download() and
# the Project Gutenberg ID numbers for each novel.

#________________________________________________________

## Step 1: Craete DATA FRAME------------ 

hgwells <- gutenberg_download(c(35, 36, 5230, 159))

# You may ask how to get ID of the book?
## use catalog
#    http://www.gutenberg.org/dirs/GUTINDEX.1996

hgwells # 20,020 rows


### Note: -----
# We can group them by gutenberg_id and create row numer column
# and Identify the begining of each chapter (the row number)
hgwl <- hgwells %>%
  group_by(gutenberg_id) %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text, 
                                     regex("^chapter [\\divxlc]",
                                           ignore_case = TRUE)))) %>%
  ungroup()

hgwl

  #slice(hgwl, 19250:19300)

#________________________________________________________

## Step 2: Tokenization and remove stop_words------------ 

tidy_hgwl <- hgwl %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

tidy_hgwl  # 67, 942 rows

#________________________________________________________

## Step 3:  Find frequencies for each word-------

tidy_hgwl %>%
  count(word, sort = TRUE) 

# what are the most common words in these novels of H.G. Wells?



#________________________________________________________

## Step 4:  Visualize -----------


tidy_hgwl %>%
  count(word, sort = TRUE) %>%
  filter(n > 200) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col( color= "red", fill = "darkcyan") +
  labs(y = NULL)



