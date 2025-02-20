# Install aand LOad packages
#install.packages("sloop") 
library(sloop) # sloop for S3 object
library(tidyverse)
library(lubridate)
#_______________________________________________________________________________
# Vectors ----------------------------

# Vectors are fundamental objects in R
## Atomic: -----------------
# An atomic vector is the simplest data type in R.
# It stores values of the same type and is the building block of most R objects.
### Logical: NA, FALSE, T
### Integer, 1L, -1L,
### Double: Decimal, Inf, NaN
#### Integer - Double (Numeric)
### Character: anything in quote
### Complex (1 + 2i)
### Raw Vector (used for binary data)
#### A raw vector in R is a data type that stores binary (byte) data instead of numeric 
#### or character values. Each element in a raw vector is a single byte (8 bits),
#### typically represented in hexadecimal format (00 to FF in hex, or 0 to 255 in decimal).
raw_vec <- charToRaw("Hello")
print(raw_vec) # Each value represents the ASCII hexadecimal code of the characters in "Hello".
# Converting Raw Vector Back to Text
rawToChar(raw_vec)




## List: Objects of different types -------------------
### 1. You can create a list using the list() function:
my_list <- list(name = "Alice", age = 30, scores = c(90, 85, 88))
print(my_list)
### 2. Accessing List Elements
#You can access elements using $, [[ ]], or [ ]:
my_list$name

my_list[[2]]  # Second element
my_list[["age"]]  # Access by name

my_list[1:2]

### 3. Modifying a List
# You can update or add new elements:
my_list$city <- "New York"  # Adding a new element
my_list$age <- 31  # Modifying an element
print(my_list)

### 4. Removing an Element from a List
my_list$age <- NULL
print(my_list) #The "age" element is removed.


### 5. Nested Lists (Lists Inside Lists)
# Lists can contain other lists:
nested_list <- list(student = my_list, course = "Math")
print(nested_list)
#You can access nested elements using [[ ]]:
nested_list$student$name

## NULL: -------------------------------
# In R, NULL represents the absence of a value or an empty object.
# It is used to indicate that a variable, object, or function has no valid data.

### 1. When is NULL Used?
#### To remove elements from lists or data frames.
#### As a default return value when an operation has no output.
#### To check missing objects before processing.
#### To initialize an empty variable.

### 2. Creating a NULL Value
x <- NULL
print(x)

### 3. Checking if a Value is NULL
# Use is.null() to check if an object is NULL:
is.null(x)

### 4. Using NULL to Remove Elements from a List
my_list <- list(a = 10, b = 20, c = 30)
my_list$b <- NULL  # Remove element "b"
print(my_list)


### 5. NULL vs NA
# NULL represents No value (empty object), its length is zero check with `is.null(x)`
# NA represents Missing value (but object exists), its length is one check with `is.na(x)
vec <- c(1, NA, 3)
is.na(vec)  # Checks for missing values

list_example <- list(a = 1, b = NULL)
is.null(list_example$b)  

is.null(list_example$a)

length(NULL)
length(NA)
typeof(NULL)
typeof(NA)
is.atomic(NULL) #Null is an empty object  that represents the absence of a value.
is.atomic(NA)
is.vector(NULL) #  NULL is not an atomic vector. NULL does not store any data.
is.vector(NA)

## Scalar are a vector of length 1.  --  x <- 25
#### Type of NA is logical
## is.vector() ------
y <- 25
length(y)
is.vector(y)

# Does it matter that NA is logically a vector? 
  ## No, Because logical COERCED to other Types

typeof(NA)
typeof(c(1L, NA))  # integer
typeof(c(1, NA))  # double
typeof(c("1", NA))  # character

# If you need NA of another type use:
typeof(NA)
typeof(NA_real_)
x_i <- NA_integer_
x_r <- NA_real_
x_c <- NA_character_
cat("Type of x_i is", typeof(x_i),
"\nType of x_r is", typeof(x_r),
"\nType of x_c is", typeof(x_c))


# How to check the ype of a vector?
is.logical(x_i)
is.integer(x_i)
is.double(x_i)
is.double(x_r)
is.character(x_i)
is.character(x_c)

# We create a vector by function `c()`

x<-c(NA, 10)
cat("The vector x is:", x, 
    "\n Its type is", typeof(x))

## How to test NA?
# Never use `==` because it always return NA.
 x == NA
 
 is.na(x)
 
 cat(" Using `x == NA, will return ", x == NA,
     "\nUsing `is.na(x)` will return", is.na(x))
#_______________________________ 
### Recall: 
 r <- c( 2, 3, 5, 7, 11, 13)
 r <= 9
 r > 11
 r == 2
 r%%2 ==0
 r%%2 == 0 | r>=11

#_______________________________
 
# COERCE VECTOR -------------------
 # Attempting to combine vectors of different types coerces them to the same type. 
 # The order of preference is character > double > integer > logical.
c(1L, T)
1 == "1"
-1 < FALSE
"one" < 2   #[ASCII order](https://en.wikipedia.org/wiki/ASCII#Character_order)

# ATTRIBUTE -------
# In R, objects can have attributes, which store metadata (extra information) about 
# the object. Attributes are useful because they provide additional context or structure to
# data without changing its core values.

## Why Set Attributes?--------------
# Setting attributes helps in organizing data, making it more meaningful and easier to manipulate. For example:
  
# Naming elements in a vector (e.g., column names in a data frame).
# Storing dimensions for matrices and arrays.
# Keeping additional metadata, such as labels, class, or timestamps.
df <- data.frame(ID = 1:3, Score = c(85, 90, 95))
attr(df, "created_at") <- Sys.time()  # Stores the current timestamp
attributes(df)

print(paste("The time stemp is:", attr(df, "created_at")))


## Functions to Work with Attributes---------------
# 1. attr() – Used to get or set a specific attribute.
x <- 1:5
attr(x, "description") <- "A sequence from 1 to 5"
attr(x, "description")  # Returns "A sequence from 1 to 5"

attr(x, "type") <- "The type is an integer"
typeof(x)
# 2. attributes() – Returns all attributes of an object.
attributes(x)

# 3. structure() – Creates an object with attributes directly.

y <- structure(c(1,2,3,4,5), description = "A sequence with metadata", 
               type = "The type is a double")
attributes(y)

typeof(y)



## Most Attributes Are Lost in Operations ---------------------
# Most R functions do not preserve attributes, 
  ## except for specific ones like names and dim.
## For example:

x <- 1:5
attr(x, "info") <- "Numbers"
sum <- sum(x)  
 sum 
attributes(sum)  # NULL  ---  Attribute is lost

# or
attributes(x[[1]])
# or
attributes(sum(x))


### Exception: names and dim Are Typically Preserved ---------------------------
# These attributes are not lost in most operations:
  
 ###  Names: Naming elements in a vector.----------------------------

x <- 1:3
attr(x, "names") <- c("a", "b", "c")
attributes(x)

# Names are so special, that there are special ways to create them and view them
y <- c(A = 10, B = 20, C = 30)
names(y)

z <- c(11, 13, 17, 19)
names(z) <- c("Eleven","Thirteen", "Seventeen", "Nineteen")
names(z)

## Names stay with single bracket subsetting (not double bracket subsetting)
y[c(1, 3)]
z[-2]
x[c(-1,-3)]

## Names can be used for subsetting
x[["a"]]
z[["Thirteen"]]

# You can remove names with unname().
unname(x)
unname(y)
unname(z)

x### Dimensions (dim): Used for matrices and arrays.-------------------------









## S3 Objects -------
# In R, S3 objects are a way to create custom objects with specific behaviors. 

### How S3 Objects Work ---------------
# An S3 object is essentially a regular R object (like a list or vector)
# with an extra "class" attribute. This attribute tells R how to handle the object
# when it is passed to generic functions.

### Creating an S3 Object -----------------
# You can create an S3 object by assigning a "class" attribute using structure() or attr().
# For example, take the factor. Its base type is the integer vector,
f <- factor(c("a", "b", "c"))
typeof(f)

# it has a class attribute of “factor”, 
class(f)
attr(f,"class")

#and a levels attribute that stores the possible levels
levels(f)

# Type attributes(f)
attributes(f)

#### UNCLASS ---------
unclass(f) -> unclass_f
unclass_f
# You can get the underlying base type by unclass()ing it, which strips the class attribute,
attr(unclass_f, "class")
#or
class(unclass_f) # It is not class of factor anymore. Thus class() returns the typeof the object.
# causing it to lose its special behaviour:
attributes(unclass_f)


# An S3 object behaves differently from its underlying base type 
# whenever it’s passed to a generic (short for generic function). 
is.object(f)   # it is an S3 object
is.object(unclass_f)  #Has no special Class, so it is not an S3 object.
# The easiest way to tell if a function is a generic is to use sloop::ftype() 
# and look for “generic” in the output:
ftype(summary) # function summary is a generic function
ftype(print) # function print is a generic function

### ftype()
ftype(`%in%`) # "function"
ftype(sum) # Error: `f` is not a function
ftype(writeLines) #"internal"
ftype(str) # A generic function


# A generic function is a function that behaves differently depending on the type of object (class) you give it.
# It chooses the right version of the function based on the object's class.

# For example, many built-in R functions, like print(), are generic. 
# This means print() works differently for numbers, data frames, lists, and
#custom objects because R picks the correct method based on the class of the input.


print(f)  # f is a factor with class attribute factor
class(f)

# Removing the class attribute makes the object behave like a regular integer again.
print(unclass_f)
class(unclass_f)


# The str() function in R is a generic function, meaning it behaves differently for different types of objects. 
# Some S3 objects use str() to hide their internal structure.

# For example, POSIXlt, which stores date-time data, is actually a list behind the scenes.
# However, when you use str() on a POSIXlt object, 
# it doesn’t show this list structure—it presents the data in a way that looks more like a
# date-time format.

time <- strptime(c("2017-01-01", "2020-05-04 03:21"), "%Y-%m-%d")
time
typeof(time)
class(time)

str(time)

str(unclass(time))

ftype(str)
#A generic function is like a middleman. Its job is to define the inputs (arguments) and then figure out which 
# specific function (method) should handle the task. The method is the actual
# function that works for a specific type of object, and the generic function picks
# the right one using method dispatch.

# You can use sloop::s3_dispatch() to see the process of method dispatch:
s3_dispatch(print(f))
# S3 methods are functions with a special naming scheme. 
print(f)
# For example, the factor method for the print() generic is called
# print.factor(). 
# You should never call the method directly, but instead rely on the generic to find it for you.
print.factor(f)

#______________________________________________
## SUMMARY Function
ftype(summary)   # A generic function


# Create a numeric vector  --- Regular object
num_vec <- c(1, 2, 3, 4, 5)
is.atomic(num_vec)
is.object(num_vec) # Not an S3 object

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
is.object(factor_vec)  # An S3 object
class(num_vec)   #numeric class


#### inherit() function ------
#The inherits() function in R is used to check if an object belongs to a specific class
# or inherits from a class in the S3 object system. 
# It helps ensure that the correct methods are applied based on an object's class hierarchy.

inherits(num_vec, class(num_vec))
#or
inherits(num_vec, "numeric")

inherits(factor_vec, "numeric")
inherits(factor_vec, "factor")
inherits(factor_vec, class(factor_vec))

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

factor_vec

unclass((factor_vec))

unclass((factor_vec))|>
  class()    #returns integer




# Create a numeric vector
values <- 1:6
values
print(values)

# create a matrix
# Use structure to add attributes and create a matrix
my_matrix <- structure(
  values, 
  dim = c(2, 3),      # Setting the dimensions (2 rows, 3 columns)
  dimnames = list(c("Row1", "Row2"), c("Col1", "Col2", "Col3")),  # Assigning row and column names
  class = "matrix"    # Setting the class as 'matrix'
)

# Print the structured object
print(my_matrix)


#_____________________________
# Factor ------------------
# Factors are R's way to storing categorical variables, 
# when variable has certain number of possible values.

# A factor is an integer vector with the class attribute `factor` and a 
# `level` attribute describing the possible levels.

factor_vec |>
  attributes()




#______________________________________________________
# Data Frame ------------------------------------
# data frames are lists where:
## 1. Each element is a vector
## 2. Each vector has the same length

df <- data.frame(a =4:6, b = c("A", "B", "C"))
is.atomic(df)
typeof(df)
class(df)
is.object(df)  # An S3 Object

attributes(df)
 names(df)
 colnames(df)
 rownames(df)
 row.names(df)
 
 rownames(df) <- c("row_1", "row_2", "row_3")

 df


 str(df)

 ## TIBBLE VS DATA FRAME -------
 
 #### 1. tibble do not automatically coerce data and 
 # after version 4.4 dataframe doess not also coercing automatically. 
 # If you want to coercing automatically we need to set 
 #                  stringsAsFactors = TRUE
 
 df_1 <- data.frame("hello-world" = c("A", "B", "C"), stringsAsFactors = TRUE)
 df_1
class(df_1$hello.world)  # Returns factor. 


DF <- data.frame("hello-world" = c("A", "B", "C"))

class(DF$hello.world) # returns character



tib_1 <- tibble::tibble("hello-world" = c("A", "B", "C"))
tib_1
class(tib_1$`hello-world`)  # returns character
 
 ##### 2.  data frame change the name if it happen to be non-synthetic (eg. has space)
 df_2 <- data.frame(`hello world` = c(1, 2, 3))
 df_2  # changes the name of variable since there is a space between hello and word
 
 typeof(df_2)
 class(df_2)
 
 ##### tibble does not change the name if it happen to be non-synthetic
 tib_2 <- tibble::tibble(`hello world` = c(1, 2, 3))
 tib_2   # Did not changed the name of variable
 
 typeof(tib_2)
 class(tib_2)
 
 ##### 3. data frame reduce to a vector when you subset one column
 
 attributes(df_2[, 1])  # data frame is Subset to a vector, so data frame reduce it to vector
 class(df_2[,1])  # returns numeric
 
 
 #####  tibble does not reduce to a vector when you subset one column
 attributes(tib_2[, 1])  # Not reduced to a vector
 class(tib_2[,1])   # returns tbl
 
 ##### 4.  data frame recycles vectors or multiple length
 
 data.frame(x = c(1, 3, 5, 2), y = c(TRUE, FALSE))
 
 ##### tibble recycles only vectors of length 1
 
 tibble::tibble(x = c(1, 3, 5, 2), y = c(TRUE, FALSE))  # ERROR
 
 tibble::tibble(x = c(1, 3, 5, 2), y = c(TRUE))
 
 #_________________________________________________
 # function -------------
 wmean <- function(x, w = NULL) {
   if (is.null(w)) {
     w <- rep(1 / length(x), length.out = length(x)) # if length x is 3 then w=(1/2,1/2)
   } else {
     w <- w / sum(w)  # (1/2 , 1/2) * (1/2 + 1/2)  
   }
   return(sum(x * w))    # (1/2*x1 + 1/2*x2)
 }
 x <- c(1, 2,3)
 wmean(x)
 wmean(x, w = c(5, 1, 1))

 

 

#_______________________________
# DATE---------------------------

Sys.Date()

Sys.Date()|>
  unclass()
as.time("1970-01-01")
unclass(as.Date("1970-01-01"))
Sys.time()

as.POSIXct(c("1980-10-10 01:11:01"), tz ="UTC"
                 )|>
  unclass()

as.POSIXlt(c("1980-10-10 01:11:01"), tz ="UTC"
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

#_______________________________________________________________________________

#SUBSETTING -----------------

## ATOMIC SUBSETTING -----------------
### SUBSETTING WITH POSITIVE INTEGER ---------
x <- c(8, 1.2, 33, 14)

x[1]                   #extract the first element
x[c(1, 3)]             #extract the first and 3rd element
iset <- c(1, 3)
x[iset]

x[c(3, 3, 3, 3)]
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

x[c(FALSE, FALSE, FALSE, FALSE)]  # returns a vector of length zero

### NO SUBSETTING ----------

x[]        # Empty brackets will return the original object.

### ZERO SUBSETTING ----------

x[0]        # Using 0 in a bracket will return a zero-length vector.

typeof(x[0])
class(x[0])

is.vector(x[0])
is.null(x[0])

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

x

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

print(x)
x$a

# Why does this not work. Suggest a correction.

var <- "a"
x$var

   #`var` is not a name in `x`. Instead, use `x[[var]]`.
x[[var]]


names(x) <- c("var", "b", "c")
x$var   # How about now? Does it work?


## DATA FRAME SUBSETTING -----
# Data frame subsetting behaves both like lists and like matrices.

df <- data.frame(A = 1:3,
                 B = c("a", "b", "c"),
                 C = 4:6)

df

row.names(df) <- c("I", "J", "K")
df

rownames(df) <- c("r1", "r2", "r3")  # rownames() is in packages tibble and base
df

# It behaves like a list for $, [[, and [ if you only provide one index. 
# The columns are the elements of the list.

df$A
df[1]
df[[1]]
df[c(1, 3)] # columns one and three
df[1,3]    # row 1 column 3


# It behaves like a matrix if you provide two indices.
df[1:2, 2]  #df[row, column]


# You can keep the data frame structure by using drop = FALSE.
df[1:2, 2, drop = FALSE]

# It is common to filter by rows by using the matrix indexing.
df[df$A < 3, ]


##
df[3,1]
df[[c(1, 3)]]   # df[[c(column, row)]]. We should us instead df[3, 1]
df[[1,3]]        # df[row, column]

#_______________________________________________________________________________
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
# normal distribution with standard deviation 10.(since mean is not given we assume is 0)
# rnorm(n, mean = 0, sd = 1)

set.seed(1)
v <- rnorm(10, sd = 10) 

mean(v)

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

v[order(v)]

# or

v %>% 
  order() %>% 
  v[.]



# Step 3:____________________________________
# calculate the  lagged differences between these elements,

# diff() is from base package and it returns suitably lagged and iterated differences
#          diff(x, lag = 1)
sort(v) %>% 
  diff() ->
  diff
diff

# Step 4:____________________________________
# average these lagged differences,
#    
diff %>% 
  mean() ->
  avg
avg

# Step 5:____________________________________
# round this average to the nearest tenth decimal place.
#             round(x, digits = 0, ...)
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


#____________________

mean_lag_diff <- function(n, SD, digit){
  rnorm(n, sd = SD) %>%
    sort() %>%
    diff() %>%
    mean() %>%
    round(digits = digit) 
}

mean_lag_diff(1000, 10, 1)

## Create Function-------------


# Write `both_na()`, a function that takes two vectors of the 
#same length and returns the number of positions that have an `NA` in both 
# vectors. Include documentation.
# Useful functions: `is.na()`, `sum()`, 
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
# vectors.
# Include documentation. 
# Useful functions: `is.na()`, `which()`, 
# logical operators.

#_____________________________________________________________________________
### which() function
a <- c(NA, NA,12, NA)
b <- c(5, NA, NA, 22)
is.na(a)
which(is.na(a))

which(is.na(b))


#_______________________________________________________________________
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


# Returns only the non-NA of both vectors



not_na <- function(x, y) {
  if (length(x) == length(y)) {
    c( x[!is.na(x)], y[!is.na(y)]) ->
      vec
    cat("The non-NA elements of both vector is:", vec)
  } else {
    print ("vectors are not of the same size. Please use two vectors of the same size")
  }

}

not_na(c(1, NA, 2), c(NA, NA))
not_na(c(NA, NA, 2), c(NA, NA, 2))
not_na(c(NA, 5, NA), c(NA, NA, NA))
not_na(c(NA, NA, NA, 2, NA, 4, NA), c(NA, NA, 2, 4, 4, NA, NA))




#_______________________________________________________________________________
# ITERATORS --------------------------
## FOR LOOP -------------
### Exercise:-----------
# Calculate the first 100 Fibonacci Numbers.
# Sanity Check: The $\log_2$ of the 100th Fibonacci Number is about 68.95.


# NOTE: WE COULD CREATE A VECTOR OF LENGTH 100 and FILLED with  NA
#                 fibvec <- rep(NA_real_, length = 100)

#              vector(mode = "logical", length = 0)


 fibvec <- vector(mode = "double", length = 100)  # create a vector of length 100
for (i in seq_along(fibvec)) {
                 
  if (i > 2) {
    fibvec[[i]] <- fibvec[[i - 1]] + fibvec[[i - 2]]
  } else if (i == 1) {
    fibvec[[i]] <- 0
  } else if (i == 2) {
    fibvec[[i]] <- 1
  } 
}



sum(fibvec[]) %>% 
  log2()




fibb <- function(n){
  fibvec <- vector(mode = "double", length = n)  # create a vector of length 100
  for (i in seq_along(fibvec)) {
    
    if (i == 1) {
      fibvec[[i]] <- 0
    } else if (i == 2) {
      fibvec[[i]] <- 1
    } else if (i > 2) {
      fibvec[[i]] <- fibvec[[i - 1]] + fibvec[[i - 2]]
    }  else{
    }
  }
  return(cat("log of sum is:",
  sum(fibvec[]) %>% 
    log2()
  , "\nAnd ", fibvec)
  )
}

fibb(100)



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



#_______________________________________________________________________________
# PURR PACKAGE ---------------
# Part of tidyvers
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

head(mtcars)
sd(mtcars$mpg)

summary(mtcars)

map(mtcars,sd) # returns a list

map_dbl(mtcars, sd) # returns a numeric

## What is map2()? ---------------
# Map over two inputs
x <- list(1, 1, 1)
y <- list(10, 20, 30)
map2(x, y, \(x, y) x + y) # an anonymous function (with \(x, y) x + y) to specify the operation for x and y
                          #The function takes two arguments (x and y), 
#                          # and then it returns the sum of those two values.

map2(x, y, `+`)          # Same as above

# You can pass on more arguments in `map_*()`
map_dbl(mtcars, mad, na.rm = TRUE)  # Median Absolute Deviation
map_dbl(mtcars, mad)


map(mtcars, summary) # Suppose you want to get the output of `summary()` on each column.
map_dbl(mtcars, summary)  #Error


#   **Exercise** (RDS 21.5.3.1): Write code that uses one of the map functions to:
  
#   1.  Determine the type of each column in `nycflights13::flights.`
#   2.  Compute the number of unique values in each column of `palmerpenguins::penguins`.
#   3.  Generate 10 random normals for each of $\mu = -10, 0, 10, \ldots, 100$.
#   4.  Generate 10 random normals for each of $\mu = -10, 0, 10$ and $\sigma = 0.5, 1, 2$.

library(nycflights13)
library(palmerpenguins)
data("flights")
data("penguins")

head(nycflights13::flights)
names(flights)


#   1.  Determine the type of each column in `nycflights13::flights.
typeof(flights$year)

map_chr(flights, typeof)

#   2.  Compute the number of unique values in each column of `palmerpenguins::penguins`.
unique(penguins$species) %>% 
  length()

unique(penguins$island) %>% 
  length()

unique(penguins$bill_length_mm) %>% 
  length()

map_int(penguins, length) # This gives us the length of each vector, but not the unique value

map_int(penguins, function(x) length(unique(x)))

# function(x) length(unique(x)) is an anonymous function that, that takes
# an input x (a column of penguins).

# Instead of explicitly defining function(x), you can use a tilde (~) shorthand:
map_int(penguins, ~ length(unique(.)))


 #   3.  Generate 10 random normals for each of $\mu = -10, 0, 10, \ldots, 100$.
map_dfc(seq(-10, 100, by = 10), rnorm, n = 10) ->
  temp
temp

#   4.  Generate 10 random normals for each of $\mu = -10, 0, 10$ and $\sigma = 0.5, 1, 2$.
map_dfc(seq(-10, 10, by = 10), ~rnorm(10, mean = ., sd = c(0.5,1, 2)))

seq(-10, 10, by = 10) %>% map_dfc( ~rnorm(10, mean = ., sd = c(0.5,1, 2)))

map_dfc(c(-10,0,10), rnorm, n=10, sd = c(0.5,0,2))
### Shortcuts --------------------

#   You can refer to elements of the vector by "`.`" in a `map()` call if the `.f` argument is preceded by a "`~`". For example, the following are three equivalent ways to calculate the mean of each column in `mtcars`.


map_dbl(mtcars, mean)
map_dbl(mtcars, function(.) mean(.))
map_dbl(mtcars, function(x) mean(x))
map_dbl(mtcars, \(x) mean(x))
map_dbl(mtcars, ~mean(.))


#  What is actually going on is that purrr is creating an "anonymous function"


.f <- function(.) {
  mean(.)
}

# and then calling this function in `map()`.



map_dbl(mtcars, .f)


# The dot for the name of the function is not necessarily
f <- function(.) {
  mean(.)
}
# and then calling this function in `map()`.
map_dbl(mtcars, f)

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
    
  # By dplyr it seems  
    mtcars %>%
      group_by(cyl) %>%
      summarise(p_value = t.test(mpg ~ am)$p.value)

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

    
#_______________________________________________________________________________    
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
    
    View(gss_cat)    # A sample of categorical variables from the General Social survey
    glimpse(gss_cat)
    
    unique(gss_cat$race)
  #
    #
    gss_cat %>% 
      pull(race)
    
    gss_cat$race
  #
    class(gss_cat$race)
    
    
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
                         # "Not applicable" has no values
    
    
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
    
   
      is.na(gss_cat$tvhours) %>%   #number of NA
      sum()   # 10146
    
    length(gss_cat$tvhours)  # 21483
    
      
    # Number of observations without NA
    length(gss_cat$tvhours) - sum(is.na(gss_cat$tvhours))  # 11337
    
   
     
    gss_cat %>% 
      select(tvhours) %>% 
      table() ->
      t
    t   # No NA is included
    sum(t)  # 11337
    
    
    
    # Drop NA
    gss_cat %>% 
      drop_na(tvhours) -> n_gss
    
      length(n_gss$tvhours) # 11337
    
    
      
      # We want average tv hours by Religions.
    gss_cat %>% 
      drop_na(tvhours) %>% 
      group_by(relig) %>% 
      summarise(mean_tv = mean(tvhours))
    
    
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
    
    names(gss_cat)
    
    gss_cat %>% 
      drop_na(tvhours) %>% 
      group_by(relig) %>% 
      summarise(mean_tv = mean(tvhours)) ->
      new_gss
    new_gss
    
    names(new_gss)
    
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
      # rincome   -   reported income
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
#_______________________________________________________________________________     

# DATE-------
## {base} -------
Sys.Date() %>% 
  class()

Sys.Date()|>
  unclass()


Sys.time() %>% 
  class()

Sys.time() %>% 
  unclass()

####Parsing:

date1 <- as.Date("1966-08-23")  # Default format YYYY-MM-DD
date2 <- as.Date("02/16/2025", format = "%m/%d/%Y")  # Custom format
date3 <- as.Date("16-02 24", format = "%d-%m %y")
date4 <- as.Date("16 96/8", format = "%d %y/%m")
date5 <- as.Date("16 96/August", format = "%d %y/%B")


print(date1)
print(date2)
print(date3)
print(date4)
print(date5)

class(date1)


## LUBRIDATE ------------
library(tidyverse)
tidyverse_packages()

# R handles date and time through Date and POSIXct and POSIXlt classes
today()

today() %>% 
  unclass()

now()

now() %>% 
  unclass()

# Lubridate has functions that will take a string of test to class `Date`



d1 <- ymd("2024-Sep/26")  #Parse date string
d1
class(d1)

mdy("09/16 2026")

t1 <- mdy_hms("09/16 2024 13:25:58") #Parse date-time string
t1
class(t1)

"2024-10-03 13:25" %>% 
  ymd_hm("")

# imaging you have a data set that has dates and time variables as a
# string of text not date objects.


library(nycflights13)
names(flights)

flights %>% 
  glimpse()


flights %>% 
  select(origin, year:day, hour, minute) %>% 
  head(4)


## Creating date and time Class ----
flights %>% 
  mutate(flight_date = ymd_hm(paste(year, month, day, hour, minute))) %>% 
  select(origin,dest, flight_date) %>% 
  head(4)

# A better approach is to use make_datetime() function

flights %>% 
  mutate(flight_date = make_datetime(year, month, day, hour, minute)) %>% 
  select(origin, dest, flight_date) %>% 
  head(4)

## Extracting date and time Class ----
# It allows you to pick specific component from date-time objects

wday("1966-08-23",label = TRUE)
wday("1966-08-23",label = TRUE) %>% 
class()

wday("1966-08-23")
wday("1966-08-23") %>% 
  class()


wday("1966 08/23") # Error
wday(ymd("1966 08/23"))
wday("08-23 1966", label = T)
wday(mdy("08-23 1966"), label = T)
mday("1966-08-23")
mday("1966-08-23", label = T)  # Error

month("1966-08-23", label = TRUE)
month(mdy("08-23 1966"), label = T)

flights %>% 
  mutate(flight_date2 = make_date(year, month,day)) %>% 
  mutate(weekday = wday(flight_date2, label = T),
         month_name = month(flight_date2, label = T)) %>% 
  select(flight_date2, weekday, month_name) %>% 
  head(4)



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
now() + months(10)
now()- years(57)



flights %>% 
  filter(time_hour >= ymd("2013-09-01"),
         time_hour < ymd("2013-10-01")) %>% 
  select(origin, month) %>% 
  head(4)

# Leap year---------------
leap_year(1900)
leap_year(2016)


# Decimal Date-----------------
# Convery date-time object to decimal

decimal_date(ydm("1966-23-08"))

# Time Spans ----
## Duration:-----
# It measures the exact amount of time between two moments in time,

dseconds(15)
dminutes(15)
# Because the result is a number it makes computation easy
# It does not take things like LEAP YEAR into account

dyears(1)



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
years(1)
# a Leap year like 2016 and add 1 year to a point in time using Period

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


### (II)----
# Or we can compare two intervals with mathematical operator 
start2 <- ymd_hms("2023-01-01  12:00:00")
end2 <- ymd_hms("2023-03-01  12:00:00")
intrv2 <- interval(start2, end2)
intrv2 %>% 
  print()

intrv > intrv2

### (III)
# We can also Convert to duration or Periods
as.duration(intrv)
as.duration(intrv2)
as.period(intrv)
as.period(intrv2)



## Working with GGPLOT2
flights$carrier %>% unique()


flights %>% 
  glimpse()


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
