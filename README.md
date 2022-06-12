# Telerilevamento Geo-Ecologico A.A. 2021-2022

## Scienze e Gestione della Natura
### Script: 

1) #### **R_code_sr.r**.
  *Visualizzazione dati satellitari in R (Riserva Indigena Parakanã)*. \
  Ogni pixel esiste nelle diverse bande con valori diversi di riflettanza, definita come il rapporto fra radiazione riflessa e radiazione incidente: questo valore vale   0 quando non c'è radiazione uscente, vale 1 quando tutta la radiazione incidente viene riflessa.\
  Visualizzazione secondo lo schema RGB. 
 
2) #### **R_code_spectral_indices.r** ####
*Indici Spettrali, vegetazione ed NDVI (deforestazione dell'area attorno a Rio Peixoto)*. \
In un pixel con un periodo di picco di biomassa, ovvero quando la vegetazione è in salute in una scala di riflettanza (range da 0 a 100) il valore nel NIR sarà alto: lo stesso pixel ha una riflettanza nel rosso bassa. \
*DVI = NIR - RED* \
In una pianta che soffre il mesofillo della foglia collassa variando gli angoli di riflessione: si abbassa la riflettanza nel NIR, si innalza quella nel rosso (non viene assorbito a sufficienza). \
L'**NDVI** (Normalized Difference Vegetation Index) è il DVI diviso per la somma di NIR e RED: essendo un valore normalizzato, consente di fare confronti. 

3) #### **R_code_time_series_greenland.r** ####
*Evoluzione nel tempo della Temperatura Superficiale in Groenlandia (Time Series Analysis)*. \
Utilizzando la temperatura della terra al suolo, si visualizza il variare di questo parametro nel tempo. I layer che contengono le temperature negli anni sono separati: si crea una sola immagine che li contiene tutti grazie alle funzioni *list.files, lapply* su *raster* e *stack*. 

4) #### **R_code_time_series_ EN.r** ####
  *Diminuzione di ossido di azoto durante il primo lockdown (Time Series Analysis)*. \
   Sentinel2 fornisce la quantità di ossidi di azoto presente in Europa. A causa della diminuzione del traffico dovuta al primo lockdown, questa quantità si abbassa. 
   
5) #### **R_code_classification.r** ####
  *Classificazione dei pixel all'interno di un'immagine (fasce energetiche Solar Orbiter, composizione mineralogica Grand Canyon)*.\
   In Solar Orbiter si dividono le regioni energetiche in 3 classi, nell'immagine del Grand Canyon in 2 e poi 4. 

6) #### **R_code_land_cover.r** ####
  *Mappe di Land Cover (sulla copertura del suolo attorno a Rio Peixoto in due diversi anni)*. \
  La classificazione può essere utile per contare quanti pixel appartengono a ciascuna classe, quantificando la differenza fra prima/dopo. 
  
7) #### **R_code_variability.r** ####
  *Variabilità di pattern spaziali (Ghiacciaio del Similaun).* \
  Maggior eterogeneità corrisponde a maggior biodiversità. Come misura della variabilità si prende la deviazione standard. \
  Applicando una finestra mobile (Moving Window) su una banda significativa, ovvero una matrice quadrata di dimensioni da stabilire, viene calcolata la deviazione       standard dei pixel all'interno della matrice: il risultato si colloca nel pixel centrale e la finestra si sposta fino a completare il file raster. 

8) #### **R_code_multivariate_analysis.r** ####
  *Analisi Multivariata, resampling e variabilità sulla Prima Componente (Riserva Indigena Parakanã, Ghiacciaio Similaun).* \
  Spesso è necessario compattare un sistema multidimensionale in un numero inferiore di variabili. La Principal Component Analysis ci permette di passare da più         bande fra loro correlate ad una sola, in grado di spiegare la maggior parte della variabilità: la variabile (banda) a cui si riduce il sistema viene detta Prima       Componente, ed è su quest'ultima che si lavora.  

9) #### **R_code_sdm.r** ####
  *Modello di Distribuzione di Specie*.\
  Un modello di distribuzione di specie ha lo scopo di fare predizioni su dove si trova una certa specie e fornire informazioni sulle variabili che condizionano la sua   distribuzione. A terra si misura la presenza/assenza di una determinata specie e per mezzo dei predittori (variabili ambientali) si fa una previsione della posizione   degli individui di tale specie dove non sono stati campionati. Il risultato è una mappa di probabilità, all'interno della quale i pixel hanno un valore compreso fra   0 e 1.  \
   1) Import shapefile contenente i punti che localizzano gli individui della specie: informazioni sulla presenza/assenza.  
   2) Import predittori, ovvero variabili ambientali. 
   3) Si assegna ogni predittore ad una variabile. 
   4) Creazione del modello lineare usando come train i punti, come predittori le variabili ambientali. 
   5) Mappa finale di previsione: oggetto raster con la probabilità di trovare la specie nello spazio. 
   La specie potrebbe essere il *Bufo Bufo*.
![rospaccio](https://user-images.githubusercontent.com/63868353/171892805-33846864-6692-4844-b808-3f21bf869782.jpg)


10) #### **R_code_colorist.r** ####
    *Pacchetto colorist per fornire metodologie aggiuntive per studiare, comprendere e comunicare le informazioni sulle distribuzioni delle specie nello spazio e nel   tempo.*

11) #### **R_code_esame_telerilevamento.r** ####
    Analisi del trend di cementificazione e scomparsa di aree verdi nel sud-est della capitale del Cile, Santiago, nel corso di due decadi (1990-2000, 2000-2010). \
    RGB, NDVI, differenza di NDVI, divisione dei pixel in classi ed eterogeneità del paesaggio. 

