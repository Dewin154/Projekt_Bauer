#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(bslib)
library(leaflet)

# Define server logic ----
server <- function(input, output) {
  
  #Der %>%-Operator ist ein Pipe Operator, Output der einen Funktion ist Input für die Andere.
  
  output$mymap <- renderLeaflet(
    leaflet() %>%
      addProviderTiles(
        providers$CartoDB.Positron,
        options = providerTileOptions(noWrap = TRUE)
      ) %>%
      fitBounds(
        lng1 = 14.07, lat1 = 49.00, # Southwest corner of Poland
        lng2 = 24.15, lat2 = 54.83  # Northeast corner of Poland
      )
  )
  #Nur zum testen hier, wie output, cards usw. funktionieren
  output$mymap2 <- renderLeaflet(
    leaflet() %>%
      addProviderTiles(
        providers$CartoDB.Positron,
        options = providerTileOptions(noWrap = TRUE)
      )
  )
  
}
