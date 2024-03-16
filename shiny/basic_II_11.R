##         ##         ##         ##         ##          ##
##    Basic shiny app with Layout                       ##
#                                                       ##
##                        Part 11                        ##
##                                         ##
##         ##         ##         ##         ##          ##
#
#


#
#
library(tidyverse)
library(shiny)
# install.packages("datasets")
# uniform color change in the background
# install.packages("shinyWidgets")
library(shinyWidgets)


ui <- fluidPage(
  tags$h2("Change shiny app background"),
  h4("It is a good idea to alter colors of your backgrounds"),
  setBackgroundColor("lightblue")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)

