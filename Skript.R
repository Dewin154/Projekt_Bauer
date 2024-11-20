setwd("C:/Users/peter/Desktop/THD/3 Semester/Assistenzsysteme/Projekt_Bauer")

data <- read.csv("apartments_rent_pl_2024_06.csv", header=TRUE, sep=",", fill=TRUE, stringsAsFactors = TRUE)
data <- read.csv("apartments_rent_pl_2024_06_bereinigt.csv", header=TRUE, sep=",", fill=TRUE, stringsAsFactors = TRUE)

View(data)

remove(data)

NA_count <- colSums(is.na(data))
print(na_counts_base)

data$hasElevator[data2$hasElevator == ""] <- "no"

remove(...)