library("shiny")
library("purrr")
library("dplyr")
library("readr")
library("stringr")
library("leaflet")
source("leggiAnagrafica.R")

server<-function(input,output){
  
  reactive({
   
    if(grepl("^P",input$parametro)){
      
      "prcp"
  
      
    }else if(grepl("[Mm]assima",input$parametro)){
      
      "tmax"
      
    }else{
      
      "tmin"
      
    }
    
    
  })->param
  

  reactive({
    
    list.files(pattern=glue::glue("^{param()}.+\\.anagrafica\\.stazioni_valide\\.csv$"))
    
  })->ffile
  
  
  observe({
    

    str_to_title(unlist(str_remove(str_remove(ffile(),"\\.anagrafica.+$"),"^.+\\.")))->regioni
    c("Seleziona tutte le stazioni",regioni)->regioni
    
    updateSelectInput(inputId = "regioni",label = "Regioni",choices = regioni,selected = regioni[1])
    
    
    
  })
  
  
  
  
  reactive({
    
    

    
    if(length(ffile())){

      if(!"Seleziona tutte le stazioni" %in% input$regioni){
        leggiAnagrafica(ffile()[purrr::map_int(tolower(input$regioni),.f=~(grep(.,ffile())))])
      }else{
        leggiAnagrafica(ffile())
      }
      
      
    }else{
      stop("File non trovati")
    }
    
  })->ana
  
  
  
  output$mappa<-renderLeaflet({
    
    coloreMarkers<-c("green","red","blue")
    names(coloreMarkers)<-parametri

    leaflet(data=ana() %>% filter(annoInizio>= input$ai[1] &  annoInizio<= input$ai[2] & annoFine>= input$af[1] & annoFine<= input$af[2]) ) %>%
      setView(lng=10,lat=42,zoom=6) %>%
      addTiles() %>%
      addCircleMarkers(lng=~Longitude,lat=~Latitude,color = as.character(coloreMarkers[input$parametro]),radius = 3,label=~SiteName,popup = ~glue::glue("<h4>{SiteName}</h4><div>SiteCode: {SiteCode}</div><div>Quota: {Elevation}</div>")) %>%
      addEasyButton(easyButton(icon="fa-globe",title="Reset zoom",onClick =JS("function(btn,map){map.setView({lng: 12,lat: 42},6);}") ))
    
    
  })
  
  output$tabella<-renderDataTable({datatable(ana() %>% filter(annoInizio>= input$ai[1] &  annoInizio<= input$ai[2] & annoFine>= input$af[1] & annoFine<= input$af[2]) )})
  output$titolo<-renderText(input$parametro)
  
}#fine server