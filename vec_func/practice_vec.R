# Practice Vector BASE R -----

x <- NA_integer_
typeof(x)
typeof(NA)
typeof(NA_real_)
c(1L, T)
1 == "1"
-1 < FALSE
"one" < 2
a <- 1:3
x <- c(NA,1)
attr(a, "X") <- "abcdef"
attr(a, "y") <- 1:5
attr(a, "y")
attributes(a[[1]])
x <- c(a =1, b=2, c = 3)
x[1:2]
x
x[[1:2]]
names(x[[1:2]])
unname(x)
attr(x, "dim") 
n<-2
matrix(rnorm(9),3,3) |> 
  is.atomic()
x
length(unname(x))

x <- factor(c(1.5, 1.7, 2, 1))
typeof(x)

x

## S3 Objects -------
# Define a constructor function for an S3 object (a simple circle object)
circle <- function(radius) {
  obj <- list(radius = radius)
  class(obj) <- "circle"  # Assign the "circle" class
  return(obj)
}

# Create a print method for the "circle" class
print.circle <- function(obj) {
  cat("Circle with radius:", obj$radius, "\n")
}

# Create a method to compute the area of the circle
area.circle <- function(obj) {
  return(pi * obj$radius^2)
}

# Instantiate a circle object
my_circle <- circle(5)

# Print the circle object
print(my_circle)  # Calls print.circle

# Compute the area of the circle
area.cicle(my_circle)  # Calls area.circle
area.circle(my_circle)


# Create a numeric vector
num_vec <- c(1, 2, 3, 4, 5)
is.atomic(num_vec)

# Apply print()
print(num_vec)
# Output: [1] 1 2 3 4 5

# Apply summary()
summary(num_vec)
# Output:
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
#   1.00    2.00    3.00    3.00    4.00    5.00

# Create a factor (S3 object)
factor_vec <- factor(c("low", "medium", "high", "medium", "low"))
is.object(factor_vec)
inherits(num_vec, class(num_vec))
# Apply print()
print(factor_vec)
# Output: 
# [1] low    medium high   medium low   
# Levels: high low medium

# Apply summary()
summary(factor_vec)
# Output:
#   high    low medium 
#      1      2      2 

unclass((factor_vec))|>
  class()
Sys.Date()|>
  unclass()
as.time("1970-01-01")
unclass(as.Date("1970-01-01"))
Sys.time()

as.POSIXct(c("1980-10-10 01:11:01"), tz ="UTC"
                 )|>
  unclass()

vector(mode = "character", length = 0)
integer()

n <- 10
x <- rep(NA_character_, length.out = 5)
x
length(x)

rep(1:4, length.out = 10)

rep(1:4, each = 2, times = 3)


l1 <- list(1:2,
           c("a", "b"))
l2 <- list(c(TRUE, FALSE))
c(l1, l2)
typeof(l1)
class(l1)
is.object(l1)

class(l1) <- "my_class"
class(matrix(1:4,2,2))
df <- data.frame(a = 4:6,
                 b = c("A", "B", "C"))
typeof(df)
class(df)
is.object(df)
attributes(df)
str(df)
colnames(df)
names(df)
df <- data.frame(`hello world` = c(1, 2, 3))
typeof(df)
class(df)
tib <- tibble::tibble(`hello world` = c(1, 2, 3))
typeof(tib)
class(tib)
attributes(df[, 1])
attributes(tib[, 1])
wmean <- function(x, w = NULL) {
  if (is.null(w)) {
    w <- rep(1 / length(x), length.out = length(x))
  } else {
    w <- w / sum(w)
  }
  return(sum(x * w))
}
x <- c(1, 2,3)
wmean(x)
wmean(x, w = c(5, 1, 1))



# Create a numeric vector
values <- 1:6

# Use structure to add attributes and create a matrix
my_matrix <- structure(
  values, 
  dim = c(2, 3),      # Setting the dimensions (2 rows, 3 columns)
  dimnames = list(c("Row1", "Row2"), c("Col1", "Col2", "Col3")),  # Assigning row and column names
  class = "matrix"    # Setting the class as 'matrix'
)

# Print the structured object
print(my_matrix)
# Subsetting with brackets -----------------

## ATOMIC SUBSETTING -----------------
### SUBSETTING WITH POSITIVE INTEGER ---------
x <- c(8, 1.2, 33, 14)

x[1]                   #extract the first element
x[c(1, 3)]             #extract the first and 3rd element
iset <- c(1, 3)
x[iset]
### ORDERING BY SUBSETTING ---------
order(x)
x[order(x)]   # return the value of x in ascending order

order(x, decreasing = TRUE) ->
  desc
x[desc]       # return the value of x in descending order


### SUBSETTING WITH NEGATIVE INTEGER ---------
x[-1]                  #will return all elements except the negative elements.
x[c(-1, -3)]
x[-c(1, 3)]

### LOGICAL VECTOR SUBSETTING ----------

x[c(TRUE, FALSE, TRUE, FALSE)]# Wherever there is a TRUE will return the element.

### NO SUBSETTING ----------

x[]        # Empty brackets will return the original object.

### ZERO SUBSETTING ----------

x[0]        # Using 0 in a bracket will return a zero-length vector.


### NAMES SUBSETTING ----------

names(x) <- c("a", "b", "c", "d")
x["a"]             # returns element  using those names in quotes
x[c("a", "c")]
x[c("a", "a")]


#### Exercises: -------
#  Exercise: Explain the output of the following
#a
y <- 1:9
y[c(TRUE, TRUE, FALSE)]
y[TRUE]
y[FALSE]
 #  R will recycle the logical values.

# b
y <- c(1, 2, 5, 7)
y[c(TRUE, FALSE, TRUE, TRUE, TRUE, FALSE, TRUE, FALSE, FALSE, TRUE, FALSE)]
 # R assumes that all values after the fourth element are NA. So after that 
# For any TRUE in will return NA



#### Exercises: -------
y <- c(af = 3, bd = 6, dd = 2)
# Show all the ways to extract the second element of the following vector:
y[2]
y[c(-1, -3)]
y[c(FALSE, TRUE, FALSE)]
y["bd"]


## Double brackets -----
# Double brackets enforces that you are only extracting one element. 
# This is really good in places where you know that you should 
# only subset one element (like for-loops).

x <- runif(100)  # randomly generate uniform distribution numbers with min=0 and max =1
sval <- 0
for (i in seq_along(x)) {
  sval <- sval + x[[i]]
}
sval   # This is the sum of all randomly generate uniform numbers


### Double brackets remove attributes of the vector (even names).------
# Important: Double brackets remove attributes of the vector (even names).
x <- c(a = 1, b = 2)
x[1]
typeof(x[1])
x[[1]]
typeof(x[[1]])


## LIST SUBSETTING -----------------
###  SINGLE BRACKET [] ------------
# If you subset a list using single brackets,
# you will get a sublist. 
# You can use integers, negative integers, logicals, and names as before

x <- list(a = 1:3, b = "hello", c = 4:6)
str(x)   # str() is a good function to print list

x[1]
x[c(1, 3)]
x[-1]
x[c(TRUE, FALSE, FALSE)]
x["b"]
x[c("a", "c")]

###  DOUBLE Bracket [[]] ------------
# Using double brackets extracts out a single element.

x[[1]]
x[["a"]]

### DOLLAR SIGNs -------
# A shorthand for using names inside double brackets is to use dollar signs.
x$a
x$b


#### Exercises: -------
# Why does this not work. Suggest a correction.
var <- "a"
x$var

   #`var` is not a name in `x`. Instead, use `x[[var]]`.


## DATA FRAME SUBSETTING -----
# Data frame subsetting behaves both like lists and like matrices.

df <- data.frame(A = 1:3,
                 B = c("a", "b", "c"),
                 C = 4:6)

df

row.names(df) <- c("I", "J", "K")
df

# It behaves like a list for $, [[, and [ if you only provide one index. 
# The columns are the elements of the list.

df$A
df[1]
df[[1]]
df[c(1, 3)]


# It behaves like a matrix if you provide two indices.
df[1:2, 2]


# You can keep the data frame structure by using drop = FALSE.
df[1:2, 2, drop = FALSE]

# It is common to filter by rows by using the matrix indexing.
df[df$A < 3, ]


# FUNCTIONS --------------

## EXAMPLE of USING PIPE------

# Using the pipe, create a vector of 100 random draws from the 
# normal distribution with standard deviation 10, sort this vector in 
    # increasing order, 
# calculate the  lagged differences between these elements,
# average these lagged differences,
# then round this average to the nearest tenth decimal place.

#__________________________________________________________________
# LET US DO THIS PROBLEM STEP BY STEP FOR ONLY 10 RANDOM NUMBERS

# Step 1:____________________________________
# create a vector of 10 random draws from the 
# normal distribution with standard deviation 10
set.seed(1)
v <- rnorm(10, sd = 10) 
v

# Step 2:____________________________________
# sort this vector in increasing order,
sort(v) 
# 0r 
v %>% 
  sort()

### NOTE: We can do this part in two steps by order() function and subsetting


order(v)->
  ord
ord

v[ord]

# or

v %>% 
  order() %>% 
  v[.]

# Step 3:____________________________________
# calculate the  lagged differences between these elements,

# diff() is from base package and it returns suitably lagged and iterated differences

sort(v) %>% 
  diff() ->
  diff
diff

# Step 4:____________________________________
# average these lagged differences,
diff %>% 
  mean() ->
  avg
avg

# Step 5:____________________________________
# round this average to the nearest tenth decimal place.
avg %>% 
  round(digits = 1) 


# NOW let's do the whole thing in one step
set.seed(1)
rnorm(10, sd = 10) %>%
  sort() %>%
  diff() %>%
  mean() %>%
  round(digits = 1) 

#__________________________________________________________________

# Let us do it for 100 random draws
rnorm(100, sd = 10) %>%
  sort() %>%
  diff() %>%
  mean() %>%
  round(digits = 1) 


## Create Function-------------


# Write `both_na()`, a function that takes two vectors of the 
#same length and returns the number of positions that have an `NA` in both 
# vectors. Include documentation. Useful functions: `is.na()`, `sum()`, 
# logical operators.


#_____________________________________
## THE FUNCTIONS STARTED WITH COMMENTS. 
#          It says what function does
#          What are inputs
#          What are outputs
#_____________________________________

# Returns number of positions that have an NA in both positions of two vectors.
#
# x: A vector the same length as y
# y: A vector the same length as x
#
# returns: The number of positions that have an NA in both x and y
both_na <- function(x, y) {
  stopifnot(length(x) == length(y))
  return(sum(is.na(x) & is.na(y)))
}
both_na(c(1, NA, 2), c(NA, NA, 2))
both_na(c(NA, NA, 2), c(NA, NA, 2))
both_na(c(NA, NA, NA), c(NA, NA, 2))


#  **Exercise**: Write `pos_na()`, a function that takes two vectors of the 
#same length and returns the positions that have an `NA` in both 
# vectors. Include documentation. Useful functions: `is.na()`, `which()`, 
# logical operators.


pos_na <- function(x, y) {
  if (length(x) == length(y)) {
    which(is.na(x) & is.na(y))
  } else {
    print ("vectors are not of the same size. Please use two vectors of the same size")
  }
  
}
pos_na(c(1, NA, 2), c(NA, NA))
pos_na(c(NA, NA, 2), c(NA, NA, 2))
pos_na(c(NA, 5, NA), c(NA, NA, NA))
pos_na(c(NA, NA, NA, 2, NA, 4, NA), c(NA, NA, 2, 4, 4, NA, NA))


#                Without if function

pos_na2 <- function(x, y) {
  stopifnot(length(x) == length(y))
  return(which(is.na(x) & is.na(y)))
}
pos_na2(c(NA, NA, 2), c(NA, NA, 2))
pos_na2(c(NA, 5, NA), c(NA, NA, NA))
pos_na2(c(NA, NA, NA, 2, NA, 4, NA), c(NA, NA, 2, 4, 4, NA, NA))
pos_na2(c(1, NA, 2), c(NA, NA))



# ITERATORS --------------------------
## FOR LOOP -------------
### Exercise:-----------
# Calculate the first 100 Fibonacci Numbers.
# Sanity Check: The $\log_2$ of the 100th Fibonacci Number is about 68.26.


# NOTE: WE COULD CREATE A VECTOR OF LENGTH 100 and FILLED with  NA
#                 fibvec <- rep(NA_real_, length = 100)

 fibvec <- vector(mode = "double", length = 100)  # create a vector of length 100
for (i in seq_along(fibvec)) {
                 # i = -i
  if (i > 2) {
    fibvec[[i]] <- fibvec[[i - 1]] + fibvec[[i - 2]]
  } else if (i == 1) {
    fibvec[[i]] <- 0 
  } else if (i == 2) {
    fibvec[[i]] <- 1
  }  else{
    stop(paste0("i = ", i))   # if i is negative it will send the error
  }
}

fibvec

sum(fibvec[]) %>% 
  log2()



### DATAFRAME and LOOPING ------------
#  Looping is often done over the columns of a data frame.

#   Note: for a data frame `df`, `seq_along(df)` is the same as `1:ncol(df)` which is the same as `1:length(df)` (since data frames are special cases of lists).

#   Let's calculate the mean of each column of `mtcars`


    data("mtcars")                         # load the data
    
names(mtcars)
dim(mtcars)
length(mtcars)
ncol(mtcars)       #length of a dataframe same as is number or its columns
mtcars[[1]]
mtcars[["mpg"]]   # extract elements of the first column


mean_vec <- vector(mode = "numeric", length = length(mtcars))  
           # Create a vectorwhose elements are zero and same length of
            # the dataframe mtcars (number of its columns)
    for (i in seq_along(mtcars)) {
      mean_vec[[i]] <- mean(mtcars[[i]], na.rm = TRUE)   
    }
    mean_vec
   
    
     colMeans(mtcars)
     # I see colMeans(mtcars) returns same thing, then the qurstion is:
# Why not just use `colMeans()`?
     # Well, there is no "`colSDs`" function, 
     # so iteration is important for applying non-implemented functions
     # to multiple elements in R.


     sd_vec <- rep(NA_real_, length = length(mtcars))
     for (i in seq_along(mtcars)) {
       sd_vec[[i]] <- sd(mtcars[[i]], na.rm = TRUE)   
     }

sd_vec   # Returns standard deviation of each columns




# PURR PACKAGE ---------------

# -   R is a functional programming language. 
# Which means that you can pass functions to functions.

# we would like to just tell R what function to apply to each column of `mtcars`. 
# This is what the purrr package allows us to do.

#   purrr is a part of the tidyverse, and so does not need to be loaded separately.


#   `map()` returns a list.
#   `map_lgl()` returns a logical vector.
#   `map_int()` returns an integer vector.
#   `map_dbl()` returns a double vector.
#   `map_chr()` returns a character vector.

map_dbl(mtcars, sd)

# You can pass on more arguments in `map_*()`
map_dbl(mtcars, mad, na.rm = TRUE)  # Median Absolute Deviation

map(mtcars, summary) # Suppose you want to get the output of `summary()` on each column.




#### map_dfc() ------------------------
# df: data frame
# c: column-wise binding (combine results into columns)
# This function will apply the given function to each element and 
# combine the results into a data frame by columns.

# Apply a function to create 3 data frame columns from a list
lst <- list(a = 1:3, b = 4:6, c = 7:9)
lst

# Multiply each element by 2
result_c <- map_dfc(lst, ~ .x * 2)  

print(result_c)


#### map_dfr() ------------------------
# df: data frame
# r: row-wise binding (combine results into rows)
# This function will apply the function to each element and 
# combine the results into a data frame by rows.

# Multiply each element by 2
result_r <- map_dfr(lst, ~ data.frame(value = .x * 2))  

print(result_r)




#   **Exercise** (RDS 21.5.3.1): Write code that uses one of the map functions to:
  
#   1.  Determine the type of each column in `nycflights13::flights.`
#   2.  Compute the number of unique values in each column of `palmerpenguins::penguins`.
#   3.  Generate 10 random normals for each of $\mu = -10, 0, 10, \ldots, 100$.


library(nycflights13)
library(palmerpenguins)
data("flights")
data("penguins")
map_chr(flights, typeof)
map_int(penguins, function(x) length(unique(x)))
map_dfc(seq(-10, 100, by = 10), rnorm, n = 10) ->
  temp


### Shortcuts --------------------

#   You can refer to elements of the vector by "`.`" in a `map()` call if the `.f` argument is preceded by a "`~`". For example, the following are three equivalent ways to calculate the mean of each column in `mtcars`.


map_dbl(mtcars, mean)
map_dbl(mtcars, function(.) mean(.))
map_dbl(mtcars, ~mean(.))


#  What is actually going on is that purrr is creating an "anonymous function"


.f <- function(.) {
  mean(.)
}

# and then calling this function in `map()`.



map_dbl(mtcars, .f)


#   Why is this useful? 
# Consider the following chunk of code which allows us to fit many simple linear regression models:
  

mtcars %>% 
  split(.$cyl) %>% 
  map(function(df) lm(mpg ~ wt, data = df)) ->
  lmlist



# `split(.$cyl)` will turn the data frame into a list of data frames where
# each data frame has a different value of `cyl` for all units. The
#    "`.`" references the current data frame.


# - `function(df) lm(mpg ~ wt, data = df)` defines a function (called an 
 #  "anonymous function") that will fit a linear model of `mpg` on `wt` 
# where those variables are in the data frame `df`.

# The `map()` call fits that linear model to each of the three data frames
# in the list created by `split()`.

# What is returned is a list of three `lm` objects that you can use to
# get fits and summaries.


summary(lmlist[[1]])


#   Again, rather than create an "anonymous function", 
# you can use the formula notation to do the same thing:
  

mtcars %>% 
  split(.$cyl) %>% 
  map(~lm(mpg ~ wt, data = .)) ->
  lmlist



# Here, the "`.`" in "`data = .`" references the current data frame from
#  the list of data frames that we are iterating through.


#  We can use `map()` to get a list of summaries.


lmlist %>%
  map(summary) ->
  sumlist


#  If you want to extract the $R^2$, you can do this using the formula notation as well.


sumlist[[1]]$r.squared ## only gets one R^2 out.

## Gets all R^2 out
sumlist %>%
  map(~.$r.squared)

###   **Exercise**:-----------

# A t-test is used to test for differences in population means. 
# R implements this with `t.test()`. 
# For example, if I want to test for differences between the mean `mpg`'s of
# automatics and manuals (coded in variable `am`), I would use the following syntax.


    t.test(mpg ~ am, data = mtcars)$p.value



# Use `map()` to get the $p$-value for this test within each group of `cyl`.



    mtcars %>%
      split(.$cyl) %>%
      map(~t.test(mpg ~ am, data = .)) %>%
      map(~.$p.value)

#### `keep()` and `discard()`---------
    
#  `keep()` selects all variables that return `TRUE` according to some function.
    
#   E.g. let's keep all numeric variables and calculate their means in the `palmerpenguins::penguins` data frame.


    library(palmerpenguins)
    data("penguins")
    penguins %>%
      keep(is.numeric) %>%
      map_dbl(mean, na.rm = TRUE)


#  `discard()` will select all variables that return `FALSE` according to some function.

#   Let's count the number of each value for each categorical variable:
      

    penguins %>%
      discard(is.numeric) %>%
      map(table)

    
 
    
####   **Exercise**:---------------
    #In the `mtcars` data frame, keep only variables that have a mean greater than `10` and
    # calculate their mean. Hint: You'll have to use some of the shortcuts above.


    mtcars %>%
      keep(~mean(.) > 10) %>%
      map(mean)

    
    
# FACTOR ----------------------------
    
    ## Creating Factors -----------------
    
#   Use `factor()` or `parse_factor()` to create a factor variable
    #   `factor()` takes the order of the levels to be the same order returned by `sort()`.
   
#   `parse_factor()` returns better warnings, so I would recommend always using that.
   #   `parse_factor()` takes the order of the levels to be the same order as the order of the value introduced.  
 
    x <- c("A", "string", "vector", "is", "a", "string", "vector")
    class(x)
    
    factor(x) ->
      f_x
    f_x
    class(f_x)
    

    sort(x)   # string apperas twice but in factor's level it appears once.
               # However the order is same as the level. To remove the extra use the following
    
    sort(unique(x))   # Nothing is repeated and the order is same as the level's order

    

    parse_factor(x)

    
#   You can always see the levels of a factor (and their order) using the `levels()` function
    levels(f_x)
    
## # forcats
    
#   forcats is an R package which makes two things much easier in R:
      
     #   Changing the order of the levels of the factor variable.
     #   Changing the levels of the factor variable.
    ?forcats
    data()  # Gives you all data available in your computer with the packages
    
    View(gss_cat)
    glimpse(gss_cat)
    
    unique(gss_cat$race)
  #
    #
    gss_cat %>% 
      pull(race)
  #
    #
    gss_cat %>% 
      pull(race) %>% 
      unique()
    
    count(gss_cat, race)
    
    count(gss_cat, race, sort = T)
    
    gss_cat %>% 
      count(race, sort = T)
    
    
    gss_cat %>% 
      pull(race) %>%    # Now we pull the race and pipe into the levels to see what levels are
      levels()
    
    
    
    gss_cat %>% 
      select(race) %>% 
      table()                 # This is useful because we can see 
                         # "Not applicable" has no vlaues
    
    
    # This is the time we use functions that we have in forcats. 
    # We want to get rid off the levels that we have no use of it.
    
    gss_cat %>% 
      mutate(race = fct_drop(race)) %>% 
      pull(race) %>% 
      levels()
    
    # Now you can see the "Not applicable " has been dropped
    
### EXAMPLE 1---------------------- 
    # LEVEL's ORDER BASED on the Count of the other variable 
    #fct_reorder()
    #    
    # We want average tv hours by Religions.
    # There is no average tv hours. 
    # we have tv hours in our data set. so we can compute the average
    is.na(gss_cat$tvhours) %>% 
      unique()
    
    gss_cat %>% 
      drop_na(tvhours) %>% 
      group_by(relig) %>% 
      summarise(mean_tv = mean(tvhours)) %>% 
      ggplot(aes(mean_tv, relig)) +
      geom_point(size =4)
    
    # If you look ta the scatterplot you'll see the plot is not very helpful.
    # The data scatters all over the plot. 
    # However, if you could have the data sorted in average tv watch based on religion
    # then we could easily look at the data and say 
    # which religions has least average tv time and ...
    
    # Let's save the mean_tv time in a new datframe just for simplicity!
    
    gss_cat %>% 
      drop_na(tvhours) %>% 
      group_by(relig) %>% 
      summarise(mean_tv = mean(tvhours)) ->
      new_gss
    new_gss
    
    # Now, We want to change the factor levels so the order of levels be based on 
    # the average tv time for each religions
    
# We uae function fct_order() from forcats
    
    fct_reorder(new_gss$relig, new_gss$mean_tv)
    
  # Let's now draw the scatterplot with this new reorder of religion's levels  
    
      new_gss %>% 
        mutate(relig = fct_reorder(relig, mean_tv)) %>%
        ggplot(aes(mean_tv, relig)) +
        geom_point(size =4)
    # You see the scatterplot is easy to read and we can analyze it better and easier.
      
      
      
      
      gss_cat %>% 
        drop_na(tvhours) %>% 
        group_by(relig) %>% 
        summarise(mean_tv = mean(tvhours)) %>% 
        mutate(relig = fct_reorder(relig, mean_tv)) %>% 
        mutate(relig = fct_rev(relig)) %>% 
        ggplot(aes(mean_tv, relig)) +
        geom_point(size =4)
      
### EXAMPLE 2----------------------
      # REVERSE ORDER 
      #
      #
      # Now we would like to analyse the income with the average age
      
      gss_cat %>% 
        select(rincome) %>% 
        table()
      
gss_cat %>% 
        drop_na(age) %>% # Removed the missing values
        filter(rincome != "Not applicable") %>% # this category is better not to be out
        group_by(rincome) %>% 
        summarise(mean_age = mean(age)) %>% 
        ggplot(aes(mean_age, rincome)) +
        geom_point(size = 4)
      
# Like previous example it would be better if this time 
      # we reverse the order the income
      gss_cat %>% 
        drop_na(age) %>% #
        filter(rincome != "Not applicable") %>% 
        group_by(rincome) %>% 
        summarise(mean_age = mean(age)) %>% 
        mutate(rincome = fct_rev(rincome)) %>% 
        ggplot(aes(mean_age, rincome)) +
        geom_point(size = 4) 
      
### EXAMPLE 3----------------------     
      # ORDER FACTOR LEVEL BY FREQUENCY OF THE VALUE OF VARIABLE 
      #
      #
gss_cat %>% 
        count(marital)
      
gss_cat %>% 
  ggplot(aes(marital)) +
  geom_bar()

# The bar chart will be more helpful if we can have them in order

gss_cat %>% 
  mutate(marital= fct_infreq(marital)) %>% 
  count(marital) 

# As you can see now we have them the levels in order of the frequency of each level

# If we want to revers the order we can use fct_rev() function
gss_cat %>% 
  mutate(marital= fct_infreq(marital)) %>% 
  mutate(marital = fct_rev(marital)) %>% 
  count(marital)


# Let us create the bar chart

gss_cat %>% 
  mutate(marital= fct_infreq(marital)) %>% 
  mutate(marital = fct_rev(marital)) %>% 
  ggplot(aes(marital)) +
  geom_bar(fill = "red", color = "green", alpha = 0.5) +
  theme_bw()

### EXAMPLE 4----------------------     
  # MANUALLY RECODE A FACTOR 
  #fct_recode(NEW = OLD)
  #

gss_cat %>% 
  pull(partyid) %>% 
  unique()
#or
unique(gss_cat$partyid)


gss_cat %>% 
  mutate(partyid = fct_recode(partyid,
                              "Republican, Strong" = "Strong republican",
                              "Republican, Weak"="Not str republican",
                             "Independent, near rep" = "Ind,near rep",
                             "Independent, near dem" = "Ind,near dem",
                             "Democrat, Weak"="Not str democrat",
                             "Democrat, Strong"="Strong democrat",
                             "Other" = "No answer",
                             "Other" = "Don't know",
                             "Other" = "Other party")) %>% 
  count(partyid)

### EXAMPLE 5----------------------     
  # MANUALLY RECODE A FACTOR 
  #fct_collapse(NEW = OLD)
  #

gss_cat %>% 
  pull(partyid) %>% 
  unique()
#or
unique(gss_cat$partyid)


gss_cat %>% 
  mutate(partyid = fct_collapse(partyid,
                              rep = c("Strong republican", "Not str republican"),
                              dem = c("Not str democrat","Strong democrat"),
                              ind = c("Ind,near dem","Ind,near rep", "Independent"),
                              other = c("No answer","Don't know","Other party"))) %>% 
           count(partyid)
 



### EXAMPLE 6----------------------     
  # LUMPING
  #fct_lump()
  #

gss_cat %>% 
  count(relig, sort = T)


# We want lump them together

gss_cat %>% 
  mutate(relig = fct_lump(relig, n =2)) %>%   # n=2 says keep the two largest one and lump the rest
  count(relig)

gss_cat %>% 
  mutate(relig = fct_lump(relig, n =2)) %>%
  ggplot(aes(relig)) +
  geom_bar()

gss_cat %>% 
  mutate(relig = fct_lump(relig, n =2)) %>%
  mutate(relig = fct_infreq(relig)) %>% 
  ggplot(aes(relig)) +
  geom_bar()

gss_cat %>% 
  mutate(relig = fct_lump(relig, n =2)) %>%
  mutate(relig = fct_infreq(relig)) %>% 
  mutate(relig = fct_rev(relig)) %>% 
  ggplot(aes(relig)) +
  geom_bar()

### EXAMPLE 7---------------------- 

# We want to set our levels of factors that when we graph it the 
# highest proportion at the right corner to be the top legend
  # Reordering factor y by its value corresponding to the largest x value
  #fct_reorder2() and fct_rev()
  #

gss_cat %>% 
  filter(!is.na(age)) %>% 
  filter(marital %in% c("Never married",
                        "Married",
                        "Widowed")) %>% 
  count(age, marital) %>% 
  group_by(age) %>% 
  mutate(prop = n/sum(n)) %>% 
  ggplot(aes(age, prop, color = marital)) +
  geom_line(size = 2, na.rm = TRUE) +
  theme_minimal()


# If you look at this graph you see it would be better since the
# Widowed has highest proprtion on the right corner 
# It is better to have it at the top of the legend and 
# Never married to be the buttom of the legend




gss_cat %>% 
  filter(!is.na(age)) %>% 
  filter(marital %in% c("Never married",
                        "Married",
                        "Widowed")) %>% 
  count(age, marital) %>% 
  group_by(age) %>% 
  mutate(prop = n/sum(n)) %>% 
  mutate(marital = fct_reorder2(marital, age, prop)) %>% 
  ggplot(aes(age, prop, color = marital)) +
  geom_line(size = 2, na.rm = TRUE) +
  theme_minimal()

# This is in the reverse order so we need to use 
#    fct_rev() function


gss_cat %>% 
  filter(!is.na(age)) %>% 
  filter(marital %in% c("Never married",
                        "Married",
                        "Widowed")) %>% 
  count(age, marital) %>% 
  group_by(age) %>% 
  mutate(prop = n/sum(n)) %>% 
  mutate(marital = fct_reorder2(marital, age, prop)) %>% 
  mutate(marital = fct_rev(marital)) %>% 
  ggplot(aes(age, prop, color = marital)) +
  geom_line(size = 2, na.rm = TRUE) +
  theme_minimal()


#fct_reorder2(The variable that is going to be changing the factor of ( The want that we want), 
#               the variables that the highest value need to be corresponds and how we are going to orde these variables,
#              The one the determine what order of the factor level is landing )

# This created in backward order that we want so then we next need to use
#   fct_rev()
     
# LUBRIDATE ------------
library(tidyverse)
tidyverse_packages()
library(nycflights13)
names(flights)

## Creating date and time Class ----
flights %>% 
  mutate(flight_date = make_datetime(year, month, day, hour, minute)) %>% 
  select(origin, dest, flight_date)

## Extracting date and time Class ----

flights %>% 
  mutate(flight_date2 = make_date(year, month,day)) %>% 
  mutate(weekday = wday(flight_date2, label = TRUE),
         month_name = month(flight_date2, label = T)) %>% 
  select(flight_date2, weekday, month_name) %>% 
  head(4)

wday("1966-08-23", label = T)
wday("1966-08-23")
mday("1966-08-23")

#Flights filtered only in 15 of each months that is Monday
flights %>% 
  mutate(flight_date2 = make_date(year, month,day)) %>% 
  filter(mday(flight_date2) == 15, wday(flight_date2) == 2)

#Flights filtered only in December
flights %>% 
  mutate(flight_date2 = make_date(year, month,day)) %>% 
  filter(month(flight_date2) == 12)
# Or

flights %>% 
  mutate(flight_date2 = make_date(year, month,day)) %>% 
  filter(month == 12)

#Flights filtered only in 3 quarter

flights %>% 
  mutate(flight_date2 = make_date(year, month,day)) %>% 
  filter(month(flight_date2) >= 7, month(flight_date2) <= 9)

# We can do better

flights %>%
  mutate(flight_date2 = make_date(year, month, day)) %>%
  filter(month >= 7 & month <= 9)

# Or we can use quarter() function

flights %>% 
  mutate(flight_date2 = make_date(year, month,day)) %>% 
  filter(quarter(flight_date2) == 3)


## Period of a flight -----
#     period()


period(c(90, 5), c("second", "minute"))

period(-1, "days")

period(c(3, 1, 2, 13, 1), c("second", "minute", "hour", "day", "week"))

period(c(1, -60), c("hour", "minute"))

period(0, "second")


# Arithmatic with Date-Time Objects
now() + month(10)
now()- years(57)



flights %>% 
  filter(time_hour >= ymd("2013-09-01"),
         time_hour < ymd("2013-10-01")) %>% 
  select(origin, month) %>% 
  head(4)


# Time Spans ----
## Duration:-----
# It measures the exact amount of time between two moments in time,
# provided in seconds. 
# Because the result is a number it makes computation easy
# It does not take things like LEAP YEAR into account

dseconds(15)
dminutes(15)



# a Leap year like 2016 and add 1 year to a point in time using duration
dyears(1)
ymd("2016-01-01") + dyears(1)
# This put you in the end of 2016. 
# It did not take to account that 2016 was  leap year.
# It just added 31557600s to the date and returned 
#     "2016-12-31 06:00:00 UTC"


## Periods -----
# Since it returns the units of times like weeks and month
# It is more natural way to work and it also take into account 
# things like LEAP YEAR

# a Leap year like 2016 and add 1 year to a point in time using Period
years(1)
ymd("2016-01-01") + years(1)
# When we add one year with period you see we go to the next year, 
# which it considers the year 2016 was leap year.
# The result is
# "2017-01-01"

# Multiply and Add Periods
(minutes(8) + days(1) + months(3))*2

## Intervals -----
# It needs start and end points
start <- ymd_hms("2024-09-01  12:00:00")
end <- ymd_hms("2024-10-01  12:00:00")
intrv <- interval(start, end)
intrv %>% 
  print()

# Interval is useful because we can determine
### (I) ----
# if a particular date time is within the interval

ymd_hms("2024-09-11  02:00:03") %within% intrv


### (II)---
# Or we can compare two intervals with mathematical operator 
start2 <- ymd_hms("2023-01-01  12:00:00")
end2 <- ymd_hms("2023-03-01  12:00:00")
intrv2 <- interval(start, end)
intrv2 %>% 
  print()

intrv > intrv2

### (III)
# We can also Convert to duration or Periods
as.duration(intrv)
as.period(intrv)
intrv


## Working with GGPLOT2

flights %>% 
  filter(carrier %in% c("9E", "US", "AA", "MQ")) %>% 
  mutate(week_day = wday(time_hour, label =T)) %>% 
  ggplot(aes(week_day)) +
  geom_bar(fill = "blue", alpha = 0.7) +
  facet_wrap(~carrier)+
  theme_bw()+ 
  labs(title = "Number of Flights by Carrier and Weekday",
       x = "Week Days",
       y ="") +
  theme(plot.title = element_text(hjust = 0.5))






flights %>% 
  filter(time_hour < ymd("2013-10-01"),
         carrier %in% c("9E", "US", "AA", "MQ")) %>% 
  mutate(week_day = wday(time_hour, label =T)) %>% 
  ggplot(aes(time_hour, color = carrier)) +
  geom_freqpoly(linewidth = 1.5) +
  theme_bw()+ 
  labs(title = "Number of Flights by Carrier",
       x = "",
       y ="") +
  theme(plot.title = element_text(hjust = 0.5))
