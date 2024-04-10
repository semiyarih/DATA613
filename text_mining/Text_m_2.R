# In files Text_m_1 to Text_m_5
# we explored in depth what we mean by the tidy text format and
# show how this format can be used to approach questions about word frequency.
# This allowed us to analyze which words are used most frequently in documents and
# to compare documents

#
#

#__________________________________________________________

# install.packages("textdata")
# install.packages("tidytext")
#library(tidyverse)
#library(dplyr)
#library(textdata)
# library(tidytext)

if (!require("pacman")) install.packages("pacman")

# Load contributed packages with pacman
pacman::p_load(tidyverse, dplyr, textdata, tidytext)


# Text body 1  famous poem

text_2 <- c("No man is an island",
          "Entire of itself",
          "Every man is a piece of the continent",
          "A part of the main.",
          "If a clod be washed away by the sea",
          "Europe is the less.",
          "As well as if a promontory were.",
          "As well as if a manor of thy friend's",
          "Or of thine own were:",
          "Any man's death diminishes me",
          "Because I am involved in mankind",
          "And therefore never send to know for whom the bell tolls;",
          "It tolls for thee.")

text_2  # it has 13 lines

#________________________________________________________

## Step 1: Craete DATA FRAME------------ 
tibble(line = 1:13, text = text_2) # we created a tibble and put them in row 1 to 13 (13 lines)

text_tibble_2 <- tibble(line = 14:26, text = text_2) 

text_tibble_2 # we created a tibble and put them in row 14 to 26 (13 lines)



#________________________________________________________

## Step 2: Tokenization------------ 
# Find line locations for each word in the text

text_tibble_2 %>%
  unnest_tokens(word, text) -> tibble_2
tibble_2 # it shows the location of each word for instance 
          # "no", "man", "is" in line 14 

 print(tibble_2, n = 33)


#________________________________________________________

## Step 3:  Find frequencies for each word-------
tibble_2 %>%
  count(word, sort =TRUE) %>% 
  filter(n > 0) ->  
  tibble_freq_2
  
 tibble_freq_2 
#________________________________________________________
  
  ## Step 4:  Visalize -----
# Create a Data visual (Bar Graph) showing and comparing word
  # frequencies
  
  
tibble_freq_2 %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col(fill = "blue", color = "red") +
  labs(y = NULL)

