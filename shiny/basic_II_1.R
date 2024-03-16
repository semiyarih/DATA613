##         ##         ##         ##         ##          ##
##   Basic shiny app with Layout                        ##
##     Shiny's HTML Tag                                 ##
##                        Part 1                        ##
##                                                      ##
##         ##         ##         ##         ##          ##



# To add more advanced content, use one of Shiny's HTML tag 
# functions.

#shiny function 	HTML5 equivalent 	creates
#p 	  <p> 	A paragraph of text
#h1 	<h1> 	A first level header
#h2 	<h2> 	A second level header
#h3 	<h3> 	A third level header
#h4 	<h4> 	A fourth level header
#h5 	<h5> 	A fifth level header
#h6 	<h6> 	A sixth level header
#a 	  <a> 	A hyper link
#br 	<br> 	A line break (e.g. a blank line)
#div 	<div> 	A division of text with a uniform style
#span <span> 	An in-line division of text with a uniform style
#pre 	<pre> 	Text 'as is' in a fixed width font
#code <code> 	A formatted block of code
#img 	<img> 	An image
#strong <strong> 	Bold text
#em 	<em> 	Italicized text
#HTML 	  	Directly passes a character string as HTML code


# Headers






library(tidyverse)
library(shiny)
# install.packages("datasets")

# Building a user interface /Layout Components

ui <- fluidPage(
  titlePanel("TITLE PANEL"),
  
  sidebarLayout(
    sidebarPanel("sidebar panel"),
    mainPanel("main panel",
              h1("First level title"),
              h2("Second level title"),
              h3("Third level title"),
              h4("Fourth level title"),
              h5("Fifth level title"),
              h6("Sixth level title"),
              a("https://shiny.rstudio.com/"),
              )
    )
  )
server <- function(input, output){
  
}
shinyApp(ui, server)