# Classification 
# Import some code already done
setwd("C:/lab") 
source("r_code.txt")

# Satellitar data
library(raster)
install.packages("RStoolbox")
library(RStoolbox)

# Solar Orbiter 
so <- brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg") 
so

plotRGB(so, 1,2,3, stretch="lin")
plotRGB(so, 1,2,3, stretch="hist")
soc <- unsuperClass(so, nClasses=3)
soc
plot(soc$map)

# It is possible to associate a pixel which is still not classificated to the nearest spectral class.  
dev.off()
gc <- brick("dolansprings_oli_2013088_canyon_lrg.jpg") 
gc
plotRGB(gc, r=1, g=2, b=3, stretch="hist") 
# Satellitar image already processed 

gcclass2 <- unsuperClass(gc, nClasses = 2 ) #non supervisionata, numero di campioni (samples)
gcclass2
# Classification gives us an object that includes the model, output map, statistics. 

plot(gcclass2$map)
# Two classes, two colors. 
dev.off()

# Four classes, four colors. 
gcclass4 <- unsuperClass(gc, nClasses=4)
gcclass4
plot(gcclass4$map)
clc <- colorRampPalette(c('yellow','red','blue','black'))(100)
plot(gcclass4$map, col=clc)
