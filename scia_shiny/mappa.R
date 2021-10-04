mappa<-function(.x,colore){

leaflet(data=.x) %>%
  setView(lng=10,lat=42,zoom=6) %>%
  addTiles() %>%
  addCircleMarkers(lng=~Longitude,lat=~Latitude,color = colore,radius = 3,label=~SiteName,popup = ~glue::glue("<h4>{SiteName}</h4><div>SiteCode: {SiteCode}</div><div>Quota: {Elevation}</div>")) %>%
  addEasyButton(easyButton(icon="fa-globe",title="Reset zoom",onClick =JS("function(btn,map){map.setView({lng: 12,lat: 42},6);}") ))
  
}