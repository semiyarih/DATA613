##         ##         ##         ##         ##          ##
##    Basic shiny app with Layout                       ##
#       Shiny's HTML Tag                                ##
##                        Part 4                        ##
##         ##         ##         ##         ##          ##
#
#

                   # Special Shiny Tags (talk through first)
#
#
library(tidyverse)
library(shiny)
# install.packages("datasets")


# Creating Tabs
ui <- fluidPage(
  titlePanel("My Shiny App"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel(
      # p("p creates a paragraph of text."),
      p("It is not a good idea to take too many classes. An
        undrgraduate student should not take more than five
        classes"),
      br(),  #line break
      # p("A new p() command starts a new paragraph"), 
      p("A freshman should probably not work his or her first
       semester of college"),
      br(),
      # strong("strong() makes bold text."),
      strong("A freshman should probably not work his or her first
       semester of college"),
      br(),
      # em("em() creates italicized (i.e, emphasized) text."),
      br(),
      p(em("A freshman should probably not work his or her first
       semester of college")),
      br(),
      #code("code displays your text similar to computer code"),
      p(code("A freshman should probably not work his or her first
       semester of college")),
      br(),
      # div("div creates segments of text with a similar style. 
      #  We can make the text a color other than black by passing 
      # the argument 'style = color:blue' to div",
      # style = "color:blue"),
      p(div("A freshman should probably not work his or her first
       semester of college", style = "color:blue")),
      br(),
      # p("span does the same thing as div, but it works within",
      #  span("groups of words", style = "color:blue"),
      # "that appear inside a paragraph.")
      span("A freshman should probably not work",style = "color:orange"), 
      "his or her first semester of college.")
    
  )
)



server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)

