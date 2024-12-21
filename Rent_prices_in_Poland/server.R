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
library(shinyBS)

# Define server logic ----
server <- function(input, output) {
  
  #Model wird bei jedem öffnen der App geladen
  modell_linear <- readRDS("C:/Users/peter/THD/3_Semester/Assistenzsysteme/Projekt_Bauer/Rent_prices_in_Poland/modell_linear.rds")
  
  #Die Berechnung des prognostizierten Preises
  price_prediction <- eventReactive(input$action_search, {
    
    feature_city <- tolower(as.character(input$input_city))  
    feature_sqm <- as.numeric(input$input_squaremeters)
    feature_rooms <- as.integer(input$input_rooms)
    feature_school <- as.numeric(input$input_school)
    feature_floor <- as.integer(input$input_floor)
    feature_buildyear <- as.integer(input$input_buildyear)
    feature_centrum <- as.numeric(input$input_centrum)
    feature_hasParkingSpace <- ifelse(input$parking_space, "yes", "no")
    feature_hasBalcony <- ifelse(input$balcony, "yes", "no")
    feature_hasElevator <- ifelse(input$elevator, "yes", "no")
    
    # Alle Features in ein Data Frame packen
    model_features <- data.frame(
      city = feature_city,
      squareMeters = feature_sqm,
      rooms = feature_rooms,
      schoolDistance = feature_school,
      floor = feature_floor,
      buildYear = feature_buildyear,
      centreDistance = feature_centrum,
      hasParkingSpace = feature_hasParkingSpace,
      hasBalcony = feature_hasBalcony,
      hasElevator = feature_hasElevator,
      stringsAsFactors = FALSE  # Avoid factor conversion
    )
    
    #Eigentliche Berechnung
    prediction <- predict(modell_linear, newdata = model_features)
    
    if (prediction <= 0){
      return(NA)
    } else {
      return(round(prediction, 2))
    }
    
  })
  
  # Output des prognostizierten Preises
  output$predicted_price <- renderText({
    paste0(price_prediction(), " €")
  })
  
  
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
