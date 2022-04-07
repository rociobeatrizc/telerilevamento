# Time series analysis of Greenland LST data from Copernicus. 
install.packages("rasterVis")
library(raster)
library(rasterVis) 
library(rgdal)

# LST stands for Land Surface Temperature. 
# Setting work directory
setwd("C:/lab/greenland") 

# One satellitar image is made of channels: brick function loads the whole package of bands, but in this case we have four separated data. 
# raster function imports a single layer, one by one. 
lst2000 <- raster("lst_2000.tif")
lst2005 <- raster("lst_2005.tif")
lst2010 <- raster("lst_2010.tif")
lst2015 <- raster("lst_2015.tif")


lst2000
# 16 bit. 

plot(lst2015)
dev.off()

# MultiFrame 
cl <- colorRampPalette(c("blue","light blue","pink","red"))(100)
par(mfrow=c(4,1)) 
plot(lst2000, col=cl)
plot(lst2005, col=cl)
plot(lst2010, col=cl)
plot(lst2015, col=cl)

# In order to simplify the code, lapply is a fuction that applies raster function at each image. 
# First, a list is needed. 
rlist <- list.files(pattern="lst")
import <- lapply(rlist, raster)
import

# stack function puts layers together in a single file, like a satellitar frame. 
tgr <- stack(import)
tgr
dev.off()
plot(tgr[[1]], col=cl)

# or
plot(tgr$lst_2000, col=cl)

# RGB.
plotRGB(tgr, r=1, g=2, b=3, stretch="lin")
# Black part is in common. 
