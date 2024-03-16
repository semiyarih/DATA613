##         ##         ##         ##         ##          ##
##    Basic shiny app with Layout                       ##
#       Shiny's HTML Tag                                ##
##                        Part 2                        ##
##         ##         ##         ##         ##          ##

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
              br(),
              a("shiny app link",  href="https://shiny.rstudio.com/")
              )
    )
  )
server <- function(input, output){
  
}
shinyApp(ui, server)