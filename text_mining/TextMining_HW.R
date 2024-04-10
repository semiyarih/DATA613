# install.packages("textdata")
# install.packages("tidytext")
library(tidyverse)
library(dplyr)
library(textdata)
library(tidytext)

# TEXT MINING (Extracting, Processing, Organizing, Summarizing,
# and producing visualizations for text data) 


# Text body 1  famous poem

text <- c("No man is an island",
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

text


# Step 1 Locate the text and create a tibble

text_tibble <- tibble(line = 14:26, text = text)

text_tibble



# Step 2 Find line locations for each word in the text

text_tibble %>%
  unnest_tokens(word, text) -> tibble2
tibble2

# print(tibble2, n = 33)



# Step 3  Find frequencies for each word
tibble2%>%
  count(word, sort =TRUE) %>% 
  filter(n >= 1) ->  



# Step 4  Create a Data visual (Bar Graph) showing and comparing word
# frequencies


tibble2%>%
  count(word, sort =TRUE) %>% 
  filter(n >= 1) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col(fill = "blue", color = "red") +
  labs(y = NULL)



# Textbody 2


text <-   c("We thus define the tidy text format as being a table",
            "with one-token-per-row. A token is a meaningful unit of text, such as a word",
            "that we are interested in using for analysis, and tokenization is", 
            "the process of splitting text into tokens. This one-token-per-row",
            "structure is in contrast to the ways text is often stored in", 
            "current analyses, perhaps as strings or in a document-term matrix.",
            "For tidy text mining, the token that is stored in each row is",
            "most often a single word, but can also be an n-gram, sentence, or",
            "paragraph. In the tidytext package, we provide functionality to", 
            "tokenize by commonly used units of text like these and convert", 
            "to a one-term-per-row format.")

text



# Step 1 Locate the text and create a tibble

text_tibble <- tibble(line = 75:85, text = text)

text_tibble



# Step 2 Find line locations for each word in the text

text_tibble %>%
  unnest_tokens(word, text) -> tibble2
tibble2



# Step 3  Find frequencies for each word
tibble2%>%
  count(word, sort =TRUE) %>% 
  filter(n >= 4) 



# Step 4  Create a Data visual (Bar Graph) showing and comparing word
# frequencies


tibble2%>%
  count(word, sort =TRUE) %>% 
  filter(n >= 4) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col(fill = "red", color = "yellow") +
  labs(y = NULL)

  

# Let's create a Word Cloud !!

# What is a Word Cloud ?

# A word cloud is a collection, or cluster, of words depicted in 
# different sizes. The bigger and bolder the word appears, the more 
#often it's mentioned within a given text and the more important 
# it is.

install.packages("tm")
install.packages("wordcloud")
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")

text <- readLines(file.choose("poemtextfile"))
text

docs <- Corpus(VectorSource(text))
docs

inspect(docs)


toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")


# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
# Remove your own stop word
# specify your stopwords as a character vector
docs <- tm_map(docs, removeWords, c("blabla1", "blabla2")) 
# Remove punctuations
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)
# Text stemming
# docs <- tm_map(docs, stemDocument)

# Now organize words and frequences in a table

dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)


# Now code to create the Word Cloud


set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

# Alternate palette names are : Blues, BuGn, BuPu, GnBu, Greens,
# Greys, Oranges, OrRd, PuBu, PuBuGn, PuRd, Purples, RdPu, Reds, 
# YlGn, YlGnBu YlOrBr, YlOrRd.




# Text Mining  Sentiment Analysis

get_sentiments("afinn")

get_sentiments("bing")

get_sentiments("nrc")


bing_word_counts <- tidy_books %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

install.packages("janeaustenr")
library(janeaustenr)
library(dplyr)
library(stringr)
library(tidyr)
library(tidyverse)
library(tidytext)


tidy_books <- austen_books() %>%
  group_by(book) %>%
  mutate(
    linenumber = row_number(),
    chapter = cumsum(str_detect(text, 
                                regex("^chapter [\\divxlc]", 
                                      ignore_case = TRUE)))) %>%
  ungroup() %>%
  unnest_tokens(word, text)

tidy_books

print(tidy_books, n = 50)

# Let's look at information for another chapter
tidy_books%>%
  filter(chapter == 4)

# Let's look at book content for another book
tidy_books%>%
  filter(book == "Emma")

# Let's consider nrc words that suggest joy.

nrc_joy <- get_sentiments("nrc") %>% 
  filter(sentiment == "joy")
nrc_joy

# Now Let's connect words found in the Emma to 
# that suggest a sentement of Joy !
tidy_books%>%
  filter(book == "Emma") %>%
  inner_join(nrc_joy) %>%
  count(word, sort = TRUE) 

# Let's create another WordCloud !!

install.packages("tm")
install.packages("wordcloud")
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")



tidy_books %>%
  anti_join(stop_words) %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 100))


+
