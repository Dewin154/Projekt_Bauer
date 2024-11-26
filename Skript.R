setwd("C:/Users/peter/Desktop/THD/3 Semester/Assistenzsysteme/Projekt_Bauer")

data <- read.csv("apartments_rent_pl_2024_06.csv", header=TRUE, sep=",", fill=TRUE, stringsAsFactors = TRUE)
data <- read.csv("apartments_rent_pl_2024_06_bereinigt.csv", header=TRUE, sep=",", fill=TRUE, stringsAsFactors = TRUE)

View(data)

#Löscht alle NA Einträge
data_omit <- na.omit(data)

remove(data)

#Zählt die Anzahl der Spalten mit dem Wert NA
na_count <- colSums(is.na(data))
print(NA_count)

#Findet genaue Zeilen in der Spalte die einen NA Wert enthält und erstellt eine Variable
na_rows <- which(is.na(data$clinicDistance))

#Zeigt die Zeilen mit NA an
View(data[is.na(data$clinicDistance), ])

#Ersetzt leere Balken mit "no"
data$hasElevator[data2$hasElevator == ""] <- "no"

#Entfernt Datensatz, Variablen z.B.: remove(data) löscht den Datensatz
remove(...)

#Bereinigt die NA Zeilen
data_clean <- data[complete.cases(data), ]

#Entfernt Spalte im Datensatz mit dem Namen "X"
data2 <- data2[, !names(data2) %in% "id"]
# yes = 1
# no  = 0

#Multiple Linear Regression

modell <- lm(priceInEuro~city+squareMeters+rooms+floor+buildYear+centreDistance+schoolDistance+clinicDistance+hasParkingSpace+hasBalcony+hasElevator, data = data)
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

#Zählt die Anzahl aller Einträge pro Stadt
city_counts <- table(data$city)

#Sortiert die Städte
city_counts_sorted <- as.data.frame(city_counts[order(-city_counts)]) # Sort in descending order
View(city_counts_sorted)

#Exportiert den Datensatz im R als CSV
write.csv(df, "specify_path_and_file_name.csv")
write.csv(data, "C:/Users/peter/THD/3_Semester/Assistenzsysteme/Projekt_Bauer/datensatz_bereinigt.csv",row.names = FALSE)
