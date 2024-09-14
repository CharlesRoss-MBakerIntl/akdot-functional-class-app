library(shiny)

source("Packages/pull_geospatial.R")
source("Packages/pull_dataframe.R")


# Observe 
observeFilters <- function(input, output, session) {
  
  
  
  ####  OBSERVE BOROUGH FILTER  #####
  observeEvent(input$borough_selector,{
    
    #If Selection is not Null
    if (is.null(input$borough_selector) == FALSE){
      
      # Set Borough Filter Active
      boroughActive(TRUE)
      
      # Set Borough Filter Values
      boroughSel(input$borough_selector)
      
      
      # Update the Census Tracts Table back to Full
      censusTable(updateDataFrame(layer = census_tracts_url))
      
      # Filter Census Tracts Table 
      censusTable(censusTable() %>% filter(COUNTYFIPS %in% boroughSel()))
      
      
      # Filter the Map Data
      filtered <- updatePolygons(layer = census_tracts_url, 
                                 where = where_statement(field = "COUNTYFIPS", 
                                                         values = boroughSel(),
                                                         format = "str")
      )
      
      # Update Map Data
      mapData(filtered)
      
      
    } #CLOSE MONITOR BOROUGH SELECTOR INPUT
    
  
    ### MONITOR WHEN FILTER EMPTY ###
    
    observe({
      
      #If Selection Active and Is Now Null
      if ((boroughActive() == TRUE) & (is.null(input$borough_selector) == TRUE)) {
        
        # Set Borough Status FALSE
        boroughActive(FALSE)
        
        # Reset Census Tracts Table
        censusTable(updateDataFrame(layer = census_tracts_url))
        
      }
      
    })
  })  
  
  
  
  
  
  
  ####  OBSERVE CENSUS SELECTOR  ####
  
  observeEvent(input$census_tracts_selector, {
    
    #If Selection is not Null
    if (is.null(input$census_tracts_selector) == FALSE){
      
      # Set Borough Status FALSE
      boroughActive(FALSE)
      
      # set Borough Filter Active
      censusActive(TRUE)
      
      # Set Borough Filter Values
      censusSel(input$census_tracts_selector)
      
      # Filter the Map Data
      filtered <- updatePolygons(layer = census_tracts_url, 
                                 where = where_statement(field = 'TRACTFIPS', 
                                                         values = censusSel(),
                                                         format = "str")
      )
      
      # Update Map Data
      mapData(filtered)
      
    }
    
    
    ### MONITOR WHEN FILTER EMPTY ###
    observe({
      
      #If Selection Active and Is Now Null
      if ((censusActive() == TRUE) & (is.null(input$census_tracts_selector) == TRUE)) {
        
        # Set Borough Status FALSE
        censusActive(FALSE)
        
        # Set Borough Back to Active if Populated
        if (is.null(input$borough_selector) == FALSE){
          
          boroughActive(TRUE)
          
          # Filter the Map Data
          filtered <- updatePolygons(layer = census_tracts_url, 
                                     where = where_statement(field = "COUNTYFIPS", 
                                                             values = boroughSel(),
                                                             format = "str")
          )
          
          # Update Map Data
          mapData(filtered)
          
          
        }
      }
      
    })
    
  })
  
  
}