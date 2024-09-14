# Load required libraries
library(shiny)
library(leaflet)
library(sf)

source("Packages/pull_geospatial.R")


# Pull Status Symbology
status_pal <- colorFactor(palette = status_colors, levels = status_levels)

# Pull Label Symbology




# Map Observe Logic
observeMap <- function(input, output, session){
  
  observe({
  
  # IF BOROUGH AND CENSUS OFF
  if ((boroughActive() == FALSE) & (censusActive() == FALSE)){
    
    
    #Update with Boroughs Default
    leafletProxy('Map') %>%
      clearGroup("Boroughs") %>%
      clearGroup("Census") %>%
      addPolygons(
        data = mapDataBoroughDefault()$spatial,
        color = ~status_pal(Status),          # Border color
        weight = 2.5,                    # Border weight
        fillColor = ~status_pal(Status),      # Fill color
        fillOpacity = 0.4,
        group = 'Boroughs'
      )%>%
      setView(lng = -156, lat = 63.9, zoom = 4)
    
    
    # IF BOROUGH ON AND CENSUS OFF
  } else if ((boroughActive() == TRUE) & (censusActive() == FALSE)) {
    
    
    #Update with Boroughs Default
    leafletProxy('Map') %>%
      clearGroup("Boroughs") %>%
      clearGroup("Census") %>%
      addPolygons(
        data = mapData()$spatial,
        color = ~status_pal(Status),          # Border color
        weight = 2.5,                    # Border weight
        fillColor = ~status_pal(Status),      # Fill color
        fillOpacity = 0.4,
        group = 'Boroughs'
      )%>%
      addLabelOnlyMarkers(
        data = mapData()$centroids,
        lng = ~centroid_long,  # Longitude of centroids
        lat = ~centroid_lat,   # Latitude of centroids
        label = ~TRACT,       # Field with labels
        labelOptions = labelOptions(
          noHide = TRUE,
          direction = 'center'
        ),
        group = 'Boroughs'
      )%>%
      fitBounds(lat1 = mapData()$extent$min_lat,
                lat2 = mapData()$extent$max_lat,
                lng1 = mapData()$extent$min_lng,
                lng2 = mapData()$extent$max_lng
      )
    
    
  } else if ((boroughActive() == FALSE) & (censusActive() == TRUE)) {
    
    #Update with Boroughs Default
    leafletProxy('Map') %>%
      clearGroup("Boroughs") %>%
      clearGroup("Census") %>%
      addPolygons(
        data = mapData()$spatial,
        color = ~status_pal(Status),          # Border color
        weight = 2.5,                    # Border weight
        fillColor = ~status_pal(Status),      # Fill color
        fillOpacity = 0.4,
        group = 'Census'
      )%>%
      addLabelOnlyMarkers(
        data = mapData()$centroids,
        lng = ~centroid_long,  # Longitude of centroids
        lat = ~centroid_lat,   # Latitude of centroids
        label = ~TRACT,       # Field with labels
        labelOptions = labelOptions(
          noHide = TRUE,
          direction = 'center'
        ),
        group = 'Census'
      )%>%
      fitBounds(lat1 = mapData()$extent$min_lat,
                lat2 = mapData()$extent$max_lat,
                lng1 = mapData()$extent$min_lng,
                lng2 = mapData()$extent$max_lng
      )
    }
    
  })
  
}