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

# Comparing ------
# Comparing the three sentiment dictionaries
#
# Let’s use all three sentiment lexicons and examine how the sentiment
# changes across the narrative arc of Pride and Prejudice. 

# Remember from above that the AFINN lexicon measures sentiment with a numeric score
# between -5 and 5, 
# while the other two lexicons categorize words in a binary fashion, either positive or negative.


## Step 1:------
# 
# First, let’s use filter() to choose only the words from the one novel
# Pride and Prejudice
# we are interested in.


pride_prejudice <- tidy_books %>% 
  filter(book == "Pride & Prejudice")



## Step 2: -----
afn <- get_sentiments("afinn")
# Now, we can use inner_join() to calculate the sentiment in different ways.
afinn_1 <- pride_prejudice %>% 
  inner_join(afn)

## Step 3: -----
# Let’s again use integer division (%/%) to define larger sections of text
# that span multiple lines,
#  # We define an index here to keep track of where we are in the narrative;
# this index (using integer division). 
afinn_2 <- afinn_1 %>% 
  group_by(index = linenumber %/% 80)



## Step 4: ----
# We Add up the value of each index and call it sentiment
afinn_3 <- afinn_2 %>% 
  summarise(sentiment = sum(value))


## Step 5: -----
# We use mutate to create a column and call it method. Its values are "AFINN"
afinn <- afinn_3 %>% 
  mutate(method = "AFINN")


#____________________________

## Step 6: 
bing <-  pride_prejudice %>% 
  inner_join(get_sentiments("bing")) %>%
  mutate(method = "Bing et al.") # A tibble: 8,704 × 6

## Step 7: 
nrc <- pride_prejudice %>% 
  inner_join(get_sentiments("nrc") %>% 
               filter(sentiment %in% c("positive", 
                                       "negative"))
  ) %>%
  mutate(method = "NRC") # A tibble: 10,903 × 6

## Step 6:----
# We know bing and nrc categorize words in a binary fashion,
# either positive or negative.
# We joined them together (rowwise)

bing_and_nrc <- bind_rows(bing, nrc) # A tibble: 19,607 × 6



## Step 7:------ 
# We can use the same pattern with 
# count(), 
# pivot_wider(), and 
# mutate() 
# to find the net sentiment in each of these sections of text.
bing_and_nrc <- bing_and_nrc %>%
  count(method, index = linenumber %/% 80, sentiment) %>%
  pivot_wider(names_from = sentiment,
              values_from = n,
              values_fill = 0) %>% 
  mutate(sentiment = positive - negative)


## Step 8:-----
# We now have an estimate of the net sentiment (positive - negative) 
# in each chunk of the novel text for each sentiment lexicon. 
# Let’s bind them together
afinn_bing_and_nrc <- bind_rows(afinn, 
          bing_and_nrc)

## Step 9:-----
 afinn_bing_and_nrc %>% 
  ggplot(aes(index, sentiment, fill = method)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~method, ncol = 1, scales = "free_y")


# The three different lexicons for calculating sentiment 
# give results that are different in an absolute sense but have
# similar relative trajectories through the novel.

# We see similar dips and peaks in sentiment at about the same places
# in the novel, but the absolute values are significantly different.

# The AFINN lexicon gives the largest absolute values, with high positive values. 
# The lexicon from Bing et al. has lower absolute values and seems to
# label larger blocks of contiguous positive or negative text.

# The NRC results are shifted higher relative to the other two, 
# labeling the text more positively, but detects similar relative 
# changes in the text. 
# We find similar differences between the methods when looking at other
# novels; the NRC sentiment is high, the AFINN sentiment has more 
# variance, the Bing et al. sentiment appears to find longer stretches 
# of similar text, but all three agree roughly on the overall trends 
# in the sentiment through a narrative arc.

### Question:----
# Why is, for example, the result for the NRC lexicon biased so high 
# in sentiment compared to the Bing et al. result?

# Let’s look briefly at how many positive and negative words
# are in these lexicons.

get_sentiments("nrc") %>% 
  filter(sentiment %in% c("positive", "negative")) %>% 
  count(sentiment)
            # negative   3316
            # positive   2308

get_sentiments("bing") %>% 
  count(sentiment)
            # negative   4781
            # positive   2005
# Both lexicons have more negative than positive words, but the ratio of
# negative to positive words is higher in the Bing lexicon than the NRC lexicon. 
# This will contribute to the effect we see in the plot above, as will any systematic difference 
# in word matches, e.g. if the negative words in the NRC lexicon do not match the words that
# Jane Austen uses very well. 
#Whatever the source of these differences, we see similar relative trajectories across the narrative
# arc, with similar changes in slope, but marked differences in absolute sentiment from lexicon to lexicon.
# This is all important context to keep in mind when choosing a sentiment lexicon for analysis.