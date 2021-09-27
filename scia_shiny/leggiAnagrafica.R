leggiAnagrafica<-function(ffile){
  
  purrr::map_dfr(ffile,.f=~(read_delim(.,delim=";",col_names=TRUE,
                                       col_types = cols(SiteCode=col_character()),
                                       locale = locale(decimal_mark = ","))) %>%
                   
                   dplyr::select(SiteName,SiteCode,Elevation,Latitude,Longitude,annoInizio,annoFine,nome_rete))
  
}