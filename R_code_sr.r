# Visualizzazione dei dati satellitari in R (Dati Landsat, 30m)

# Installazione pacchetto raster.
install.packages("raster")

library(raster) # Lettura e analisi di dati spaziali: contiene le funzioni base.

# Cartella di lavoro
setwd("C:/lab")


# RasterBrick: l'immagine satellitare è un oggetto raster con più layer, la funzione brick importa tutti i dati. 
# Un pixel esiste nelle bande con diverse riflettanze. 
l2011 <- brick("p224r63_2011.grd")

# Informazioni. Oggetto RasterBrick, dimensioni, bande...
l2011

# Plot in uno spazio generico XY
# Riflettanza in ogni banda
plot(l2011)  

# colorRampPalette. Scelgo una serie di colori, poi adatto l'immagine alla palette da me scelta.
# Non essendoci soglie nette, si definiscono alla fine (100)
# Nero: bassa riflettanza. Bianco: alta riflettanza. 
cl <- colorRampPalette(c("black", "grey", "light grey")) (100) 
plot(l2011, col = cl)


# Banda 4, riflettanza elevata. Se c'è vegetazione, c'è alta riflettanza. Legenda ad ogni singola banda. 
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

# Export Multiframe. Una riga, due colonne. Array: insieme di caratteri uniti da c
pdf("multiframe.pdf")
par(mfrow= c(1,2))
plot(l2011$B1_sre, col=cl_2)
plot(l2011$B2_sre, col=cl_3)
dev.off()

# revert MF
par(mfrow= c(2,1))
plot(l2011$B1_sre, col=cl_2)
plot(l2011$B2_sre, col=cl_3)

cl_4 <- colorRampPalette(c("dark red", "red", "pink"))(100) # Red
cl_5 <- colorRampPalette(c("red", "orange", "yellow"))(100) # NIR

# MF con 4 bande. 
par(mfrow= c(2,2))
plot(l2011$B1_sre, col=cl_2)
plot(l2011$B2_sre, col=cl_3)
plot(l2011$B3_sre, col=cl_4) 
plot(l2011$B4_sre, col=cl_5)


# RGB components. Every device works with the 3 essential colors scheme: red, green, blue.
# A satellitar plot needs three channels at once, assembled in correspondence of RGB scheme. 
plotRGB(l2011, r=3, g=2, b=1, stretch="lin") # stretch (linear or by histograms) amplifies and allows us to better see contrasts. 

# Pairing red with NIR means colour in red everything that reflects in NIR. Plants reflect radiation in IR. 
plotRGB(l2011, r=4, g=3, b=2, stretch="lin") 

# Shifting IR in green component. 
plotRGB(l2011, r=3, g=4, b=2, stretch="lin")

# Yellow = bare soil.  
plotRGB(l2011, r=3, g=2, b=4, stretch="lin") 

plotRGB(l2011, r=3, g=4, b=2, stretch="hist") # With "hist" we see elements that otherwise we wouldn't see. 

# Exercise: build a multiframe with visible RGB (linear stretch) on top of false colours (histogram stretch). 
par(mfrow= c(2,1)) 
plotRGB(l2011, r=3, g=2, b=1, stretch="lin") # Human sight
plotRGB(l2011, r=3, g=4, b=2, stretch="hist") # High resolution power

# Exercise: upload the image from 1988
l1988 <- brick("p224r63_1988.grd")
l1988
# dev.off()

par(mfrow= c(2,1))
plotRGB(l1988, r=4, g=3, b=2, stretch="lin")
plotRGB(l2011, r=4, g=3, b=2, stretch="lin")

# sessionInfo()
# Sys.time()
