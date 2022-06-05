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
library(patchwork) # Permette di creare MultiFrame con i grafici generati da ggplot. 
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

# Assegno ad una variabile. 
g1 <- ggRGB(sen, 1, 2, 3)

# Nel verde si monta la banda del NIR: si vedono bene la roccia viola e la neve, mentre la vegetazione è verde (contrasto fra boschi e praterie).  
ggRGB(sen, 2, 1, 3)

# Assegno ad una seconda variabile per creare un MultiFrame. 
g2 <- ggRGB(sen, 2, 1, 3)

# Patchwork: immagini una di fianco all'altra con + , una sopra l'altra con /
g1 + g2
g1 / g2 

# Come misura della variabilità del paesaggio si sceglie la deviazione standard, che esprime la dispersione dei dati intorno alla media. 
# Si fa passare su uno strato una finestra mobile, che si sposta lungo tutta l'immagine (ciclo FOR). 
# Fa un calcolo qualsiasi sui valori di riflettanza all'interno della finestra (3x3) e riporta un valore nel pixel centrale, che è posto al centro dell'immagine originale.
# Focal su singola variabile. Si sceglie un layer con informazioni (NIR), un indice spettrale...

# Occorre scegliere uno strato rappresentativo: il layer del NIR è una buona banda sulla quale calcolare la deviazione standard. 
# Si associa la banda ad una variabile. 
nir <- sen[[1]]

# Funzione Focal (RStoolbox).
# Sullo strato scelto, focal fa passare grazie ad un ciclo FOR una finestra mobile, cioè una matrice le cui dimensioni vanno specificate. 
# Sui valori di riflettanza all'interno della matrice, focal calcola la deviazione standard (anche questa da definire) e riporta un valore nel pixel centrale della finestra.
# Il procedimento fino a ricoprire di pixel ricalcolati da focal tutta l'immagine originale. 
# Matrice 3x3, funzione deviazione standard. 
sd3 <- focal(nir, matrix(1/9, 3, 3), fun=sd)

# Plot
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100) 
plot(sd3, col=clsd)
# Luoghi a bassa variabilità: roccia compatta senza crepacci (zone blu), acqua
# Luoghi ad alta variabilità: bordi dei boschi (rosa), crepacci (rossi). 

# ggplot() apre il plot vuoto, a cui si aggiunge una geometria raster.
# Mapping per le aestethics 
# Il colore corrisponde allo strato che abbiamo calcolato, ovvero "layer"
ggplot() + 
  geom_raster(sd3, mapping=aes(x=x, y=y, fill=layer)) 
# Crepacci e limiti risultano più evidenti. 

# Viridis: https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html
# Alcuni colori non possono essere visualizzati da persone con difetti visivi (es. daltonismo): viridis crea mappe di colori accessibili a tutti. 
# Default: viridis. 
ggplot() +
  geom_raster(sd3, mapping =aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis() +
  ggtitle("Standard Deviation 3x3 by Viridis")

# Visualizzazione della misura di variabilità: inferno azzera la variabilità minima. 
inferno <- ggplot() +
  geom_raster(sd3, mapping =aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option = "inferno") +
  ggtitle("Standard Deviation by Inferno")

# Altro esempio: magma. 
magma <- ggplot() +
  geom_raster(sd3, mapping =aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option = "magma") +
  ggtitle("Standard Deviation by Magma")

dev.off()

# Posso cambiare le dimensioni della matrice, ad esempio 7x7. 
sd7 <- focal(nir, matrix(1/49, 7, 7), fun=sd)

# Il risultato è meno dettagliato. 
ggplot() +
  geom_raster(sd7, mapping =aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option = "viridis") +
  ggtitle("Standard Deviation 7x7 by Viridis")

# Immagini a confronto. 
viridis3 <- ggplot() +
  geom_raster(sd3, mapping =aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis() +
  ggtitle("Standard Deviation 3x3 by Viridis")

viridis7 <- ggplot() +
  geom_raster(sd7, mapping =aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option = "viridis") +
  ggtitle("Standard Deviation 7x7 by Viridis")

viridis3 + viridis7
