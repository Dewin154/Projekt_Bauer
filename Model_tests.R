setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

data <- read.csv("datensatz_bereinigt.csv", header=TRUE, sep=",", fill=TRUE, stringsAsFactors = TRUE)

View(data)

modell <- lm(priceInEuro~city+squareMeters+rooms+floor+buildYear+centreDistance+schoolDistance+hasParkingSpace+hasBalcony+hasElevator, data = data)
summary(modell)

#Zählt die Anzahl aller Einträge pro Stadt
city_counts <- table(data$city)

#Sortiert die Städte
city_counts_sorted <- as.data.frame(city_counts[order(-city_counts)]) # Sort in descending order
View(city_counts_sorted)
