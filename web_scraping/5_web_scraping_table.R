#______________________________#

# table web scraping

#______________________________#


 # Source  https://github.com/abhimotgi

if (!require("pacman")) install.packages("pacman")


# Load contributed packages with pacman
pacman::p_load(rvest, dplyr, tidyverse, ggplot2, readr)

  
# Short cut for %>% is 
      # Window: ctrl + shift + M
      # Mac: : cmd + shift + M




link <- "https://www.cargurus.com/Cars/price-trends/"
page <- read_html(link)

# Recall from 4_web_scraping.r-------------
# gadget selector

cars <- page |> 
  html_elements("._8kuES .mZMMg") |> 
  html_text2()
cars


price_increase <- page |> 
  html_elements("._8kuES .tmRG2") |> 
  html_text2()


car_m <- tibble(cars, price_increase)

car_market <- tibble(cars, price_increase = parse_number(price_increase))
 car_market


 ##  PROCESS IN DETAILS--------------------------------------------
# First Example -----------------------------
## Average sales price from CARGURUS

# let us show How to find a table in a webpage.

# The typical way is to go and find the table that you want.

# Right click on it (on google chrome) and the and then a source code will be open
# you hover over the page to find out the name of the table to pass it to R. So
# R knows what table you are looking for.



car_link <- "https://www.cargurus.com/Cars/price-trends/"
page <- read_html(car_link)

car_table <- page %>% html_elements("table")


# When you put "table" in nodes function. It looks for all tables in this page.

car_table

# If you look at the console, you will see there is only one table is in this page
# and this is what we want.Or you may use
length(car_table)

# So you tell RVEST that you want the only table

car_table <- page %>% html_elements("table") %>% .[1]  # .[1]



# Now you need to get the table. So we use 
#     html_table

car_table <- car_table %>% 
  html_table(fill = TRUE)     # If you get an error on inconsistent number of columns
                            # use the argument -- fill=TRUE -- says
                              #   missing cells in tables are now always 
                              # automatically filled with NA.

class(car_table)  # This is a list 

View(car_table)
# If you look at the result, it comes in list object ( a list inside the table) and you
# want to access inside the first object in the list [[1]]



car_table <- car_table %>% 
  .[[1]]

View(car_table)



### ALTERNATIVE APPROACH TO GET Inside of the list ------
# You can Get to inside the list as follow
#  

car_table <- page %>% html_elements("table") %>% .[1]  %>% 
  html_table(fill = TRUE) 

#     fill = TRUE  says
#   missing cells in tables are now always automatically filled with NA.

class(car_table )
car_table_alt <- car_table[[1]]

View(car_table_alt)

#___________________________________________________________
## Example 1 - Revisited ------

car_link <- "https://www.cargurus.com/Cars/price-trends/"
page <- read_html(car_link) 

page %>%
  html_table(fill = TRUE) ->
  car_t
length(car_t) # Only one object
class(car_t)  # It is a list

car_t[[1]] |> 
  View()

# or

car_t %>% 
  .[[1]] ->
  car_table

nrow(car_table)

head(car_table, 20) # If you look at the table you see we have to 
                    # remove row 2 and 13
car_table[c(2,13),]


# We want to remove these rows
car_table[-c(2,13),] ->
  car_table

View(car_table)

nrow(car_table)  # Number of rows reduced from 61 to 59!


names(car_table)

### Columns are characters----
# We use `clean_names` from {janitor} package. 
# It will change the name  so names are unique and consist only of the _ character, numbers, and letters. 

          # Install and load
# install.packages("janitor")
library(janitor)
car_table <- car_table %>% 
  clean_names()   # from {janitor}

names(car_table) # You can see the name has changed after using clean_names() from {janitor}
      #year_over_year is stands for Year over Year percent change
      # in the total number of auto

# Still column are character, so we want to parse them.
# We use mutate

glimpse(car_table)

# What is the class of avg_price
class(car_table$avg_price)

car_table %>% 
  mutate(avg_price = parse_number(avg_price)) ->
  car_table

class(car_table$avg_price)

# We would like to change for the rest

car_table %>% 
  mutate(last_30_days = parse_number(last_30_days),
         last_90_days = parse_number(last_90_days),
         year_over_year = parse_number(year_over_year)) ->
  car_table

head(car_table)

# If we want to arrange them in descending order in `avg_price`

car_table %>% 
  arrange(desc(avg_price)) ->
  car_table
View(car_table)

car_table %>% 
  ggplot(aes(x = make_style, y = avg_price)) +
  geom_bar(stat = "identity") ->   # If you want the heights of the bars
  plt                                # to represent values in the data
  
plt                            

# We can do coordinate flip
plt +
coord_flip()


#___________________________________________________________


#___________________________________________________________
# Example 2 - From WIKIPEDIA---------------------------------------------------
# State and territory rankings

# Step 1:
elec_link <- "https://en.wikipedia.org/wiki/List_of_U.S._states_and_territories_by_population"
elec_link

# Read the page
elec_page <- read_html(elec_link)
elec_page

# Get the tables
 elec_page %>% html_elements("table")
 
# How many tables are there?
 elec_page %>% html_elements("table") |> 
   length()

# We are interested in the first table
 elec_page %>% html_nodes("table") %>% .[1]
 
 
 # Let's get the table
 elec_page %>% html_nodes("table") %>% .[1] %>%    
   html_table(fill = TRUE) |> 
   View()
 
 
 elec_page %>% html_nodes("table") %>% .[1] %>%    
   html_table(fill = TRUE) %>% .[[1]] ->
   elec_table
 
 elec_table |> 
   View()
 # The name of columns and the first row both together make
 # The actual the columns name
 names(elec_table)
 # First Row
 head(elec_table, n=1)
 
 # We can't directly use the clean name to change the name. Because the names and the first row contains the name.
 elec_table %>% 
   clean_names()
 # Thus we have to do as follow
 
 # Step 1. I put both column name and Row 1 together
 
 # Let vector h contains the color names
 names(elec_table) ->h
 h
 # The first row can be selected by
 elec_table[1, ]
 
 # Now bind these togther
 names(elec_table) <- rbind(h, elec_table[1, ])
 
 # Step 2. used clean_name() from {janitor} package
 elec_table %>% 
   clean_names() ->
   elec_table
 
 elec_table |> 
   names()

 
 # As you can see we have to remove c_. Use rename_all() from {dplyr}
 
 elec_table <- elec_table %>% 
   rename_all(~str_remove(., "^c_"))
 
 names(elec_table)   # prefix "c_" has been removed
 
 elec_table |> 
   head()
 
 # Now we have to remove the first row
 elec_table <- elec_table[-1,]  # First row has been removed
 
 head(elec_table)
 
 # Some Row contains  __ instead of NA
View(elec_table)

# Now we need to replace __ with NA
elec_table %>% mutate_all(~na_if(., "—")) ->
  elec_table 

# The next step is to fix the class of all columns
# All columns must be numeric except the first on which should stay as character.
View(elec_table)

elec_table %>%
  mutate_if(!names(.) %in% "state_or_territory_state_or_territory", parse_number) ->
  elec_table_2  # it checks if the name of column is not "state_or_territory_state_or_territory"
head(elec_table_2)    # Then it will be parse to number 


# There are few columns that their name needs to be replaced
names(elec_table_2)



elec_table_2 %>% 
  rename("state_or_territory" = "state_or_territory_state_or_territory",
         "pop_perseat_2020_a" = "pop_perseat_2020_a_pop_perseat_2020_a",
         "percent_ec_2020" = "percent_ec_2020_percent_ec_2020",
         "pop_perelec_vote_2020_c" = "pop_perelec_vote_2020_c_pop_perelec_vote_2020_c", 
         "percent_us_2020"  = "percent_us_2020_percent_us_2020"  
  ) ->
  elec_table

names(elec_table)

View(elec_table)


## Example 2 (revisited) - From WIKIPEDIA ------------------------------------------------
    # This work can also be found on `table_web_scraping.QMD
# Electoral Collage
 ### Finding Table by XPATH ---------- 
 # Step 1: Go to the webpage: https://en.wikipedia.org/wiki/List_of_U.S._states_and_territories_by_population
 # Step 2: Find the table that you are interested in and right click on it
 # Step 3: Select "inspect Element"
 # Step 4: On the source code move cursor until you see the table is blue
 # Step 5: right click, select "Copy" and then select "Copy XPath". This is what you need


wiki_link <- "https://en.wikipedia.org/wiki/List_of_U.S._states_and_territories_by_population"
wiki_page <- read_html(wiki_link)

elec_table_alt <- wiki_page %>% 
  html_elements(xpath = '//*[@id="mw-content-text"]/div[1]/table[1]')   #Remember you need to tell R
                                                                # where to find 
                                                                 # Open source code. 
                                                                # Move cursor to inspect the table 
                                                           # You may find something like <table  clas = "    ">
                                                                # Right click > Cop > XPath
elec_table_alt <- elec_table_alt %>%
  
  html_table(fill = TRUE)%>% .[[1]]  # .[[1]]  tells get the first object in the list

View(elec_table_alt)


#####   ALL in One Step

wiki_link <- "https://en.wikipedia.org/wiki/List_of_U.S._states_and_territories_by_population"
wiki_page <- read_html(wiki_link)

elec_table_alt <- wiki_page %>% html_elements(xpath = '//*[@id="mw-content-text"]/div[1]/table[1]')

elec_table_alt <- elec_table_alt %>%
  
  html_table(fill = TRUE)%>% .[[1]]  # .[[1]]  tells get the first object in the list

View(elec_table_alt)








