rm(list=objects())
library("tidyverse")

#quale parametro: usare prcp per la precipitazione!!
PARAM<-c("prcp","tmax","tmin")[3] 
REGIONE<-"Piemonte"
nomeScript<-"descrizioneSerie.Rmd"
nomeHTML<-str_replace(nomeScript,"\\.Rmd$",".html")

DA_ELIMINARE<-c("")

if(grepl("^p",PARAM)){
  DA_ELIMINARE<-c("5616_1","5616_3","5647_2","5647_3","5649_1","5651_2","5651_3")  
}else if(grepl("max",PARAM)){
  DA_ELIMINARE<-c("5616_1","5616_3","5649_1")    
}else if(grepl("min",PARAM)){
  DA_ELIMINARE<-c("5616_1","5616_3","5649_1")    
}else{
  stop("Parametro non riconosciuto!")
}

rmarkdown::render(nomeScript,params = list(param=PARAM,regione=REGIONE,file_input="serie controllate",da_eliminare=DA_ELIMINARE),output_file =nomeHTML)
tolower(str_replace(str_remove(REGIONE," +"),"'",""))->REGIONE
system(glue::glue("mv {nomeHTML} {PARAM}.{REGIONE}.{nomeHTML}"))

