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

# Most common positive and negative words------------------

# One advantage of having the data frame with both sentiment and word 
# is that we can analyze word counts that contribute to each sentiment.
# By implementing count() here with arguments of both word and sentiment,
# we find out how much each word contributed to each sentiment.
bing_word_counts <- tidy_books %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

bing_word_counts


# This can be shown visually, and we can pipe straight into ggplot2
bing_word_counts %>%
  group_by(sentiment) %>%
  slice_max(n, n = 10) %>% 
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(x = "Contribution to sentiment",
       y = NULL)

# Take a look at the graphs
# lets us spot an anomaly in the sentiment analysis; the word “miss” 
# is coded as negative but it is used as a title for young, unmarried women
# in Jane Austen’s works. If it were appropriate for our purposes,
# we could easily add “miss” to a custom stop-words list using bind_rows(). 
# We could implement that with a strategy such as this.

stop_words #A tibble: 1,149 × 2

custom_stop_words <- bind_rows(tibble(word = c("miss"),  
                                      lexicon = c("custom")), 
                               stop_words)

custom_stop_words # A tibble: 1,150 × 2


