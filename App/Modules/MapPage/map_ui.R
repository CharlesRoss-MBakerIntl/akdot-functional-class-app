library(shiny)
library(shinyWidgets)
library(reactable)
library(leaflet)
library(leaflet.esri)
library(htmlwidgets)



mapUI <- fluidPage(
  
  # First Column Map Page
  column(width = 3,
         offset = 0,
         style='padding:0px;',
         
         
         
         # Select Project Box   
         box(title = "Boroughs", id = 'borough_selection', width = 12, solidHeader = FALSE, status = 'primary', collapsible = TRUE, collapsed = FALSE,
             fluidRow(
               
               # SELECT STATUS
               column(
                 width = 12,
                 uiOutput("boroughSelector")
                )
             )
         ),
         
         
         # Select Project Box   
         box(title = "Census Tracts", id = 'census_tracts_selection', width = 12, solidHeader = FALSE, status = 'primary', collapsible = TRUE, collapsed = FALSE,
             fluidRow(
               
               # SELECT STATUS
               column(
                 width = 12,
                 uiOutput("censusTractsSelector")
               )
             )
         )
      
  ),
  
  # Second Column in Map Page
  column(width = 5,
         offset = 0,
         style='padding:0px;',
         
         # Map
         box(title = "Route Map", id = "editor_map",width = 12, solidHeader = F, status = 'primary', collapsible = FALSE, collapsed = FALSE,
             fluidRow(
               column(
                 width = 12,
                 leafletOutput("Map", height = "600px")  
               )
             )
         )
  ),
  
  
  # Second Column in Map Page
  column(width = 4,
         offset = 0,
         style='padding:0px;',
         
         # Map
         box(title = 'Route Selection', id = 'route_selection', width = 12, solidHeader = F, status = 'primary', collapsible = FALSE, collapsed = FALSE,
             fluidRow(
               column(
                 width = 12,
                 reactableOutput("routeSelector")
                 
               )
             )
         )
  ),
  
)


