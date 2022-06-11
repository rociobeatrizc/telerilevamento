# Time Series Analysis
# Come cambia una regione nel tempo visualizzando più immagini satellitari: si prende in considerazione la Groenlandia.  

# Pacchetto da installare: miglior visualizzazione e interazione con i dati raster. 
install.packages("rasterVis")

# Librerie. 
library(raster)    # Lettura e manipolazionedi dati satellitari. 
library(rasterVis) # Visualizzazione raster. 
library(rgdal)     # GDAL (Geospatial Data Abstraction Library) per R. 

# Come parametro da valutare nel corso del tempo si usa il Land Surface Temperature (LST).
# Misura la temperatura della terra al suolo. 

# Cartella di lavoro. 
setwd("C:/lab/greenland")

# Con la funzione Brick si carica l'intero blocco di bande che compongono un'immmagine in R. 
# Con la funzione Raster si importa un singolo layer: abbiamo 4 dati diversi. 
lst2000 <- raster("lst_2000.tif")
lst2005 <- raster("lst_2005.tif")
lst2010 <- raster("lst_2010.tif")
lst2015 <- raster("lst_2015.tif")

lst2000
# Risoluzione Radiometrica: bit a disposizione. 
# 16 bit. 
2^16

# Plot di una sola immagine. 
plot(lst2015)
dev.off()

# Plot del MultiFrame 
cl <- colorRampPalette(c("blue","light blue","pink","red"))(100)
par(mfrow=c(4,1)) 
plot(lst2000, col=cl)
plot(lst2005, col=cl)
plot(lst2010, col=cl)
plot(lst2015, col=cl)

# list.files, lapply, stack. 
# Al posto di importare gli oggetti uno ad uno, si crea una lista  estraendo tutti i file che hanno in comune la stringa "lst".
# Ad rlist si applica la funzione raster con lapply. 
rlist <- list.files(pattern="lst")
import <- lapply(rlist, raster)
import

# Con la funzione stack si inseriscono i layer in un unico file tipo immagine satellitare. 
tgr <- stack(import)

# Per plottare una sola immagine devo richiamarla con la posizione o con il suo nome. 
plot(tgr[[1]], col=cl)

# Oppure
plot(tgr$lst_2000, col=cl)

# Possiamo fare un RGB basandoci sui Layer
plotRGB(tgr, r=1, g=2, b=3, stretch="lin")
# Parte nera: in comune. 
