# Analisi Multivariata: ha lo scopo di compattare un sistema multidimensionale in un numero minore di variabili. 
# Si utilizza la PCA (Principal Component Analysis). 
# Si passa da N dimensioni ad una sola, sfruttando la correlazione che può esserci fra i valori di riflettanza dei pixel di ciascun layer.  
# I valori dei pixel si dispongono in un sistema cartesiano e nella zona di maggior variabilità si fa passare un primo asse, detto Componente Principale (PC1). 
# Il secondo asse viene posto perpendicolare al primo, a metà della variazione iniziale: spiega una seconda percentuale di variabilità. 
# In questo modo i due assi non sono più correlati. 
# Applicando il calcolo della deviazione standard sulla PC1, si ottengono informazioni sulla variabilità su gran parte dell'informazione iniziale. 

# Librerie. 
library(raster)    # Lettura e analisi di dati spaziali: funzioni base. 
library(RStoolbox) # Strumenti per processare e analizzare immagini telerilevate: contiene le funzioni per l'Analisi Multivariata.  
library(ggplot2)   # Per la produzione di grafici a partire da un set di dati.
library(patchwork) # Permette di creare MultiFrame con i grafici generati da ggplot. 
library(viridis)   # Per incrementare la leggibilità. 

# Set WD
setwd("C:/lab") 

## Riserva indigena di Parakanã.

# Immagine Landsat con 7 bande (funzione brick)
p224r63_2011 <- brick("p224r63_2011_masked.grd")

plot(p224r63_2011) 
# Bande Landsat
# B1: blue
# B2: green
# B3: red
# B4: NIR
# B5: infrarosso medio
# B6: infrarosso termico
# B7: infrarosso medio
dev.off()

# Prima di eseguire la PCA, si procede con il ricampionamento o resampling per diminuire la risoluzione.
# Ricampionando l'immagine attraverso una finestra mobile che estrae la media dei valori della matrice, si alleggerisce. 

p224r63_2011res <- aggregate(p224r63_2011, fact=10) 
# fact=10 significa che compatta 100 pixel insieme (10x10). 

p224r63_2011res
# La risoluzione, inizialmente 30x30, ora è 300x300: immagine meno dettagliata. 

# Confronto fra le due immagini. 
g1 <- ggRGB(p224r63_2011, 4, 3, 2)    # Immagine originale. 
g2 <- ggRGB(p224r63_2011res, 4, 3, 2) # Immagine ricampionata.
g1 / g2  

# PCA grazie alla funzione rasterPCA. 
p224r63_2011res_pca <- rasterPCA(p224r63_2011res)

summary(p224r63_2011res_pca$model)
# Call: funzione che abbiamo utilizzato
# Model: modello che si utilizza, matrice con le correlazioni fra le bande. 
# Map: oggetto raster. 

# RGB dell'oggetto raster. 
plotRGB(p224r63_2011res_pca$map, r=1, g=2, b=3, stretch="lin")


## Ghiacciaio Similaun. 

# Immagine Sentinel con 4 bande (funzione brick). 
sen <- brick("sentinel.png")

# NIR nel rosso
ggRGB(sen, 1, 2, 3, stretch="lin") 

# NIR nel verde: maggior differenziazione fra la vegetazione. 
ggRGB(sen, 2, 1, 3, stretch="lin") 

# Da quest'immagine dobbiamo catturare un solo layer per il calcolo della variabilità. 
# In RStoolbox: rasterPCA. 
sen_PCA <- rasterPCA(sen)

# Informazioni sulle percentuali di variabilità spiegate dalle componenti. 
summary(sen_PCA$model)
# La prima il 67%, la seconda il 32%, la terza è rumore, la quarta è la banda di controllo. 

# Visualizzazione grafica delle componenti. 
plot(sen_PCA$map)

# Si assegnano a variabili le prime tre. 
pc1 <- sen_PCA$map$PC1
pc2 <- sen_PCA$map$PC2
pc3 <- sen_PCA$map$PC3

# Si assegnano a variabili i plot delle tre componenti. 
g1 <- ggplot() +
  geom_raster(pc1, mapping=aes(x=x, y=y, fill=PC1))
g2 <- ggplot() +
  geom_raster(pc2, mapping=aes(x=x, y=y, fill=PC2))
g3 <- ggplot() +
  geom_raster(pc3, mapping=aes(x=x, y=y, fill=PC3))

# Patchwork dei tre grafici. 
g1+g2+g3

# Sull'immagine della PC1 si applica il calcolo della deviazione standard.
sd3 <- focal(pc1, matrix(1/9, 3, 3), fun=sd)
# Finestra mobile 3x3, calcolo della deviazione standard. 
 
# Plot del risultato utilizzando il pacchetto Viridis per la visualizzazione. 
ggplot() +
  geom_raster(sd3, mapping=aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option = "inferno")

# Confronto.
# RGB
im1 <- ggRGB(sen, 2, 1, 3)

# PC1
im2 <- ggplot() +
  geom_raster(pc1, mapping=aes(x=x, y=y, fill=PC1))

# Deviazione standard sulla PC1
im3 <- ggplot() +
  geom_raster(sd3, mapping=aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option="inferno")              

# Patchwork finale. 
im1 + im2 + im3              

# Calcolo eterogeneità in 5x5 e assegnazione a variabile. 
sd5<- focal(pc1, matrix(1/25, 5, 5), fun=sd)    
im4 <- ggplot() +
  geom_raster(sd5, mapping=aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option = "inferno")
 
# Calcolo eterogeneità in 7x7 e assegnazione a variabile. 
sd7<- focal(pc1, matrix(1/49, 7, 7), fun=sd)    
im5 <- ggplot() +
  geom_raster(sd7, mapping=aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option = "inferno")

# Confronto: il livello di dettaglio è inferiore aumentando le dimensioni della finestra mobile. 
im3 + im4 + im5
