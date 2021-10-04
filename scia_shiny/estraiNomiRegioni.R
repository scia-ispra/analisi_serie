library("stringr")

estraiNomiRegioni<-function(.x){
  
  str_to_title(unlist(str_remove(str_remove(.x,"\\.anagrafica.+$"),"^.+\\.")))
  
}