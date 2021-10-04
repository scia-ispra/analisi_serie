library("shiny")
library("purrr")
library("dplyr")
library("readr")
library("stringr")
library("leaflet")
source("vars.R")
source("leggiAnagrafica.R")
source("estraiNomiRegioni.R")
source("mappa.R")



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
    
    param()->parametro
    list.files(pattern=glue::glue("^{parametro}.+\\.anagrafica\\.stazioni_valide\\.csv$"))
    
  })->ffile
  
  
  observe({
    
   
    str_remove(str_remove(str_extract(ffile(),"\\..+\\.anagrafica"),"^\\."),"\\..+")->nomiRegioni
    str_to_title(nomiRegioni)->nomiRegioni
    c("Seleziona tutte le stazioni",nomiRegioni)->nomiRegioniFinale
    
    updateSelectizeInput(inputId = "regioni",choices = nomiRegioniFinale,selected = nomiRegioniFinale[1])
    
  })
  

  reactive({

    leggiAnagrafica(ffile())      

  })->ana  
  
  
  observeEvent(input$parametro,{
    
      output$mappa<-renderLeaflet({
   
        ana() %>%  filter((annoInizio >= input$ai[1] & annoInizio<=input$ai[2])) %>%
          filter((annoFine >= input$af[1] & annoFine<=input$af[2]))->subAna
        
        mappa(.x=subAna,colore= as.character(coloreMarkers[input$parametro]))
        
      })
      

  })  
  
  
  observeEvent(input$parametro,{
    

    output$tabella<-DT::renderDataTable({
      
      
      ana() %>%  filter((annoInizio >= input$ai[1] & annoInizio<=input$ai[2])) %>%
        filter((annoFine >= input$af[1] & annoFine<=input$af[2]))->subAna

      DT::datatable(subAna)
      
    })
    
    
  })    
  
  
  observeEvent(input$vai,{
    
        ana()->subAna
    
    
        if(! "Seleziona tutte le stazioni" %in% input$regioni) {ana() %>% filter(nome_regione %in% input$regioni)->subAna}
          
        output$mappa<-renderLeaflet({
          
            subAna %>%  filter((annoInizio >= input$ai[1] & annoInizio<=input$ai[2])) %>%
            filter((annoFine >= input$af[1] & annoFine<=input$af[2]))->subAna
          
            validate(need(nrow(subAna)!=0,"Nessun dato disponibile per questa selezione"))

            mappa(.x=subAna,colore= as.character(coloreMarkers[input$parametro]))
          
        })
        
        output$tabella<-DT::renderDataTable({
          
          subAna %>%  filter((annoInizio >= input$ai[1] & annoInizio<=input$ai[2])) %>%
            filter((annoFine >= input$af[1] & annoFine<=input$af[2]))->subAna
          
          validate(need(nrow(subAna)!=0,"Nessun dato disponibile per questa selezione"))
          
          DT::datatable(subAna)
          
        })
    

  })  
  
  observeEvent(input$parametro,{
    
    updateSliderInput(inputId = "ai",label="Anno inizio serie",value = c(1961,2000),min = 1961,max=2000,step = 1)
    updateSliderInput(inputId = "af",label="Anno fine serie",value = c(2018,2020),min = 2018,max=2020,step = 1)
    updateActionButton(inputId = "vai",label = "Aggiorna rete stazioni")

  })

  
  output$titolo<-renderText(input$parametro)
  
  
}#fine server