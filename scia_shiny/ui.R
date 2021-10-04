#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library("htmltools")
library("shinydashboard")
library("leaflet")
library("DT")
library("shinycssloaders")
source("vars.R")



ui<-dashboardPage(
    skin = "blue",
    header=dashboardHeader(title="SCIA"),
    sidebar = dashboardSidebar(
      shiny::selectInput("parametro","Parametro",choices=parametri,multiple=FALSE),
      sliderInput("ai",label="Anno inizio serie",min=1961,max=2000,step=1,sep="",value=c(1961,2000)),
      sliderInput("af",label="Anno fine serie",min=2018,max=2020,step=1,sep="",value=c(2018,2020)),
      selectInput("regioni","Regioni",choices="",multiple = TRUE,selected = ""),      
      actionButton("vai",label = "Aggiorna rete stazioni")
    ),
    
    
    body = dashboardBody(
      
      fluidRow(
        
        tabBox(
          tabPanel(title="Mappa",withSpinner(leafletOutput("mappa",width="100%",height=800),type=1)),
          tabPanel(title="Dati",withSpinner(DT::dataTableOutput("tabella"))),
          title=textOutput("titolo"),
          width=12
      )),
     
      
    )
)