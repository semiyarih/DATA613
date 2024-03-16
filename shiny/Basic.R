##              ##             ##  
##              ##             ##  
##    Basic  ShinyApp          ## 
##              ##             ##  
##              ##             ##  

                # This is the simplest app. Click on `Run App` button (at the top of the editor) 
                # and you see a blank webpage.

# Install and load shiny
# install.packages("shiny")
library(shiny)

# Basic Shiny App -----
ui <- fluidPage(
  
)
server <- function(input, output) {
}
shinyApp(ui, server)
