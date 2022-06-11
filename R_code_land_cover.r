# Mappe di Land Cover, sulla copertura, sull'uso del suolo e sulla transizione tra le diverse categorie. 
# La classificazione non supervisionata fa sì che, scelto un numero di classi, si raggruppino i pixel in tali classi. 
# I pixel non classificati verranno assegnati alla classe spettrale più vicina sulla base della loro riflettanza. 

# Pacchetti da installare. 
# ggplot2 per generare grafici, lavora anche sui file raster. 
# Patchwork per la composizione di grafici creati con ggplot.
install.packages("ggplot2")
install.packages("patchwork")


# Librerie 
library(raster)
library(RStoolbox) 
library(ggplot2)
library(patchwork) #https://patchwork.data-imaginist.com/

# Potrebbe essere necessaria anche la seguente installazione:
# for grid.arrange plotting
# install.packages("gridExtra")
# library(gridExtra) 

# Cartella di lavoro. 
setwd("C:/lab") 

# Rio Peixoto 1992
l92 <- brick("defor1_.jpg")

# NIR = 1
plotRGB(l92, 1, 2, 3, stretch="lin")

dev.off()

# Rio Peixoto 2006
l06 <- brick("defor2_.jpg")

# MultiFrame: una riga, due colonne. 
par(mfrow= c(1,2))
plotRGB(l92, r=1, g=2, b=3, stretch="lin")
plotRGB(l06, r=1, g=2, b=3, stretch="lin")

# MF con ggplot: ggRGB crea l'immagine RGB, si assegna ad una variabile. 
p1 <- ggRGB(l92, r=1, g=2, b=3, stretch="lin")
p2 <- ggRGB(l06, r=1, g=2, b=3, stretch="lin")

# Grazie a Patchwork è sufficiente sommare le due immagini. 
p1 + p1
p1/p2

# Classificazione del suolo: con due classi riusciamo a distinguere ciò che è acqua da ciò che è foresta. 
set.seed(1)
l92c <- unsuperClass(l92, nClasses = 2)
plot(l92c$map)

# Classe 1: suolo destinato all'agricoltura, acqua.  
# Classe 2: foresta.

l06c <- unsuperClass(l06, nClasses = 2)
plot(l06c$map)

# Frequenza: quante volte avviente un certo evento. 
# Quante volte trovo pixel foresta? Con freq si ottiene la frequenza delle due classi. 

freq(l92c$map)
#       value  count
# [1,]     1 306860
# [2,]     2  34432

freq(l06c$map)
#       value  count
# [1,]     1 163752
# [2,]     2 178974

# In proporzione: pixel di foresta/agricoltura della prima immagine rispetto al totale. 

# Prima immagine. 
l92
# Totale pixel: 341292
tot92 <- 341292

# Proporzione in % delle classi nella prima e nella seconda immagine. 
prop_92 <- freq(l92c$map) * 100 / tot92
prop_92
# 10% agricoltura, 90% foresta. 

prop_06 <- freq(l06c$map) * 100 / tot06
prop_06 
# 47% agricoltura, 52% foresta. 

# Da freq(l92$map) si guardano i pixel di ciascuna categoria. 
# Assegnazione
prop_forest_92 <- 306023 * 100/ tot92
prop_agriculture_92 <- 35269 * 100/tot92
 
# Seconda immagine 
l06
tot06 <- 342726

# Assegnazione 
prop_forest_06 <-  178716 * 100/ tot06
prop_agriculture_06 <- 164719 * 100/ tot06

# Foresta: 90% nel 1992, 52% nel 2006
prop_forest_92
prop_forest_06

# DataFrame: tre vettori, uno contiene le variabili foresta/agricoltura, gli altri due i valori corrispondenti per i due anni. 
class <- c("Forest","Agriculture") 
percent_1992 <- c(89.83, 10.16)
percent_2006 <- c(52.06, 47.93)

percentages <- data.frame(class, percent_1992, percent_2006)
percentages

# Plot
# ggplot(DataFrame, aes(x, y, color=x)) +
# tipo_di_grafico(stat="legenda", fill="colore delle barre")

plot92 <- ggplot(percentages, aes(x=class, y=percent_1992, color=class)) + 
  geom_bar(stat="identity", fill="white")

plot06 <- ggplot(percentages, aes(x=class, y=percent_2006, color=class)) + 
  geom_bar(stat="identity", fill="white")

# Si può scrivere anche così: 
# ggplot(percentages) +    
#   geom_bar(aes(x=class, y=percent_2006, color=class), stat="identity", fill="white")

# Patchwork 
plot92 + plot06
