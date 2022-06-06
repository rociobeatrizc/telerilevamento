# Analisi Multivariata: ha lo scopo di compattare un sistema multidimensionale in un numero minore di variabili. 
# Si utilizza la PCA (Principal Component Analysis). 
# Si passa da N dimensioni ad una sola, sfruttando la correlazione che può esserci fra i valori di riflettanza dei pixel di ciascun layer.  
# I valori dei pixel si dispongono in un sistema cartesiano e nella zona di maggior variabilità si fa passare un primo asse, detto Componente Principale (PC1). 
# Il secondo asse viene posto perpendicolare al primo, a metà della variazione iniziale: spiega una seconda percentuale di variabilità. 
# In questo modo i due assi non sono più correlati. 
# Applicando il calcolo della deviazione standard sulla PC1, si ottengono informazioni sulla variabilità su gran parte dell'informazione iniziale. 

library(raster)
library(RStoolbox)  # Libreria del Telerilevamento: contiene le funzioni per l'analisi Multivariata. 
library(ggplot2)
library(patchwork)
library(viridis)


# Set WD
setwd("C:/lab") 

# Import Area di Studio (primo script) con 7 bande (funzione brick)
p224r63_2011 <- brick("p224r63_2011_masked.grd")
# Landsat con riflettanza in 7 bande.
plot(p224r63_2011) 
dev.off()

# Prima di eseguire la PCA, si procede con il ricampionamento o resampling (aggregate in R).
# 4 milioni di pixel per 7 bande: 28 milioni di pixel. Si diminuisce la risoluzione ricampionando l'immagine attraverso una MW. 
# La MW lavora per blocchi, estrae la media dei valori della matrice aggregando i pixel. 
p224r63_2011res <- aggregate(p224r63_2011, fact=10) # Di quanto aggreghiamo i pixel, 10 significa che compatta 100 pixel insieme (10x10)
summary(p224r63_2011res)
plot(p224r63_2011res) 

# Bande Landsat
# B1: blue
# B2: green
# B3: red
# B4: NIR
# B5: infrarosso medio
# B6: infrarosso termico
# B7: infrarosso medio
g1 <- ggRGB(p224r63_2011, 4, 3, 2)
g2 <- ggRGB(p224r63_2011res, 4, 3, 2) # Immagine ricampionata
g1 / g2  

# Sopra: immagine di dettaglio. Sotto: perde dettaglio. 
# Il patter di compattamento è lineare.  
# 30x30 risoluzione Landsat
p224r63_2011

# 300x300 (fattore 10)
p224r63_2011res

# PCA Area di Studio
p224r63_2011res_pca <- rasterPCA(p224r63_2011res)
summary(p224r63_2011res_pca$model)
plotRGB(p224r63_2011res_pca$map, r=1, g=2, b=3, stretch="lin")


## PCA e Variability: Ghiacciaio Similaun. 
sen <- brick("sentinel.png")
# NIR nel rosso
ggRGB(sen, 1, 2, 3, stretch="lin") 

# NIR nel verde: maggior differenziazione fra la vegetazione. Da quest'immagine dobbiamo catturare un solo layer per il calcolo della variabilità. 
# PCA
ggRGB(sen, 2, 1, 3, stretch="lin") 

# In RStoolbox: rasterPCA
sen_PCA <- rasterPCA(sen)

sen_PCA
# Call: funzione che abbiamo utilizzato
# Model: modello che si utilizza, matrice con le correlazioni fra le bande. 
# Map: oggetto raster. 

summary(sen_PCA$model)
# Quanta variabilità spiega la PCA? 
# La prima il 67%, la seconda il 32%, la terza è rumore
# Del sistema originale a tre bande, ne bastano due: ne usiamo una sola, la prima. 
plot(sen_PCA$map)
pc1 <- sen_PCA$map$PC1
pc2 <- sen_PCA$map$PC2
pc3 <- sen_PCA$map$PC3

# Patchwork
g1 <- ggplot() +
  geom_raster(pc1, mapping=aes(x=x, y=y, fill=PC1))

g2 <- ggplot() +
  geom_raster(pc2, mapping=aes(x=x, y=y, fill=PC2))

g3 <- ggplot() +
  geom_raster(pc3, mapping=aes(x=x, y=y, fill=PC3))

g1+g2+g3


# Sull'immagine della PC1 si applica il calcolo della deviazione standard. 
sd3 <- focal(pc1, matrix(1/9, 3, 3), fun=sd)

# Plot 
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
im1 + im2 + im3              

# Calcolo eterogeneità in 5x5
sd5<- focal(pc1, matrix(1/25, 5, 5), fun=sd)    
im4 <- ggplot() +
  geom_raster(sd5, mapping=aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option = "inferno")
 
# Calcolo eterogeneità in 7x7
sd7<- focal(pc1, matrix(1/49, 7, 7), fun=sd)    
im5 <- ggplot() +
  geom_raster(sd7, mapping=aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option = "inferno")

# Confronto: meno dettaglio 
im3 + im4 + im5
