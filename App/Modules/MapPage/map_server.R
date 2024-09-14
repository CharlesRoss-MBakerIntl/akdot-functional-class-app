library(shiny)
library(sf)
library(shinyWidgets)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyauthr)
library(shinyalert)
library(leaflet)
library(leaflet.esri)
library(htmlwidgets)
library(dplyr)


source("Modules/MapPage/map_startup.R")
source("Modules/MapPage/observe_map.R")
source("Modules/MapPage/observe_filters.R")


source("Packages/map_views.R")
source("Packages/pull_geospatial.R")
source("Packages/pull_dataframe.R")




mapServer <- function(input, output, session) {
  
  
  ##### RUN STARTUP ######
  mapStartup(input, output, session)
  
  
  #######  OBSERVE FILTERS  #######
  #observeFilters(input, output, session)

  
  #######  OBSERVE MAP  #######
  #observeMap(input, output, session)
  

  
} #CLOSE SERVER
  
  
  
  
  

  
  
  
  
  
