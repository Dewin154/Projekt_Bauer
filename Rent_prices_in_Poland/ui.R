#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(bslib)
library(leaflet)
library(shinyBS)

thematic::thematic_on() #dynamisches anpassen der plots an UI Theme

# Definiert UI, page_sidebar ist nur ein von vielen Layouts                                     
ui <- page_sidebar(
 
  #Title Block mit Elementen. Kann wie HTML bearbeitet werden
  title = tagList(
    tags$span(
      "Mietpreise in Polen", 
      style = "font-size: 30px; font-family: Arial, sans-serif;"
    ),
    
    # Button for Dark Mode
    tags$div(
      input_dark_mode(), 
      style = "font-size: 25px;"
    )
    
  ),
  # Beinhaltet alle sidebar elemente wie action boxes etc.
  sidebar = sidebar(
    
    actionButton("action_search", label = "Suchen"),
    
    
    
    selectInput(
      "input_city",
      label = "Stadt Wählen",
      choices = 
        list(
          "Warszawa", 
          "Krakow", 
          "Wroclaw", 
          "Lodz",
          "Poznan",
          "Katowice",
          "Gdansk",
          "Szczecin",
          "Lublin",
          "Bydgoszcz",
          "Rzeszow",
          "Gdynia",
          "Bialystok",
          "Radom",
          "Czestochowa"
        ),
      selected="Warszawa"
    ),
    
    #Hier wegen Einfachkeit. Leichtere Handhabung in server.R bei der Berechnung des prog. Preises
    checkboxInput("parking_space", "Parkplatz", value = FALSE, width = NULL),
    checkboxInput("balcony", "Balkon", value = FALSE, width = NULL),
    checkboxInput("elevator", "Aufzug", value = FALSE, width = NULL),
    
    numericInput("input_squaremeters", "Quadratmeter", 0, min = 25, max = 10000),
    
    numericInput("input_rooms", "Anzahl der Räume", 1, min = 1, max = 10),
 
    numericInput("input_floor", "Stockwerk", 1, min = 1, max = 20),

    
    sliderInput(
      "input_buildyear", "Baujahr",
      min = 1900, max = 2024, value = 1970, dragRange = FALSE, sep ="", ticks = FALSE,
    ),
    
    sliderInput(
      "input_centrum", "Entfernung zum Zentrum in km",
      min = 0, max = 15, value = 0, step = 0.5, dragRange = FALSE, sep ="", ticks = FALSE,
    ),
    
    sliderInput(
      "input_school", "Entfernung zur Schule in km",
      min = 0, max = 4, value = 0, step = 0.5, dragRange = FALSE, sep ="", ticks = FALSE,
    ),

  ),
  
  #card ist in Shiny das was <div> in HTML ist
  card(
    card_body(
      value_box(
        title = "Prognostizierter Mietpreis",
        value = textOutput("predicted_price"),
        showcase = bsicons::bs_icon("house-check-fill",size = "0.9em"), #https://icons.getbootstrap.com/ alle möglichen icons
        theme = "teal" #teal
      ),
    )
  ),
  
  card(
    card_header("Interaktive Karte"),
    card_body(
      leafletOutput("mymap", width = "550px", height = "500px"),
      )
    ),
  
  )


