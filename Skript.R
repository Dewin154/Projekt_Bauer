#setwd("C:/Users/peter/Desktop/THD/3 Semester/Assistenzsysteme/Projekt_Bauer")
#print(dirname(rstudioapi::getActiveDocumentContext()$path))
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#install custom theme 
rstudioapi::addTheme("https://raw.githubusercontent.com/SofieDunt/darculaR-rstheme/main/darculaR.rstheme", apply = TRUE)

#data <- read.csv("apartments_rent_pl_2024_06.csv", header=TRUE, sep=",", fill=TRUE, stringsAsFactors = TRUE)
data <- read.csv("datensatz_bereinigt.csv", header=TRUE, sep=",", fill=TRUE, stringsAsFactors = TRUE)

View(data)

#Löscht alle NA Einträge
data_omit <- na.omit(data)

remove(data)

#Zählt die Anzahl der Spalten mit dem Wert NA
na_count <- colSums(is.na(data))
print(na_count)

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
data <- data[, !names(data) %in% "X"]
# yes = 1
# no  = 0

#Multiple Linear Regression

modell <- lm(priceInEuro~city+squareMeters+rooms+floor+buildYear+centreDistance+schoolDistance+hasParkingSpace+hasBalcony+hasElevator, data = data)
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
orig_data$squareMeters <- as.numeric(gsub(",", ".", as.character(orig_data$squareMeters)))
orig_data$squareMeters <- as.numeric(gsub(",", ".", as.character(orig_data$squareMeters)))
orig_data$centreDistance <- as.numeric(gsub(",", ".", as.character(orig_data$centreDistance)))
orig_data$schoolDistance <- as.numeric(gsub(",", ".", as.character(orig_data$schoolDistance)))
orig_data$clinicDistance <- as.numeric(gsub(",", ".", as.character(orig_data$clinicDistance)))
orig_data$pharmacyDistance <- as.numeric(gsub(",", ".", as.character(orig_data$pharmacyDistance)))
orig_data$kindergartenDistance <- as.numeric(gsub(",", ".", as.character(orig_data$kindergartenDistance)))
orig_data$priceInEuro <- as.numeric(gsub(",", ".", as.character(orig_data$priceInEuro)))

#Zählt die Anzahl aller Einträge pro Stadt
city_counts <- table(data$city)

#Sortiert die Städte
city_counts_sorted <- as.data.frame(city_counts[order(-city_counts)]) # Sort in descending order
View(city_counts_sorted)

#Exportiert den Datensatz im R als CSV
write.csv(df, "specify_path_and_file_name.csv") #Allgemein
write.csv(data, "C:/Users/peter/THD/3_Semester/Assistenzsysteme/Projekt_Bauer/datensatz_bereinigt.csv",row.names = FALSE) #Beispiel

#Speichert die Arbeitsumgebung wie beim Schließen des Projekts
save.image(file = "C:/Users/peter/THD/3_Semester/Assistenzsysteme/Projekt_Bauer/.RData")


#Aufteilung des Datensatzes
count_of_rows <- nrow(data)
set.seed(123)
training_indices <- sample(1:count_of_rows, size = 0.8 * count_of_rows)
train_data <- data[training_indices, ]
test_data <- data[-training_indices, ]


#Korrelationsmatrix erstellen
install.packages("corrplot")
library(corrplot)
cor_matrix <- cor(data3, use = "complete.obs") #Matrix erstellen

corrplot(cor_matrix, method = "color", 
                   col = colorRampPalette(c("red", "white", "blue"))(200),
                   tl.col = "black", tl.srt = 45, addCoef.col = "black") #Plot erstellen




# Run the app ----
shiny::runApp()

#Vorhersage treffen
test_data_merkmale <- test_data[, !names(test_data) %in% "priceInEuro"]  # Features
test_data_zielvariable <- test_data$priceInEuro                             # Target
predictions <- predict(modell_linear, newdata = test_data_merkmale)

#Berechne MAE, MSE, r squared
mae <- mean(abs(test_data_zielvariable - predictions))

mse <- mean((test_data_zielvariable - predictions)^2)

r2 <- 1 - (sum((test_data_zielvariable - predictions)^2) / sum((test_data_zielvariable - mean(test_data_zielvariable))^2))


#Model speichern damit er für andere in der App verfügbar ist. Model soll im ordner der Shiny App gespeichert werden
saveRDS(modell_linear, "C:/Users/peter/THD/3_Semester/Assistenzsysteme/Projekt_Bauer/Rent_prices_in_Poland/modell_linear.rds")






