##              ##             ##  
##              ##             ##  
##    Create a drop down       ## 
##    menu to select colors    ##
##            ShinyApp         ##  
##              ##             ##  
##              ##             ##  

# Install and load shiny
# install.packages("shiny")
library(shiny)

# Basic Shiny App -----
ui <- fluidPage(selectInput(inputId = "color",
                            label = "Color:",
                            choices = c("Red", "Yellow", "Green", "Blue")),
                sidebarPanel(                  # use mainPanel() instead of sidebarPanel
                  plotOutput("color_plot")
                )
  
)
server <- function(input, output) {
  output$color_plot <- renderPlot({
    plot(1:100, col = input$color
         )})
}
shinyApp(ui, server)
