
library(tidyverse)

library(data.table)


# Packages in tidyverse
tidyverse_packages()
# data.table vs tidyverse--------------

# Use data.table for large data sets that you read
# in with fread()

# Let's read in a data table.  Do not forget to set your working
# directory.

### Using a data.table read in---------------

flights1 <- fread("./dot_table/nycdata.csv")  
flights1                      # note how large the data table is;  253,316 rows !!

# Consider the class(es) that data array belongs to

class(flights1)

#  Again, flights1 is a very large data table

nrow(flights1)
ncol(flights1)

dim(flights1)

## tidyverse read in--------------

flights2 <- read_csv("./dot_table/nycdata.csv") # produces a tibble
flights2
  
class(flights2)



# Now let us take a look at the structure and data identification
# for the data table

str(flights1)  # data.table way
glimpse(flights1)


glimpse(flights2)  # tidyverse way
str(flights2)
# Filtering/Arranging Rows (Observations)


## Filter------------------
# Just like in the tidyverse, we use logicals to 
# filter based on rows. The syntax for this is to place 
# the logicals inside a bracket. Let's find all flights 
# that left JFK and arrived at LAX.

# data.table way



# Remember the data contains row nad column and we use [Row,Column]
# so since filtering is a row process, you may use , or not use it
# R support both

flights1[origin == "JFK" & dest == "LAX"]

# With ,

flights1[origin == "JFK" & dest == "LAX", ] 

# equivalent tidyverse way

flights2 |> 
  filter(origin == "JFK", dest == "LAX")


# Select a few columns

# With data.table

flights1[, c("carrier","origin","dest")]  # You must use the "
# or
flights1[, c(6:8)]

# Now filter all flights 
# that left JFK and arrived at LAX. 

flights1[origin == "JFK" & dest == "LAX", c("carrier","origin","dest")]

# equivalent tidyverse way
flights2 %>%
  select(carrier,origin,dest)%>%
  filter(origin == "JFK", dest == "LAX") 


## Specific Row----------------
# data.table

# To get a specific row(s), insert the number(s) into the 
# brackets.
flights1
# let's extract one row; row 3
flights1[3]    # insert the the row number in brackets

# Now let's extract rows 1, 3, and 207
flights1[c(1, 3, 207)] 

# equivalent tidyverse way      use the command slice

flights2%>%
  slice(3)


flights2%>%
  slice(1, 3, 207)

## Reorder -------------------
# Reorder rows by using the order() function inside the brackets.
# Let's reorder the rows alphabetically by origin, and break 
# ties in reverse alphabetical order by destination.

# data.table way
flights1[order(origin, -dest)]


# equivalent tidyverse way    
flights2 %>%
  arrange(origin, desc(dest))

## Select -----------------

# Let's select variables year,month,day,carrier,origin,dest
# and then arrange them the rows alphabetically by origin, and break 
# ties in reverse alphabetical order by destination.

# data.table way

flights1[order(origin, -dest), c("year","month","day","carrier",'origin','dest')]
# equivalent tidyverse way    
flights2 %>%
  select(year,month,day,carrier,origin,dest)%>%
  arrange(origin, desc(dest))

# Selecting Columns (Variables)

# To select a variable (a column), you also use bracket notation,
# but you place a comma before you select the columns. This idea
# is that you are selecting all rows (empty space after comma).

# We will select the column variables origin and dest

# data.table way




# With dot: USE .()
flights1[, .(origin, dest)]   # Do not use quotation


# Without dot: 

## Use list()

flights1[, list(origin, dest)]


# Character Vector Method: Use c() with their character names
#  use quotation

flights1[, c("origin", "dest")]
 # or
flights1[, c(7, 8)]

# Range Method: Use : to select variables within a range of 
# columns.

flights1[, origin:dest]


# equivalent tidyverse way
flights2 %>%
  select(origin, dest)


## Remove Column------------------

# To remove a column using the range or character methods, 
# place a ! before the columns to remove

# using data.table

flights1

flights1[, !c("year", "month")]

# or

flights1[, !(year:month)]


# Using tidyverse

flights2%>%
  select(-year, -month)
# or
flights2%>%
  select(-c(year, month))


# Unlike the tidyverse, you filter rows and select columns in 
# one call for the data.table method rather than using two or 
# more separate functions.

# Lets find all year, month, day, and hour arrangements for 
# flights that leave JFK and arrive at LAX

# tidyverse way
flights2 %>%
  select(year, month, day, hour, origin, dest)%>%
  filter(origin == "JFK", dest == "LAX") -> f2
f2


# data.table way
flights1[origin == "JFK" & dest == "LAX", .(year, month, day, hour)]

# or (and more descriptive)  preferred method

flights1[origin == "JFK" & dest == "LAX", .(year, month, day, hour,
         origin, dest)]


## Creating New Variables (Mutate)----------------

# The fastest way to create and remove variables in a data.table is
# by reference, where we modify the data.table, we don't create a 
# new data.table.

# Use := to modify a data.table by reference. You put the variable
# names (as a character vector) to the left of :=. You put the new 
# variables (as a list) to the right of :=.

# data.table way
flights1

flights1[, c("gain") := .(dep_delay - arr_delay)]
flights1

# equivalent tidyverse way    
flights2 %>%
  mutate(gain = dep_delay - arr_delay) ->
  flights3
flights3
# Let's see the new column
View(flights3)

## Removing a column ------------------

## data.table way      remove a column by setting that variable to NULL.

flights1[,!"gain"]  # With this code gain varaible has been removed but flights1
# has not updated yet. To updated it yu need to add another line to set the result to flights 1
#      flights1[,!"gain"] -> flights1

# The best way is the following that has both steps in one line

flights1[, c("gain") := .(NULL)]
flights1


## equivalent tidyverse way

flights3


flights3 %>%
  select(-gain) ->
  flights2
flights2

# Add multiple variables by separating them with columns.

flights1[, c("gain", "dist_km") := .(dep_delay - arr_delay, 
        1.61 * distance)]
flights1

glimpse(flights1)

# Eliminate the added columns by using NULL

flights1[, c("gain", "dist_km") := .(NULL, NULL)]
flights1


## Group Summaries---------------------

# You calculate summaries in the column slot. 
# It's best to use the list method.

# Lets find the mean for departure delays

# data.table way
flights1[, .(meandd = mean(dep_delay))]
# or
flights1[, list(meandd = mean(dep_delay))]


## equivalent tidyverse way
flights2 %>%
  summarize(meandd = mean(dep_delay))


# Let's produce more that one summary

# data.table way
flights1[, .(meandd = mean(dep_delay), meanad = mean(arr_delay))]

## equivalent tidyverse way
flights2 %>%
  summarize(meandd = mean(dep_delay), meanad = mean(arr_delay))

## Count the number of rows with .N.-----------------

## data.table way
flights1[, .(.N)]
# or
flights1[, list(.N)]
# or
flights1[, c(.N)]

# or
flights1[, .N]

## equivalent tidyverse way
flights2 %>%
  count()


## Group Summaries-------------
# In data.table, you create grouped summaries by simultaneously
# grouping and calculating summaries in one line, not separately 
# like in dplyr.


# In data.table, you use the by argument to specify the grouping
# variable. It should also be a list.

# data.table way
flights1[, .(meandd = mean(dep_delay)) , by = .(origin)]

# equivalent tidyverse way
flights2 %>%
  group_by(origin) %>%
  summarize(meandd = mean(dep_delay))

## Recoding---------------

# Suppose you want to change the values of a variable. In the 
# tidyverse, we used recode() to do this.

#In data.table, we filter the rows then mutate by reference.

# Let's substitute AmerAir in for AA for the variable carrier.

# data.table way

flights1

flights1[carrier == "AA", carrier := "AmerAir"]  # Note: We use := for the new name of observations
flights1

## equivalent tidyverse way
flights2

flights2 %>%
  mutate(carrier = recode(carrier, "AA" = "AmerAir")) ->
  flights2
flights2

View(flights2)

# Uniting-----------------

#To unite, use paste().

table5

class(table5)

# Convert to a data.table array

dt5 <- as.data.table(tidyr::table5)
dt5

class(dt5)

# data.table way
dt5[, year := paste(century, year, sep = "")]
dt5[, century := NULL]
dt5
str(dt5)

# Equivalent tidyverse methods

tidyr::table5 %>%
  unite(century, year, col = "year", sep = "")

# Or simply

table5 %>%
  unite(century, year, col = "year", sep = "")



# Chaining-------------------

# In the tidyverse, we chain commands by using the 
# pipe %>%. In data.table, we chain commands by adding 
# additional brackets after the brackets we used. 
# Data.table makes this very efficient.

# Let's calculate the mean arrival delay for american 
#airlines for each origin/destination pair, then order 
# the results by origin in increasing order, breaking 
# ties by destination in decreasing order.

# Lets find the mean of arrival delays(gouping
# by origin and destination) for the carrier AmerAir.

#In the tidyverse way and then alphabetizing by origin.

flights2 %>%
  select(carrier,origin, dest, arr_delay)%>%
  filter(carrier == "AmerAir") %>%
  group_by(origin, dest) %>%
  summarise(meanad = mean(arr_delay)) %>%
  arrange(origin, desc(dest)) -> flights2a
flights2a

## data.table way
flights1[carrier == "AmerAir", .(meanad = mean(arr_delay)),
        by = .(origin, dest)][order(origin, -dest)]



# Joining------------------------

# We'll use the following data.tables to introduce joining.


xdf <- data.table(mykey = c("1", "2", "3"),
                  x_val = c("x1", "x2", "x3"))
xdf
class(xdf)

ydf <- data.table(mykey = c("1", "2", "4"),
                  y_val = c("y1", "y2", "y3"))

ydf
class(ydf)

# Use the merge() function for all joining in data.table.

## Inner Join:-------------

# data.table way
merge(xdf, ydf, by = "mykey")

# equivalent tidyverse way
inner_join(xdf, ydf, by = "mykey")

## Outer Joins (Left, Right, Full)-----------

# Left Join
# data.table way
merge(xdf, ydf, by = "mykey", all.x = TRUE)  # merge() from {data.table}

# equivalent tidyverse way
left_join(xdf, ydf, by = "mykey")

# Right Join

# data.table way
merge(xdf, ydf, by = "mykey", all.y = TRUE)

# equivalent tidyverse way
right_join(xdf, ydf, by = "mykey")


# Full Join

# data.table way
merge(xdf, ydf, by = "mykey", all.x = TRUE, all.y = TRUE)

# equivalent tidyverse way
full_join(xdf, ydf, by = "mykey")


# Binding-------------
## Binding Rows:-------------------
  
# data.table way
rbind(xdf, ydf, fill = TRUE)

# equivalent tidyverse way
bind_rows(xdf, ydf)

## Binding Columns:-------------
# data.table way
cbind(xdf, ydf)  # It will use recycling if one row is multiple of the other

# equivalent tidyverse way

bind_cols(xdf, ydf)  # Row sizes must be the same

# Change the type of column and rename

# data.table

cbind(xdf, ydf) ->
  bct
bct
glimpse(bct)

bct[, mykey := as.numeric(mykey)]
setnames(bct, "mykey", "mk1")
str(bct)

# you may do this again because we have two columns with the same name
bct[, mykey := as.numeric(mykey)]
setnames(bct, "mykey", "mk2")
str(bct)


# Or wecan do it one step
setnames(xdf, old = "mykey", new = "mk1") 

setnames(ydf, old = "mykey", new = "mk2") 

cbind(xdf, ydf) ->
  bct_n
glimpse(bct_n)


# Now we want to have them as the numerical value and give them a new name
bct_n[, c("k1", "k2") := .(as.numeric(mk1), as.numeric(mk2))]
str(bct_n)



# Remove mk1 and mk2 columns

bct_n[, !c(1, 3)]->
  bct_n
glimpse(bct_n)

# Rearrange

bct_n[, c(3, 1, 4, 2)]

## Let's see if can do it better
xdf <- data.table(mykey = c("1", "2", "3"),
                  x_val = c("x1", "x2", "x3"))


ydf <- data.table(mykey = c("1", "2", "4"),
                  y_val = c("y1", "y2", "y3"))

setnames(xdf, old = "mykey", new = "mk1") 

setnames(ydf, old = "mykey", new = "mk2") 

cbind(xdf, ydf) ->
  new
new

new[, c("k1", "k2") := .(as.numeric(mk1), as.numeric(mk2))][,!c(1,3)][,c(3,1,4,2)] ->
  new

glimpse(new)

# tidyverse way

xdf <- data.table(mykey = c("1", "2", "3"),
                  x_val = c("x1", "x2", "x3"))


ydf <- data.table(mykey = c("1", "2", "4"),
                  y_val = c("y1", "y2", "y3"))

bind_cols(tibble(xdf), tibble(ydf)) ->
  bc
bc   # We get different name we each key


# We want to change the name and also change their type to numeric
bc |> 
  mutate(mk1 = as.numeric(mykey...1), mk2 = as.numeric(mykey...3)) |> 
  select(c(-1, -3)) |> 
  relocate(c(3, 1, 4, 2))


q()
y
