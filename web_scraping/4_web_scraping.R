##_____________________________###
#                                #
#  Web Scrapping_A                #
#                                #
##_____________________________###

# Web Scraping with {rvest}-------------------------------

# We want to scrape one page from IMDB top 100 movies of all time.
#  You need to instal _____selectorgadget chrome extension________

# It gives you the CSS tag for different element on web pages.
# You need that to web scraping element from the webpage.

## HTML (Hypertext Markup Language) ------
# It is a text-based approach to describing how content 
# contained within an HTML file is structured. 
# This markup tells a web browser how to display text,
# images and other forms of multimedia on a webpage.
##_____ Example ______##
#            <p>Hello World</p>

#          HTML cannot be used in a CSS file.
#___________________________________________________________


## CSS (Cascading Style Sheets) -------- 
# Like HTML, CSS is not a programming language.
# It's not a markup language either. CSS is a style sheet
# language. CSS is what you use to selectively style 
# HTML elements.
##_____ Example ______##
#            header{ background-color: green;
#          CSS can be used in an HTML file.
##___________________________________________________________

### What is difference between HTML and CSS?-----
# HTML is a markup language used to create static web pages
# and web applications. CSS is a style sheet language
# responsible for the presentation of documents written
# in a markup language.


# Install and load the packages
# rvest for scraping and dplyr for piping

  if (!require("pacman")) install.packages("pacman")

# Load contributed packages with pacman
pacman::p_load(rvest, dplyr, tidyverse, xml2)



#_________________NOTE__________________
#_________________NOTE__________________

# rvest 1.0.0 renamed a number of functions
# 
# xml_node() & html_node() -> html_element()

# xml_nodes() & html_nodes() -> html_elements()

##__________________________________
##__________________________________
##__________________________________

# SCRAPE From One Page ------------------------------------

# Now we are going to make a new variable for the link

link <- "https://www.imdb.com/list/ls055592025/"

page <- read_html(link)  # it gets HTML code from web page
page

# Let us scrape "name",  "rating", "synopsis", and the "cast"

#          Create the columns
#__________________ 1.  NAME ________________________________________
# First create the name- Which is the title of the movie



#__________________________________________
# You need the tag for the title
     # here is where the "selectorgadget" becomes useful
                    # click on the selector gadget icon on top of page (IMBD.com)
                    # now if you move moues around on the window,
#                   # you will see different boxes start to select/highlite
#                   # we select a title. By clicking on it. It will be turn green
                    #You'll see a lot of thing s turnyellow
#                   # Since we only want the title then we deselect the one that we don't need 
#                   # by clicking on it. Then it turns out red

#                   # Then you will see all titles on that page is yellow. 
#                   # You need to check each time to make sure what you need is selected

#                   # we know there are 100 movies on this webpage. If you look at the bottom of
                    # the apge you see on the box on bottom it says
                    #  '.lister-item-header a.`  `clear(100)`  which indicates it has selected 100 titles

#                   # The tag that we are looking for is on the first thing at bottom of the page
#                   # You need to copy the tag
                    #       .lister-item-header a
                    # paste it inside the html_nodes()

name <- page %>%    # create the column. pass the page inside the nodes and the second
  html_elements(".lister-item-header a")       # argument is the tag for the title

name

# html_node() ---> select parts of the documents using CSS selectors. This will give
# the HTML source code pull out the actual elements that we want to grab
#________________________________

name <- page %>%    
  html_elements(".lister-item-header a") %>%        
    html_text2()

name

# html_text() ---> we need it because there is line tags for the movies . for example around
# the names of movies so HTML text actually 
#      PARSE the text from within those tags
#________________________________________ Now we are done with first column

#__________________ 2.  Rate ________________________________________
# The process is very similar to the first one

rate <- page %>%    
  html_elements(".ipl-rating-star.small .ipl-rating-star__rating")
rate

rate %>%       
  html_text2() ->
  rate
rate

#__________________ 3.  Year _______________________________________
#

year <- page %>%    
  html_elements(".text-muted.unbold") %>%   # Clear the selection gadget now select year   
  html_text2()

year  # it has three strings at the beginning so we need to remove it!




year <- year[4:103]  
year

#__________________ 4.  Synopsis ________________________________________
# What is movie Synopsis? A film synopsis is typically a one-page document that summarizes your film. 

# Clear the selection gadget now select Synopsis  
      # Note: You may see there is less than 100 selection. Then you need to scroll down and click on the
            # those ones that are not selected

synopsis <- page %>%    
  html_elements(".ipl-rating-widget+ p , .ratings-metascore+ p") %>%     
  html_text()

synopsis



# Now we are going to create  the data frame

movies <- data.frame(name, year, rate, synopsis)
View(movies)
head(movies)

# Or a tibble
 t_movies <- tibble(name, year, rate, synopsis)
        
View(t_movies)
head(t_movies)

## All Steps in One attempt-------------------------

#_____________________ EVERYTHING TO GATHER______________

link <- "https://www.imdb.com/list/ls055592025/"
page <- read_html(link)
name <- page %>% html_nodes(".lister-item-header a") %>% 
  html_text()

year <- page %>%    
  html_nodes(".text-muted.unbold") %>%
  html_text() 

year[-c(1:3)] -> year
year


rate <- page %>% html_nodes(".ipl-rating-star.small .ipl-rating-star__rating") %>%
  html_text()

synopsis <- page %>% html_nodes(".ipl-rating-widget+ p , .ratings-metascore+ p") %>%     
  html_text()

top_movies <- tibble(name, year, rate, synopsis)

View(top_movies)
head(top_movies)

# Save the file
write.csv(top_movies, "top_movies.csv")



