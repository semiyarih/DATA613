##         ##         ##         ##         ##          ##
##    Basic shiny app with Layout                       ##
#       Shiny's HTML Tag                                ##
##                        Part 3                        ##
##         ##         ##         ##         ##          ##

library(tidyverse)
library(shiny)
install.packages("datasets")

# Building a user interface /Layout Components

ui <- fluidPage(
  titlePanel("My Shiny App"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel(
      h1("First level title", align = "center", style = "color:red"),
      h2("Second level title", align = "right", style = "color:blue"),
      h3("Third level title", align = "center"),
      h4("Fourth level title", align = "center"),
      h5("Fifth level title", align = "center"),
      h6("Sixth level title", align = "left"),
      a("https://shiny.rstudio.com/"),
      br(),
      a("shiny app link",  href="https://shiny.rstudio.com/")
    )
  )
)

server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)

