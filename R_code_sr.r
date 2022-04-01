# First script

# install.packages("raster")
library(raster)

# Setting work directory
setwd("C:/lab")

# Import
l2011 <- brick("p224r63_2011.grd") 
l2011

# Plot in generic space xy
plot(l2011)

# https://www.r-graph-gallery.com/42-colors-names.html  Colors 
cl <- colorRampPalette(c("black", "grey", "light grey")) (100)
plot(l2011, col = cl) 
# dev.off() function that turns off images 

# Band 4, high reflectance (vegetation) 

# Bande Landsat
# B1: blue
# B2: green
# B3: red
# B4: NIR
# B5: infrarosso medio
# B6: infrarosso termico
# B7: infrarosso medio

# Blue band (B1_sre) 
plot(l2011$B1_sre, col=cl) #by calling by name
plot(l2011[[1]]) #by position 

# Plot B1 (blue) from dark blue to blue to light blue
cl_2 <- colorRampPalette(c("dark blue", "blue", "light blue")) (100)
plot(l2011$B1_sre, col=cl_2)

# Export as PDF in lab folder: nearly a vector image
pdf("banda1.pdf")
plot(l2011$B1_sre, col=cl_2)
dev.off()

# Export as png image 
png("banda1.png")
plot(l2011$B1_sre, col=cl_2)
dev.off()

# Plot B2 (green) from dark green to green to light green
cl_3 <- colorRampPalette(c("dark green", "green", "light green")) (100)
plot(l2011$B2_sre, col=cl_3)

# Export Multiframe: 1 stands for one row, 2 for two columns. An array is an ensemble of characters united by c. 
pdf("multiframe.pdf")
par(mfrow= c(1,2))
plot(l2011$B1_sre, col=cl_2)
plot(l2011$B2_sre, col=cl_3)
# dev.off() to turn off

# Revert MF
par(mfrow= c(2,1))
plot(l2011$B1_sre, col=cl_2)
plot(l2011$B2_sre, col=cl_3)

# Two new palettes for red and NIR channels
cl_4 <- colorRampPalette(c("dark red", "red", "pink"))(100) #Red
cl_5 <- colorRampPalette(c("red", "orange", "yellow"))(100) #NIR

# MF of all bands 
par(mfrow= c(2,2))
plot(l2011$B1_sre, col=cl_2)
plot(l2011$B2_sre, col=cl_3)
plot(l2011$B3_sre, col=cl_4) #Red
plot(l2011$B4_sre, col=cl_5 ) #NIR

# Color images can be created by assembling bands: we use RGB system.  

# NIR channel
cl_6 <- colorRampPalette(c("coral", "coral3", "dark red")) (100)
plot(l2011$B4_sre, col=cl_6)
dev.off()

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

