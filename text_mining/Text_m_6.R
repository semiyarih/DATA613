# In files Text_m_6
# We address the topic of opinion mining or sentiment analysis. 
# When human readers approach a text, we use our understanding of
# the emotional intent of words to infer whether a section of text is
# positive or negative, or perhaps characterized by some other more 
# nuanced emotion like surprise or disgust. 
# We can use the tools of text mining to approach the emotional content of
# text programmatically


#
#
#___________________________________________________________



# Let's create a Word Cloud !!

# What is a Word Cloud ?

# A word cloud is a collection, or cluster, of words depicted in 
# different sizes. The bigger and bolder the word appears, the more 
#often it's mentioned within a given text and the more important 
# it is.

# install.packages("tm")
# install.packages("wordcloud")
# install.packages("SnowballC")
# install.packages("RColorBrewer")
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library(readr)

setwd("C:/Users/semiyari/Desktop/DATA613/Data613-Spring23/Week 14_TextMining")

text <- readLines("poem")
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
