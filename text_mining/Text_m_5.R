# In files Text_m_1 to Text_m_5
# we explored in depth what we mean by the tidy text format and
# show how this format can be used to approach questions about word frequency.
# This allowed us to analyze which words are used most frequently in documents and
# to compare documents



#
#

#__________________________________________________________

#
#Now, let’s calculate the frequency for each word for the works of 
#     Jane Austen, 
#     the Brontë sisters, and
#     H.G. Wells 
# by binding the data frames together. 
# We can use 
#         pivot_wider() and pivot_longer() from tidyr to reshape
# our dataframe so that it is just what we need for plotting and 
# comparing the three sets of novels.

library(gutenbergr)
library(tidyverse)
library(dplyr)
library(textdata)
library(tidytext)

# calculate the frequency -----
# for each word for the works of 
#     Jane Austen, 
#     the Brontë sisters, and
#     H.G. Wells 


#__________________________________
## Novels by Jane Austen’sl--------

Austen <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text, 
                                     regex("^chapter [\\divxlc]",
                                           ignore_case = TRUE)))) %>%
  ungroup() %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)


#__________________________________
## Novels by H.G. Well--------



Hg <- gutenberg_download(c(35, 36, 5230, 159))  %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)



#__________________________________
## Novels by Brontë sisters--------


Bronte <- gutenberg_download(c(1260, 768, 969, 9182, 767))  %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

#__________________________________
# frequency ----------


frequency <- bind_rows(mutate(Bronte, author = "Brontë Sisters"),
                       mutate(Hg, author = "H.G. Wells"), 
                       mutate(Austen, author = "Jane Austen")) %>% 
  mutate(word = str_extract(word, "[a-z']+")) %>%
  count(author, word) %>%
  group_by(author) %>%
  mutate(proportion = n / sum(n)) %>% 
  select(-n) %>% 
  pivot_wider(names_from = author, values_from = proportion) %>%
  pivot_longer(`Brontë Sisters`:`H.G. Wells`,
               names_to = "author", values_to = "proportion")

frequency

# We use str_extract() here because the UTF-8 encoded texts from Project Gutenberg have
# some examples of words with underscores around them to indicate emphasis (like italics).
# The tokenizer treated these as words, but we don’t want to count
# “_any_” separately from “any”.


#__________________________________
# Visulizing--------

library(scales)

# expect a warning about rows with missing values being removed
ggplot(frequency, aes(x = proportion, y = `Jane Austen`, 
                      color = abs(`Jane Austen` - proportion))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  scale_color_gradient(limits = c(0, 0.001), 
                       low = "darkslategray4", high = "gray75") +
  facet_wrap(~author, ncol = 2) +
  theme(legend.position="none") +
  labs(y = "Jane Austen", x = NULL)

# Words that are close to the line in these plots have similar frequencies in both sets of texts,
    # for example, in both Austen and Brontë texts (“miss”, “time”, “day” at the upper frequency end) 
    # or in both Austen and Wells texts (“time”, “day”, “brother” at the high frequency end).

# Words that are far from the line are words that are found more in one set of texts than another. 
    # For example, in the Austen-Brontë panel, words like “elizabeth”, “emma”, and “fanny” (all proper nouns)
    # are found in Austen’s texts but not much in the Brontë texts, while 

# words like “arthur” and “dog” are found in the Brontë texts but not the Austen texts. 

# In comparing H.G. Wells with Jane Austen, Wells uses words like “beast”, “guns”, “feet”, and “black” that 
# Austen does not, 
# while Austen uses words like “family”, “friend”, “letter”, and “dear” that Wells does not.


# Take a look at the graphs again:
# The words in the Austen-Brontë panel are closer to the zero-slope line than
# in the Austen-Wells panel. 

# Also notice that the words extend to lower frequencies in the Austen-Brontë panel;
# there is empty space in the Austen-Wells panel at low frequency. 

# These characteristics indicate that Austen and the Brontë sisters use more similar words
# than Austen and H.G. Wells. 

# Also, we see that not all the words are found in all three sets of texts and there are fewer
# data points in the panel for Austen and H.G. Wells.


#__________________________________
# Correlation test -------

# Let’s quantify how similar and different these sets of word frequencies are using a 
# correlation test.


## Brontë Sisters vs Jane Austen -----------
cor.test(data = frequency[frequency$author == "Brontë Sisters",],
         ~ proportion + `Jane Austen`)


## H.G. Wells vs Jane Austen -----------
cor.test(data = frequency[frequency$author == "H.G. Wells",], 
         ~ proportion + `Jane Austen`)

# Just as we saw in the plots, the word frequencies are more correlated between
# the Austen and Brontë novels than between Austen and H.G. Wells.

