# Supplement for textmining_1.pdf

if (!require("pacman")) install.packages("pacman")
# Load contributed packages with pacman
pacman::p_load(tidyverse, dplyr, textdata, wordcloud,
               tidytext, stringr, janeaustenr, tm)


# The {tidytext} package
# provides functions and datasets to easily convert text into tidy
# formats and integrate seamlessly with other text mining tools.

# The “tidy text format” organizes data with one token per row.
## A token represents a meaningful unit of text, such as a word,
## used for analysis.
### Tokens can be individual words, phrases or even whole sentences.

## The process of splitting text into tokens is called tokenization.


# Four Steps Process --------------
## 1. Create a Data Frame
## 2. Tokenization: Break the text into smaller units, such as words or phrases (tokens).
## 3. Find Word Frequencies: Count how often each word appears in the text.
## 4. Visualize: Use charts like bar graphs, word clouds, or histograms to represent the frequencies.

# Example: ---------------
#      https://www.luminarium.org/sevenlit/donne/meditation17.php   (POAM)
text <-  c("No man is an island",
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
                    "And therefore never send to know for whom the bell",
                    "It tolls for thee.")

## Step 1: Create a DATA FRAME --------------
text_tibble <- tibble(line = 1:13, text = text)

text_tibble %>%
  head()

## Step 2: Tokenization  --------------------
## To work with text in a tidy format, we need to break it into
## smaller parts (called tokens) and organize it as a tidy dataset.
## We can do this using the unnest_tokens() function from
## the tidytext package.
##                unnest_tokens(data, output, input)
text_tibble %>%
  unnest_tokens(word, text) -> tibble
tibble

tibble %>% 
  slice(c(1, 11, 21, 51, 61))

#  The unnest_tokens function works with two key arguments:
## the name of the new column (for the tokens, like word) and
## the name of the existing column that contains the text to be split (like text). 

## When we use unnest_tokens, each row of the original text is split so that each word 
## becomes its own row in the new data frame. By default:
### Words are split (tokenized) individually.
### Other columns, like line numbers, stay in the data.
### Punctuation is removed.
### Tokens are converted to lowercase for easier comparison 
###            (this can be turned off with to_lower = FALSE).


## Step 3: Find Word Frequencies -------------
tibble %>%
  count(word, sort =TRUE) %>%
  filter(n > 0) ->
  tibble_freq

tibble_freq

# Step 4: Visualize -------------
tibble_freq %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col(fill = "blue", color = "red") +
  labs(y = NULL) ->
  graph

graph

### What is a Word Cloud ? -----

# A word cloud is a collection, or cluster, of words depicted in 
# different sizes. The bigger and bolder the word appears, the more 
#often it's mentioned within a given text and the more important 
# it is.
tibble %>%
  count(word, sort =TRUE) %>%
  with(wordcloud(word, n, max.words = 50))

#________________________________
# Novels of Jane Austen -------------
# using the {janeaustenr} package. 
#This package organizes the text in a one-row-per-line format.
# Let’s convert it into a tidy format for analysis.

## Step 1: Create a DATA FRAME-----
### First part: We group the data based on books

austen_books() %>%
  group_by(book)

# Let's have slices of some rows
# to see if there are different books
austen_books() %>%
  group_by(book) %>% 
  slice(c(1,  10,000, 40,000, 70,000))

### We group the data based on the book and give each row a
### unique number. So, we need to create a column for linenumber
austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number())

### Second part:------
### Now we want to find out each line of text is included in what
### chapter of the book!. So, we need to create a column for Chapter
austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text,
                                     regex("^chapter [\\divxlc]",
                                           ignore_case = TRUE))))


## Question:
# What does   regex(“^chapter [\divxlc]”  do?
##         Answer:
###       This regular expression pattern would match any chapter
####         heading in Jane Austen’s novels that starts with the word
####        “chapter” followed by a space and then one of the Roman
####         numerals I, V, X, L, or C, or the lowercase letter ‘d’.
###       \d is a metacharacter that matches any digit from 0 to 9


### Third part:-------
### In this step we ungroup the data 
original_books <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text,
                                     regex("^chapter [\\divxlc]",
                                           ignore_case = TRUE)))) %>% 
  ungroup() 

original_books

## Step 2: Tokenization and remove stop_words --------
###  There are a few words that they do not have special meaning,
### so we want to remove them. These words are listed in a file called stop_words

### Part 1:  Find line locations for each word in the text ------

tidy_books <- original_books %>%
  unnest_tokens(word, text)
tidy_books            # there are 725,055 rows

### Part 2: Stop Words -------
####  stop words are words that are not useful for an analysis, typically extremely common words
####  such as “the”, “of”, “to”, and so forth in English.

#### A data frame with 1149 rows and 2 variables:
#####   stop_words is a document from tidytext package and has 1149 rows and 2 columns.


head(stop_words)

### Remove Stop Words
###  In this part we remove the stop_words from our data by anti_join() from {dplyr}
tidy_stop <- tidy_books %>%
  anti_join(stop_words)

tidy_stop # now it has 217,609 rows


## Step 3: Find Word Frequencies ---------
###  We can also use dplyr’s count() to find the most common words in all the books as a whole.

tidy_stop %>%
  count(word, sort = TRUE) %>% 
  filter(n > 500)

# Step 4: Visualize -------------
tidy_stop %>%
  count(word, sort = TRUE) %>% 
  filter(n > 500) %>%
  ggplot(aes(n, word)) +
  geom_col(fill = "blue", color = "red") +
  labs(y = NULL)

# Reorder for better analyze
tidy_stop %>%
  count(word, sort = TRUE) %>% 
  filter(n > 500) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col(fill = "blue", color = "red") +
  labs(y = NULL) ->
  graph

graph

### Word Cloud -----


tidy_stop %>%
  count(word, sort = TRUE)  %>%
  filter(n > 500) %>%
  with(wordcloud(word, n, max.words = 100))

#____________________________________________
# Sentiment Analysis ------------
## Here we address the topic of opinion mining or sentiment analysis. 
  ## When human readers approach a text, we use our understanding of the emotional 
  ## intent of words to infer whether a section of text is positive or negative,
  ## or perhaps characterized by some other more nuanced emotion like surprise or disgust.
## We can use the tools of text mining to approach the emotional content of text programmatically

## What is a Lexicon (in Text Mining)? ------
# A lexicon is a list of words that each have a meaning or score attached to them. 
# In text mining, it’s often used for things like sentiment analysis 
#      (figuring out if a text is positive, negative, or neutral).

# For example:
  
##   The word "happy" might have a positive score.

##   The word "sad" might have a negative score.

##   A neutral word like "book" might have no score.

# When a package uses a lexicon to analyze text, it looks up each word in the text,
# finds its score from the lexicon, and uses those scores to figure out 
# the overall sentiment of the text.

## Three general-purpose lexicons are: ---------
### 1. AFINN from Finn Årup Nielsen -------
#### The AFINN lexicon assigns words with a score that runs
####    between -5 and 5, with negative scores indicating negative
####    sentiment and positive scores indicating positive sentiment.

get_sentiments("afinn")

### 2. bing from Bing Liu and collaborators -----------
#### The bing lexicon categorizes words in a binary fashion into
####   positive and negative categories.

get_sentiments("bing")

### 3. nrc from Saif Mohammad and Peter Turney -------
#### Categorizes words in a binary fashion (“yes”/“no”) into
####   categories of positive, negative, anger, anticipation, disgust,
####   fear, joy, sadness, surprise, and trust.

get_sentiments("nrc")


## EXAMPLE -------
#  Sentiment analysis with inner join
#  Let’s look at the words with a joy score from the NRC lexicon.
#   What are the most common joy words in Emma?

# Step 1:
## We need to take the text of the novels and convert the text to
## the tidy format using unnest_tokens(), Get the books

austen_books()

## Group them by the book

 austen_books() %>%
  group_by(book)

## Now create a column that keeps the row numbers. 
 ## We want  to detect the Chapter numbers 
 
 austen_books() %>%
   group_by(book) %>%
  mutate(
    linenumber = row_number(),
    chapter = cumsum(str_detect(text,
                                regex("^chapter [\\divxlc]",
                                      ignore_case = TRUE))))
 
 ## Ungroup
 austen_books() %>%
   group_by(book) %>%
   mutate(
     linenumber = row_number(),
     chapter = cumsum(str_detect(text,
                                 regex("^chapter [\\divxlc]",
                                       ignore_case = TRUE)))) %>% 
   ungroup() ->
   tidy_books
 
 tidy_books

 # Line 1 to 9 has the chapter 0 and Chapter 1 starts in line 10.
 
 # Step 2: tokenization ------------------
 
 tidy_books <- tidy_books %>%
   unnest_tokens(word, text)
 
 tidy_books
 
 ## Question: -----
 # Why we use the name `word` for output column from  unnest_tokens()?
#### Answer: This is a convenient choice because the sentiment  lexicons and 
 ### stop word datasets have columns named word;
 ### performing inner joins and anti-joins is thus easier.
 
 ## Let’s use the NRC lexicon and filter() for the joy words. ##
 
 nrc_joy <- get_sentiments("nrc") %>% 
   filter(sentiment == "joy")
 nrc_joy

 # Step 3: Frequency-----
 # Now Let's connect words found in the Emma to 
 # that suggest a sentement of Joy !
 tidy_books%>%
   filter(book == "Emma") %>%
   inner_join(nrc_joy) %>%
   count(word, sort = TRUE) 
 
 # Step 4: Visualization ------
 tidy_books%>%
   filter(book == "Emma") %>%
   anti_join(stop_words) %>%
   inner_join(nrc_joy) %>%
   count(word, sort = TRUE) %>%
   filter(n > 50) %>%
   mutate(word = reorder(word, n)) %>%
   ggplot(aes(n, word)) +
   geom_col( color= "red", fill = "darkcyan") +
   labs(y = NULL)
 
 
 
 ## Word Cloud
 tidy_books %>%
   anti_join(stop_words) %>%
   inner_join(nrc_joy) %>%
   count(word) %>%
   with(wordcloud(word, n, max.words = 100))
 
 # Use `warnings()` to see the warnings
#___________________________________________________
## Example revisited: --------------
 ### Use AFFIN --------------
 affin_joy <- get_sentiments("afinn")%>% 
   filter(value >= 1)
 
 affin_joy
 
 # Step 4: Visualization ------
 tidy_books%>%
   filter(book == "Emma") %>%
   anti_join(stop_words) %>%
   inner_join(affin_joy) %>%
   count(word, sort = TRUE) %>%
   filter(n > 50) %>%
   mutate(word = reorder(word, n)) %>%
   ggplot(aes(n, word)) +
   geom_col( color= "red", fill = "darkcyan") +
   labs(y = NULL)
 
 
 
 ## Word Cloud
 tidy_books %>%
   anti_join(stop_words) %>%
   inner_join(affin_joy) %>%
   count(word) %>%
   with(wordcloud(word, n, max.words = 100))
 
 
 #____________________________________________
 ### Use AFFIN --------------
 bing_joy <- get_sentiments("bing") %>% 
   filter(sentiment == "positive")
 bing_joy
 
 # Step 4: Visualization ------
 tidy_books%>%
   filter(book == "Emma") %>%
   anti_join(stop_words) %>%
   inner_join(bing_joy) %>%
   count(word, sort = TRUE) %>%
   filter(n > 50) %>%
   mutate(word = reorder(word, n)) %>%
   ggplot(aes(n, word)) +
   geom_col( color= "red", fill = "darkcyan") +
   labs(y = NULL)
 
 
 
 ## Word Cloud
 tidy_books %>%
   anti_join(stop_words) %>%
   inner_join(bing_joy) %>%
   count(word) %>%
   with(wordcloud(word, n, max.words = 100))
 
 