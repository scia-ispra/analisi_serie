source("estraiNomiRegioni.R")

leggiAnagrafica<-function(ffile){
  
  purrr::map_dfr(ffile,.f=function(nomeFile){
    
    estraiNomiRegioni(nomeFile)->regione
    
    
    readr::read_delim(nomeFile,delim=";",col_names=TRUE,col_types = readr::cols(SiteCode=col_character()),locale = readr::locale(decimal_mark = ",")) %>%
                   dplyr::select(SiteName,SiteCode,Elevation,Latitude,Longitude,annoInizio,annoFine,nome_rete) %>%
      dplyr::mutate(nome_regione=.env$regione)
    
  
  
  })
  
}#fine leggiAnagrafica