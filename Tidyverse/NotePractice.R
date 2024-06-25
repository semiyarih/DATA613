##
## Source: https://www.listendata.com/2023/07/7-ways-to-remove-rows-with-na-in-r.html
##

library(tidyverse)
library(cowplot) # The cowplot package is a simple add-on to ggplot. It provides various features that help with creating 
library(nycflights13)  # Use for {dpyr}
library(dbplyr)

#_______________________________________________________________________________________________
# A **vignette** is a long-form guide to your package. Function documentation
# It is great if you know the name of the function you need, but it’s useless otherwise. 
# A vignette is like a book chapter or an academic paper:
# it can describe the problem that your package is designed to solve, and then 
# show the reader how to solve it.
#_______________________________________________________________________________________________
#_______________________________________________________________________________________________
# Adjusted R^2, It prevents overfitting
# 1−(1−R ^2)((n-1)/(n-k-1)) 
# n is the number of observations in the sample.
# k is the number of predictors in the model.
# Unlike regular R-squared, adjusted R-squared can be negative.
# This occurs when the model fits the data worse than a model with no predictors.
# A negative adjusted R-squared suggests that the chosen model does not explain the variability
# in the dependent variable and might be worse than a simple average of the dependent variable.
#_______________________________________________________________________________________________
# Function ----------------------

## stopifnot()------------
# It is good for identifying NA or Nan in vectors
v1 <- c(3:5, NA)
v2 <- c(3:5, NA)
v3 <- c(1:5, 16, Inf)
v4 <- c(1, 2, 3, 4, 5, 16, Inf)
stopifnot(v3 == v4) # it returns nothing if vectors are the same and if none entries are NA
v3 == v4


stopifnot(v1 == v2) # vectors are the same size but contain NA. It returns Error. Why?
# Because R knows NAs are not the same. For instance NA +1 = NA not same as NA = NA + 2
v1 == v2

# How about NaN?
v5 <- c(3:5, NaN)
v6 <- c(3:5, NaN)

stopifnot(v5 == v6) # Returns error
v5 == v6

## is.na() ------
# it check the vector if it finds NA return true for that entry otherwise Fasle
is.na(v1)

sum(is.na(v1))  # counts the number of TRUE which here is NA

# The following vectors have the same length and both have NA in position 2.
x <- c(1, NA, 2)
y <- c(NA, NA, 2)
is.na(x)
is.na(y)

is.na(x) & is.na(y) # the operand & is TRUE if both entries are TRUE so, 
    #the only place both are TRUE is when both vector has NA on the same positions otherwise it returns FALSE
### sum()---- 
# Used to find how many NA
(is.na(x) & is.na(y)) %>% 
  sum()


# But I am interested to know which position has NA in both vectors
### which()-------
# Used to find the location

(is.na(x) & is.na(y)) %>% 
  which()
## Create a function----------
na_both_position <- function(x, y){
  if (length(x) == length(y)){
    na_s <- sum(is.na(x) & is.na(y))
    na_p <- which(is.na(x) & is.na(y))
    na <- paste("The number of NA is ", na_s, " and the NA(s) are in positions(s) ", na_p)
  } else {
    na <- "No match"
  }
  na
}
na_both_position(c(1, NA, 2), c(NA, NA, 2))
na_both_position(c(NA, 2, NA), c(2, NA, NA))
na_both_position(c(NA, NA, NA), c(NA, NA, 2))
na_both_position(c(NA, NA, NA), c(NA, NA, 2, 1))

# "print" is used to display the value of an object to the console or output window, 
# while "cat" is used to concatenate and print one or more objects to the console or output window.

# print just shows the human user a string representing what is going on inside the computer. 
# The computer cannot make use of that printing. return is how a function gives back a value. 
# This value is often unseen by the human user, but it can be used by the computer in further functions.

N <- 2
M <- c(3, 5)

print(M)
return(M) # Error No function to return from


print("The number of NA is ", N, " and the NA(s) are in positions(s) ", M) # You get Error


paste("The number of NA is", N, "and the NA(s) are in positions(s)", M)  # Gives space
paste0("The number of NA is ", N, " and the NA(s) are in positions(s) ", M) # Do not give space

print(paste("The number of NA is ", N, " and the NA(s) are in positions(s) ", M))


cat("The number of NA is ", N, " and the NA(s) are in positions(s) ", M)

## Conditional Statement ----
# if-else


### Note about is.integer()-------------
# it check if an object is integer type
is.integer(10)  # False

is.integer(10L) # TRUE
is.integer(-2L) # TRUE

## to find if a number is whole number we can divide it by 1. If the reminder is 0 we have a whole number

25%% 1 == 0
25.1 %% 1 ==0

#### # Write a function to evaluate if a number is even or odd

even_odd <- function(x){
  if (x %% 1== 0){     # Check if the number is a whole number. If it is not return "Not a whole number"
    if  (x %% 2 == 0)  # check if number is even or odd
    {
      status <- "Even"
    }
    else 
    {
      status <- "Odd"
    }
    return(status)
  }
  else{
    status <- "Not a whole number"
  }
  return(status)
}
    
    
  
even_odd(-119)



## How to remove NA?-------

## From a vector----------------
### 1. Using is.na() ----
v <- c(15, 3, 2, NA)
v[!is.na(v)]

### 2. Using na.rm (as a an argument) ----
sum(v)  # returns NA
sum(v, na.rm = TRUE)
mean(v, na.rm = TRUE)
var(v, na.rm = TRUE)
sd(v, na.rm = TRUE)

### 3. Using omit() method-----
  # Returns the non-NA values
  # Returns the indexes of NA values which are removed from the vector
na.omit(v)


## From a data frame----------------
### 1.  use na.omit() from {stat}-------
# It is good for a data frame

v <- c(15, 3, 2, NA)
na.omit(v)

# define v as a dataframe
df <- as.data.frame(v)
df
na.omit(df)

### 2. Removing Rows with NAs -----

#### 2a. using complete.cases() Function ------
df
df[complete.cases(df), ]

#### 2b. using rowSums() Function ---------
df[rowSums(is.na(df)) == 0, ]

#### 2c. using drop_na() Function -----------
df %>% 
  drop_na()

#### 2d. with Only NAs in a Row using subset() & rowSums() Functions-----------------
subset(df, rowSums(is.na(df)) != ncol(df))

#### 2e.  with Only NAs in a Row using filter() & rowSums() Functions-----------------
filter(df, rowSums(is.na(df)) != ncol(df))

#### 2f. with Only NAs in a Row using rowSums() & ncol() Functions-------
df[rowSums(is.na(df)) != ncol(df), ]


##### Example: -------
df <- data.frame(name = c('deeps','sandy', 'david', NA,'preet',NA),
                 sex   = c('Male', 'Male', NA, NA, 'Female',NA),
                 score = c(50, 100, 45, 100, 90, NA),
                 address = c('London', 'Bangalore', NA, NA, NA,NA))


df

# 1. 
na.omit(df)

# 2a.
df[complete.cases(df), ]

# 2b.
df[rowSums(is.na(df)) == 0, ]

# 2c.
df %>% 
  drop_na()

# 2d.
subset(df, rowSums(is.na(df)) != ncol(df))


# 2e.
filter(df, rowSums(is.na(df)) != ncol(df))

# 2f.

df[rowSums(is.na(df)) != ncol(df), ]


### Exercise---------------
## Implement a `fizzbuzz()` function. It takes a single number as 
## input. If the number is divisible by three, it returns `"fizz"`. If it's 
## divisible by five it returns `"buzz"`. If it's divisible by three and five, 
## it returns `"fizzbuzz"`. Otherwise, it returns the number.


fi.bu_zz <- function(x){
  x <- 
  if (x %% 15 == 0){
    return("fizzbuzz")
  }
else if (x %% 5 == 0){
  return("buzz")
}
else if (x %% 3 == 0){
  return("fizz")
}
else{
  return(x)
}
}

fi.bu_zz(50)
fi.bu_zz(45)
fi.bu_zz(9)
fi.bu_zz(17)
fi.bu_zz(c(15, 3, 2))  # we get error here


## for vector x

output <- 0 # we need to initate the object input
fi.bu_zzv <- function(x){
  x <- x[!is.na(x)]  # remove NA
  l <- length(x) # length of vector x
  if (l <= 1){
    x <- c(x)
  }
  else{
    x<- x
  }
  
  for (i in 1:l){
    if (x[i] %% 15 == 0){
      output[i] <- "fizzbuzz"
    }
    else if (x[i] %% 5 == 0){
      output[i] <- "buzz"
    }
    else if (x[i] %% 3 == 0){
      output[i] <-"fizz"
    }
    else{
      output[i] <-x[i]
    }
  }
  return(output)
}


fi.bu_zzv(50)
fi.bu_zzv(45)
fi.bu_zzv(9)
fi.bu_zzv(17)
fi.bu_zzv(c(15, 3, 2)) 


# Visualization ----------------
# install.packages("tidyverse")
# library(tidyverse) # The packge ggplots, dplyr and many more included

### Question:-------
# 1. Do you see any conflict message?
#    It says there are conflicts between 
#     dplyr::filter and stats::filter
#              also
#      dplyr::lag() and stats::lag()
# What is different between lag() in dplyr and stats packages?
#______________________________________
###LAG and LEAD------------
# LAG refers: to a delay in performance
## 


# Example to show difference
# Create a data frame
df <- data.frame(
  Group = c("A", "A", "B", "B", "B"),
  Value = c(1, 2, 3, 4, 5)
)

# Calculate the lag of 'Value' within each group
df
df %>% 
  group_by(Group) %>%
  mutate(Lagged_Value = lag(Value))  # This is the lag() with dplyr

## stat:lag(x, k =1, ...) where value is a time series object with the same class as x
# This applies to a time series

dates <- seq(as.Date("2023-01-01"), by = "month", length.out = 12)
dates
values <- rnorm(12, mean = 50, sd = 10)
values

df <- data.frame(Date = dates, Value = values)
df

  as.ts(df) -> time_series
time_series     # Convert to time series
               # we may use 
                       ts(df)
  
 # class of time_series is "mts"    "ts"     "matrix". We want to be only ts
                       
                               

stats::lag(time_series, k=2) # Start 2 months earlier

class(time_series) <- "ts"
class(time_series)

stats::lag(time_series, k=3)  # Start 2 months earlier

## Another example

# Calculate the lag of the vector
lagged_x <- stats::lag(x, 2)
lagged_x  # tsp is Attribute of Time-Series-like Objects

ldeaths %>% 
  class()

stats::lag(ldeaths, 1) # starts one month earlier

#____________________________

dplyr::lag(1:5)

lag(1:5) # If you just type lag() it will run it from dplyr,
# because it is currently loaded.



x <- 1:10
x
lag(x) # lag function shifted our vector one element to the left side.
# It remove the last value and add NA at the beginning!
lead(x) # lead function shifted our vector one element to the right side.
# It remove the first value and add NA at t


# End of the Examples ABout LAG

##_____________________________________________________

## ggplot and ggplot2--------------------
# You may notice that we sometimes reference 'ggplot2' and sometimes 'ggplot'. 
# To clarify, 'ggplot2' is the name of the most recent version of the package. 
# However, any time we call the function itself, it's just called 'ggplot'.



# **Aesthetic** means “something you can see”.
# The aesthetic attributes consists of color,
# size, and shape. Aesthetic mappings describe how variables in the data are
# mapped to visual properties (aesthetics) of geoms (geometric of objects).

# **A geom** defines the
#layout of a ggplot2 layer. So, a geoms help you to create histogram, bar charts,
# or any other plots.

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "2seater"), # it shows the trend only for 2seater car
              se = FALSE)

# Linear Trend

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), 
              method = lm, # it shows the linear trend only for subcompact car
              se = FALSE)


## FACET -------------

###  - FACET a Single Variable---------------
#Please note the ~ before the name of variable in the first argument of `facet_wrap(,)`
# Also the variable must be discrete (or categorical)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, ncol=2 )   # Category class



# A Discrete variable (cty)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ cty, nrow = 5) 

### FACET on the combination of two variables----------------

#Please note the ~ between the name of variables in the argument of `facet_grid(,)`

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)   # drive and cylinder


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(trans ~ drv)  

# See the difference

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ trans)  

#### USE COWPLOT

p1 <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() +
  geom_smooth(se = FALSE)
p2 <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() +
  geom_smooth(mapping = aes(group = drv), se = FALSE)
p3 <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy,
                                       color=drv)) + 
  geom_point() +
  geom_smooth(se = FALSE)
p4 <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color=drv)) +
  geom_smooth(se = FALSE)
p5 <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color=drv)) +
  geom_smooth(se = FALSE, mapping = aes(linetype = drv))
p6 <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color=drv)) 

theme_set(theme_gray())

# Combine all plots
plot_grid(p1, p2, p3, p4, p5, p6,
          labels=c("1","2","3", "4","5","6"), ncol=2,
          nrow = 3)


# Tidy Data and Tidying Data----------------------


#  We want tidy data because R easily manipulates vectors. So in the long run 
# it will make your life easier to first make data tidy.

# Tables: display the number of Tuberculosis (TB) cases 
# documented by the World Health Organization in Afghanistan, Brazil, and China 
# between 1999 and 2000.

## Gather & Pivot_Longer --------------
# gather() and pivot_longer()
      # Problem: One variable spread across multiple columns.
table4b

# The columns `1999` and `2000` contain the value of cases and populations

#  i. The columns that are values, not variables,
#  ii. The name of the variable that will take the values of the column names 
# (`key`), and
#  iii. The name of the variable that will take the values spread in the cells 

                     #### gather(data,..., key, value)------
               # ... a selection of columns
 #_____________#### Get `cases`#______________#
##### Use table4a

tidyr::table4a %>%
  gather(`1999`, `2000`, key = "Year", value = "cases") ->
  tidy4a1
tidy4a1
#______________#                          #______________#                    #______________#
                                          #    # We can remove " around variables name       #
                                          #    # as long as they are one word.               #
#______________#                          #______________#                    #______________#
# or
tidyr::table4a %>%
  gather(c(`1999`, `2000`), key = "Year", value = "case")


#_____________#### Get `populations`#______________#
 ##### Use table4b

tidyr::table4b %>%
  gather(`1999`, `2000`, key = "Year", value = "Population") ->
  tidy4b1
tidy4b1

          #### pivot_longer(data, cols, names_to, values_to)-----------------
           # if a data frame (df) has more than one columns use  c(vi, vj, vk)
# An updated approach to `gather()` is `pivot_longer()`. It "lengthens" data, 
# increasing the number of rows and decreasing the number of columns.

#_____________#### Get `cases`#______________#
##### Use table4a
tidyr::table4a %>%
  pivot_longer(`1999`,`2000`, names_to = "Year", values_to = "cases") # error (only one place for argument cols)


tidyr::table4a %>%
  pivot_longer(`1999`: `2000`, names_to = "Year", values_to = "cases")

# or

tidyr::table4a %>%
  pivot_longer(cols = c(`1999`, `2000`), names_to = "Year", values_to = "cases")

# or

tidyr::table4a %>%
  pivot_longer(c(`1999`, `2000`), names_to = "Year", values_to = "cases")

#_____________#### Get `populations`#______________#
##### Use table4b
tidyr::table4b %>%
  pivot_longer(cols = c(`1999`, `2000`), names_to = "Year", values_to = "Population")


#_____________#### Combine tidy4a1 and tidy4b1 by `left_join`#______________#
   #by `country` and `Year`
left_join(tidy4a1, tidy4b1, by = c("country", "Year"))


## Spread & Pivot_Wider -------------------
# spread() and pivot_wider()
          # Problem: One observation is spread across multiple rows.
table2

              #### spread(data, key, value)------
table2 %>% 
  spread(key =  "type", value = "count")


              #### pivot_wider(data, names_from, values_from)------
table2 %>% 
  pivot_wider(names_from = "type", values_from = "count")


## Separate -------------
                               # ## `separate(data, col, into)` 
# Problem: One column contains two (or more) variables.

table3

table3 %>% 
  separate(col = "rate", into = c("cases", "Population"))


## Unite--------------------
            ### `unite(data, ... , col, sep)`
# Unite multiple columns to one column

table5  #Year divide to century and year
# Problem: One variable spread across multiple columns.

table5 %>% 
  unite("century", "year", col = "Year", sep = "" ) ->
  tidy5
 # Or
table5 %>% 
  unite(century: year, col = "Year", sep = "" )
# Or
table5 %>% 
  unite(c(century, year), col = "Year", sep = "" )


# Note the vales are character
str(tidy5)
 # Thus we need parse Year to double
tidy5 %>%
  mutate(Year = parse_number(Year)) ->
  tidy5a
tidy5a

#DPLYR ---------------------------------
# To explore the basic data manipulation verbs of dplyr, we’ll use `nycflights13::flights`.

# We need to remember the five key dplyr functions that allow
# you to solve the vast majority of your data manipulation challenges:
# 1. Filter
# 2. Arrange
# 3. Select
# 4. Mutate
# 5. Summarize

## 1. filter() -------------------
# Pick observations by their values

 # This will select every row where month is one of the values 11 or 12.

flights %>% 
  glimpse()

nov_dec <- filter(flights, month %in% c(11, 12))
nov_dec

    #____________________________________________________________________#
    #                   `x %in% y`\                                      #
    #    This will select every row where x is one of the values in y    #
    #                                                                    #
    #       month %in% c(11, 12) will select every month whose           #
    #                value is 11 and 12                                  #
    #____________________________________________________________________#
# Or

filter(flights, month >= 11)

# If you wanted to find flights that weren’t delayed (on arrival or departure)
# by more than two hours, you could use either of the following two filters:

flights %>% 
  filter(arr_delay <= 120 | dep_delay <= 120)

# or

flights %>% 
  filter(!(arr_delay > 120 & dep_delay > 120))  # instead of & we can use ,


flights %>% 
  filter(is.na(dep_delay))  # we filter only NA

flights %>% 
  filter(is.na(dep_delay) & origin == "LGA")  


## 2.`arrange()`------
# `arrange()`: Reorder the rows\
# The `arrange()`, changes rows order. If you provide more than one column name,
# each additional column will be used to break ties in the values of preceding columns

flights %>%             # by default ascending order
  arrange(dep_delay)



arrange(flights, year, month, day)



### descending order -----------
flights %>% 
  arrange(desc(dep_delay))





### grouped arrange.-------
# We want arrange dep_delay grouped by origin

group_origin <- flights %>% 
  group_by(origin)    # {dplyr}

group_origin

# Now you need to specifically ask 

group_origin %>% 
  arrange(dep_delay, .by_group = TRUE)  # Do not forget `.` before `by_group`



### What happened to NA?------
# They are listed on the last rows in both descending and ascending order

flights %>% 
  arrange(desc(dep_delay)) %>% 
  tail(n=20)


## 3. select()---------------------------
# `select()`: Pick variables by their names

flights %>% 
  select(year, month, day)


# use `-` to deselect some variables

flights %>% 
  select(-c(year, month, day))


# 0r

flights %>% 
  select(- (year:day))


### Rename Variable by select(Newname = Oldname) -------
flights %>% 
  select(year, month, day, Day = day)


flights %>% 
  select(year, month, day, arr_time, dep_time, sched_dep_time, 
         sched_arr_time, Year = year, Day = day) ->
  mini_flights
mini_flights
### everything()  --------------
#  it is a dplyr function and it catch all other variables. 

mini_flights %>% 
  select(everything())


# Let us assume you want to put evrything() after Year and arr_time
# first in mini_flights

mini_flights %>% 
  select(Year, arr_time, everything())


#### A note about everything()------
# Remember, ecverything() will catch all other variables that you haven't pick
mini_flights %>% 
  select( Year, everything(), Day)
# in above code, Day doe snot listed at the end. Why? because everything has got it.
# so above code is same as
mini_flights %>% 
  select( Year, everything())

### More in select-------
#### starts_with, ends_with-------
#There are a number of helper functions you can use within `select()`\
#1. `starts_with(”abc”)`: matches names that begin with “abc”.\
flights %>% 
  select(starts_with("sch"))
#2. `ends_with(”xyz”)`: matches names that end with “xyz”.\
flights %>% 
  select(ends_with("time"))
#3. `contains(”ijk”)`: matches names that contain “ijk”.\
flights %>% 
  select(contains("_"))
#4. `matches()`: selects variables that match a regular expression. We learned more about
#regular expressions in strings.\
flights %>% 
  select(matches("[tm]")) # select any variable that contains t or m or both

flights %>% 
  select(matches('^[tm]')) # select any variable that start with t or m 
#5. `num_range(”x”, 1:3)`: matches x1, x2 and x3.\

df <-data.frame (x_1 = c(10, 20, 30) , x_2 = c("x", "xx", "xxx"), x_3 = c(T, F, T), x_4 = c(NA, NaN, Inf))
df

df %>% 
  select(num_range("x_", 2:4))



## 4. `mutate()`---------

# `mutate()`: Create new variables with functions of existing variables\

flights %>% 
  select(dep_delay, arr_delay, distance,air_time) %>% 
  mutate(Gain = dep_delay - arr_delay,
         Speed = distance/air_time*60,
         Hours = air_time / 60,
         Gain_per_hour = Gain / Hours
         ) 
### transmute()----------
# If you only want to keep the new variables, use transmute():

flights %>% 
  transmute(Gain = dep_delay - arr_delay,
         Speed = distance/air_time*60,
         Hours = air_time / 60,
         Gain_per_hour = Gain / Hours)

### Functions used in mUtate--------
# There are many functions for creating new variables that you can use with
# `mutate()`

# 1. Arithmetic operators: +, −, ∗, /, ˆ.\
# These are all vectorised, using the so called “recycling rules”. If one
#parameter is shorter than the other, it will be automatically extended
# to be the same length.\

# 2. Modular arithmetic: %/% (integer division) and %% (remainder), where
# x == y * (x %/% y) + (x %% y). Modular arithmetic is a handy tool
#because it allows you to break integers up into pieces. For example, in the
# flights dataset, you can compute hour and minute from dep time with:

transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100
)

# 3. Logs: `log()`, `log2()`, `log10()`. Logarithms are an incredibly useful transformation for dealing with data that ranges across multiple orders of magnitude.\
# It is recommended to use `log2()` when everything else is equal and you are
# not sure which “Log“ to pick. Because it’s easy to interpret.

# 4. Offsets: `lead()` and `lag()` allow you to refer to leading or lagging values.
# This allows you to compute running differences (e.g. x - lag(x)) or find
# when values change (x != lag(x)). They are most useful in conjunction
# with `group by()`.

x <- 1:10
x
lag(x) # lag function shifted our vector one element to the left side.
# It remove the last value and add NA at the beginning!
lead(x) # lead function shifted our vector one element to the right side.
# It remove the first value and add NA at the end!


# 5. Cumulative and rolling aggregates: R provides functions for running sums,
# products, mins and maxes: `cumsum()`, `cumprod()`, `cummin()`, `cummax()`;
# and `dplyr` provides `cummean()` for cumulative means.


x <- 1:10
cumsum(x) # Cumulative sum

cummean(x) # It will find mean 1/1, (1+2)/2, (1+2+3)/3

# 6. Logical comparisons, <, <=, >, >=, ! =, and ==, which you learned
# about earlier.

# 7. Ranking: there are a number of ranking functions, but you should start
# with `min_rank()`. It does the most usual type of ranking (e.g. 1st, 2nd,
#                                                           2nd, 4th). The default gives smallest values the small ranks; use desc(x)
# to give the largest values the smallest ranks.

y <- c(1, 2, 2, NA, 3, 4)
min_rank(y) # assigned the minimum ranking possible
# five numbers so it goes from 1 to 5.


min_rank(desc(y))
#It gives the largest values the smallest ranks


## 5. `summarise()`

# `summarise()`: Collapse many values down to a single summary\


summarise(flights, delay = mean(dep_delay, na.rm = TRUE))


# summarise dep_delay by mean and group it wit year, month, day

flights %>% 
  group_by(year, month, day) %>% 
  summarise(MeanDelay = mean(dep_delay, na.rm = TRUE))


### Note:`group_by()` and `summarise()`----
# Together `group_by()` and `summarise()` provide one of the tools that you’ll use
# most commonly when working with `dplyr`: grouped summaries.

# Group By DEST
flights %>% 
  group_by(dest) %>% 
  summarise(Count = n(),
            MeanDistance = mean(distance, na.rm = TRUE),
            MeanArrDelay = mean(arr_delay, na.rm = TRUE))


# Group By ORIGIN
flights %>% 
  group_by(origin) %>% 
  summarise(Count = n(),
            MeanDistance = mean(distance, na.rm = TRUE),
            MeanArrDelay = mean(arr_delay, na.rm = TRUE))



# Summarize the flight distance and arr_delay and group by destination, 
# but EXCLUDE the destination start with "A"

flights %>% 
  group_by(dest) %>% 
  summarise(Count = n(),
            MeanDistance = mean(distance, na.rm = T),
            MeanArrDelay = mean(arr_delay, na.rm =T)) %>% 
  filter(dest !=c("ABQ", "ACK", "ALB"))


flights %>% 
  group_by(dest) %>% 
  summarise(Count = n(),
            MeanDistance = mean(distance, na.rm = T),
            MeanArrDelay = mean(arr_delay, na.rm =T)) %>% 
  filter(!grepl("^A", dest)) # We use grepl() from {base}

# OR


flights %>% 
  group_by(dest) %>% 
  summarise(Count = n(),
            MeanDistance = mean(distance, na.rm = T),
            MeanArrDelay = mean(arr_delay, na.rm =T)) %>% 
  filter(!startsWith(dest, "A"))   # startsWith() in {base}


### Remove NA from columns------
####   filter(df, !is.na(A), !is.na(B))  ---------

# If missing values on dep_delay or arr_delay represents the canceled flights, 
# then we can get summarise only on not_canceled flights

flights %>% 
  filter(!is.na(arr_delay) & !is.na(dep_delay)) %>% 
  group_by(year, month, day) %>% 
  summarise(n =  n(),
            mean_dist = mean(distance),
            mean_arr_delay = mean(arr_delay)) ->
  not_canceled_flights


not_canceled_flights



not_canceled_flights%>% 
  ggplot(aes(mean_arr_delay)) +
  geom_freqpoly(bins = 15)

# It shows the majority if the flights ahd no average arriving delay, but there are
# flights that have in 100 minutes late and there are flights that came earler. 
# You may want to see the histogram fro this.

not_canceled_flights%>% 
  ggplot(aes(mean_arr_delay)) +
  geom_histogram(bins = 15)   

# the sum of the hight to the left of zero is about 100. 
# So about 100 flights cam ahead of schedule


# scatter plot will do a better job

not_canceled_flights %>% 
  ggplot(aes(x=mean_arr_delay, y = n)) +
  geom_point()

# The maximum average delay occurs on march 8 2013 and it was 85.9 minutes late
# and there were 798 flights on that day
not_canceled_flights %>% 
  filter(mean_arr_delay > 80)


### Function that can be used by summarise()--------------------

# mean(x)`, `median(x)`, `sd(x)`, `IQR(x)`, `mad(x)` 
# mad() is median absolute deviation more useful if you have outliers. 
# It provides a more robust measure of dispersion that is less influenced by extreme values
# Measures of rank: `min(x)`, `quantile(x, 0.25)`, `max(x)`
# Measures of position: `first(x)`, `nth(x, 2)`, `last(x)`.
  # These work similarly to `x[1]`, `x[2]`, and `x[length(x)]` 
  # but let you set a default value if that position does not exist
# Counts and proportions of logical values: 
  # `sum(x > 10)`, `mean(y == 0)`. When used with numeric functions, 
  # TRUE is converted to 1 and FALSE to 0. This makes `sum()` and `mean()` very useful: 
  # `sum(x)` gives the number of TRUEs in x, and `mean(x)` gives the proportion.
 x <- 1:100
sum(x > 50)
mean(x>50)


# What proportion of flights are delayed by more than an hour?
flights %>% 
  summarise(Prop_a.delay_60 = mean(arr_delay>60, na.rm = T),
            prop_d.delay_60 = mean(dep_delay>60, na.rm = T))

# Group by year, month, day
flights %>% 
  group_by(year, month, day) %>% 
  summarise(Prop_a.delay_60 = mean(arr_delay>60, na.rm = T),
            prop_d.delay_60 = mean(dep_delay>60, na.rm = T))
  


## * `recode()`:------
#          recode(x, Old = "New")
# To use with dataframe, we need to utilize  mutate
###                mutate(df, x = recode(x, Old = "New"))------

estate <- read_csv(file = "https://dcgerard.github.io/stat_412_612/data/estate.csv")

names(estate)

unique(estate$Quality)

estate %>% 
  mutate(Quality = recode(Quality,
         Medium = "medium",
         Low = "low",
         High = "high"))


estate %>%
  mutate( Bath = recode(Bath,
                        `4` = ">3",
                        `5` = ">3",
                        `6` = ">3",
                        `7` = ">3"))



estate %>%
  mutate(Bath = if_else(Bath > 3,
                        ">3",
                        as.character(Bath)))


# DBPLYR------------------------------------

# dplyr basically implements the most common actions in SQL (but SQL can do more).

# We'll use a soccer dataset to demonstrate how to use dplyr (instead of SQL) 
#  syntax when interacting with a database. Download and unzip the soccer 
#  database from <https://dcgerard.github.io/stat_412_612/data.html>.
  
# We'll use the dbplyr package to interact with databases.

### Load RSQLite package-------------
# You'll also need to install the RSQLite package. There are different ways to
#   create/access/update/delete data from relational databases, and RSQLite 
#   provides an R interface for one of these ways.

library(RSQLite)

# - If your database uses a different engine, you'll need to download other
# packages to interact with it (see [Introduction to dbplyr]
 # (https://cran.r-project.org/web/packages/dbplyr/vignettes/dbplyr.html))


#### First,-----
#we'll tell R where the database is using `dbConnect()`,
# (you might need to change the path).

con <- dbConnect(drv = SQLite(), dbname = "./Week0/soccer.sqlite")

#### Second,
# Now we'll list the data frames available in the connection we just created.

    dbListTables(con)

#### Third,
  # - Use `tbl()` to make a reference to the tables in `con`.

   Countery_db <- tbl(con, "Country")
   Countery_db
   
   League_db <- tbl(con, "League")
   League_db
   
   Match_db <- tbl(con, "Match")
   Match_db
   
   Player_db <- tbl(con, "Player")
   Player_db
   
   Player_Attributes_db <- tbl(con, "player_Attributes")
   Player_Attributes_db
    
   Team_db    <- tbl(con, "Team")
   Team_db
   
   Team_Attributes_db <- tbl(con, Team_Attributes)
   Team_Attributes_db
   
   Sqlite_Sequence_db <- tbl(con, Sqlite_Sequence)

   ss
    
    
    
# Parsers--------------------------------------

#  Change character vectors into other types using parsers.

#  Suppose you have the following data frame

dfdat <- tribble(
  ~date,        ~time,      ~number, ~factor, ~logical,

  "12-01-1988", "10:10:02", "2",     "A",     "TRUE",
  "11-12-1987", "11:10:57", "4",     "A",     "TRUE",
  "02-03-1989", "10:10:25", "6",     "B",     "FALSE",
  "06-03-1982", "22:10:55", "2",     "B",     "TRUE",
  "09-21-1981", "10:10:02", "1",     "A",     "FALSE"
)
dfdat


