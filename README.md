# Telerilevamento Geo-Ecologico A.A. 2021-2022

## Scienze e Gestione della Natura. 
#### Script: 

1) Visualizzazione dati satellitari in R (Riserva Indigena Parakanã): **R_code_sr.r**.\
Ogni pixel esiste nelle diverse bande con valori diversi di riflettanza, definita come il rapporto fra radiazione riflessa e radiazione incidente: questo valore vale 0 quando non c'è radiazione uscente, vale 1 quando tutta la radiazione incidente viene riflessa.

2) Indici Spettrali, vegetazione ed NDVI (deforestazione dell'area attorno a Rio Peixoto): **R_code_spectral_indices.r**\
In un pixel con un periodo di picco di biomassa, ovvero quando la vegetazione è in salute in una scala di riflettanza (range da 0 a 100) il valore nel NIR sarà alto: lo stesso pixel ha una riflettanza nel rosso bassa. \
DVI = NIR - RED \
In una pianta che soffre il mesofillo foliare collassa variando gli angoli di riflessione: si abbassa la riflettanza nel NIR, si innalza quella nel rosso (non viene assorbito a sufficienza). 
3) Evoluzione nel tempo della Temperatura Superficiale in Groenlandia (Time Series Analysis): **R_code_time_series_greenland.r**

4) Diminuzione di ossido di azoto durante il primo lockdown (Time Series Analysis): **R_code_time_series_ EN.r**

5) Classificazione dei pixel all'interno di un'immagine (fasce energetiche Solar Orbiter, composizione mineralogica Grand Canyon): **R_code_classification.r**

7) Mappe di Land Cover (sulla copertura del suolo attorno a Rio Peixoto in due diversi anni): **R_code_land_cover.r**

8) Variabilità di pattern spaziali (Ghiacciaio del Similaun): **R_code_variability.r**

9) Analisi Multivariata, resampling e variabilità sulla Prima Componente (Riserva Indigena Parakanã, Ghiacciaio Similaun): **R_code_multivariate_analysis.r**

10) Modello di Distribuzione di Specie: **R_code_sdm.r**
![rospaccio](https://user-images.githubusercontent.com/63868353/171892805-33846864-6692-4844-b808-3f21bf869782.jpg)

11) Pacchetto colorist per fornire metodologie aggiuntive per studiare, comprendere e comunicare le informazioni sulle distribuzioni delle specie nello spazio e nel tempo: **R_code_colorist.r**


