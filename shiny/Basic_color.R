
library(shiny)
library(htmltools)

ui <- fluidPage(
  selectInput("color", "Choose a color:", choices = c("green", "white", "red", "Iran" )),
  headerPanel("Iranian Flag"),
  uiOutput("color_description"),
  actionButton(inputId = "show_image", label = "Show Image"),
  mainPanel(
  imageOutput("Iranianflag")
  )
)

server <- function(input, output) {
  output$color_description <- renderUI({
    description <- switch(input$color,
                          "red" = "This color is associated with fire and passion.",
                          "white" = "This color is associated with honesty and purity.",
                          "green" = "This color is associated with nature and growth.",
                          "Iran" = "Iranian flag is a tricolour of green, white, and red, with a lion, sun and a beautiful crown emblem in the middle")
    p(description)
  })
  observeEvent(input$show_image, {
  output$Iranianflag <- renderImage({
    list(src = "./Iranianflag.png", contentType = "image/png")
  }, deleteFile = FALSE)
  })
}

shinyApp(ui, server)
