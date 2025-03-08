library(shiny)
runApp("C:/Users/semiyari/Desktop/shiny")


library(rsconnect)
# you can get the following from your shinyapp.io
rsconnect::setAccountInfo(name='k8inxy-hamid-semiyari',
                          token='GET YOURS ',
                          secret='GET YOURS')


rsconnect::deployApp('Use your path')
