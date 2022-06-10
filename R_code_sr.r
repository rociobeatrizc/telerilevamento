# Visualizzazione dei dati satellitari in R (Dati Landsat, 30m)

# Libreria per leggere e manipolare i dati satellitari.  
install.packages("raster")
library(raster) 

# Cartella di lavoro
setwd("C:/lab")


# RasterBrick: oggetto raster con più layer, la funzione brick importa tutti i dati. 
# Lo stesso pixel esiste in tutte le bande: in ciascuna di queste ha la propria riflettanza. 
l2011 <- brick("p224r63_2011.grd")

# Informazioni. Oggetto RasterBrick, dimensioni, bande...
l2011

# Plot in uno spazio generico XY: valori di riflettanza per ogni banda. 
plot(l2011)  

# colorRampPalette. Scelgo una serie di colori, poi adatto l'immagine alla palette da me scelta.
# Non essendoci soglie nette, si definiscono alla fine (100)
# Nero: bassa riflettanza. Bianco: alta riflettanza. 
cl <- colorRampPalette(c("black", "grey", "light grey")) (100) 
plot(l2011, col = cl)


# Nella banda 4 (NIR) la riflettanza è elevata, ciò significa che è presente vegetazione.
# La vegetazione in salute riflette la radiazione nell'infrarosso. 

# Bande Landsat
# B1: blu
# B2: verde
# B3: rosso
# B4: infrarosso vicino
# B5: infrarosso medio
# B6: infrarosso termico
# B7: infrarosso medio

# Plot di una singola banda, quella del blu (B1_sre). 
plot(l2011$B1_sre, col=cl)
plot(l2011[[1]])

cl_2 <- colorRampPalette(c("dark blue", "blue", "light blue")) (100)
plot(l2011$B1_sre, col=cl_2)

# Esportando in PDF l'immagine è quasi vettoriale. 
pdf("banda1.pdf")
plot(l2011$B1_sre, col=cl_2)
dev.off()

# Esporto in PNG 
png("banda1.png")
plot(l2011$B1_sre, col=cl_2)
dev.off()

# Plot B2: tre tonalità di verde.
cl_3 <- colorRampPalette(c("dark green", "green", "light green")) (100)
plot(l2011$B2_sre, col=cl_3)

# Esportare MultiFrame. 
# Una riga, due colonne. Array: insieme di caratteri uniti da c
pdf("multiframe.pdf")
par(mfrow= c(1,2))
plot(l2011$B1_sre, col=cl_2)
plot(l2011$B2_sre, col=cl_3)
dev.off()

# Si inverte il MF. 
par(mfrow= c(2,1))
plot(l2011$B1_sre, col=cl_2)
plot(l2011$B2_sre, col=cl_3)

# Altre due palette per attribuire a ciascuna banda colori diversi. 
cl_4 <- colorRampPalette(c("dark red", "red", "pink"))(100) # Red
cl_5 <- colorRampPalette(c("red", "orange", "yellow"))(100) # NIR

# MultiFrame con 4 bande. 
par(mfrow= c(2,2))
plot(l2011$B1_sre, col=cl_2)
plot(l2011$B2_sre, col=cl_3)
plot(l2011$B3_sre, col=cl_4) 
plot(l2011$B4_sre, col=cl_5)
