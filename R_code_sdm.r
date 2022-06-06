# Species Distribution Modelling.
# La modellizzazione della distribuzione di specie ha due scopi: prevedere la distribuzione di una specie nello spazio e capire i parametri che la governano. 
# Un modello prende i dati a rilevati a terra sulla presenza/assenza di una specie. 
# Utilizzando i predittori (variabili ambientali), il modello stima dove non è stato fatto il campionamento qual è la probabilità di trovare quella specie in quel luogo.
# Si passa così da una mappa di punti ad una mappa continua di probabilità, dove i pixel hanno un valore compreso fra 0 e 1. 

# Pacchetto necessario per creare il modello. 
install.packages("sdm")

library(sdm)    # Specie e predittori (variabili ambientali). 
library(raster) # Lettura e analisi di dati spaziali. 
library(rgdal)  # Geospatial Data Abstraction Library.   

# Non si usa la WD, ma un file incluso nel pacchetto sdm che va caricato con system file (pacchetto raster).
file <- system.file("external/species.shp", package="sdm") 

# Path
file

# Non è un raster, ma uno Spatial Point Dataframe (punti nello spazio): nel file c'è la presenza/assenza della specie (Occurence). 
# Shapefile legge i file vettoriali
species <- shapefile(file)
species

# Plot della presenza di una specie nello spazio.  
plot(species, pch=19)

# Tabella di presenza/assenza. 
species$Occurrence
# 1 presenza, 0 assenza. 

# Plot  degli individui che hanno occorrenza uguale ad 1, cioè sono presenti, in blu. 
# Quelli assenti in rosso.  
occ <- species$Occurrence
plot(species[occ == 1,], col='blue', pch=19)
points(species[occ == 0,], col='red', pch=19)
dev.off()

# Predictors o Predittori: ci aiutano a prevedere dove sarà la specie. 
# Si ricava il path .
path <- system.file("external", package="sdm") 

# Si prendono tutti i file con estensione asc e si crea una lista: full.names conserva il percorso.
lst <- list.files(path=path, pattern='asc$', full.names = T) 
lst

# Essendo già dentro al pacchetto, non abbiamo bisogno della funzione brick per importare la lista. 
# Al posto delle bande abbiamo 4 variabili, i nostri predittori: quota, precipitazioni, temperatura, vegetazione.  
preds <- stack(lst)
cl <- colorRampPalette(c('blue','orange','red','yellow')) (100)
plot(preds, col=cl)

# Assegniamo ogni predittore ad una variabile 
elev <- preds$elevation
prec <- preds$precipitation
temp <- preds$temperature
vege <- preds$vegetation
 
plot(elev, col=cl)
points(species[occ == 1,], col='black', pch=19)
# Specie a cui non piace stare a quote elevate.

plot(temp, col=cl)
points(species[occ == 1,], col='black', pch=19)
# Specie che non ama il freddo. 

plot(prec, col=cl)
points(species[occ == 1,], col='black', pch=19)
# Si trova in luoghi con medio alta quantità di precipitazioni. 
  
plot(vege, col=cl)
points(species[occ == 1,], col='black', pch=19)
# Non si trova dove la vegetazione scarseggia.

dev.off()

# Das Model: funzioni all'interno del pacchetto sdm. Specie e predittori sono i dati. 
# All'interno del pacchetto sdm si trova sdmData, che costruisce il modello. 
datasdm <- sdmData(train=species, predictors=preds)
# I dati di train sono le specie, i predittori le variabili ambientali. 

# Modello lineare. 
m1 <- sdm(Occurrence ~ elevation + precipitation + temperature + vegetation, data=datasdm, methods = "glm")
# In input (x): dati ambientali (variabili indipendenti).
# In output (y): Occurence. 
# Metodo: glm, Generalized Linear Models. 

# Mappa finale di previsione: oggetto raster con la probabilità di trovare la specie nello spazio.    
p1 <- predict(m1, newdata=preds)
plot(p1, col=cl)
points(species[species$Occurrence == 1,], pch=16)

# MultiFrame con la mappa di previsione e le variabili.
par(mfrow=c(2,3))
plot(p1, col=cl)
plot(elev, col=cl)
plot(prec, col=cl)
plot(temp, col=cl)
plot(vege, col=cl)

# In alternativa
final <- stack(preds, p1)
plot(final, col=cl)
