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

# Si prendono tutti i file con estensione asc e si crea una lista: full.names conserva il percorso
lst <- list.files(path=path, pattern='asc$', full.names = T) 
lst

# Essendo già dentro al pacchetto, non abbiamo bisogno della funzione brick per importare la lista. 
# Al posto delle bande, abbiamo 4 variabili: i dati geografici sono i proxy. 
preds <- stack(lst)
cl <- colorRampPalette(c('blue','orange','red','yellow')) (100)
plot(preds, col=cl)

# Assegniamo ogni predittore ad una variabile 
elev <- preds$elevation
prec <- preds$precipitation
temp <- preds$temperature
vege <- preds$vegetation

# Organismo a cui non piace stare a quote elevate. 
plot(elev, col=cl)
points(species[occ == 1,], col='black', pch=19)

# Specie che non ama il freddo.  
plot(temp, col=cl)
points(species[occ == 1,], col='black', pch=19)

# Medio alta quantità di precipitazioni. 
plot(prec, col=cl)
points(species[occ == 1,], col='black', pch=19)

# Specie che non si trova dove la vegetazione scarseggia.  
plot(vege, col=cl)
points(species[occ == 1,], col='black', pch=19)

dev.off()

# Das Model: funzioni all'interno del pacchetto sdm. Specie e predittori sono i dati. 
# Train, Test. 
datasdm <- sdmData(train=species, predictors=preds)

# Modello lineare per ogni variabile. y = Occurrence (in output), le x sono i predittori. 
m1 <- sdm(Occurrence ~ elevation + precipitation + temperature + vegetation, data=datasdm, methods = "glm")

# Predizione della mappa finale. Oggetto raster con la probabilità di trovare la specie nello spazio: mappa di previsione.   
p1 <- predict(m1, newdata=preds)
plot(p1, col=cl)
points(species[species$Occurrence == 1,], pch=16)

# Dati suddivisi fra Train e Test, il problema è che i dati devono essere tanti.  
# Altro metodo: BootStrap, si tolgono una serie di dati. 
# MultiFrame con le variabili.
par(mfrow=c(2,3))
plot(p1, col=cl)
plot(elev, col=cl)
plot(prec, col=cl)
plot(temp, col=cl)
plot(vege, col=cl)

# In alternativa
final <- stack(preds, p1)
plot(final, col=cl)
