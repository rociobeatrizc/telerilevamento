# Questo è il primo script che useremo a lezione

# install.packages("raster")
library(raster)

# Settaggio cartella di lavoro
setwd("C:/lab")

# import
l2011 <- brick("p224r63_2011.grd") 
l2011

# plot generico in uno spazio xy
plot(l2011)

cl <- colorRampPalette(c("black", "grey", "light grey")) (100)
# https://www.r-graph-gallery.com/42-colors-names.html  Colori su R
plot(l2011, col = cl) 
