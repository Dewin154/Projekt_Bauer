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
  
  modell_linear <- readRDS("C:/Users/peter/THD/3_Semester/Assistenzsysteme/Projekt_Bauer/Rent_prices_in_Poland/modell_linear.rds")
  
  price_prediction <- eventReactive(input$action_search, {
    # Process features
    feature_city <- as.factor(input$input_city)
    feature_sqm <- as.numeric(input$input_squaremeters)
    feature_rooms <- as.integer(input$input_rooms)
    feature_school <- as.numeric(input$input_school)
    feature_floor <- as.integer(input$input_floor)
    feature_buildyear <- as.integer(input$input_buildyear)
    feature_centrum <- as.numeric(input$input_centrum)
    
    # Initialize checkbox features
    feature_checkbox <- data.frame(
      hasParkingSpace = "no",
      hasBalcony = "no",
      hasElevator = "no"
    )
    
    # Update checkbox features based on input
    if (!is.null(input$input_checkbox)) {
      for (feature in input$input_checkbox) {
        feature_checkbox[[feature]] <- "yes"
      }
    }
    
    # Combine features into one dataframe
    model_features <- cbind(
      city = tolower(feature_city),
      squareMeters = feature_sqm,
      rooms = feature_rooms,
      schoolDistance = feature_school,
      floor = feature_floor,
      buildYear = feature_buildyear,
      centreDistance = feature_centrum,
      feature_checkbox
    )
    
    # Make prediction using the preloaded model
    prediction <- predict(modell_linear, newdata = model_features)
    return(round(prediction, 2))
  })
  
  # Output predicted price
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
