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

# Pairing red with NIR
plotRGB(l2011, r=4, g=3, b=2, stretch="lin") 


# Le piante riflettono molto nell'infrarosso, il tessuto a palizzata fa sì che rimbalzi (venga riflesso) il NIR. 
# Tutto quello che riflette nel NIR diventa di colore rosso. Nel mezzo ci sono zome d'ombra (polmone)

# Si sposta l'infrarosso nella componente GREEN. Tutto quello che riflette nel NIR diventa verde. 

plotRGB(l2011, r=3, g=4, b=2, stretch="lin")

# Differenza di potenziale. 
# L'aria si muove da alta a bassa pressione. La pianta convince l'acqua in alta pressione (basso) a 
# tirare su acqua. Traspira tutta l'acqua dall'alto, la pressione diminuisce sulla chioma e l'acqua va verso l'alto.
# Meccanismo ciclico, rilascio d'acqua che torna in forma di pioggia. 
# Geometria frattale. I rami di una pianta si ripetono nello spazio. 

plotRGB(l2011, r=3, g=2, b=4, stretch="lin") #Tutto quello che diventa giallo è suolo nudo. 

# Stretch lineare. Presa una certa banda, in ascissa vedo le riflettanze: se queste vanno da un valore ad
# un valore preciso, prendo una funzione lineare per riportare a 0 ciò che ha il valore minimo
# e a 100 ciò che ha il valore massimo. Ampliamento dei valori possibili. 

# Stretch per istogrammi. Invece di usare una funzione lineare, si usa una curva che provoca un forte aumento. 

plotRGB(l2011, r=3, g=4, b=2, stretch="hist") 
# Alta differenziazione nelle colorazioni, si vedono elementi che altrimenti non si vedono. 
# Il NIR governa nel caso di vegetazione. Non c'è una composizione ideale. 
# Exercise: build a multiframe with visible RGB (lin. stretch) on top of false colours
# (hist. stretch)

par(mfrow= c(2,1)) #si ragiona per RIGHE
plotRGB(l2011, r=3, g=2, b=1, stretch="lin") #occhio umano
plotRGB(l2011, r=3, g=4, b=2, stretch="hist") #alta potenza risolutiva 

l1988 <- brick("p224r63_1988.grd")
l1988
dev.off()

par(mfrow= c(2,1))
plotRGB(l1988, r=4, g=3, b=2, stretch="lin")
plotRGB(l2011, r=4, g=3, b=2, stretch="lin")

#1988: inizio urbanizzazione, il colore è dovuto alla foschia. 
# Ora c'è una riserva naturale, motivo del bordo. Il sistema intorno deve essere sostenibile. 

