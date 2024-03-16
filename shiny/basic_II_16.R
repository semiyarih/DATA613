##         ##         ##         ##         ##          ##
##    Basic shiny app with Layout                       ##
#                                                       ##
##                        Part 16                        ##
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



ui <- fluidPage(
  setBackgroundColor("yellow"),
  headerPanel (title = "Shiny Tabset Example"),
  sidebarLayout(
    sidebarPanel(
      selectInput("ngear", "Select the gear number", c("Cylinders" =
                                                         "cyl", "Transmission" = "am", "Gears" = "gear"))
    ),
    
    mainPanel(
      tabsetPanel(type = "tab" ,
                  tabPanel("Data", tableOutput("mtcars")),
                  tabPanel("Summary" , verbatimTextOutput("summ")),
                  tabPanel("Plot", plotOutput("plot"))
                  
      )
    )
    
  )
)



library(shiny)

server <- function(input,output) {
  output$mtcars <- renderTable({
    #mtcars        #[input$ngear]    
    
    # mtcars[ c("mpg", input$ngear)] 
    mtcars[ , input$ngear]
    
  })
  
  output$summ <- renderPrint({
    #summary(mtcars)    #[input$ngear])   
    #summary(mtcars[c("mpg",input$ngear)])
    summary(mtcars[ , input$ngear])
  })
  
  #output$plot <- renderPlot({
  #with(mtcars, boxplot(mpg~gear))
  #boxplot(mpg~input$ngear, data = c(mtcars$cyl,mtcars$am,
  #   mtcars$gear))
  
  output$plot <- renderPlot({
    
    ggplot(mtcars, aes(x = factor(get(input$ngear)), y = mpg)) +
      geom_boxplot() +
      labs(x = input$ngear, y = "Miles per gallon")
  })
}


shinyApp(ui = ui, server = server)



