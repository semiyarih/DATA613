##         ##         ##         ##         ##          ##
##    Basic shiny app with Layout                       ##
#                                                       ##
##                        Part 15                        ##
##                                         ##
##         ##         ##         ##         ##          ##
#                 # Creating Tabs
#


#
#
library(tidyverse)
library(shiny)
# install.packages("datasets")
# uniform color change in the background

# install.packages("shinyWidgets")
library(shinyWidgets)

# Creating Tabs
X <- rnorm(50, 2, .5)
Y <- rnorm(50, 5, 1)
Z <- rnorm(50, 1.5, .75)

data.frame(X,Y,Z) -> DF
DF

ui <- fluidPage(
  titlePanel("DF Histograms"),
  sidebarLayout(
    sidebarPanel(
      selectInput("vars", "DF variables", 
                  choices = names(DF)),
      
    ),
    
    mainPanel(
      tabsetPanel(type = "tab",
                  tabPanel("Plot1", plotOutput("plot1")),
                  tabPanel("Plot2", plotOutput("plot2")),
                  tabPanel("Plot3", plotOutput("plot3")),
                  tabPanel("Summary" , verbatimTextOutput("summ")),
                  tabPanel("Table", tableOutput("DF"))
                  
      )
    )
  )
)

server <- function(input, output) {
  output$plot1 <- renderPlot({
    ggplot(DF, aes(x = .data[[input$vars]])) +
      geom_histogram(fill = "purple") +
      ggtitle("DF HISTOGRAMS")
    
  })
  
  output$plot2 <- renderPlot({
    ggplot(DF, aes(x = .data[[input$vars]])) +
      geom_boxplot(fill = "yellow") +
      ggtitle("DF BOXPLOT YELLOW")
    
  })
  
  output$plot3 <- renderPlot({
    ggplot(DF, aes(y = .data[[input$vars]])) +
      geom_boxplot(fill = "red") +
      ggtitle("DF BOXPLOT RED")
    
  })
  
  output$summ <- renderPrint({
    
    summary(DF)
  })
  
  output$DF <- renderTable({
    head(DF)
    
  })
}
shinyApp(ui = ui, server = server)





