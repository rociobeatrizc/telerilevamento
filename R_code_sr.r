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
