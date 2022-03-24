# First script

# install.packages("raster")
library(raster)

# Setting work directory
setwd("C:/lab")

# import
l2011 <- brick("p224r63_2011.grd") 
l2011

# plot in generic space xy
plot(l2011)

cl <- colorRampPalette(c("black", "grey", "light grey")) (100)
# https://www.r-graph-gallery.com/42-colors-names.html  Colors 
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

# Plot di una singola banda, quella del blu (B1_sre)
plot(l2011$B1_sre, col=cl)
plot(l2011[[1]])

cl_2 <- colorRampPalette(c("dark blue", "blue", "light blue")) (100)
plot(l2011$B1_sre, col=cl_2)

# Export as PDF in lab folder. Immagine quasi vettoriale
pdf("banda1.pdf")
plot(l2011$B1_sre, col=cl_2)
dev.off()

# png 
png("banda1.png")
plot(l2011$B1_sre, col=cl_2)
dev.off()

# plot B2 from dark green to green to light green
cl_3 <- colorRampPalette(c("dark green", "green", "light green")) (100)
plot(l2011$B2_sre, col=cl_3)

# Export Multiframe. Una riga, due colonne. Array: insieme di caratteri uniti da c
pdf("multiframe.pdf")
par(mfrow= c(1,2))
plot(l2011$B1_sre, col=cl_2)
plot(l2011$B2_sre, col=cl_3)
dev.off()

# Revert MF
par(mfrow= c(2,1))
plot(l2011$B1_sre, col=cl_2)
plot(l2011$B2_sre, col=cl_3)

cl_4 <- colorRampPalette(c("dark red", "red", "pink"))(100) #Red
cl_5 <- colorRampPalette(c("red", "orange", "yellow"))(100) #NIR
# MF con le 4 bande
par(mfrow= c(2,2))
plot(l2011$B1_sre, col=cl_2)
plot(l2011$B2_sre, col=cl_3)
plot(l2011$B3_sre, col=cl_4) #Red
plot(l2011$B4_sre, col=cl_5 ) #NIR
