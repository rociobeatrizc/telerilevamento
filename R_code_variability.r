# Analisi di pattern spaziali: visualizzazione di variazioni geostrutturali e variazioni ecologiche all'interno di un'immagine satellitare.  
# Maggiore eterogeneità (detta anche variability) nel paesaggio equivale a maggiore biodiversità. 
# Ciascun elemento che compone la biodiversità ha la propria riflettanza.
# Come esempio, si consideri il ghiacciaio del Similaun (dati Sentinel). 
# Ghiacciaio del Similaun (Otzi). Il bosco è rosso scuro, le praterie rosso chiaro, le zone scure sono i crepacci, c'è la neve e si vede l'acqua (assorbe IR).

# Installazione del pacchetto Viridis, sviluppato per permettere a chi ha deficit visivi una buona visualizzazione dei colori. 
install.packages("viridis")

# Librerie. 
library(raster)    # Lettura e analisi di dati spaziali: funzioni base. 
library(RStoolbox) # Strumenti per processare e analizzare immagini telerilevate: da qui proviene la funzione focal. 
library(ggplot2)   # Per la produzione di grafici a partire da un set di dati.
library(patchwork) # Permette di creare multiframe con i grafici generati da ggplot. 
library(viridis)   # Per incrementare la leggibilità. 

# Impostazione Working Directory
setwd("C:/lab")

# Importazione immagine Sentinel contenente il ghiacciaio: trattandosi di un'immagine satellitare a più bande, occorre usare brick (libreria raster).   
sen <- brick("sentinel.png")

# Immagine RGB creata con ggplot, lo stretch lineare è di default e non occorre specificarlo.  
# 1 : NIR 
# 2 : Red
# 3 : Green
ggRGB(sen, 1, 2, 3) 
dev.off()

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
