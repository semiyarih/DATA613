##         ##         ##         ##         ##          ##
##    Basic shiny app with Layout                       ##
#                                                       ##
##                        Part 5    
##                      Reactivity 1                    ##
##         ##         ##         ##         ##          ##
#
#

          # use h2 to increase the font of the first example
# Reactivity shiny app 1 (coding forces output changes for given
# inputs)

#
#
library(tidyverse)
library(shiny)
#install.packages("datasets")

ui <- fluidPage(
  titlePanel("Name Greetings"),
  textInput("name", "What's your name?"),
  textOutput("greeting")
)

server <- function(input, output, session) {
  output$greeting <- renderText({
    paste("Hello ", input$name, "!")
  })
}

shinyApp(ui = ui, server = server)



