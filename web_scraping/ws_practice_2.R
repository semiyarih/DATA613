 # Supplement to "webscraping_3.pdf" 
# 
#________________________________________________________

pacman::p_load(pacman, rvest, tidyverse)

#_____________________________________________
# Web page Structure -----------
## HTML, Hyper Text Markup Language----------------
## One focus on the appearance and format of the page called HTML
## It tells the browser how to display the content.
## It uses 
###  1. “tags” -----
## to tell the browser how to display content.
##      <tagname>Content goes here</tagname>

###  2. Attributes:------
## Attributes are written inside the opening tag. They are written as attribute="value".
##            <tagname attribute="value">Content goes here</tagname>

###  3. Content:------
## The content is the text or elements between the opening and closing tags. 
## This is what will be displayed on the webpage.
## For instance, in
##           <p>Hello World</p>, 
## “Hello World” is the content.

###  4. Element:------
## An element is a complete structure that includesboth the opening tag, 
## the content, and the closing tag. 
## For example, 
##              <p>Hello World</p> 
## is a paragraph element.

## Necessary Tags:-----------------
### 1. <html>  -------
## It tells the tart and end of html document

### 2. <head> -------
## where you put important information about the document

### 3. <title> ------
## The title tag (inside <head>) defines the title shown in the browser tab.

### 4. <body> ------
## This tag is where all the content that you want to display on the webpage goes

## XML  -------------------------
## The other one Called XML similar to HTML but focus more on managing data in web.




# Webscraping ------
## read_html()-----
#Use read_html() to read the HTML for that page into R. 


html <- read_html("https://rvest.tidyverse.org/articles/starwars.html")

print(html)

# This returns an xml_document object which you’ll then manipulate using {rvest} functions.
html %>% 
  class()


### Example:-----
# The function minimal_html() from {rvest}
## Creates an HTML document from inline HTML

html <- minimal_html("
<h1>This is a heading</h1>
<p id='first'>This is a paragraph</p>
<p class='important'>
This is an important paragraph</p>
")

print(html)

class(html)

##               Here three most important  ---------

## 1. p -------
## It selects all
html %>% 
  html_element("p")

html %>% 
  html_elements("p")   # it finds all elements that match the selector

# Note: 
# Let us use the selector `a` that does not match any element

html %>% 
  html_element("a") #html_element() returns a missing value.


html %>% 
  html_elements("a") # html_elements() returns a vector of length 0

## 2. `.title` -------------
## It selects all elements with class “title”.

# .important selects all elements with `class` “important”
html |> html_elements(".important")


## 3. `#title` -----------------
## It selects the element with the id attribute that equals “title” 
#The first selects the element with the `id` attribute
# that equals “first”.
html |> html_element("#first")

###  Nesting selections ------
###We are using html_elements() to identify elements that will become observations then 
## using html_element() to find elements that will become variables.

### Example:----
html <- minimal_html("
<ul>
<li><b>C-3PO</b> is a <i>droid</i>
that weighs <span class='weight'>167 kg</span></li>
<li><b>R4-P17</b> is a <i>droid</i></li>
<li><b>R2-D2</b> is a <i>droid</i>
that weighs <span class='weight'>96 kg</span></li>
<li><b>Yoda</b> weighs <span class='weight'>
66 kg</span></li>
</ul>
")

class(html)

# We can use html_elements() to make a vector 
# where each element corresponds to a different character:
html %>% 
  html_elements("li") -> character
character
# There are 4 characters `C-3PO`, `R4-P17`, `R2-D2`, and `Yoda`



html %>% 
  html_element("li") 
# Note: The first element is:
#
#               <li><b>C-3PO</b> is a <i>droid</i>
#        that weighs <span class='weight'>167 kg</span></li>
#
# The name of each character is
# 1.    <b>C-3PO</b>  
# 2.    <i>droid</i>  
# 3.    <span class='weight'>167 kg</span>


#____________________

class(character)
# To extract the name of each character, we use html_element()
# Note: The tag for te name is <b>
character %>% 
  html_element("b")

# we get the same thing if we use html_elements()
character %>% 
  html_elements("b")

# Why both returns the samething?
# When you use html_element("b") on that list, it applies to each <li> node,
# returning the first <b> from each — and 
# each <li> has one <b>, so you get 4 elements.

# So when there's only one match, both give the same output — 
# but html_elements() is more general.

## 2. `.title`---- `.weight` -------------
character
# We want to get one weight for each character, 
# even if there’s no weight <span>.
character %>% 
  html_element(".weight")  


# html_elements() finds all weight s that are children of characters. 
# There’s only three of these, so we lose the connection between names and weights:
character %>% 
  html_elements(".weight")




#______________________________________________________________

## HTML TEXT -----
### html_text2() ------
## It extracts the plain text contents of an HTML element:

character %>%  
  html_element("b") %>%  
  html_text2() -> name
name


# (i)
character %>%  
  html_element(".weight") %>%  
  html_text2() -> weight
weight

# Can you explain the difference between (i) and (ii)?

# (ii)
character %>%  
  html_elements(".weight") %>%  
  html_text2() -> weights
weights
#_________________weights()#___________________
# Create a table for name and weight

tibble(name, weight)

##  HTML ATTRIBUTE ---------------
# html_attr() extracts data from attributes:
  
  html <- minimal_html("
  <p><a href='https://en.wikipedia.org/wiki/Cat'>cats</a></p>
  <p><a href='https://en.wikipedia.org/wiki/Dog'>dogs</a></p>
")
html


html |> 
  html_elements("p") # returns paragraphs

html |> 
  html_elements("a")   # returns links

# html_attr() always returns a string, 
# so if you’re extracting numbers or dates, 
# you’ll need to do some post-processing.

html |> 
  html_elements("p") |>
  html_element("a") |> 
  html_attr("href")

# Or
html |> 
  html_elements("a") |> 
  html_attr("href")


## HTML TABLES -------------
## html_table()
## HTML tables are built up from four main elements: 
## <table>, 
## <tr> (table row), 
## <th> (table heading), and 
## <td> (table data). 
## Here’s a simple HTML table with two columns and three rows:

html <- minimal_html("
                     <table class='mytable'>
                     <tr><th>x</th>   <th>y</th></tr>
                     <tr><td>1.5</td> <td>2.7</td></tr>
                     <tr><td>4.9</td> <td>1.3</td></tr>
                     <tr><td>7.2</td> <td>8.1</td></tr>
                     </table>
                     ")
html


# the selector for class here is `.mytables`
html |> 
  html_element(".mytable") 

# Thus
html |> 
  html_element(".mytable") |> 
  html_table()

# The column x and y usually convert to numerical but it DOES NOT always work.
# Thus we want to turn this conversion off and do the conversion manually.

html |> 
  html_element(".mytable") |> 
  html_table(convert = FALSE)

# Then we use mutate function to parse it

html %>%  
  html_element(".mytable") %>%  
  html_table(convert = FALSE) %>% 
  mutate(x = parse_double(x), y = parse_double(y))


