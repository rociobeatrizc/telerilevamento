# Classification: from raster data to classes. 
# Import some code already done
setwd("C:/lab") 
source("r_code.txt")

# Satellitar data
library(raster)

# unsuperClass
install.packages("RStoolbox") 
library(RStoolbox)

# Solar Orbiter 
so <- brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg") 
so

plotRGB(so, 1,2,3, stretch="lin")
plotRGB(so, 1,2,3, stretch="hist")

# We set 3 classes: pixels will be divided into these. 
soc <- unsuperClass(so, nClasses=3)
soc
plot(soc$map)
dev.off()

# Grand Canyon
# https://landsat.visibleearth.nasa.gov/view.php?id=80948
# When John Wesley Powell led an expedition down the Colorado River and through the Grand Canyon in 1869, he was confronted with a daunting landscape. 
# At its highest point, the serpentine gorge plunged 1,829 meters (6,000 feet) from rim to river bottom, making it one of the deepest canyons in the United States. 
# In just 6 million years, water had carved through rock layers that collectively represented more than 2 billion years of geological history, nearly half of the time Earth has existed.

# It is possible to associate a pixel which is still not classificated to the nearest spectral class. 
# Import satellitar image already processed. 
gc <- brick("dolansprings_oli_2013088_canyon_lrg.jpg") 
gc
plotRGB(gc, r=1, g=2, b=3, stretch="hist") 

# Two classes. 
gcclass2 <- unsuperClass(gc, nClasses = 2 ) )
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
