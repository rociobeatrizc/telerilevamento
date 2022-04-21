# Classification 
# Import some code already done
setwd("C:/lab") 
source("r_code.txt")

# Satellitar data
library(raster)
install.packages("RStoolbox")
library(RStoolbox)

# Solar Orbiter 
so <- brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg") 
so

plotRGB(so, 1,2,3, stretch="lin")
plotRGB(so, 1,2,3, stretch="hist")
soc <- unsuperClass(so, nClasses=3)
soc
plot(soc$map)

# pixel non cancora classificato 
# come lo associo ad una classe? classe spettralmente più vicina 
# da caricare come R_code_classification.r
# siamo in grado di discriminare fra vari tipi mineralogici? Grand Canyon
dev.off()
gc <- brick("dolansprings_oli_2013088_canyon_lrg.jpg") #immagini spettrali (es rgb con tre bande) si importa con brick
gc
plotRGB(gc, r=1, g=2, b=3, stretch="hist") #immagine solo nel visibile 
# immagine già elaborata 
# classificazione 

gcclass2 <- unsuperClass(gc, nClasses = 2 ) #non supervisionata, numero di campioni (samples)
gcclass2
# La classifiocazione produce un oggetto che ha all'interno il modello in sè, la mappa in uscita, le statistiche 1variate
# restituisce solo map come output

plot(gcclass2$map)
# classe 1, classe 2, i valori intermedi non hanno senso. più che differenziazioni sono ombre
# ridefinire le classi perchè fanno schifo

dev.off()

gcclass4 <- unsuperClass(gc, nClasses=4)
gcclass4
plot(gcclass4$map)
clc <- colorRampPalette(c('yellow','red','blue','black'))(100)
plot(gcclass4$map, col=clc)
