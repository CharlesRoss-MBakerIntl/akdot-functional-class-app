library(shiny)

source("Packages/pull_geospatial.R")
source("Packages/pull_dataframe.R")
source("Packages/map_views.R")



mapStartup <- function(input, output, session) {
  
  
  ######  PULL DATA  ######
  
  #Pull Borough Layers 
  bor_pull = renderPolygons(file = bor_census_file)
  
  #Pull Borough Table
  #bor_table = renderDataFrame(layer = bor_census_url)
  
  #Pull Census Table
  #census_table = renderDataFrame(layer = census_tracts_url)
  
  #Pull Route Data
  #route_table = renderDataFrame(layer = routes_url)
  
  
  
  
  ######  SAVE TABLE DATA  ######
  
  #Save Borough Data Table
  #boroughTable(bor_table)
  #boroughTableDefault(bor_table)
  
  #Save Borough Data Table
  #censusTable(census_table)
  #censusTableDefault(census_table)
  
  #Save Route Data Table
  #routeTable(route_table)
  #routeTableDefault(route_table)
  
  
  
  
  ######  SAVE MAP DATA  ######
  
  #Save to Default Data
  mapDataBoroughDefault(bor_pull)
  
  #Save to Current Map
  mapData(bor_pull$spatial)
  
  
  
  
  ######  SET BASE MAP  ######
  
  #Activate Borough Map
  output$Map <- renderLeaflet({
    
    # Attempt to Load Map
    tryCatch({
      
      map <- createBaseMap()
      
      
    }, error = function(e) {
      
      #Produce Shiny Alert if Map Fails to Load
      shinyalert(
        title = "Failed to Load GeoJSON",
        text = paste("GeoJSON Failed to Load Locations Map:", e),
        type = "error"
      )
    })
    
    
    #Return Map from Function
    return(map)
    
  })
  
  
  
  #Activate Boroughs
  output$boroughSelector <- renderUI({
    
    if (!is.null(boroughTable())) {
      
      #Create Census Select Item
      borough_select <- multiInput(
        inputId = "borough_selector",
        label = NULL, 
        choiceNames = boroughTable()$NAME,
        choiceValues = boroughTable()$FIPS
      )
    }
    
    return(borough_select)
    
  })
  
  
  
  #Activate Census Tracts
  output$censusTractsSelector <- renderUI({
    
    if (!is.null(censusTable())) {
      
      #Set Name, Choices for Input
      names <- paste(censusTable()$TRACT, censusTable()$COUNTY, sep = " - ")
      values <- censusTable()$TRACTFIPS
      
      
      #Create Census Select Item
      census_select <- multiInput(
        inputId = "census_tracts_selector",
        label = NULL, 
        choiceNames = names,
        choiceValues = values
      )
    }
    
    return(census_select)
    
  })
  
  

  
  
  #Activate Route Table
  output$routeSelector <- renderReactable({
    
    if (!is.null(routeTable())) {
      
      route_table <- reactable(
                        routeTable()[, c("Route_Name", "Route_ID", "Status")],
                        columns = list(
                          
                          # Route Name Column
                          Route_Name = colDef(
                            name = "Route Name",
                            show = TRUE,
                            cell = function(value) {
                              htmltools::tags$strong(value) # Bold the Route Name
                            }),
                          
                          #Route ID Column
                          Route_ID = colDef(show = TRUE,
                                            name = "Route ID",
                                            headerStyle = list(backgroundColor = "#f5f5f5", color = "#333", fontSize = "14px", padding = "10px")
                                            ),
      
                          
                          # #Borough Column
                          # Borough = colDef(show = TRUE,
                          #                  name = "Borough/Census Area"
                          #                  ),
                          
                          #Status Column
                          Status = colDef(show = TRUE,
                                          name = "Status",
                                          cell = function(value) {
                                            # Center the gauge and text
                                            htmltools::tags$div(
                                              style = "display: flex; justify-content: center; align-items: center; height: 100%;",
                                              htmltools::tags$div(
                                                style = "width: 80%; background-color: #f3f3f3; border-radius: 4px; position: relative; height: 20px;",
                                                htmltools::tags$div(
                                                  style = paste0("width: ", value, "; background-color: #4caf50; height: 100%; border-radius: 4px;"),
                                                  htmltools::tags$span(style = "display: block; text-align: center; color: white; font-weight: bold", paste0(value))
                                                )
                                              )
                                            )
                                          }
                          )
                          
                        ),
                        
                        #Additional Settings
                        defaultPageSize = 10,
                        highlight = TRUE,
                        striped = TRUE,
                        bordered = TRUE,
                        compact = TRUE
      )
          
    }
    
    return(route_table)
    
  })
  
}