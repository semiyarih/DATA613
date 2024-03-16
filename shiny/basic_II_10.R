##         ##         ##         ##         ##          ##
##    Basic shiny app with Layout                       ##
#                                                       ##
##                        Part 10                        ##
##                                         ##
##         ##         ##         ##         ##          ##
#
#


#
#
library(tidyverse)
library(shiny)
# install.packages("datasets")

ui <- fluidPage(
  h2("Putting things together", style = "color:red"),
  h5("Plots from the mtcars data table" , style = "color:blue"),
  selectInput("var1", "Variable 1", choices = names(mtcars)),
  selectInput("var2", "Variable 2", choices = names(mtcars)),
  
  mainPanel(
    plotOutput(outputId = "Scatterplot"),
    plotOutput(outputId = "Histogramplotvar1"),
    plotOutput(outputId = "Histogramplotvar2")
  )
)
server <- function(input, output) {
  output$Scatterplot <- renderPlot({
    ggplot(mtcars, aes(x = .data[[input$var1]], y = .data[[input$var2]])) +
      geom_point(color = "blue") +
      geom_smooth(method = lm, color = "red", se = FALSE) +
      ggtitle("Mtcars Scatter Plot")
  })
  
  output$Histogramplotvar1 <- renderPlot({
    ggplot(mtcars, aes(x = .data[[input$var1]])) +
      geom_histogram(fill = "red")
  })
  
  
  output$Histogramplotvar2 <- renderPlot({
    ggplot(mtcars, aes(x = .data[[input$var2]])) +
      geom_histogram(fill = "blue")
  })
  
}

shinyApp(ui = ui, server = server)



