library(raster)
install.packages("rgdal")
library(rgdal)
install.packages("RStoolbox") #Telerilevamento e PCA
library(RStoolbox)
library(rasterdiv)
install.packages("rasterdiv")

# Setting wd. 
setwd("C:/lab")

# Uploading a new image 
l1992 <- brick("defor1_.jpg")
plot(l1992)
l1992 

# Only three channles: we can use RGB components. 
plotRGB(l1992, r=1, g=2, b=3, stretch="lin") 
# Band number 1 stands for NIR: following the electromagnetic spectrum we mount the remaining two bands in sequence. 
# Layer 1 = NIR
# Layer 2 = red
# Layer 3 = green

# Second image: the aim is compare it with the elder image. 
l2006 <- brick("defor2_.jpg")
l2006


plotRGB(l2006, r=1, g=2, b=3, stretch="lin")
dev.off()

# Plot in a MultiFrame 
par(mfrow= c(2,1))
plotRGB(l1992, r=1, g=2, b=3, stretch="lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="lin")

# DVI: difference between NIR and red. Time 1
dvi1992 = l1992[[1]] - l1992[[2]]
dvi1992

cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100) # specifying a color scheme, DVI is one layer (we don't need $) 
plot(dvi1992, col=cl)
dev.off()

# Same for 2006
dvi2006 = l2006[[1]] - l2006[[2]]
plot(dvi2006, col=cl)

# MultiFrame 
par(mfrow=c(2,1)) 
plot(dvi1, col=cl, main="DVI at time 1")
plot(dvi2, col=cl, main="DVI at time 2")

# Compare 
dvi_diff = dvi1992 - dvi2006
cld <- colorRampPalette(c('blue','white','red'))(100)
plot(dvi_diff, col=cld)

# NDVI Time 1
# (NIR-RED) / (NIR+RED)
ndvi1992 = dvi1992 / (l1992[[1]] + l1992[[2]])
ndvi1992
plot(ndvi1992, col=cl)
dev.off()

par(mfrow= c(2,1))
plotRGB(l1992, r=1, g=2, b=3, stretch="lin")
plot(ndvi1992, col=cl)

# NDVI Time 2
ndvi2006 = dvi2006 / (l2006[[1]] + l2006[[2]])
ndvi2006

# MultiFrame of time 1 and 2
par(mfrow= c(2,1))
plot(ndvi1992, col=cl)
plot(ndvi2006, col=cl)

# RStoolbox
si1992 <- spectralIndices(l1992, green=3, red=2, nir=1)
plot(si1992, col=cl)
dev.off()
                
si2006 <- spectralIndices(l2006, green=3, red=2, nir=1)
plot(si2006, col=cl)
plot(copNDVI)
