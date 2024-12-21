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

thematic::thematic_on() #dynamisches anpassen der plots an UI Theme

# Definiert UI, page_sidebar ist nur ein von vielen Layouts                                     
ui <- page_sidebar(
 
  #Title Block mit Elementen. Kann wie HTML bearbeitet werden
  title = tagList(
    tags$span(
      "Mietpreise in Polen", 
      style = "font-size: 30px; font-family: Arial, sans-serif;"
    ),
    
    tags$div(
      input_dark_mode(), # Button for Dark Mode
      style = "font-size: 25px;"
    )
    
  ),
  # Beinhaltet alle sidebar elemente wie action boxes etc.
  sidebar = sidebar(
    
    actionButton("action", label = "Action Button"),
    
    checkboxGroupInput("variable", "Checkboxes:",
                       c("Parkplatz" = "cyl",
                         "Balkon" = "am",
                         "Aufzug" = "gear")),
    
    numericInput("obs", "Numeric Input", 0, min = 1, max = 10000),
    
    selectInput(
      "var",
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
    
    sliderInput(
      "obs", "Jahr",
      min = 1970, max = 2024, value = 1970, dragRange = FALSE, sep ="", ticks = FALSE,
    )
  ),
  
  "Output",
  
  #card ist in Shiny das was <div> in HTML ist
  card(
    card_body(
      value_box(
        title = "Prognostizierter Mietpreis",
        value = 100,
        showcase = bsicons::bs_icon("house-check-fill",size = "0.9em"), #https://icons.getbootstrap.com/ alle möglichen icons
        theme = "teal"
      ),
    )
  ),
  
  
  card(
    card_header("Interaktive Karte"),
    card_body(
      leafletOutput("mymap"),
      )
    ),
  
  card(
    leafletOutput("mymap2")
  )
  
  )


