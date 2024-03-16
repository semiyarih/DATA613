##         ##         ##         ##         ##          ##
##    Basic shiny app with Layout                       ##
#                                                       ##
##                        Part 13                        ##
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
  
  # use a gradient in background
  setBackgroundColor(
    color = c("#F7FBFF", "#2171B5"),
    gradient = "radial",
    direction = c("top", "left")
  ),
  
  titlePanel("Hello Shiny!"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("obs",
                  "Number of observations:",
                  min = 0,
                  max = 1000,
                  value = 500)
    ),
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

server <- function(input, output, session) {
  output$distPlot <- renderPlot({
    hist(rnorm(input$obs))
  })
}

shinyApp(ui, server)


