library(shiny)
library(bslib)
library(leaflet)
library(shinyBS)

# Define server logic ----
server <- function(input, output) {
  
  # Model wird bei jedem Öffnen der App geladen
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
  modell <- readRDS("modell_log_cleaned.rds")
  
  # Data Frame für die Markers und deren Position auf der Karte und Vorhersagen
  df_city_coords <- data.frame(
    city = c("Warszawa", "Krakow", "Wroclaw", "Lodz", "Poznan", "Katowice", "Gdansk", "Szczecin", "Lublin", "Bydgoszcz", "Rzeszow", "Gdynia", "Bialystok", "Radom", "Czestochowa"),
    Latitude = c(52.237049, 50.049683, 51.107883, 51.759445, 52.409538, 50.270908, 54.372158, 53.428543, 51.246452, 53.123482, 50.041187, 54.51889, 53.13333, 51.40253, 50.79646),
    Longitude = c(21.017532, 19.944544, 17.038538, 19.457216, 16.931992, 19.039993, 18.638306, 14.552812, 22.568445, 18.008438, 21.999121, 18.53188, 23.16433, 21.14714, 19.12409),
    predictions = NA
  )
  
  # Funktion zur Prüfung der richtigen Eingabe
  is_valid_input <- reactive({
    if (as.numeric(input$input_squaremeters) < 25) {
      showNotification(
        "Für korrekte Vorhersage muss die Fläche mindestens 25 Quadratmeter betragen!",
        type = "error",
        duration = 8
      )
      return(FALSE)
    }
    if (as.numeric(input$input_rooms) < 1) {
      showNotification(
        "Für korrekte Vorhersage muss die Anzahl der Zimmer mindestens 1 betragen!",
        type = "error",
        duration = 8
      )
      return(FALSE)
    }
    if (as.numeric(input$input_floor) < 1) {
      showNotification(
        "Für korrekte Vorhersage muss die Etage mindestens 1 betragen!",
        type = "error",
        duration = 8
      )
      return(FALSE)
    }
    return(TRUE)
  })
  
  # Funktion für die Prognose des Preises
  price_prediction <- eventReactive(input$action_search, {
    if (!is_valid_input()) {
      output$result <- renderText({ "" })
      return() # Vorzeitiges Beenden bei ungültiger Eingabe
    }
    
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
      stringsAsFactors = FALSE
    )
    
    # Prognose des Preises
    prediction <- exp(predict(modell, newdata = model_features))
    
    if (prediction <= 0) {
      return(NA)
    } else {
      return(round(prediction, 2))
    }
  })
  
  # Prognose im UI anzeigen
  output$predicted_price <- renderText({
    paste0(price_prediction(), " € ≙ ", round(price_prediction() * 4.27, 2), " zł")
  })
  
  # Berechnung der Preise für alle Städte basierend auf Eingaben
  price_predictions_for_all_cities <- eventReactive(input$action_search, {
    if (!is_valid_input()) {
      return(NULL)
    }
    
    predictions_for_all_cities <- list()
    
    # Loop durch alle Städte
    for (i in 1:nrow(df_city_coords)) {
      city_name <- df_city_coords$city[i]
      
      model_features <- data.frame(
        city = tolower(city_name),
        squareMeters = as.numeric(input$input_squaremeters),
        rooms = as.integer(input$input_rooms),
        schoolDistance = as.numeric(input$input_school),
        floor = as.integer(input$input_floor),
        buildYear = as.integer(input$input_buildyear),
        centreDistance = as.numeric(input$input_centrum),
        hasParkingSpace = ifelse(input$parking_space, "yes", "no"),
        hasBalcony = ifelse(input$balcony, "yes", "no"),
        hasElevator = ifelse(input$elevator, "yes", "no"),
        stringsAsFactors = FALSE
      )
      
      # Prognose für jede Stadt
      predictions_for_all_cities[[city_name]] <- exp(predict(modell, newdata = model_features))
    }
    
    # Füge die Vorhersagen in die Liste der Städte mit Coords ein
    df_city_coords$predictions <- unlist(predictions_for_all_cities)
    return(df_city_coords)
  })
  
  # Rendert die Karte mit Markern auf den Städten
  output$mymap <- renderLeaflet({
    leaflet(df_city_coords) %>% 
      addProviderTiles(
        providers$CartoDB.Positron,
        options = providerTileOptions(noWrap = TRUE)
      ) %>%
      fitBounds(
        lng1 = 14.07, lat1 = 49.00,
        lng2 = 24.15, lat2 = 54.83  
      ) %>%
      addMarkers(
        ~Longitude,
        ~Latitude,
        popup = ~paste0(
          "<b>Stadt:</b> ", city, "<br>",
          "<b>Mietpreis:</b> ", ifelse(is.na(predictions), "NA", round(predictions, 2))
        )
      )
  })
  
  # Aktualisiert die Karte bei jedem "Search"
  observeEvent(input$action_search, {
    if (!is_valid_input()) {
      return() # Abbruch, falls Eingabe ungültig
    }
    
    updated_coords <- price_predictions_for_all_cities()
    
    leafletProxy("mymap", data = updated_coords) %>%
      clearMarkers() %>%
      addMarkers(
        ~Longitude,
        ~Latitude,
        popup = ~paste0(
          "<b>Stadt:</b> ", city, "<br>",
          "<b>Mietpreis:</b> ", ifelse(is.na(predictions), "NA", paste0(round(predictions, 2), " €"))
        )
      )
  })
}
