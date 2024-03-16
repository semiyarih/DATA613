##              ##             ##  
##              ##             ##  
##    Create a drop down       ## 
##    menu to select colors    ##
##            ShinyApp         ##  
##              ##             ##  
##              ##             ##  

# Install and load shiny
# install.packages("shiny")
# install.packages("shinyWidgets")
library(shinyWidgets)
library(shiny)
library(tidyverse)
library(babynames)

# Basic Shiny App -----
ui <- fluidPage(textInput(inputId = "name",
                            label = "Baby Names:",
                          value = "",
                            placeholder = "Arya"),
                sliderInput(inputId = "year",
                            label = "Year",
                            max = max(babynames$year),
                            min = min(babynames$year),
                            value = c(min(babynames$year),
                                      max(babynames$year)),
                            step = 1
                            ),
                radioButtons(inputId = "sex",
                             label = "Gendre",
                             choices = c(Boy = "M", 
                                         Girl = "F")),
                submitButton("Submit"),
                plotOutput(outputId = "plot"),
                tableOutput(outputId = "babys")
               
  
)
server <- function(input, output,session) {
  output$plot <- renderPlot(
    
    babynames %>% 
      filter(name == input$name,
             sex == input$sex) %>% 
      ggplot(aes(x = year,
                 y = n)) +
      geom_line()
  )
  output$babys <- renderTable({
    babynames %>% 
      filter(name == input$name,
             sex == input$sex) %>% 
      select( year, prop)
         })
}
shinyApp(ui, server)
