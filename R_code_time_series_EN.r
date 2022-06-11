# Durante il primo lockdown c'è stata una forte diminuzione di ossidi di azoto, che derivano direttamente dal traffico umano. 
# Lo scopo è visualizzare tale diminuzione usando Sentinel2, una missione spaziale ESA il cui satellite ha 10 metri di risoluzione.
# Sentinel2 è in grado di misurare anche l'ossido di azoto, basandosi sulle riflettanze.

# Libreria richiesta
library(raster)

# Cartella di lavoro
setwd("C:/lab/EN") 

# Funzioni per importare i dati.  
# BRICK: immagine satellitare a più bande. 
# RASTER: un solo layer.

# Prima immagine
EN01 <- raster("EN_0001.png")
cl <- colorRampPalette(c('red','orange','yellow'))(100) 
plot(EN01, col=cl)
dev.off()

# Ultima immagine: diminuzione consistente. 
EN13 <- raster("EN_0013.png") 
plot(EN13, col=cl)

# Importo separatamente tutti i file.
EN01 <- raster("EN_0001.png")
EN02 <- raster("EN_0002.png")
EN03 <- raster("EN_0003.png")
EN04 <- raster("EN_0004.png")
EN05 <- raster("EN_0005.png")
EN06 <- raster("EN_0006.png")
EN07 <- raster("EN_0007.png")
EN08 <- raster("EN_0008.png")
EN09 <- raster("EN_0009.png")
EN10 <- raster("EN_0010.png")
EN11 <- raster("EN_0011.png")
EN12 <- raster("EN_0012.png")
EN13 <- raster("EN_0013.png")

# Plot
par(mfrow=c(4,4))
plot(EN01, col=cl)
plot(EN02, col=cl)
plot(EN03, col=cl)
plot(EN04, col=cl)
plot(EN05, col=cl)
plot(EN06, col=cl)
plot(EN07, col=cl)
plot(EN08, col=cl)
plot(EN09, col=cl)
plot(EN10, col=cl)
plot(EN11, col=cl)
plot(EN12, col=cl)
plot(EN13, col=cl)

# Stack crea una sola immagine: ogni immagine di cui si compone diventa un layer. 
EN <- stack(EN01, EN02, EN03, EN04, EN05, EN06, EN07, EN08, EN09, EN10, EN11, EN12, EN13)

# Plot dello stack. 
plot(EN, col=cl)

# Plot della prima immagine dello stack. 
plot(EN$EN_0001, col=cl)

## Si semplifica il procedimento.
# Si importano con list.files i file che contengono la stringa "EN", creando una lista. 
rlist <- list.files(pattern="EN")
rlist

# A questa lista di file, si applica con lapply la stessa funzione: raster
list_rast <- lapply(rlist, raster)
list_rast

# Infine, stack mette insieme in un'unica immagine 
EN_stack <- stack(list_rast)
EN_stack

# Plot della prima immagine dello stack
cl <- colorRampPalette(c('red','orange','yellow'))(100) # 
plot(EN_stack$EN_0001, col=cl)

# oppure 
plot(EN_stack[[1]], col=cl)

# EN01 di fianco a EN13
par(mfrow=c(1,2))
plot(EN_stack$EN_0001, col=cl, main="inizio")
plot(EN_stack$EN_0013, col=cl, main="fine")
?plot

# Stack con le due immagini: nuova immagine con due layer. 
s_113 <- stack(EN_stack[[1]], EN_stack[[13]])
plot(s_113, col=cl) 
dev.off()

# Differenza fra azoto iniziale e finale. 
diff <- EN_stack[[1]] - EN_stack[[13]]

# oppure: dif <- EN_stack$EN_0001 - EN_stack$EN_0013
cldif <- colorRampPalette(c('blue','white','red'))(100)
plot(diff, col=cldif) 

# Zone d'Europa con la decrescita più forte. 
plotRGB(EN_stack, r=1, g=7, b=13, stretch="lin")
plotRGB(EN_stack, r=1, g=7, b=13, stretch="hist")
