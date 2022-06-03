# Species Distribution Modelling

install.packages("sdm")
library(sdm)
library(raster) # Predictors
library(rgdal) # Species 

# ggplot visualization 
# library(ggplot2)
# library(patchwork)
# library(viridis)
 
# In sdm we can already find a shapefile with the specie: there is no need to set the working directory.
file <- system.file("external/species.shp", package="sdm") 

# Path
file

# Spatial Point Dataframe (not raster file) with the occurrences of the specie (presence/absence)
species <- shapefile(file)
species

# Presence/absence  
plot(species, pch=19)

# Presence 1, absence 0. 
species$Occurrence

# Blue points: presence. Red points: absence. 
occ <- species$Occurrence
plot(species[occ == 1,], col='blue', pch=19)
points(species[occ == 0,], col='red', pch=19)
dev.off()

# Predictors are parameters that can be useful to predict where the specie is. 
# Path: system.file 
path <- system.file("external", package="sdm") 

# List of files (full.names keeps the original path).
lst <- list.files(path=path, pattern='asc$', full.names = T) 
lst

# It is not necessary to use brick function to import the list: is already inside the package. 
# Instead of bands, we have geographic data (proxy). 
preds <- stack(lst)
cl <- colorRampPalette(c('blue','orange','red','yellow')) (100)
plot(preds, col=cl)

# Predictors into a variable
elev <- preds$elevation
prec <- preds$precipitation
temp <- preds$temperature
vege <- preds$vegetation

# Exploring the specie's distribution with respect to each variable. 
# Elevation
plot(elev, col=cl)
points(species[occ == 1,], col='black', pch=19)

# Temperature 
plot(temp, col=cl)
points(species[occ == 1,], col='black', pch=19)

# Precipitation 
plot(prec, col=cl)
points(species[occ == 1,], col='black', pch=19)

# Vegetation 
plot(vege, col=cl)
points(species[occ == 1,], col='black', pch=19)

dev.off()

# Das Model: species and predictors as data. 
datasdm <- sdmData(train=species, predictors=preds)

# Linear model. 
# Y (output): occurrence. 
# X (input): predictors. 
m1 <- sdm(Occurrence ~ elevation + precipitation + temperature + vegetation, data=datasdm, methods = "glm")

# Prediction Map: raster file. 
p1 <- predict(m1, newdata=preds)
plot(p1, col=cl)
points(species[species$Occurrence == 1,], pch=16)

# MultiFrame with predictors.
par(mfrow=c(2,3))
plot(p1, col=cl)
plot(elev, col=cl)
plot(prec, col=cl)
plot(temp, col=cl)
plot(vege, col=cl)

# More easily: 
final <- stack(preds, p1)
plot(final, col=cl)
