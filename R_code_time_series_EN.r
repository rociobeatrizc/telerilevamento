# A consequence of the first lockdown on March 2020 due to COVID-19 was a significant decrease of nitrogen oxides. 
# Sentinel2, a satellite with a power resolution of 10 meters, is able to measure nitrogen oxide through reflectances. 

library(raster)

# In our directory there is a set of 13  Sentinel's images, from January to March. 
setwd("C:/lab/EN") 

# Raster function works on a single layer: in this case we consider the first image, dating back to January 2020  
EN01 <- raster("EN_0001.png")
cl <- colorRampPalette(c('red','orange','yellow'))(100) 
plot(EN01, col=cl)
dev.off()

# Thirteenth image shows a decrease in nitrogen circulation. 
EN13 <- raster("EN_0013.png")
plot(EN13, col=cl)

# Import all the images
EN01 <- raster("EN_0001.png")
EN02 <- raster("EN_0002.png")
EN03 <- raster("EN_0003.png")
EN04 <- raster("EN_0004.png")
EN05 <- raster("EN_0005.png")
EN06 <- raster("EN_0006.png")
EN07 <- raster("EN_0007.png")
EN08 <- raster("EN_0008.png")
EN09 <- raster("EN_0009.png")
EN10 <- raster("EN_0010.png")
EN11 <- raster("EN_0011.png")
EN12 <- raster("EN_0012.png")
EN13 <- raster("EN_0013.png")

# Plot all data together 
par(mfrow=c(4,4))
plot(EN01, col=cl)
plot(EN02, col=cl)
plot(EN03, col=cl)
plot(EN04, col=cl)
plot(EN05, col=cl)
plot(EN06, col=cl)
plot(EN07, col=cl)
plot(EN08, col=cl)
plot(EN09, col=cl)
plot(EN10, col=cl)
plot(EN11, col=cl)
plot(EN12, col=cl)
plot(EN13, col=cl)

# Stacking vectors concatenates multiple vectors into a single vector along with a factor indicating where each observation originated.  nstacking reverses this operation
EN <- stack(EN01, EN02, EN03, EN04, EN05, EN06, EN07, EN08, EN09, EN10, EN11, EN12, EN13)

# importing all the data together with the lapply function
rlist <- list.files(pattern="EN")
rlist
list_rast <- lapply(rlist, raster)
list_rast 

# stack functions puts all the data in a single file
EN_stack <- stack(list_rast)
EN_stack

# Exercise: plot only the first image of the stack
cl <- colorRampPalette(c('red','orange','yellow'))(100) # 
plot(EN_stack$EN_0001, col=cl)
# or
plot(EN_stack[[1]], col=cl)

# automated processing source function
source("name_of_your_file.r")

# Plot EN01 besides EN13: two ways. 
# MultiFrame
par(mfrow=c(1,2))
plot(stack_EN$EN_0001, col=cl, main="First image")
plot(stack_EN$EN_0013, col=cl, main="Last Image")

# Or two elements stack
s_113 <- stack(stack_EN[[1]], stack_EN[[13]])
plot(s_113, col=cl) 

# Difference between first and last recording of nitrogen oxide. 
difen <- stack_EN[[1]] - stack_EN[[13]]
cldif <- colorRampPalette(c('blue','white','red'))(100)
plot(difen, col=cldif) 
