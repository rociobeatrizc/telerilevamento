# Indici spettrali. 
# Si possono usare le bande per visualizzare le immagini satellitari in modi differenti ed evidenziare alcune componenti dell'ecosistema rispetto ad altre. 
# L'NDVI (Normalized Difference Vegetation Index) è un indice spettrale di vegetazione basato sulla differenza fra le bande del NIR e del RED. 
# In un pixel con un periodo di picco di biomassa, in una scala di riflettanza (range da 0 a 100) il valore nel NIR sarà alto: lo stesso pixel ha una riflettanza nel rosso bassa. 
# DVI = NIR - RED
# In una pianta che soffre il mesofillo foliare collassa variando gli angoli di riflessione. 
# Si abbassa la riflettanza nel NIR, si innalza quella nel rosso (non viene assorbito a sufficienza). 

# Libreria per tutti i dati in formato immagine. 
library(raster)

# Libreria per usare dati spaziali. 
install.packages("rgdal")
library(rgdal)

# Toolbox for remote sensing image processing and analysis such as calculating spectral indices, principal component transformation, unsupervised and supervised classification or fractional cover analyses
install.packages("RStoolbox") 
library(RStoolbox)

install.packages("rasterdiv")
library(rasterdiv)

setwd("C:/lab")

# Earth Observatory NASA: Rio Peixoto, dati già analizzati. Si importano tutte le bande insieme. 
l1992 <- brick("defor1_.jpg")
plot(l1992)
l1992 

# Tre sole bande. Il range di valori di riflettanza va da 0 a 255, a differenza delle immagini precedenti (da 0 a 1). 
# La riflettanza è il rapporto fra luce riflessa e incidenza: può variare da 0 a 1 in valori decimali. 
# Shannon. Variare fra 0 e 1 ha un costo in termini di spazio. Quanta informazione c'è in un dato? 
# Teoria dell'informazione basata sui bit. 1 bit = 0 oppure 1, informazione binaria. 
# 2 bit: 4 informazioni. 3 bit: 8 informazioni. Informazioni = 2^n, dove n è il numero di bit

2^8
# 256 possibili valori nelle immagini a 8 bit, da 0 a 255.
# Per plottare tre bande insieme abbiamo le componenti RGB

plotRGB(l1992, r=1, g=2, b=3, stretch="lin") 
# Si associa ad ogni componente una banda alla cieca
# La banda numero 1 è quella del NIR, l'ho associata al rosso: la vegetazione è rossa
# Le altre due bande si montano in sequenza: 2 rosso, 3 green seguendo lo spettro elettromagnetico. 

# Layer 1 = NIR
# Layer 2 = Red
# Layer 3 = Green

l2006 <- brick("defor2_.jpg")
l2006

plotRGB(l2006, r=1, g=2, b=3, stretch="lin")
dev.off()

# Plot in a MultiFrame 
par(mfrow= c(2,1))
plotRGB(l1992, r=1, g=2, b=3, stretch="lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="lin")

# L'acqua assorbe molto nel NIR, infatti l'acqua tende al nero nella seconda immagine. Nell'immagine sopra è visibile
# il sedimento del fiume, molto simile alla colorazione del suolo nudo. 
# Massimo DVI= 255 (NIR-RED)

dvi1992 = l1992[[1]] - l1992[[2]]
dvi1992
# -114, 248 estremi. 
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100) # specifying a color scheme, DVI è un singolo strato
plot(dvi1992, col=cl)
dev.off()

dvi2006 = l2006[[1]] - l2006[[2]]
plot(dvi2006, col=cl)

par(mfrow=c(2,1)) 
plot(dvi1992, col=cl)
plot(dvi2006, col=cl)
# Giallo = male, molta deforestazione. Per distruggere un habitat basta frammentarlo a sufficienza 
# Popolazioni non siano più a contatto (individui stessa specie)

# Si possono usare i nomi
# nomi: defor2_.1, defor2_.2, defor2_.3

# Per confrontarle si può fare la differenza 
# Zone rosse: forte deforestazione, differenza molto alta. 
dvi_diff = dvi1992 - dvi2006
dvi_diff
cld <- colorRampPalette(c('blue','white','red'))(100)
plot(dvi_diff, col=cld)
 
# NDVI: differenza normalizzata. Si divide la differenza per la somma delle due bande: in questo modo si possono fare confronti. 
ndvi1992 = dvi1992 / (l1992[[1]] + l1992[[2]])
ndvi1992
plot(ndvi1992, col=cl)
dev.off()

# MF con immagine RGB e NDVI della prima immagine. 
par(mfrow= c(2,1))
plotRGB(l1992, r=1, g=2, b=3, stretch="lin")
plot(ndvi1992, col=cl)

# NDVI 2006
ndvi2006 = dvi2006 / (l2006[[1]] + l2006[[2]])
ndvi2006

# MF con i due NDVI 
par(mfrow= c(2,1))
plot(ndvi1992, col=cl)
plot(ndvi2006, col=cl)

# Spectral Indices: tutti gli indici che riguardano la nostra area di studio.
# 1992
si1992 <- spectralIndices(l1992, green=3, red=2, nir=1)
plot(si1992, col=cl)
dev.off()

# 2006
si2006 <- spectralIndices(l2006, green=3, red=2, nir=1)
plot(si2006, col=cl)

# Tutta la Terra. 
plot(copNDVI)
