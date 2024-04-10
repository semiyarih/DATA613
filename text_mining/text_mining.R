# Text Analysis in R ----


# Install and load the packages
if (!require("pacman")) install.packages("pacman")

# Load contributed packages with pacman
pacman::p_load(tidyverse, tidytext, tidyr, dplyr, gglpot2, readr)

# Set working directory
setwd("C:/Users/semiyari/Desktop/DATA613/Data613-Spring23")

df <- read_csv("./data/civil_war.csv") 

# or if the folder data was inside of Week 9_SQL_TextMining, we could use
 #    df <- read_csv("./data/civil_war.csv")  

# or if the civil_war.csv was inside of Week 9_SQL_TextMining, we could use
#    df <- read_csv("civil_war.csv")  


# The data is nicely separated such that each text is in a single cell.
# We have only 384 Observations

# Let us add a new variable that shows the number of row

 df %>%
   mutate(df, n_Row = row_number()) %>%  # Each observation gets unique number
   relocate(Battle, n_Row) ->             # It will be helpful after restructure
   df_cw 
 #____________________________________________
# Restructure the dataframe ---- 
 
rdf_cw <- unnest_tokens(tbl = df_cw, input = Outcome, output = word) # this is from {tidytext. tbl is the table
                             # input is the variable that we want to unnest it. 
                                     # unnest = to put out of ( a nest)
                             # output is what we plan to get. we want to get one word
# Why we called the output variable `word`? You will see how useful it is when we 
 # want to use `anti_join() (in the second approach) from {dplyr}.
 `
 # We have 3590 observations. Why? 
#             As you can see we removed all punctuation, everything is lower case 
#                   Each word gets its own row
# Now we have data in one word-per-row format, we can manipulate it. Often we 
 # We want to remove Stop words. Stop words are the words that are not useful for 
 # any analysis. Typically common words such as "the", "of", "on",...
 # We can remove stop words with `anti_join()
 #____________________________________________
# Remove Stop words ---- 
 # How to remove stop words from rdf_cw?
 # There are two ways, I like the second one
 
 ## First approach ----
# Create a new data frame by get_stopwords() from {tidytext}
 stp <- get_stopwords(source = "smart") # why we use smart?
    # It is more expansive dictionary of sto words
    # Some use " snow ball" instead.
 
    rdf_cw %>%
      anti_join(stp, by = "word") ->
      rdf_cw1
 
 

    
     
 ## Second approach ---- 
data(stop_words)

# We get an error
rdf_cw %>%
  anti_join(stop_words) ->
  rdf_cw2

# Now it should work!
data(stop_words)  # This will have more stop words than stp

rdf_cw %>%
  anti_join(stop_words, by = "word") ->
  rdf_cw2

# I will use the rdf_cw2.


### What are those extra 47 words in rdf_cw1?----

anti_join(rdf_cw1, rdf_cw2, by = "word") 

# Lets select only column word

anti_join(rdf_cw1, rdf_cw2, by = "word") %>%
  select(word)

# What are the unique words
anti_join(rdf_cw1, rdf_cw2, by = "word") %>%
  select(word) %>%
  unique()    # unique is from {base}
# or
anti_join(rdf_cw1, rdf_cw2, by = "word") %>%
  select(word) %>%
  distinct()   # distinct is from {dplyr}. distinct() is faste than unique()

# Do they return the same result?
#     Let us check
anti_join(rdf_cw1, rdf_cw2, by = "word") %>%
  select(word) %>%
  unique() ->
  u

anti_join(rdf_cw1, rdf_cw2, by = "word") %>%
  select(word) %>%
  distinct() ->
  d

all(d==u)   # if it returns TRUE that means both returned the same result.
#____________________________________________
# Sentiment analysis ----
## bing----
# with bing dictionary.
# get_sentiments has only one argument but its argument have different values (bing, afinn, nrc)
# bing is a dictionary of whole words of assigned sentiments
# The words are labled as positive or negative

bing <- get_sentiments(lexicon = "bing")   # get_sentiments() is from {tidytext}


# Getting a new data frame that the word is matching between bing and our data frame
bing %>%
  inner_join(rdf_cw2, by = "word") -> 
  df_bing

## (afinn and nrc).  Google to learn more about these two dictionary -----
# Note The {textdata} package is required to download the NRC word-emotion association lexicon.
# and afinn word-emotion association lexicon. Thus you may need to install and load the {textdata} package
# 
# install.packages("textdata")

library(textdata)
afinn <- get_sentiments("afinn") # it has ranges from -5 to +5(more positive sentiment)
nrc <- get_sentiments("nrc")

afinn %>%
  inner_join(rdf_cw2, by = "word") -> 
  df_afinn


nrc %>%
  inner_join(rdf_cw2, by = "word") -> 
  df_nrc

#____________________________________________

# Count ----
# we will use count() from {dplyr} to find the most common words

## count the words after removing stop words ---- 
rdf_cw2 %>%
  count(word, sort = TRUE)



# Filter to remove any observation that have frequency less than 20. Why 20?
# I just made it up
rdf_cw2 %>%
  count(word, sort = TRUE) %>%
  filter( n >= 20)

# Let us reorder the variable word
rdf_cw2 %>%
  count(word, sort = TRUE) %>%
  filter( n >= 20) %>%
  mutate(word = reorder(word, n))


## Count the sentiment words  ----
# How many positive or negative words are there
df_bing %>%
  count(sentiment, sort = TRUE)

# or

df_bing %>%
  count(Battle, sentiment, sort = TRUE)

# or

df_bing %>%
  count(Battle, sentiment, n_Row, sort = TRUE)
# and so on

#____________________________________________
# Manipulate (spread) data frame from long to wide format----

df_bing %>%
  count(Battle, sentiment, n_Row, sort = TRUE) ->
  df_bing

sprd <- spread(key = sentiment,  # The key here is the variable sentiment. This is the
                  value = n, fill = 0, # the variable that we want to spread.
                  data = df_bing)   # fill =0 means if an observation does not have value positive or 
                                    # negative then replace it with zero

# or
df_bing %>%
  spread(key = sentiment, value = n, fill = 0, . )
               
# Or we can do this by pivot_wider()
df_bing %>% 
  pivot_wider(names_from = sentiment, 
                    values_from = n, values_fill = 0, .) 


#____________________________________________
# Creat a new sentiment variable----
# We want to create a new variable (sentiment, which is difference between 
   #  postive and negative)  by mutate()

sprd %>%
  mutate(sentiment = positive - negative) ->
  new_df
 

# Now we can find the mean of sentiment variable
mean(new_df$sentiment) # We may say that in average we have
#         slightly positive sentiment 
                   
#____________________________________________
# Visualization----
## Visulization Of the most common words----
# Since we have categorical variable then we use bar chart

rdf_cw2 %>%
  count(word, sort = TRUE) %>%
  filter( n >= 20) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col()

# If you would like to remove the lable word you need add labs(y = NULL) 
rdf_cw2 %>%
  count(word, sort = TRUE) %>%
  filter( n >= 20) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col() +
  labs(y = NULL)

## Visualizing for the new_df -------

new_df %>% 
  ggplot(aes(n_Row, sentiment)) + 
  geom_point() + 
  labs( x = "number of row", y ="Sentiment") 

new_df %>% 
  ggplot(aes(n_Row, sentiment)) + 
  geom_boxplot() + 
  labs( x = "Number of row", y ="Sentiment") 

 # Let us use pivot_longer
new_df %>%
  pivot_longer(cols=c(negative, positive),
               names_to = "View",
               values_to = "Points") ->
  lngr_df

lngr_df %>% 
  ggplot(aes(View, Points, fill= sentiment)) + 
  geom_boxplot() + 
  facet_wrap(vars(sentiment)) +
  labs( x = "View", y ="Points") 

#____________________________________________
## Tidying the works of Jane Austen -----------
# We use 6 completed, published novels from the {janeaustenr}
# and transform them into a tidy format.
#      install and load the package
# install.packages("janeaustenr")
library(janeaustenr)

# austen books data frame

austen_books()

# Let us group them by book

 austen_books() %>% 
   group_by(book) 
 
 
# Let us add two columns linenumber and chapter
 # chapter
 austen_books() %>%
   group_by(book) %>%
   mutate(linenumber = row_number(),
          chapter = cumsum(str_detect(text, 
                                      regex("^chapter [\\divxlc]",
                                            ignore_case = TRUE)))) 

# Now ungroup the data frame and assign it to anew data frame
 original_books <- austen_books() %>%
   group_by(book) %>%
   mutate(linenumber = row_number(),
          chapter = cumsum(str_detect(text, 
                                      regex("^chapter [\\divxlc]",
                                            ignore_case = TRUE)))) %>%
   ungroup()
 original_books

# To work with this as a tidy dataset, 
 # we need to restructure it in the one-token-per-row format,
 # which as we saw earlier is done with the 
 #      unnest_tokens() function.
 
 
 tidy_books <- original_books %>%
   unnest_tokens(word, text)
 
 tidy_books
 
# Now that the data is in one-word-per-row format, we can manipulate it 
 # with tidy tools like dplyr.  
 
 
 tidy_books <- tidy_books %>%
   anti_join(stop_words, by = "word")
 
# We can use {dplyr}’s count() to find the most common words in all the books as a whole.
 tidy_books %>%
   count(word, sort = TRUE) 

 # Because we’ve been using tidy tools, our word counts are stored in a tidy data frame. 
 # This allows us to pipe this directly to the ggplot2 package, 
 # for example to create a visualization of the most common words 
 

 
 tidy_books %>%
   count(word, sort = TRUE) %>%
   filter(n > 600) %>%
   mutate(word = reorder(word, n)) %>%
   ggplot(aes(n, word)) +
   geom_col() +
   labs(y = NULL)
 
 
 
#____________________________________________
# Word frequencies-----
# A common task in text mining is to look at the word frequencies
# Let us down load the {gutenburgr}
# The gutenbergr package provides access to the public domain works
# from the Project Gutenberg collection. 
# We will mostly use the function gutenberg_download() that downloads 
# one or more works from Project Gutenberg by ID

# If you use download.package("pac_name") instead of install.package("pac_name")
# You will get the following error
#      download.packages("pac_name")
#       Error in dir.exists(destdir) : 
#     argument "destdir" is missing, with no default


# install.packages("gutenbergr")

library(gutenbergr)

hgwells <- gutenberg_download(c(35, 36, 5230, 159))

View(hgwells)

# unnest_tokens(tbl,output,input,
#                   token = "words",
#                   format = c("text", "man", "latex", "html", "xml"),
#                   to_lower = TRUE,
#                   drop = TRUE,
#                   collapse = NULL,
#                   ...
#                   )

 hgwells %>%
   unnest_tokens(word, text) # output=word and input=text


# The tidy data frame is
 # You may get an error for the following
 tidy_hgwells <- hgwells %>%
   unnest_tokens(word, text) %>%
   anti_join(stop_words)
 
# Thus you need to add by = "word"
 tidy_hgwells <- hgwells %>%
   unnest_tokens(word, text) %>%
   anti_join(stop_words, by = "word")
 
# What are the most common words in this novel?
 
 tidy_hgwells %>%
   count(word, sort = TRUE)
 
# Now let’s get Jane Eyre, Wuthering Heights, 
 #   The Tenant of Wildfell Hall, Villette, and Agnes Grey.
 # We will again use the Project Gutenberg ID numbers for each novel
 # and access the texts using gutenberg_download().

 bronte <- gutenberg_download(c(1260, 768, 969, 9182, 767))
bronte

# Let's tidy the data frame
tidy_bronte <- bronte %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words, by = "word")


tidy_bronte %>%
  count(word, sort = TRUE)

# Interesting that “time”, “eyes”, and “hand” are in the top 10 for
# both H.G. Wells and the Brontë sisters.

# Now, let’s calculate the frequency for each word for the works of
# Jane Austen, the Brontë sisters, and H.G.

frequency <- bind_rows(mutate(tidy_bronte, author = "Brontë Sisters"),
                       mutate(tidy_hgwells, author = "H.G. Wells"), 
                       mutate(tidy_books, author = "Jane Austen")) %>% 
  mutate(word = str_extract(word, "[a-z']+")) %>%
  count(author, word) %>%
  group_by(author) %>%
  mutate(proportion = n / sum(n)) %>% 
  select(-n) %>% 
  pivot_wider(names_from = author, values_from = proportion) %>%
  pivot_longer(`Brontë Sisters`:`H.G. Wells`,
               names_to = "author", values_to = "proportion")

frequency







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



cor.test(data = frequency[frequency$author == "Bronte Sisters",],
         ~ proportion + `Jane Austen`)




cor.test(data = frequency[frequency$author == "H.G. Wells",], 
         ~ proportion + `Jane Austen`)


# Just as we saw in the plots, the word frequencies are more correlated between the Austen and 
# Brontë novels than between Austen and H.G. Wells.

