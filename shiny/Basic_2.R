##              ##             ##  
##              ##             ##  
##    Movies  ShinyApp         ## 
##              ##             ##  
##              ##             ##  

# Install and load shiny
library(shinyWidgets)
library(shiny)
library(tidyverse)
library(ggplot2movies)

# Basic Shiny App -----
ui <- fluidPage(selectInput(inputId = "mpaa",
                            label = "Motion Picture Association of America:",
                            choices = list('General Audience' = '""',
                            Restricted = "R",
                            'Parental Guidance' = "PG",
                            'No one under 17' = "NC-17"
                            )),
                sliderInput(inputId = "year",
                            label = "Year Range:",
                            min = min(movies$year),
                            max = max(movies$year), 
                            value = c(min(movies$year), max(movies$year))
                            , step = 1
                            ),
                submitButton(),
                tableOutput(outputId = "Title")
  
)
server <- function(input, output) {
  output$Title <- renderTable(
    movies %>%
      filter(mpaa == input$mpaa, year == input$year) %>% 
      select(title, Action, Animation, Documentary, Comedy, Romance)
  )
  
}
shinyApp(ui, server)
