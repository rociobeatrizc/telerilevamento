library(raster)
install.packages("rgdal")
library(rgdal)
setwd("C:/lab")

l1992 <- brick("defor1_.jpg")
plot(l1992)
l1992 
# tre sole bande. Il range va da 0 a 255, a differenza delle immagini precedenti (da 0 a 1)
# Shannon. Variare fra 0 e 1 ha un costo in termini di spazio. Quanta informazione c'è in un dato? 
# Teoria dell'informazione basata sui bit. 1 bit = 0 oppure 1, informazione binaria. 
# 2 bit: 4 informazioni. 3 bit: 8 informazioni. Informazioni = 2^n dove n è il numero di bit
2^8
# 256 possibili valori nelle immagini a 8 bit, da 0 a 255.
# Per plottare tre bande insieme abbiamo le componenti RGB

plotRGB(l1992, r=1, g=2, b=3, stretch="lin") # Si associa ad ogni componente una banda alla cieca
# La banda numero 1 è quella del NIR, l'ho associata al rosso e la vegetazione è rossa
# Le altre due bande si montano in sequenza. 2 rosso, 3 green seguendo lo spettro em. 
# layer 1 = NIR
# layer 2 = red
# layer 3 = green

l2006 <- brick("defor2_.jpg")
l2006

plotRGB(l2006, r=1, g=2, b=3, stretch="lin")
dev.off()

# Plot in a MultiFrame 
par(mfrow= c(2,1))
plotRGB(l1992, r=1, g=2, b=3, stretch="lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="lin")

# L'acqua assorbe molto nel NIR, l'acqua tende al nero nella seconda immagine. Nell'immagine sopra è visibile
# il sedimento del fiume, molto simile alla colorazione del suolo nudo. 
# Massimo DVI=255 (NIR-RED)

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
cld <- colorRampPalette(c('blue','white','red'))(100)

# Giallo = male, molta deforestazione. Per distruggere un habitat basta frammentarlo a sufficienza 
# Popolazioni non più a contatto (individui stessa specie)
# Si possono usare i nomi

# nomi: defor2_.1, defor2_.2, defor2_.3
# Per confrontarle si può fare la differenza 


dvi_diff = dvi1992 - dvi2006
cld <- colorRampPalette(c('blue','white','red'))(100)
plot(dvi_diff, col=cld)

# Zone rosse: forte deforestazione, differenza molto alta.  
