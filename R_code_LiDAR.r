# LiDAR: tecnologia che si basa sul sensore attivo, diversamente dal sensore ottico. 
# Emette energia attraverso impulso laser, che ritorna al sensore: calcolando quanto tempo impiega, si trova la distanza dell'oggetto sul quale la luce è rimbalzata. 
# La risoluzione cambia sulla base della distanza: più vicini siamo, più la point cloud è accurata. 
# Il sensore può essere montato su elicotteri, aerei e droni, che scansionano dall'alto al basso. 
# Può anche trovarsi su un apparecchio fisso per scannerizzare frane. 
# ALS: Airborne Laser Scanner. Non fa foto, fa una scansione come un radar del terreno. 
# L'impulso ha diversi centimetri di diametro. Una parte dell'impulso torna indietro quando incontra il primo oggetto (primo ritorno). 
# Il primo ritorno rappresenta la superficie, l'ultimo punto è il terreno. 
# Una foresta più rada rimbalza la luce a diverse altezze. 
# Sottraendo ai punti più alti quelli più bassi si ottiene l'altezza degli alberi: boschi eterogenei hanno diversità di altezza hanno più specie al loro interno. 


# Da alcuni anni c'è GEDI, un satellite su cui è stato montato una tecnologia LiDAR (30, 10 m)
# Un drone scannerizza piccole regioni ma in modo molto accurato. 
# TLS è fisso, meglio per le applicazioni in ambito geologico.
# Canopy height, volume e classificazione delle specie: alcune riflettono il dato ad intensità diversa. 

install.packages("lidR")
## Creare CHM (Canopy) 

# Ogni regione ha uno o più dataset LiDAR, con DSM e DTM. 
# Load needed packages
library(raster) #"Geographic Data Analysis and Modeling"
library(rgdal)  #"Geospatial Data Abstraction Library"
library(viridis)
library(ggplot2)
library(RStoolbox)  # LiDAR

# Set WD
setwd("C:/lab/dati")

# Load DSM 2013
dsm_2013 <- raster("2013Elevation_DigitalElevationModel-0.5m.tif")

# Info
dsm_2013

# Plot the DSM 2013
plot(dsm_2013, main="Lidar Digital Surface Model San Genesio/Jenesien")

# Load DTM 2013
dtm_2013 <- raster("2013Elevation_DigitalTerrainModel-0.5m.tif")

# Plot DTM 2013
plot(dtm_2013, main="Lidar Digital Terrain Model San Genesio/Jenesien")

# Create CHM 2013 as difference between DSM and DTM.
chm_2013 <- dsm_2013 - dtm_2013

# View CHM attributes
chm_2013

# Plot CHM 2013
ggplot() + 
  geom_raster(chm_2013, mapping =aes(x=x, y=y, fill=layer)) + 
  scale_fill_viridis() +
  ggtitle("CHM 2013 San Genesio/Jenesien")

# Save the CHM on computer
writeRaster(chm_2013,"chm_2013_San_genesio.tif")


# Load DSM 2004
dsm_2004 <- raster("2004Elevation_DigitalElevationModel-2.5m.tif")

# View info about the raster: dato con risoluzione più bassa. 
dsm_2004

# Plot the DSM 2004
plot(dsm_2004, main="Lidar Digital Surface Model San Genesio/Jenesien")

# load DTM 2004
dtm_2004 <- raster("2004Elevation_DigitalTerrainModel-2.5m.tif")

# Plot DTM 2004
plot(dtm_2004, main="Lidar Digital Terrain Model San Genesio/Jenesien")

# Create CHM 2004 as difference between DSM and DTM
chm_2004 <- dsm_2004 - dtm_2004

# View CHM attributes
chm_2004

# Plot CHM 2004
ggplot() + 
  geom_raster(chm_2004, mapping =aes(x=x, y=y, fill=layer)) + 
  scale_fill_viridis() +
  ggtitle("CHM 2004 San Genesio/Jenesien")


# Save CHM on computer 
writeRaster(chm_2004,"chm_2004_San_genesio.tif")


# Error
difference_chm<-chm_2013-chm_2004

# Reseample 2013 to 2004 @2.5m
chm_2013_reseampled<-resample(chm_2013, chm_2004)

# Calculate difference in CHM
difference<-chm_2013_reseampled-chm_2004

# Plot the difference 
ggplot() + 
  geom_raster(difference, mapping =aes(x=x, y=y, fill=layer)) + 
  scale_fill_viridis() +
  ggtitle("difference CHM San Genesio/Jenesien")


# Save the rasters
writeRaster(chm_2013_reseampled,"chm_2013_reseampled_San_genesio.tif")
writeRaster(difference,"difference chm San_genesio.tif")


### Point Cloud

library(lidR)

# Load point cloud
point_cloud<-readLAS("C:lab/dati/LIDAR-PointCloudCoverage-2013SolarTirol.laz")

# Plot r3 point cloud
plot(point_cloud)
