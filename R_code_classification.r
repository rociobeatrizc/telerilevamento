# Classificazione di immagini.
# La classificazione non supervisionata permette di passare dai dati continui ad una suddivisione in classi.  
# Analisi e gestione di dati satellitari: da questo pacchetto proviene unsuperClass. 
install.packages("RStoolbox")

# Librerie
library(raster)
library(RStoolbox)

# Set WD
setwd("C:/lab") 

## Importare un pezzo di codice già scritto. 
source("r_code.txt")

## Solar Orbiter
# Import di un'immagine di Solar Orbiter, una missione ESA che cattura immagini ravvicinate del Sole. 
# Contiene le regioni energeticamente attive. 
so <- brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg") 

# Plot RGB
plotRGB(so, 1,2,3, stretch="lin")
plotRGB(so, 1,2,3, stretch="hist")

# unsuperClass: unsupervised clustering of Raster data using kmeans clustering. 
# Outputs. 
# Model: tre raggruppamenti (come richiesto in nClasses) e rispettive dimensioni.
# Map: oggetto Raster all'interno del quale ciascun pixel è nella prima, seconda oppure terza classe.  
soc <- unsuperClass(so, nClasses=3)
soc
plot(soc$map)
dev.off()


## Grand Canyon 
# Come associo un pixel non ancora classificato ad una classe? Si sceglie quella spettralmente più vicina. 
# In questo modo si può, ad esempio, discriminare fra i vari tipi mineralogici nel Grand Canyon.  
# Immagine già elaborata, solo nel visibile. 
gc <- brick("dolansprings_oli_2013088_canyon_lrg.jpg") 
gc
plotRGB(gc, r=1, g=2, b=3, stretch="hist")

# Classificazione 
gcclass2 <- unsuperClass(gc, nClasses = 2)
gcclass2
# La classificazione produce un oggetto che ha all'interno il modello in sè, la mappa in uscita, le statistiche univariate

plot(gcclass2$map)
# Classe 1 e 2. I valori intermedi non hanno senso. 

dev.off()

# 4 classi all'interno delle quali distribuire i pixel. 
gcclass4 <- unsuperClass(gc, nClasses=4)
gcclass4
plot(gcclass4$map)
clc <- colorRampPalette(c('yellow','red','blue','black'))(100)
plot(gcclass4$map, col=clc)
