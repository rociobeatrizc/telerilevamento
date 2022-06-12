# Analisi della capitale del Cile: Santiago del Cile (zona sud-est). 

# La cementificazione e la frammentazione degli spazi verdi sono problemi comuni alla maggior parte delle capitali sudamericane. 
# In Cile questo problema è aggravato dal fatto che buona parte della popolazione del paese (oggi circa 18 milioni di abitanti) vive nella capitale (6 milioni di abitanti).
# Si prendono in considerazione tre anni differenti: 1990, 2000 e 2010. 
# Fra il 1990 e il 2000 c'è stato un incremento di 2 milioni di persone in tutto il paese: anche fra il 2000 e il 2010 l'aumento è stato di 2 milioni. 
# Lo scopo del seguente codice è capire, a grandi linee, come la capitale ha risposto nelle due decadi a tale crescita demografica. 
# Di ogni anno si sceglie il mese di Novembre, essendo primavera nell'emisfero sud. 

## Librerie:
library(raster)      # Lettura immagini raster
library(patchwork)   # Composizione grafici
library(ggplot2)     # Grafici
library(RStoolbox)   # Strumenti per la manipolazione di immagini telerilevate
library(viridis)     # Visualizzazione
library(rasterdiv)   

# Set WD
setwd("C:/lab/esame")


### Import Immagini: dal satellite Landsat5, la cui risoluzione è 30x30.  

# Le immagini non hanno bordi omogenei, è necessario ridefinirle. 
# Con drawExtent si ricavano le coordinate delle estremità di un'immagine (pacchetto raster). 
# Si crea un vettore con le coordinate, che verrà utilizzato per ritagliare con crop (pacchetto raster).
land_ext <- extent(c(349057.8, 360359.5, -3724766, -3712488))

# Prima immagine: Novembre 1990.
# Trattandosi di un'immagine satellitare a più bande, si usa brick. 
lan90 <- brick("Landsat90.tif") 
lan90 <- crop(lan90, land_ext)
lan90
# Oggetto RasterBrick con 6 bande selezionate in fase di download. 

# Bande Landsat
# SR_B1 = Blue
# SR_B2 = Green
# SR_B3 = Red
# SR_B4 = NIR 
# SR_B5 = SWIR1
# SR_B7 = SWIR2

# Seconda immagine: Novembre 2000. 
lan00 <- brick("Landsat00.tif") 
lan00 <- crop(lan00, land_ext)

# Terza Immagine:Novembre 2010. 
lan10 <- brick("Landsat10.tif") 
lan10 <- crop(lan10, land_ext)


### Prima visualizzazione con RGB. 

# Al posto del rosso nello schema RGB, si pone il NIR.
# Necessario lo stretch a istogramma per far risaltare i contrasti. 
# Si assegnano i tre plot a tre variabili diverse.
g1 <- ggRGB(lan90, 4, 2, 1, stretch = "hist") + 
  labs(x="Longitude",y="Latitude") +
  ggtitle("1990")
 
g2 <- ggRGB(lan00, 4, 2, 1, stretch = "hist") + 
  labs(x="Longitude",y="Latitude") +
  ggtitle("2000")

g3 <- ggRGB(lan10, 4, 2, 1, stretch = "hist") +
  labs(x="Longitude",y="Latitude") +
  ggtitle("2010")

# Patchwork consente di visualizzare insieme le tre immagini. 
patchwork1 <- g1 + g2 + g3 
patchwork1 + plot_annotation(
  title = 'Santiago de Chile',
  subtitle = 'Puente Alto Municipality',
  caption = 'Source: Landsat5')

# La maggior parte della scomparsa delle zone verdi avviene fra il 1990 e il 2000.
# Fra 2000 e 2010 sembra esserci ulteriore frammentazione e cementificazione. 
# Tali trend verranno analizzati meglio in seguito. 

dev.off()


# Salva PDF con un grafico per pagina. 
pdf("RGB_santiago.pdf")
print(g1 + plot_annotation(
  title = 'Santiago de Chile',
  subtitle = 'Puente Alto Municipality',
  caption = 'Source: Landsat5'))
print(g2 + plot_annotation(
  title = 'Santiago de Chile',
  subtitle = 'Puente Alto Municipality',
  caption = 'Source: Landsat5'))
print(g3 + plot_annotation(
  title = 'Santiago de Chile',
  subtitle = 'Puente Alto Municipality',
  caption = 'Source: Landsat5'))
dev.off()


### NDVI = (NIR - RED) / (NIR+RED)

# Calcolo NDVI, poi si assegna l'immagine ottenuta ad una variabile. 
# I colori scelti appartengono a viridis per una visualizzazione più inclusiva. 

# NDVI 1990
ndvi90 <- (lan90[[4]]-lan90[[3]]) / (lan90[[4]]+lan90[[3]])
ndviplot1 <- ggplot() +
  geom_raster(ndvi90, mapping = aes(x=x, y=y, fill=layer), show.legend = FALSE) +
  scale_fill_viridis(option = "magma", name = "NDVI values") +
  labs(x="Longitude",y="Latitude") +
  ggtitle("1990")

# NDVI 2000
ndvi00 <- (lan00[[4]]-lan00[[3]]) / (lan00[[4]]+lan00[[3]])
ndviplot2 <- ggplot() +
  geom_raster(ndvi00, mapping = aes(x=x, y=y, fill=layer, ), show.legend = FALSE) +
  scale_fill_viridis(option = "magma", name = "NDVI values") +
  ggtitle("2000")

# NDVI 2010
ndvi10 <- (lan10[[4]]-lan10[[3]]) / (lan10[[4]]+lan10[[3]])
ndviplot3 <- ggplot() +
  geom_raster(ndvi10, mapping = aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option = "magma", name = "NDVI Values") +
  ggtitle("2010")

# Patchwork
patchwork2 <- ndviplot1 + ndviplot2 + ndviplot3
patchwork2 + plot_annotation(
  title = 'NDVI',
  subtitle = 'Santiago de Chile, Puente Alto Municipality',
  caption = 'Source: Landsat5')

dev.off()

# Salva PDF con un grafico per pagina. 
pdf("NDVI_santiago.pdf")
print(ndviplot1 + plot_annotation(
  title = 'Santiago de Chile',
  subtitle = 'Puente Alto Municipality',
  caption = 'Source: Landsat5'))
print(ndviplot2 + plot_annotation(
  title = 'Santiago de Chile',
  subtitle = 'Puente Alto Municipality',
  caption = 'Source: Landsat5'))
print(ndviplot3 + plot_annotation(
  title = 'Santiago de Chile',
  subtitle = 'Puente Alto Municipality',
  caption = 'Source: Landsat5'))
dev.off()


# Differenza di NDVI fra il 1990 e il 2000
diff_1 = ndvi90 - ndvi00
diffplot1 <- ggplot() +
  geom_raster(diff_1, mapping =aes(x=x, y=y, fill=layer), show.legend = FALSE) +
  scale_fill_gradientn(colours=c("#0000FFFF","#FFFFFFFF","#FF0000FF")) +
  ggtitle("1990-2000")

# Differenza di NDVI fra il 2000 e il 2010
diff_2 = ndvi00 - ndvi10
diffplot2 <- ggplot() +
  geom_raster(diff_2, mapping =aes(x=x, y=y, fill=layer)) +
  scale_fill_gradientn(colours=c("#0000FFFF","#FFFFFFFF","#FF0000FF"), name = "Difference") +
  ggtitle("2000-2010")

# Composizione
patchwork3 <- diffplot1 + diffplot2
patchwork3 + plot_annotation(
  title = 'NDVI Difference',
  subtitle = 'Santiago de Chile, Puente Alto Municipality')
# Le zone verdi scompaiono principalmente nella decade prima del 2000.
# In quella successiva prevale la costruzione di altre strade.

dev.off()

# Salva PDF con un grafico per pagina. 
pdf("NDVI_diff_santiago.pdf")
print(diffplot1 + plot_annotation(
  title = 'NDVI Difference',
  subtitle = 'Santiago de Chile, Puente Alto Municipality'))
print(diffplot2 + plot_annotation(
  title = 'NDVI Difference',
  subtitle = 'Santiago de Chile, Puente Alto Municipality'))
dev.off()


### Quantificare la perdita di aree verdi fra il 1990 e il 2000: Land Cover.  

# unsuperClass distribuisce i pixel dell'immagine in modo non supervisionato fra il numero di classi indicato. 
set.seed(3)
lan90c <- unsuperClass(lan90, nClasses = 3)
lan00c <- unsuperClass(lan00, nClasses = 3)

# Visualizzazione dell'oggetto raster contenuto in $map: putroppo i colori cambiano fra i due plot. 
par(mfrow=c(2,1))
set.seed(3)
plot(lan90c$map, main = "3 Classes")
plot(lan00c$map)

# Salva 2 PDF
pdf("class_santiago.pdf")
plot(lan90c$map, main = "3 Classes")
dev.off()
pdf("class2_santiago.pdf")
plot(lan00c$map)
dev.off()

# Totale di pixel delle immagini
lan90
lan00
# Coincidono: 153784
tot <- 153784

# Pixel per classe nella prima immagine. 
freq(lan90c$map)
#        value  count
# [1,]     1    63073 Cemento
# [2,]     2    52729 Roccia
# [3,]     3    37982 Aree verdi

prop_cemento_90 <- 63073 * 100/tot
prop_verde_90 <- 37982 * 100/tot
prop_roccia_90 <- 52729 * 100/tot

# Pixel per classe nella seconda immagine. 
freq(lan00c$map)
#         value  count
# [1,]     1     32155  Aree Verdi
# [2,]     2     66345  Cemento
# [3,]     3     55284  Roccia

prop_cemento_00 <- 66345 * 100/tot
prop_verde_00 <- 32155 * 100/tot
prop_roccia_00 <- 55284 * 100/tot

# Costruiamo un DataFrame attraverso il quale creare un barplot. 
# DataFrame: tre vettori, uno contiene le variabili, gli altri due i valori corrispondenti per i due diversi anni. 

# Primo vettore
class <- c("Green Areas", "Asphalt", "Soil") 

# 1990
prop_verde_90
# 24.7
prop_cemento_90
# 41.01
prop_roccia_90
# 34.3

# Secondo vettore
percent_90 <- c(24.7, 41.01, 34.3)

# 2000
prop_verde_00
# 20.9
prop_cemento_00
# 43.14
prop_roccia_00
# 35.9

# Terzo vettore
percent_00 <- c(20.9, 43.14, 35.9)

# DataFrame
percentages <- data.frame(class, percent_90, percent_00)

# BarPlot
barplot90 <- ggplot(percentages, aes(x=class, y=percent_90, color=class)) + 
  geom_bar(stat="identity", fill="white", show.legend = FALSE) + 
  theme(axis.title.x = element_blank(), axis.title.y = element_blank()) +
  ggtitle("1990")

barplot00 <- ggplot(percentages, aes(x=class, y=percent_00, color=class)) + 
  geom_bar(stat="identity", fill="white") + 
  theme(axis.title.x = element_blank(), axis.title.y = element_blank()) +
  labs(color = "Class") +
  ggtitle("2000")

# Composizione dei BarPlot
patchwork4 <- barplot90 + barplot00
patchwork4 + plot_annotation(
  title = 'Percentage of pixels per Class',
  subtitle = 'Santiago de Chile, Puente Alto Municipality')
# La diminuzione delle zone verdi c'è, ma è solo del 4%, diversamente da quanto si coglie ad occhio.
# Può essere dovuto alla forte frammentazione del territorio, che fa sì che unsuperClass non riesca a distinguere i pixel. 

# Salva PDF
pdf("barplot_santiago.pdf")
print(barplot90 + plot_annotation(
  title = 'Percentage of pixels per Class',
  subtitle = 'Santiago de Chile, Puente Alto Municipality'))
print(barplot00 + plot_annotation(
  title = 'Percentage of pixels per Class',
  subtitle = 'Santiago de Chile, Puente Alto Municipality'))
dev.off()


### Si procede l'analisi dell'eterogeneità per visualizzare meglio i pattern spaziali: a maggior variabilità corrisponde maggior biodiversità.  

# Si estrae da ogni immagine la banda del NIR. Viene scelta in quanto contiene la maggior parte delle informazioni sulla vegeteazione. 
nir1 <- lan90[[4]]
nir2 <- lan00[[4]]
nir3 <- lan10[[4]]

# Finestra mobile: matrice 3x3 che si sposta sull'immagine, calcola la deviazione standard, assegna quel valore al pixel centrale e si sposta di nuovo. 
# Tre nuovi file raster che esprimono la variabilità. 
sd1 <- focal(nir1, matrix(1/9, 3, 3), fun=sd)

sd2 <- focal(nir2, matrix(1/9, 3, 3), fun=sd)

sd3 <- focal(nir3, matrix(1/9, 3, 3), fun=sd)

# Plot Eterogeneità. 
et1 <- ggplot() +
  geom_raster(sd1, mapping =aes(x=x, y=y, fill=layer), show.legend = FALSE) +
  scale_fill_viridis(option = "rocket") +
  ggtitle("1990")

et2 <- ggplot() +
  geom_raster(sd2, mapping =aes(x=x, y=y, fill=layer), show.legend = FALSE) +
  scale_fill_viridis(option = "rocket") +
  ggtitle("2000")

et3 <- ggplot() +
  geom_raster(sd3, mapping =aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option = "rocket", name = "Variability") +
  ggtitle("2010")

# Patchwork 
patchwork5 <- et1 + et2 + et3
patchwork5 + plot_annotation(
  title = 'Land heterogeneity',
  subtitle = 'Santiago de Chile, Puente Alto Municipality')
# Diminuisce moltissimo, il cemento uniforma il paesaggio. 

# Salva PDF
pdf("variability_santiago.pdf")
print(et1 + plot_annotation(
  title = 'Land heterogeneity',
  subtitle = 'Santiago de Chile, Puente Alto Municipality'))
print(et2 + plot_annotation(
  title = 'Land heterogeneity',
  subtitle = 'Santiago de Chile, Puente Alto Municipality'))
print(et3 + plot_annotation(
  title = 'Land heterogeneity',
  subtitle = 'Santiago de Chile, Puente Alto Municipality'))
dev.off()


### Santiago del Cile oggi

# Landsat 9
# Band 1 = Ultra Blue (ultra blue, coastal aerosol) surface reflectance
# Band 2 = Blue
# Band 3 = Verde
# Band 4 = Rosso
# Band 5 = NIR

lan22 <- brick("Landsat22.tif") 
lan22 <- crop(lan22, land_ext)

g4 <- ggRGB(lan22, 5, 3, 2, stretch = "hist") + 
  labs(x="Longitude",y="Latitude") +
  ggtitle("2022")

patchwork6 <- g1 / g4
patchwork6 + plot_annotation(
  title = 'Santiago de Chile',
  caption = 'Source: Landsat5, Landsat9')

# Salva PDF
pdf("santiago_today.pdf")
g4 + plot_annotation(
  title = 'Santiago de Chile',
  caption = 'Source: Landsat9')
dev.off()
