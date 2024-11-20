setwd("C:/Users/peter/Desktop/THD/3 Semester/Assistenzsysteme/Projekt_Bauer")

data <- read.csv("apartments_rent_pl_2024_06.csv", header=TRUE, sep=",", fill=TRUE, stringsAsFactors = TRUE)
data <- read.csv("apartments_rent_pl_2024_06_bereinigt.csv", header=TRUE, sep=",", fill=TRUE, stringsAsFactors = TRUE)

View(data)

remove(data)

NA_count <- colSums(is.na(data))
print(NA_count)

#Ersetzt leere Balken mit "no"
data$hasElevator[data2$hasElevator == ""] <- "no"

remove(...)

#Bereinigt die NA Zeilen
data_clean <- data[complete.cases(data), ]

#Entfernt Spalte im Datensatz mit dem Namen "X"


# yes = 1
# no  = 0

#Multiple Linear Regression
modell <- lm(priceInEuro~city+squareMeters+rooms+floor+buildYear+centreDistance+schoolDistance+clinicDistance+kindergartenDistance+pharmacyDistance+hasParkingSpace+hasBalcony+hasElevator+hasStorageRoom, data = data_clean)
summary(modell)

#Konvertieren in Double !!Vorsicht

data_clean$squareMeters <- as.double(data_clean$squareMeters)

#Konvertieren in Factor !!Vorsicht

data_clean$buildYear <- as.factor(data_clean$buildYear)
data_clean$rooms <- as.factor(data_clean$rooms)
data_clean$floor <- as.factor(data_clean$floor)


#Konvertieren in Numeric !!Vorsicht

data_clean$squareMeters <- as.numeric(data_clean$squareMeters)

#Richtiges Konvertieren (von Factor auf Numeric), erst werden die daten als character konvertiert, die Kommata für Punkte ersetzt (englische Schreibweise) und dann ins Numeric Konvertiert
data_clean$squareMeters <- as.numeric(gsub(",", ".", as.character(data_clean$squareMeters)))
data_clean$squareMeters <- as.numeric(gsub(",", ".", as.character(data_clean$squareMeters)))
data_clean$centreDistance <- as.numeric(gsub(",", ".", as.character(data_clean$centreDistance)))
data_clean$schoolDistance <- as.numeric(gsub(",", ".", as.character(data_clean$schoolDistance)))
data_clean$clinicDistance <- as.numeric(gsub(",", ".", as.character(data_clean$clinicDistance)))
data_clean$pharmacyDistance <- as.numeric(gsub(",", ".", as.character(data_clean$pharmacyDistance)))
data_clean$kindergartenDistance <- as.numeric(gsub(",", ".", as.character(data_clean$kindergartenDistance)))
data_clean$priceInEuro <- as.numeric(gsub(",", ".", as.character(data_clean$priceInEuro)))

