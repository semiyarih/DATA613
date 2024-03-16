##         ##         ##         ##         ##          ##
##     Most Basic shiny app with Layout                 ##
##                                                      ##
##                                                      ##
##         ##         ##         ##         ##          ##



# titlePanel and sidebarLayout are the two most popular elements 
# to add to fluidPage. They create a basic Shiny app with a sidebar.

# sidebarLayout always takes two arguments:

# sidebarPanel function output

# mainPanel function output

# These functions place content in either the sidebar or the main 
#panels.

# The sidebar panel will appear on the left side of your app by 
# default. You can move it to the right side by giving
# sidebarLayout the optional argument position = "right".

ui <- fluidPage(
  titlePanel("title panel"),
  
  sidebarLayout(position = "right",
                sidebarPanel("sidebar panel"),
                mainPanel("main panel")
  )
)
