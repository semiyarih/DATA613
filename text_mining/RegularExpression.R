
# RegExp

# install.packages("janeaustenr")
library(janeaustenr)
library(dplyr)
library(stringr)  #fruit
library(tidyr)
library(tidyverse)
library(babynames)   
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
# Measure the running time -------------------

#_________________________________________

system.time({
tidy_books %>%
  anti_join(stop_words)
}
)
# The user time relates to the execution of the code, 
# the system time relates to system processes such as 
# opening and closing files, and the elapsed time 
# is the difference in times since you started the stopwatch
#__________________________________________
system.time({
tidy_books %>%
  filter(!word %in% (stop_words$word)) 
})

# You can also compute it some how manually (which is not recommended)
s <- Sys.time()
tidy_books %>%
  anti_join(stop_words)
print(Sys.time() -s)

#_________________________________
# Install and load the pryr package
install.packages("pryr")
library(pryr)

# Estimate memory usage of tidy_books and stop_words
tidy_books_size <- object_size(tidy_books)
stop_words_size <- object_size(stop_words)

# Estimate memory usage after anti_join
anti_join_result <- tidy_books %>% anti_join(stop_words)
anti_join_result_size <- object_size(anti_join_result)

# Print the estimated memory sizes
print(tidy_books_size)
print(stop_words_size)
print(anti_join_result_size)

#_________________________________
# Estimate memory usage of tidy_books and stop_words
tidy_books_size <- object_size(tidy_books)
stop_words_size <- object_size(stop_words)

# Estimate memory usage after anti_join
filter_result <- tidy_books %>% filter(!word %in% (stop_words$word)) 
filter_result_size <- object_size(filter_result)

# Print the estimated memory sizes
print(tidy_books_size)
print(stop_words_size)
print(filter_result_size)


# Regex-------------------------


## escaping-------------

# To create the regular expression \., we need to use \\.
dot <- "\\."
dot

# But the expression itself only contains one \
str_view(dot)



# And this tells R to look for an explicit .
str_view(c("abc", "a.c", "bef"), "a.c")

# How about this?
str_view(c("abc", "a.c", "bef"), "a\.c")

# or

str_view(c("abc", "a.c", "bef"), "a\\.c")
#_________________________

# If \ is used as an escape character in regular expressions,
# how do you match a literal \? Well, you need to escape it, 
# creating the regular expression \\. To create that regular expression,
# you need to use a string, which also needs to escape \. 
# That means to match a literal \ you need to write "\\\\" 
# — you need four backslashes to match one!


x <- c("a\\b", "acb", "a.b")
str_view(x)

str_view(x, "\\\\")


# How about if I use \\?
str_view(x, "\\")

# Alternatively, you might find it easier to use the raw strings

str_view(x, r"{\\}")

#### If you’re trying to match a literal ., $, |, *, +, ?, {, }, (, ),
#### there’s an alternative to using a backslash escape: 
### you can use a character class: [.], [$], [|], ... all match the literal values.

str_view(c("abc", "a.c", "a*c", "a c"), "a[.]c")

str_view(c("abc", "a.c", "a*c", "a c", "bb*c", "b*c"), ".[*]c")

str_view(c("abc", "a.c", "a*c", "a c", "bb*c", "b*c"), "\\b.[*]c")  # This \\b bounded to one character


## \n, end of Line----------------------


cat("Hello \nWorld")
# Another example
# storing strings in variables
string1 <- "GEEKS"
string2 <- "FOR"
string3 <- "GEEKS+"

# passing variable in cat() without new
# line serperator
cat(string1,string2,string3)

# passing a string using \n to split
cat("GEEKS \nFOR \nGEEKS+")

# passing variables using \n
cat(string1,"\n",string2,"\n",string3)

## \r Carriage Return-------------------------

cat("Hello \r World")
cat("Hello \rWorld")

#Another example
# storing strings in variables


# passing a string using \r 
cat("GEEKS \rFOR \rGEEKS+")

# passing variables using \r
cat(string1,"\r",string2,"\r",string3)


### \r\n Carriage Return-------------------------

cat("Hello \r\n World")
cat("Hello \r\nWorld")

#Another example
# storing strings in variables


# passing a string using \r 
cat("GEEKS \r\nFOR \r\nGEEKS+")

# passing variables using \r
cat(string1,"\r\n",string2,"\r\n",string3)

### \n\r Carriage Return-------------------------

cat("Hello \n\r World")
cat("Hello \n\rWorld")

#Another example
# storing strings in variables


# passing a string using \r 
cat("GEEKS \n\rFOR \n\rGEEKS+")

# passing variables using \r
cat(string1,"\n\r",string2,"\n\r",string3)

# Mixed
# passing a string using \r 
cat("GEEKS \r\nFOR \n\rGEEKS+")

cat("GEEKS \nFOR \rGEEKS+")

cat("GEEKS \rFOR")

cat("GEEKS \rFOR \r")

cat("GEEKS \rFOR \rGEEKS+")

cat("GEEKS \rFOR \rG+")

cat("GEEKS \rFOR \n")

cat("GEEKS \rFOR \nGEEKS+")

cat("GEEKS \rFORFORFOR \rGEEKS+")

cat("GEEKS \nFORFORFOR \rGEEKS+")

cat("GEEKS \nFORFORFOR \rGEEKS+, \r")

## Shorthand Character Classes-------------------
# Load required libraries
library(dplyr)
library(stringr)

### \d matches a single digit------------------
# Sample data frame 
data <- data.frame(
  ID = c(1, 2, 3, 4, 5),
  Text = c("apple123", "banana456", "orange789", "peach, peach100, 200peach", "256")
)

str_extract(data$Text, "\\d") # matches a single digit

str_extract(data$Text, "\\d+") # + matches one or more occurrence

str_extract(data$Text, "\\d*") # * matches zero or more occurrence

str_extract(data$Text, "\\d?") # ? matches zero or no occurrence

str_extract_all(data$Text, "\\d") # matches a single digit

str_extract_all(data$Text, "\\d+") # + matches one or more occurrence

str_extract_all(data$Text, "\\d*") # * matches zero or more occurrence

str_extract_all(data$Text, "\\d?") # ? matches zero or no occurrence

# Extract digits (\d) from the 'Text' column using dplyr and stringr
result <- data %>%
  mutate(Digits = str_extract(Text, "\\d+"))  

# Display the result
print(result) 

### \s matches whitespace and \w matches word-----------------


# Sample data frame
df <- data.frame(text = c("apple", " banana", "cherry", "  date", "grape", "  a  123", " e _ 23", "i_456", " aapple"))


str_extract(df$text, "^\\s*[aeiouAEIOU]\\w*") # start with whitespace zero or more then vowel and then folow with word, underscore or number

str_extract(df$text, "^\\s*[aeiouAEIOU]*")
str_extract(df$text, "^\\s+.")
str_extract(df$text, "^\\s+.+")

# Filtering rows with words starting with a vowel (\w) using dplyr
vowel_filtered <- df %>%
  filter(str_detect(text, "^\\s*[aeiouAEIOU]\\w*"))

# Filtering rows with whitespace characters (\s) using dplyr
whitespace_filtered <- df %>%
  filter(str_detect(text, "\\s"))

# Print the filtered data frames
print(vowel_filtered)
print(whitespace_filtered)

# ^\\s*[aeiouAEIOU]\\w* is used to match words that start with a vowel, ignoring any leading whitespace.
# \\s is used to match whitespace characters.


## Anchors---------------

str_view(fruit, "^a")

str_view(fruit, "a$")


str_view(fruit, "apple")

str_view(fruit, "^apple$")



#________________________________________________________________
# By default, regular expressions will match any part of a string. 
# If you want to match at the start or end you need to anchor 
# the regular expression using ^ to match the start or $ to match the end:


# You can also match the boundary between words (i.e. the start or end of a word)
# with \b. This can be particularly useful when using RStudio’s find and replace tool. 
# For example, if to find all uses of sum(), you can search for
# \bsum\b to avoid matching summarize, summary, rowsum and so on:
x <- c("summary(x)", "summarize(df)", "rowsum(x)", "sum(x)")
str_view(x, "sum")

str_view(x, "\\bsum\\b")


# When used alone, anchors will produce a zero-width match:

str_view("abc", c("$", "^", "\\b"))

str_replace_all("abc", c("$", "^", "\\b"), "--")

# Create sample data
my.data <- data.frame(
  text = c("apple", "pineapple", "banana", "applesauce", "orange", "grape")
)

# Using \b anchor to match words that start with "app"
result_b <- my.data %>%
  filter(grepl("\\bapp", text))

# Using \B anchor to match words that do not start with "app"
result_B <- my.data %>%
  filter(grepl("\\Bapp", text))

# Print the results
cat("Words that start with 'app':\n")
print(result_b)

cat("\nWords that do not start with 'app':\n")
print(result_B)

#_________________________________

data <- data.frame(
  name = c("John Doe", "Jane Doe", "Peter Smith", "Mary Johnson", "STARTJohn", "MJohnson", "JohnEND", "John Smith", "Doe Smith", "Doe John"),
  age = c(25, 20, 30, 40, 45, 50, 55, 50, 66, 60)
)

# Define anchors
# \b matches a word boundary
# \B matches a non-word boundary

# Use anchors to filter the data frame
data %>%
  filter(str_detect(name, "\\bJohn\\b"))
# John Doe    John Smith  Doe John

data %>%
  filter(str_detect(name, "\\bJohn"))
# John Doe           Mary Johnson       JohnEND     John Smith  Doe John

data %>%
  filter(str_detect(name, "John\\b"))
# John Doe  StartJohn John Smith   Doe John

#______________________________________
data %>%
  filter(str_detect(name, "\\BJohn\\B"))
# MJohnson

data %>%
  filter(str_detect(name, "\\BJohn"))
# MJohnson   MJohnson

data %>%
  filter(str_detect(name, "John\\B"))
# Mary Johnson    MJohnson

#______________________________________

data %>%
  filter(str_detect(name, "\\bJohn\\B"))
# Mary Johnson    JohnEND

data %>%
  filter(str_detect(name, "\\BJohn\\b"))
# STARTJohn


# Character classes

x <- "abcd ABCD 12345 -!@#%. abbcd"
str_view(x, "[abc]+")
str_replace(x, "[abc]+","-")
str_replace_all(x, "[abc]+","-")
.
str_view(x, "[a-z]+")

str_view(x, "[^a-z0-9]+")


# You need an escape to match characters that are otherwise
# special inside of []
str_view("a-b-e-f-c", "[a-c]")

str_view("a-b-e-f-c", "[a\\-c]")


#\d matches any digit;
#\D matches anything that isn’t a digit.
#\s matches any whitespace (e.g., space, tab, newline);
#\S matches anything that isn’t whitespace.
#\w matches any “word” character, i.e. letters and numbers;
#\W matches any “non-word” character.

x <- "abcd ABCD 12345 -!@#%."
y <- c("abcd"." ABCD", "12345"," -!@#%.")

str_view(x, "\\d")
str_view(x, "\\d+")
str_view(y, "\\d")
str_view(y, "\\d+")
str_view_all(y, "\\d")
str_view_all(y, "\\d+")
str_view_all(y, "\\d")


str_view(x, "\\D+")

str_view(x, "\\s+")


str_view(x, "\\S+")

str_view(x, "\\w+")

str_view(x, "\\W+")

# Quantifiers----------------- 
# Quantifiers control how many times a pattern matches.
# {n} matches exactly n times.
# {n,} matches at least n times.
# {n,m} matches between n and m times.





##Grouping and capturing-------------------
# As well as overriding operator precedence, parentheses 
# have another important effect: they create capturing groups
# that allow you to use sub-components of the match.
#
# \1 refers to the match contained in the first parenthesis,
# \2 in the second parenthesis, and so on. For example,
# the following pattern finds all fruits that have a repeated pair of letters:

str_view(fruit, "(..)\\1") # (..) two letters that is repeating among the name of fruit


# And this one finds all words that start and end with the same pair of letters:
  
  str_view(words, "^(..).*\\1$") # ^ start with (..)two letters that repeats but there is any letter(s) (of size (*) or more ) and it will $ end by those two letters that started.


  x <- "First Second Third Fourth"
  x
  
  str_replace(x, "(\\w+) (\\w+) (\\w+)", "\\1 \\3 \\2") %>% 
    str_view()
  
  # or wecan change the order
  str_replace(x, "(\\w+) (\\w+) (\\w+) (\\w+)", "\\4 \\3 \\2 \\1") %>% 
    str_view()
  
  
  sentences %>% 
  head()

# You can also use back references in str_replace(). 
  # For example, this code switches the order of the second and third words in sentences:
  
  sentences %>%   
    str_replace("(\\w+) (\\w+) (\\w+)", "\\1 \\3 \\2") %>% 
    str_view()

  #_____________________________________
  # If you want to extract the matches for each group you can use str_match(). But str_match() 
  
  sentences %>%  
    str_match("the (\\w+) (\\w+)") %>%  # it goes in each line find word "the" and tow words after that.
    head()                      # Note: word 'the" not "The"
  

  
  # You could convert to a tibble and name the columns:
  
  sentences %>% 
    str_match("the (\\w+) (\\w+)") %>% 
    as_tibble(.name_repair = "minimal") %>% 
    set_names("match", "word1", "word2")
  
  #_____________________________________ 
  
 df <- data.frame(sentences) 
 df %>%
   head()
 
 str_
 
df %>% 
  filter(str_detect(sentences, "the (\\w+) (\\w+)")) %>% 
  head()
#__________________________________________________________

email <- c("john@example.com", "jane@example.com", 
          "foo@bar.com", "abbcccddddd@example.com",
          "johnjohn@example.com", "johhn@example.com",
          "johhhhn@example.com")
# Sample data frame with email addresses
df <- data.frame(email)

# Filter out email addresses with consecutive repeating characters
filtered_data <- df %>%
  filter(!grepl("(.)\\1{2,}", email))

print(filtered_data)

# In this example, the regex pattern (.)\\1{2,} is used to match any character that 
# is followed by the same character repeated at least 2 times. 
# The \\1 refers to the first captured group (which is the character matched by (.)),
# and {2,} specifies that it should repeat at least 2 times.


df %>%
  filter(grepl("(.)\\1{2,}", email)) %>% 
  print()


df %>%
  filter(grepl("(.)\\1", email)) %>% 
  print()


#_____________________________________


# Create a data frame with some text
df <- data.frame(text = c("This is a sentence with 5 words",
                          "This is another sentence with morethan 5 words",
                          "Word1 word2 word3 word4 word 5",
                          "Word1 word2 word3 word4",
                          "Word1",
                          "W    1", #\\w doesn't contain whitespace, but numbers and _
                          "W____1",
                          "12345",
                          "word"   # contains four letters
                          ))



# Use the `str_detect()` function to find all rows where the text contains 5 or more words.

# 2. Text_6 = str_detect(text, "\\w{6}") is used to check if the text column contains a sequence of exactly 6 word character
df %>% mutate(Text5_More = str_detect(text, "\\w{5,}"), Text_6 = str_detect(text, "\\w{6}"),
              This = str_detect(text, "^This"))


#____________________________
## Pattern control--------------------
