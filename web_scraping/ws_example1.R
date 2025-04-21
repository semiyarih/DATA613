  # Exampl1: StarWars

# https://rvest.tidyverse.org/articles/starwars.html

# We’d encourage you to navigate to that page now and 
# use “Inspect Element” to inspect one of the headings 
# that’s the title of a Star Wars movie. 
# While you are on the webpage right click and 
# when menu is open scroll down to bottom of the page and then click “Inspect”

pacman::p_load(pacman, rvest, tidyverse)

# We want to scrap the name of the movies

# STEP 1: READ URL -------

url <- "https://rvest.tidyverse.org/articles/starwars.html"

html <- read_html(url)
html

print(html)

class(html)


# STEP 2: IDENTIFY ELEMENTS

section <- html %>% 
  html_elements("section")

section

# From the section we see:
# 1. The name of the movies wrapped with tag <h2>
section %>% 
  html_elements("h2")

# from the header we need to select the text

section %>% 
  html_elements("h2") %>% 
  html_text()   # it returns the raw text
# We need to use text2

section %>% 
  html_elements("h2") %>% 
  html_text2()


# 2. The Relaese wrapped with tag <p>
section %>% 
  html_element("p") 

# We need the realeased year

section %>% 
  html_element("p") %>% 
  html_text2()

# We need to get the rid off "Realeased:"

section %>% 
  html_element("p") %>% 
  html_text2() %>% 
  str_remove_all("Released: ")


# This is must be of the class date. What is its class

section %>% 
  html_element("p") %>% 
  html_text2() %>% 
  str_remove_all("Released: ") %>% 
  class()


# Thus we need to parse it to date

section %>% 
  html_element("p") %>% 
  html_text2() %>% 
  str_remove_all("Released: ") %>% 
  parse_date()

# What is the class?

section %>% 
  html_element("p") %>% 
  html_text2() %>% 
  str_remove_all("Released: ") %>% 
  parse_date() %>% 
  class()


# The Director of the movie is wrapped by class "director".
# To see that just take a look at the first section
section[[1]]

section |>
  html_element(".director") 

section |>
  html_element(".director") %>% 
  html_text2()





# The synopsis of the movie is wrapped by class "crawl".
# To see that just take a look at the first section
section[[1]]
 



section |>
  html_element(".crawl") 

section |>
  html_element(".crawl") %>% 
  html_text2()


#______ All in one steps and create a table

tibble(
  title = section %>%  
    html_element("h2") %>%  
    html_text2(),
  released = section %>% 
    html_element("p") %>%  
    html_text2() %>%  
    str_remove("Released: ") %>%  
    parse_date(),
  director = section %>%  
    html_element(".director") %>% 
    html_text2(),
  intro = section %>%  
    html_element(".crawl") %>% 
    html_text2()
)
  
