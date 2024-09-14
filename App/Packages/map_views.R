library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyauthr)
library(shinyalert)
library(leaflet)
library(viridis)
library(leaflet.extras)
library(leaflet.esri)
library(htmlwidgets)


source("Packages/pull_geospatial.R")
source("Packages/pull_dataframe.R")



####### SET SYMBOLOGIES ########

status_pal <- colorFactor(palette = status_colors, levels = status_levels)






####### MAP VIEWS ########

createBaseMap <- function(){
  
  # Load Map with Borough Census Areas
  map <- leaflet() %>%
    addTiles() %>%
    setView(lng = -156, lat = 63.9, zoom = 4)
  
  # Return Map
  return(map)
  
}






updateMap <- function(){
  
  

  
}














