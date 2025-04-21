# This file can be used alongside by "webscraping_2.pdf" 
#

if (!require("pacman")) install.packages("pacman")

# Load contributed packages with pacman
pacman::p_load(pacman, tidyverse, repurrrsive, jsonlite)

x<- list(L1 = list(A1 = 1, A2 =2), L2 = list(B1 = 3, B2 = 4))
str(x)


# View() --------

x5 <- list(10, list(20, list(30, list(40, list(50)))))
str(x5)
View(x5)



x5[[1]] 
x5[[2]]
x5[[2]][[1]]


x5[[2]][[2]][[2]][[2]] # Which could get it from the interactive View(x5)
x5[[2]][[2]][[2]][[2]] %>% 
  typeof()    #list

# To access 50 you need to write 
x5[[2]][[2]][[2]][[2]][[1]]

x5[[2]][[2]][[2]][[2]][[1]] %>% 
  typeof()   # double


# List-Columns --------
## Example 1:
# Create a tibble with list-columns
df <- tibble(
  id = 1:3,
  data = list(
    c(1, 2, 3), # First row contains a vector of 3 numbers
    c(4, 5), # Second row contains a vector of 2 numbers
    c(6, 7, 8, 9) # Third row contains a vector of 4 numbers
  )
)
# Print the tibble
print(df)   # There are two columns `id` and `data` where the value of the second column is list
View(df)
typeof(df$data)

## Example 2:

df_1 <- tibble(
  x = 1:2,
  y = c("a", "b"),
  z = list(list(1, 2), list(3, 4, 5))
)
df_1
View(df_1)
typeof(df_1[[1]])
typeof(df_1[[2]])
typeof(df_1[[3]])
typeof(df_1$z)

df_1 %>% 
  str()


# Pulling z
df_1$z
df_1[[3]]

# Pulling z with str()
df_1$z %>% 
  str()


df_1 |>
  pull(z) |>
  str()

# Unnesting ----
## Simplifying Complex data to make it wasier to work

## types of list-columns:-----
### Named List-Columns--------

df1 <- tribble(
  ~x, ~y,
  1, list(a = 11, b = 12, c= 18),
  2, list(a = 21, b = 22, c= 28),
  3, list(a = 31, b = 32, c= 38)
)
df1

# Column y contains list
# When you unnest named list-columns, each named element becomes its
# own column, so you end up with a new data frame with separate
# columns for each item in the list.
df1 |>
  unnest_wider(y)


##### unnest_wider() is used when you have a list-column
#####breaking them into individual columns, making the data wider.

df3 <- tribble(
  ~x, ~y,
  1, list(a = 11, b = 12, c= 18),
  2, list(a = 21, b = 22),
  3, list(a = 31, b = 32, c= 38, d = 42)
)
df3

df3 |>
  unnest_wider(y)
#### you can use the 
#### names_sep argument 
#### to request that they combine the column name and the element name. 
#### This is useful for disambiguate repeated names
df1 |>
  unnest_wider(y, names_sep = "_")

### Unnamed List-Columns-----
# These are simpler and don’t have named elements. 
df2 <- tribble(
  ~x, ~y,
  1, list(11, 12, 13),
  2, list(21),
  3, list(31, 32),
)
df2
# When you unnest these, they usually expand into rows, not columns.
# We’ll get one row for each child.

##### unnest_longer()
##### This function is for when you have a list-column and you want
##### to turn each item in the list into a new row. It’s like taking a
##### list of things and stacking them vertically, making the data longer
df2 |>
  unnest_longer(y)


df1 |>
  unnest_longer(y)

## Question:---------------
# What happens if one of the elements is empty?
df6 <- tribble(
  ~x, ~y,
  "a", list(1, 2),
  "b", list(3),
  "c", list()
)
df6 |> 
  unnest_longer(y)

# We get zero rows in the output, so the row effectively disappears

# If you want to preserve that row, adding NA in y, setkeep_empty = TRUE.
df6 |> 
  unnest_longer(y, keep_empty = TRUE)


# Question: --------------------
## What happens if you unnest a list-column that contains different types of vector?
df4 <- tribble(
  ~x, ~y,
  "a", list(1),
  "b", list("a", TRUE, 5)
)
df4

df4 %>% 
  unnest_longer(y)
# Because unnest_longer() can’t find a common type of vector, 
# it keeps the original types in a list-column.
# However, every element is a list, even though the contents are of different types.

df4 %>% 
  unnest_longer(y) -> new_df

typeof(new_df)

####  unnest_auto()------------- 
#### it automatically picks between unnest_longer() and unnest_wider() based on
#### the structure of the list-column.

df1 %>% 
  unnest_auto(y)

df3 %>% 
  unnest_auto(y)


df2 %>% 
  unnest_auto(y)

df6 %>% 
  unnest_auto(y)  # it has two arguments data = df6 and column = y. For missing data appear you need  unnest_longer()


df4 %>% 
  unnest_auto(y)

#### unnest() ---------------
## unnest() expands both rows and columns. It’s useful when
## you have a list-column that contains a 2d structure like a data
## frame, which you don’t see here, but you might encounter if
## you use the {tidymodels} ecosystem.
# Sample data with nested lists -----------
data <- tibble(
  id = 1:3,
  info = list(
    tibble(score = c(10, 20), time = c(5, 10)),
    tibble(score = c(15, 25, 35), time = c(7, 8, 9)),
    tibble(score = c(40), time = c(12))
  )
)
data

# info is the column of the list type

# Using unnest() to expand the 'info' column
data %>%
  unnest(info)

# JSON --------------------
## When web scraping, you often deal with data in JSON format

## Here’s a quick breakdown of how JSON works:

### Null: Similar to NA in R, it means “no data” or “empty.” 
### For example, null is used when a value is missing.

### String: A string in JSON is like a text in R, but it must be
### enclosed in double quotes. - Example: “hello world”.

### Number: JSON numbers are like R numbers. They can be
### integers (123), decimals (123.45), or in scientific notation
### (1.23e3). However, JSON doesn’t support special values like
###             Inf or NaN.
### The symbols “NaN”, “Infinity”, and “-Infinity” are replaced with “null”

### Boolean: Similar to R’s TRUE and FALSE, but in JSON, they
### are written as true or false

## Complex Types:--------------
### JSON uses two structures:
#### Arrays ------------------
# These are like unnamed lists in R. An array is a collection of
# values, enclosed in square brackets [].

##Examples:
### 1.                [“apple”, “banana”, “cherry”].
### 2.                 [null, 1, “string”, false]

#### Objects-----------------------
# These are like named lists in R. An object contains pairs of
# “keys” and “values” enclosed in curly braces {}.
###  Example:             {“name”: “John”, “age”: 30}.

###
## Dates and Times -------------------
# JSON doesn’t have a special way to store dates or times.
# Instead, dates are usually stored as strings (text). For
## Example:
  d <- "2024-11-06"
class(d)


# If you want to use these as dates in R, you need to convert
# them using functions like readr::parse_date() for dates or
#          readr::parse_datetime() for dates with times.

## Convert string to Date
library(readr)
date <- parse_date("2024-11-06")
class(date)

ymd("2024-11-06") %>% 
  class()

## Convert string to Date time "POSIXct" "POSIXt"
datetime <- parse_datetime("2024-11-06 14:30:00")
class(datetime)

ymd_hms("2024-11-06 14:30:00") %>% 
  class()


## Working with numbers ------
# Sometimes, numbers in JSON are not stored as proper
# numbers, but as strings (text). This can happen because
# JSON’s rules for numbers aren’t always perfect.
n <- "123.45" # Stored as a string
class(n)

# use parse_double() to turn it into proper number in R
parse_double(n)

parse_double(n) %>% 
  class()

parse_guess(n) %>% 
  class()

parse_integer(n)  # There is no readr function to conver a decimal number that 
# Represented as a character.
# if you want to convert it to integer you must be creative
parse_double(n) %>% 
  as.integer()

# or
as.numeric(n) %>% 
  as.integer()

# Jsonlite---------
library(jsonlite)
# There are two main functions you need to know about:
## read_json(): Use read_json() to read a JSON file from disk (computer).
### It loads the data from a JSON file so you canwith it in R.

## parse_json()


# repurrsive--------------
# A path to a json file inside the package
 library(repurrrsive)
gh_users_json() #from {repurrsive}

# You can read it with read_json():




# gh_users is:
# The list of gitHub users profiles and it is without named elements. Thus the following rturns Null
names(gh_users)
# Each profile like gh_users[[1]] is a named list
# gh_user, which is a single user profile, also in nested list form.
names(gh_users[[1]])
gh_users[[1]]  # First git hub users
gh_users[[1]]$name
gh_users[[1]]$updated_at


## read_json() ------

gh_users2 <- read_json(gh_users_json())


View(gh_users2)
gh_users2[[1]]
gh_users2[[1]]$name
gh_users2[[1]]$updated_at


# The list of gitHub users profiles and it is without named elements.
# Each profile like gh_users[[1]] is a named list
View(gh_users)

# check if they are identical
identical(gh_users, gh_users2)





## parse_json()--------------
# The function parse_json() is used to convert a string of JSON data into an R object
#           (something that R can work with).

# Its job is to take a `JSON text`  and convert it into R object 
# Let’s start with the simplest JSON: a single number (in JSON, it looks like 1)

parse_json("1") 

parse_json('"hello"')

parse_json('[1,2,3]') 


parse_json("1") %>% class()   

parse_json('"hello"') %>% class() 

parse_json('[1,2,3]') %>% class()


parse_json("1") %>% # 
  class()

parse_json('1') %>%
  class()



# "1" or '1' is an R string containing the number 1, not a JSON string.
# We are parsing JSON number 1, result is R numeric.
identical(parse_json('1'), parse_json("1"))

# How about the following?
parse_json(1) %>% 
  class()

# 1 is a number and it is not a JSON text. 
# Why these two are identical?

identical(parse_json(1), parse_json("1"))

# R first converts it to JSON for you
# Then parse_json() reads that JSON [1] 
# and gives you back 1 as an R object.

# Here are steps of the behind scene:

# 1. R first converts it to JSON for you
toJSON(1)   # [1]   #>> We will go over toJSON() later <<

# 2. Then parse_json() reads that JSON [1]
parse_json(toJSON(1))  # The result is a list

parse_json(toJSON(1))[[1]] # The result is an integer

# 3. and gives you back 1 as an R object.



parse_json(toJSON(1))[[1]] %>% 
  class()


# The short answer is:
## when parse_json() receives a number like 1, 
## it automatically converts it into a valid JSON string

identical(parse_json(1), parse_json(toJSON(1))[[1]])

#___________________________________________________________

parse_json('1') %>%
  str()   # gives a detailed structure 

parse_json("1") %>%
  str() 

parse_json(1) %>%
  str() 

parse_json('[1]') %>%
  str() 

parse_json(toJSON(1))

parse_json(toJSON(1))[[1]]

#____________________________________________________
parse_json("4-14-2025") 
# You're passing "4-14-2025" as an R string, but it is not valid JSON.
# In JSON, strings must use double quotes inside the JSON content. 
# is like doing in Json 4-14-2025 which must be writen as "4-14-2025"


parse_json(4-14-2025) 

parse_json(""4-14-2025"") # using two double quotes on both ends, so R doesn’t know where the string starts or ends.

parse_json("\"4-14-2025\"")

parse_json('"4-14-2025"')

#___________________________________________________________________
## Convert to DATE -------------
# This does not parse a date.
# It simply parses the JSON string "4-14-2025", resulting in an R character string
parse_json('"4-14-2025"') %>% 
  class()

# To get an actual R Date, you need to convert it manually:

# Parse the JSON string to R character
x <- parse_json('"4-14-2025"')  # note the inner quotes for a JSON string

# Convert to Date (format = "m-d-Y")
as.Date(x, format = "%m-%d-%Y") 

# This does not parse a date.

# or use mdy from lubridate
mdy(x)

#______________________________________________________
## JSON with an array -----------
parse_json('[1, 2, 3]')

parse_json('[1, 2, 3]') %>% 
  str()

# The string ‘[1, 2, 3]’ is a JSON array containing three numbers.
# When you parse it, R turns this array into a list of three integers.

## JSON with an object
parse_json('{"x": [1, 2, 3]}')

parse_json('{"x": [1, 2, 3]}') %>% 
  str()
# The string ‘{“x”: [1, 2, 3]}’ is a JSON object where the key x 
#            has an array [1, 2, 3] as its value.

# This means parse_json('{"x": [1, 2, 3]}') converted
# the JSON object into a list with one key (x), and the value of
# x is a list of three numbers: 1, 2, and 3.

#_________________________
# Starting the rectangling process --------
# In most cases, JSON files contain one big top-level array at the beginning. 
# This array holds data about many items, like multiple pages, records, or results.
'[
  {"name": "John", "age": 34},
  {"name": "Jane", "age": 25},
  {"name": "Sam", "age": 27}
]'    # Do not forget single quotation mark




json <- '[
{"name": "John", "age": 34},
{"name": "Jane", "age": 25},
{"name": "Sam", "age": 27}
]'     

json

# Converting JSON to a Table in R we use tibble()-------
## Each item in the array will become a row in the table

json_df <- tibble(json = parse_json(json))
json_df

## Each row represents a person (John, Jane, Sam).
## Each column represents their attributes (name and age).
# The column contains the list is `json`
# Let us unnest it

json_df %>% 
  unnest_wider(json)
# or
json_df %>% 
  unnest_auto(json)
#_____________________________________________
# Rare Cases ---------------------------
## Sometimes, a JSON file is structured as a single “top-level”object,{},
## which represents just one main item or “thing.”

'{
"status": "OK",
"results": [
{"name": "John", "age": 34},
{"name": "Susan", "age": 27}
]
}'

# This JSON data has a single top-level object with two keys:
## “status” and “results”.

## “results” is a list of two items, each with name and age fields.
###  Needs a little adjustment

json <- '{
"status": "OK",
"results": [
{"name": "John", "age": 34},
{"name": "Susan", "age": 27}
]
}'

## Json to table
json_df1 <- tibble(json = list(parse_json(json)))
json_df1  # json column contains list

## Unnest

json_df1 |>
  unnest_wider(json) # Not what we expected

#
json_df2 <- tibble(results = parse_json(json)$results)
json_df2 # results contains list

json_df2 |>
  unnest_wider(results) # result tibble


#_____ We do as follow, if we want to have a list 

parsed <- parse_json(json)

parsed$status



json_df2 |>
  unnest_wider(results) ->
  tbl
tbl


output <- list(
  status = parsed$status,
  results = tbl
)

output




#________________________________________________

# fromJSON() ------------------------
# Often works well, particularly in simple cases, but you’re better off 
# doing the rectangling yourself so you know exactly what’s happening

## The Most Cases []------

json <- '[
{"name": "John", "age": 34},
{"name": "Susan", "age": 27}
]'

fromJSON(txt = json) ->
  j_tbl
j_tbl


## Rare Cases {}-------

json <- '{
"status": "OK",
"results": [
{"name": "John", "age": 34},
{"name": "Susan", "age": 27}
]
}'


fromJSON(txt = json) ->
  json_tbl
json_tbl

View(json_tbl)

json_tbl[["results"]]

#________________________
# to JSON ----------------------
# toJSON() Convert dataframe to JSON
j_tbl

toJSON(j_tbl)

