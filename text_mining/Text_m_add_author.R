#
#How to add author and other information in text mining?
#__________________________________________________________

# install.packages("textdata")
# install.packages("tidytext")

library(tidyverse)
library(dplyr)
library(textdata)
library(tidytext)


# Define the text, author name, address, and publication date
text <- c("In relation to the textmining assignment, I was wondering if there is a good way to store additional information in the tibble such as the authors name or the publication date?",
"Or is there another way to link this information to it?")
text
# Let's assume we want to addfollowing
author_name <- "Student"
address <- "Data 613"
publication_date <- "June 29, 2023"

# There are a few ways:
# 1. Add columns to the tibble------

# Create the tibble with the additional information
tibble_plus <- tibble(
  text = text,
  author = author_name,
  address = address,
  publication_date = publication_date
)

print(tibble_plus)


# 2. Create separate tibble specifically for storing this information.------

# Convert `text` to a tibble
text %>% 
  tibble() ->
  t_text
t_text
 # The column has no name here. I want the name of column to be `Text`
text %>% 
  tibble(Text = .) ->
  t_text_c
t_text_c



# Create a metadata tibble
t_meta <- tibble(Author = author_name, Address = address, PublicationDate = publication_date)
t_meta

# Add the metadata tibble columns to the text tibble
text_meta <- bind_cols(t_text_c, t_meta)
text_meta

print(text_meta)

# Tokenize the text and count the words
word_freq <- text_meta %>%
  unnest_tokens(Word, Text) %>%
  count(Word, sort = TRUE)

print(word_freq)



