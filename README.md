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

7) #### **R_code_land_cover.r** ####
  *Mappe di Land Cover (sulla copertura del suolo attorno a Rio Peixoto in due diversi anni)*. \
  La classificazione può essere utile per contare quanti pixel appartengono a ciascuna classe, quantificando la differenza fra prima/dopo. 
  
8) Variabilità di pattern spaziali (Ghiacciaio del Similaun): **R_code_variability.r**

9) Analisi Multivariata, resampling e variabilità sulla Prima Componente (Riserva Indigena Parakanã, Ghiacciaio Similaun): **R_code_multivariate_analysis.r**

10) Modello di Distribuzione di Specie: **R_code_sdm.r**
![rospaccio](https://user-images.githubusercontent.com/63868353/171892805-33846864-6692-4844-b808-3f21bf869782.jpg)

11) Pacchetto colorist per fornire metodologie aggiuntive per studiare, comprendere e comunicare le informazioni sulle distribuzioni delle specie nello spazio e nel tempo: **R_code_colorist.r**


