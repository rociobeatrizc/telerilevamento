# Spatial Variability in Similaun glacier: the more variability we see, the more biodiversity is present.  
# Il ghiacciaio del Similaun (dati Sentinel, 10m): variabilità spaziale (eterogeneità e varianza) - usando indici di vegetazione e Principal Components.
# Maggiore eterogeneità (detta anche variability) nel paesaggio equivale a maggiore biodiversità.
# Ciascun elemento di biodiversità ha la propria riflettanza. 
# Appaiono come zone di differenziazione fra un punto e un altro del paesaggio. 
# Ghiacciaio del Similaun (Otzi). Il bosco è rosso scuro, le praterie rosso chiaro, le zone scure sono i crepacci, c'è la neve e si vede l'acqua (assorbe IR).

# Color maps designed to improve graph readability for readers with common forms of color blindness and/or color vision deficiency.
install.packages("viridis")

library(raster)
library(RStoolbox) # For image viewing and variability calculation
library(ggplot2) # For ggplot plotting
library(patchwork) # Multiframe with ggplot2 graphs
library(viridis)

# 1 : NIR 
# 2 : Red
# 3 : Green

# I dati telerilevati vengono salvati come dati temporanei e non possono essere inclusi in un progetto. 
setwd("C:/lab")

# Lo stretch lineare viene fatto in automatico. 
sen <- brick("sentinel.png")

ggRGB(sen, 1, 2, 3, stretch="lin") 
dev.off()
# Suolo: zone scure

g1 <- ggRGB(sen, 1, 2, 3)

# Si vede bene la roccia viola e la neve, mentre la vegetazione è verde (contrasto fra boschi e praterie)
# Nel verde si monta l'infrarosso. 
g2 <- ggRGB(sen, 2, 1, 3)
# Patchwork 
g1 / g2 

# Come si misura la variabilità?
# Si fa passare su uno strato una finestra mobile, che si sposta lungo tutta l'immagine (ciclo FOR). 
# Fa un calcolo qualsiasi sui valori di riflettanza all'interno della finestra (3x3) e riporta un valore nel pixel centrale, che è posto al centro dell'immagine originale.
# Intorno alla media c'è una curva di valori possibili: la deviazione standard è la misura degli scarti dalla media, al quadrato si chiama varianza ed è quella che usiamo. 
# La varianza quindi misura la variabilità intorno alla media. 
# Focal su singola variabile. Si sceglie un layer con informazioni (NIR), un indice spettrale...

# Associamo ad una variabile l'Infrarosso: buona banda per fare questo calcolo. 
nir <- sen[[1]]

# Funzione Focal (RStoolbox)
# Variabilità su NIR, si definisce la matrice, la funzione è la deviazione standard, cioè il calcolo che scegliamo per stabilire la variabilità)  
sd3 <- focal(nir, matrix(1/9, 3, 3), fun=sd)

clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100) #
plot(sd3, col=clsd)
# Luoghi a bassa variabilità: roccia compatta senza crepacci (zone blu), acqua
# Luoghi ad alta variabilità: bordi dei boschi (rosa), crepacci (rossi). 

# ggplot apre il plot vuoto
# Si aggiunge una geometria raster, si fornisce l'immagine da plottare
# Abbiamo a che fare con un raster quindi si specifica mapping per le aest. 
# Il colore corrisponde allo strato che abbiamo calcolato, ovvero "layer"
ggplot() + 
  geom_raster(sd3, mapping=aes(x=x, y=y, fill=layer)) 
# Crepacci e limiti risultano più evidenti. 

# Viridis: https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html
# Alcuni colori non possono essere visualizzati da persone con difetti visivi. 
# Default: viridis. 
viridis3 <- ggplot() +
  geom_raster(sd3, mapping =aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option = "viridis") +
  ggtitle("Standard Deviation 3x3 by Viridis")

# Visualizzazione della misura di variabilità: Inferno azzera la variabilità minima. 
inferno <- ggplot() +
  geom_raster(sd3, mapping =aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option = "inferno") +
  ggtitle("Standard Deviation by Inferno")

magma <- ggplot() +
  geom_raster(sd3, mapping =aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option = "magma") +
  ggtitle("Standard Deviation by Magma")

dev.off()

# Posso cambiare le dimensioni della matrice, ad esempio 7x7 (meno dettaglio)
sd7 <- focal(nir, matrix(1/49, 7, 7), fun=sd)

ggplot() +
  geom_raster(sd7, mapping =aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option = "viridis") +
  ggtitle("Standard Deviation 7x7 by Viridis")

viridis7 <- ggplot() +
  geom_raster(sd7, mapping =aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option = "viridis") +
  ggtitle("Standard Deviation 7x7 by Viridis")

viridis3 + viridis7
