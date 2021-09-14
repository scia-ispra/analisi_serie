rm(list=objects())
library("tidyverse")

#quale parametro: usare prcp per la precipitazione!!
PARAM<-c("prcp","tmax","tmin")[3] 
REGIONE<-"Emilia Romagna"
nomeScript<-"descrizioneSerie.Rmd"
nomeHTML<-str_replace(nomeScript,"\\.Rmd$",".html")

DA_ELIMINARE<-c("")

if(grepl("^p",PARAM)){
  DA_ELIMINARE<-c("12702_1")  
}else if(grepl("max",PARAM)){
  DA_ELIMINARE<-c("14354_1","9320_1")    
}else if(grepl("min",PARAM)){
  DA_ELIMINARE<-c("14354_1")    
}else{
  stop("Parametro non riconosciuto!")
}

rmarkdown::render(nomeScript,params = list(param=PARAM,regione=REGIONE,file_input="serie controllate",da_eliminare=DA_ELIMINARE),output_file =nomeHTML)
tolower(str_replace(str_remove(REGIONE," +"),"'",""))->REGIONE
system(glue::glue("mv {nomeHTML} {PARAM}.{REGIONE}.{nomeHTML}"))

