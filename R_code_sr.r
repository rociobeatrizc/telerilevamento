# Visualizzazione dei dati satellitari in R (Dati Landsat, 30m)

# Libreria per leggere e manipolare i dati satellitari.  
install.packages("raster")
library(raster) 

# Cartella di lavoro
setwd("C:/lab")


# RasterBrick: oggetto raster con più layer, la funzione brick importa tutti i dati. 
# Lo stesso pixel esiste in tutte le bande: in ciascuna di queste ha la propria riflettanza. 
l2011 <- brick("p224r63_2011.grd")

# Informazioni. Oggetto RasterBrick, dimensioni, bande...
l2011

# Plot in uno spazio generico XY: valori di riflettanza per ogni banda. 
plot(l2011)  

# colorRampPalette. Scelgo una serie di colori, poi adatto l'immagine alla palette da me scelta.
# Non essendoci soglie nette, si definiscono alla fine (100)
# Nero: bassa riflettanza. Bianco: alta riflettanza. 
cl <- colorRampPalette(c("black", "grey", "light grey")) (100) 
plot(l2011, col = cl)


# Nella banda 4 (NIR) la riflettanza è elevata, ciò significa che è presente vegetazione.
# La vegetazione in salute riflette la radiazione nell'infrarosso. 

# Bande Landsat
# B1: blu
# B2: verde
# B3: rosso
# B4: infrarosso vicino
# B5: infrarosso medio
# B6: infrarosso termico
# B7: infrarosso medio

# Plot di una singola banda, quella del blu (B1_sre). 
plot(l2011$B1_sre, col=cl)
plot(l2011[[1]])

cl_2 <- colorRampPalette(c("dark blue", "blue", "light blue")) (100)
plot(l2011$B1_sre, col=cl_2)

# Esportando in PDF l'immagine è quasi vettoriale. 
pdf("banda1.pdf")
plot(l2011$B1_sre, col=cl_2)
dev.off()

# Esporto in PNG 
png("banda1.png")
plot(l2011$B1_sre, col=cl_2)
dev.off()

# Plot B2: tre tonalità di verde.
cl_3 <- colorRampPalette(c("dark green", "green", "light green")) (100)
plot(l2011$B2_sre, col=cl_3)

# Esportare MultiFrame. 
# Una riga, due colonne. Array: insieme di caratteri uniti da c
pdf("multiframe.pdf")
par(mfrow= c(1,2))
plot(l2011$B1_sre, col=cl_2)
plot(l2011$B2_sre, col=cl_3)
dev.off()

# Si inverte il MF. 
par(mfrow= c(2,1))
plot(l2011$B1_sre, col=cl_2)
plot(l2011$B2_sre, col=cl_3)

# Altre due palette per attribuire a ciascuna banda colori diversi. 
cl_4 <- colorRampPalette(c("dark red", "red", "pink"))(100) # Red
cl_5 <- colorRampPalette(c("red", "orange", "yellow"))(100) # NIR

# MultiFrame con 4 bande. 
par(mfrow= c(2,2))
plot(l2011$B1_sre, col=cl_2)
plot(l2011$B2_sre, col=cl_3)
plot(l2011$B3_sre, col=cl_4) 
plot(l2011$B4_sre, col=cl_5)

## RGB
# Si possono montare bande insieme per creare immagini a colori secondo lo schema RGB (Red, Green, Blue).  

# Canale NIR. 
cl_6 <- colorRampPalette(c("coral", "coral3", "dark red")) (100)
plot(l2011$B4_sre, col=cl_6)
dev.off()

# RGB components. Qualsiasi computer/apparato lavora con lo schema dei tre colori fondamentali: rosso, verde, blu.
# Un plot satellitare richiede tre bande per volta, che vanno montate in corrispondenza dello schema RGB.

# Bande Landsat
# B1: blue
# B2: green
# B3: red
# B4: NIR

# Rosso: banda 3. Verde: banda 2. Blu: banda 1. 
# stretch amplia per vedere meglio i contrasti, può essere lineare o a istogrammi
# Il risultato rappresenta la riserva naturale a 800 km esattamente come le vedrebbe l'occhio umano. 
plotRGB(l2011, r=3, g=2, b=1, stretch="lin") 

# Associando il rosso alla banda del NIR, tutto quello che riflette nel NIR diventa di colore rosso. 
# Nel mezzo ci sono zome d'ombra (polmone) 
# Le piante riflettono molto nell'IR, il tessuto a palizzata fa sì che rimbalzi (venga riflesso) il NIR. 
plotRGB(l2011, r=4, g=3, b=2, stretch="lin")

# Si sposta l'IR nella componente GREEN. Tutto quello che riflette nel NIR diventa verde. 
plotRGB(l2011, r=3, g=4, b=2, stretch="lin")

# Come fa un albero di diversi metri a condurre l'acqua fino in cima?
# La pianta rilascia acqua dalla chioma attraverso la traspirazione: in questo modo l'acqua in basso sale per differenza di potenziale (va verso una zona dove la pressione è minore).
# Si tratta di un meccanisco ciclico, l'acqua liberata torna sottoforma di pioggia. 

# NIR nel verde: tutto quello che diventa giallo è suolo nudo. 
plotRGB(l2011, r=3, g=2, b=4, stretch="lin") 

# Sullo stretch lineare: presa una certa banda, posti in ascissa i suoi valori, è possibile che questi siano circoscritti in un range. 
# Lo stretch crea una nuova banda all'interno della quale il valore minimo della banda originale viene posto come 0, mentre il valore massimo diventa 100. 
# In questo modo si ampliano i valori possibili, riscalandoli grazie ad una funzione lineare: aumento la potenza di visualizzazione dei colori.  
# Stretch per istogrammi: invece di usare una funzione lineare, si usa una curva che provoca un forte aumento. 
plotRGB(l2011, r=3, g=4, b=2, stretch="hist") 

# Grazie allo stretch lineare si vede un'alta differenziazione nelle colorazioni, si vedono elementi che altrimenti non si vedono. 
# Il NIR governa nel caso di vegetazione. Non c'è una composizione ideale nelle altre bande.
par(mfrow= c(2,1)) # Si ragiona per RIGHE
plotRGB(l2011, r=3, g=2, b=1, stretch="lin") # Occhio umano
plotRGB(l2011, r=3, g=4, b=2, stretch="hist") # Alta potenza risolutiva 

# Immagine fine anni '80
l1988 <- brick("p224r63_1988.grd")
l1988
dev.off()

# MultiFrame 
par(mfrow= c(2,1))
plotRGB(l1988, r=4, g=3, b=2, stretch="lin")
plotRGB(l2011, r=4, g=3, b=2, stretch="lin")

# 1988: inizio urbanizzazione, il colore è dovuto alla foschia (sensore diverso). Vengono aperte le prime strade. 
# Ora c'è una riserva naturale, motivo del bordo. Il sistema intorno deve essere sostenibile. 
