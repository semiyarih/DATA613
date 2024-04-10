
# In files Text_m_1 to Text_m_5
# we explored in depth what we mean by the tidy text format and
# show how this format can be used to approach questions about word frequency.
# This allowed us to analyze which words are used most frequently in documents and
# to compare documents

#
# https://cengel.github.io/R-text-analysis/textprep.html

#__________________________________________________________

# install.packages("textdata")
# install.packages("tidytext")
library(tidyverse)
library(dplyr)
library(textdata)
library(tidytext)


library(stringr)

# https://www.tidytextmining.com/tidytext.html

# tidy data has a specific structure:
  
  # Each variable is a column
  # Each observation is a row
  # Each type of observational unit is a table

# TEXT MINING (Extracting, Processing, Organizing, Summarizing,
# and producing visualizations for text data) 

# What is Text mining?
## It also known as text analytics, is a process of analyzing large amounts of
  ## unstructured text data to extract meaningful insights and patterns.
  ## It involves using techniques from natural language processing, machine learning,
  ## and statistics to automatically identify and extract key information from text, such as 
  ## sentiment, topics, entities, and relationships between them.

# What is token?
##  Tokens can be individual words, phrases or even whole sentences. 

# What is tokenization?
## The process of breaking up a given text into units called tokens.




# Textmining ONLY ONE Document ----------

## Emily Dickinson wrote some lovely text in her time.-----

text_1 <- c("Because I could not stop for Death -",
          "He kindly stopped for me -",
          "The Carriage held but just Ourselves -",
          "and Immortality")

text_1 # 4 lines

#________________________________________________________

## Step 1: Craete DATA FRAME------------ 
# We need to put it into data frame, 
# before  turn it into a tidy text dataset

text_df_1 <- tibble(line = c(1:4), text = text_1)  

text_df_1  # There are four lines

# tibble packages, that has a convenient print method, will not 
# convert strings to factors, and does not use row names. 
# Tibbles are great for use with tidy tools.

#
### since each row is made up of multiple combined words. ----
# We need to convert this so that it has one-token-per-document-per-row.

#________________________________________________________

## Step 2: Tokenization------------ 
 # Within our tidy text framework, we need to both break the text into individual tokens 
# and transform it to a tidy data structure. 
# To do this, we use tidytext’s unnest_tokens() function.

#       unnest_tokens(data, output, input)

text_df_1 %>%
  unnest_tokens(word, text) ->
  tibble_1

### unnest_token()--------------
# output column name that will be created as the text is
          # unnested into it (word, in this case)

# input column that the text comes from
          # (text, in this case)

# Remember that `text_df_1` above has a column called
           # text that contains the data of interest.

### Location of each token:------
       # the word "because", "i", "could" are in line 1 and
      # "stopped" is in line 2
      # "carriage" in line 3



#### Note:-----------------------
#____________________ 1.
# Punctuation has been stripped.
#____________________ 2.
# After using unnest_tokens, we’ve split each row so that there is one token (word)
# in each row of the new data frame; the default tokenization in unnest_tokens() is for single word
#____________________ 3.
# By default, unnest_tokens() converts the tokens to lowercase, which makes them easier to compare or
# combine with other datasets. (Use the to_lower = FALSE argument to turn off this behavior).


#________________________________________________________

## Step 3:  Find frequencies for each word-------

tibble_1%>%
  count(word, sort =TRUE) %>% 
  filter(n >= 1)

#________________________________________________________

## Step 4:  Visualize -------
# Create a Data visual (Bar Graph) showing and comparing word
# frequencies
tibble_1%>%
  count(word, sort =TRUE) %>% 
  filter(n >= 1) %>%
  ggplot(aes(n, word)) +
  geom_col(fill = "blue", color = "red") +
  labs(y = NULL)

# We want reorder the levels of the `word` column based on the counts `n`. 
# We use reorder() function from {base}

tibble_1%>%
  count(word, sort =TRUE) %>% 
  filter(n >= 1) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col(fill = "blue", color = "red") +
  labs(y = NULL)
#___________________________________________________________

# Take another look of our example -----------------

#___________________________________________________________

# Manipulate process and visualize the text---------
          # (step by step)
# Having text data in tidy data lets us manipulate, process, and visualize the text using the 
# standard set of tidy tools, namely dplyr, tidyr, and ggplot2 as follow:

#____________________ A.                        #____________________ A.
#                        TIDY DATA 
#                            from{tidytext}

text_1 <- c("Because I could not stop for Death -",
          "He kindly stopped for me -",
          "The Carriage held but just Ourselves -",
          "and Immortality")

text_df_1 <- tibble(line = 1:4, text = text_1)  


#                           unnest_token
#____________________ B.                        #____________________ B.
#                        TIDY TEXT
#                       from{tidyr} and {dplyr}

text_df_1 %>%
  unnest_tokens(word, text) ->
  tibble_1
#                           count
#____________________ C.                        #____________________ C.
#                        SUMMARIZED TEXT
#                       from{tidyr} and {dplyr}
# Step 3  Find frequencies for each word

tibble_1%>%
  count(word, sort =TRUE) %>% 
  filter(n >= 1) ->
  tibble_freq_1
  
  
  
 
#                            ggplot2
#____________________ D.                        #____________________ D.
#                        VISUALIZATION

  # Step 4  Create a Data visual (Bar Graph) showing and comparing word
  # frequencies
  

tibble_freq_1 %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col(fill = "blue", color = "red") +
  labs(y = NULL)

