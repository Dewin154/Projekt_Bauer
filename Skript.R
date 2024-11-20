setwd("C:/Users/peter/Desktop/THD/3 Semester/Assistenzsysteme")

data <- read.csv("apartments_rent_pl_2024_06.csv", header=TRUE, sep=",", fill=TRUE, stringsAsFactors = TRUE)
data2 <- read.csv("apartments_rent_pl_2024_06_bereinigt.csv", header=TRUE, sep=";", fill=TRUE, stringsAsFactors = TRUE)

View(data)
View(data2)

remove(data)
remove(data2)

na_counts_base <- colSums(is.na(data2))
print(na_counts_base)



remove(duplicates_count)