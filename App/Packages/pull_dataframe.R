library(dplyr)
library(shiny)
library(sf)
library(httr)
library(jsonlite)



renderUIDList <- function(table, field, value) {
  
  #Create Empty UID List
  uid_list <- NULL
  
  #Set Table Query
  uid_query <- paste0(table, "/query")
  
  #Set Table Query Params
  uid_params <- list(
    token = token(),
    where = paste0(field, "=", "'", value, "'"),
    outFields = 'UID',
    f = "json"
  )
  
  
  # Attempt to Load Spatial Data from File
  tryCatch({
  
    # Pull Response from GeoJSON
    uid_response <- GET(uid_query, query = uid_params)
    
    # Write the GeoJSON File from Content
    uid_content <- content(uid_response, as = "text", encoding = "UTF-8")
    
    #Convert to JSON
    uid_json_data <- fromJSON(uid_content)
    
    #Create DF
    uid_data <- as.data.frame(uid_json_data$features$attributes)
    
    #Find Unique Values for Field
    uid_values <- unique(uid_data[['UID']])
    
    #Create list of Unique Values
    uid_list <- as.list(uid_values)
  
  }, 
  error = function(e) {
    stop(paste("renderUIDList Failed:", e))
  })
  
  return(uid_list)
  
}






# Render Dataframe from Geospatial File
renderSpatialDataFrame <- function(content) {
  
  #Create Empty Data
  data <- NULL
  
  # Attempt to Load Spatial Data from File
  tryCatch(
    {
      
      # Render Data Frame from GeoJSON File
      data <- sf::st_read(content)
      
      
    # Failure 
    }, 
    error = function(e) {
      stop(paste("renderSpatialDataFrame Failed:", e))
    })
  
  
  #Return Data Frame
  return(data)
  
}






renderDataFrame <- function(layer, where = "1=1", fields = "*") {
  
  # Create Empty Data Frame
  data <- NULL
  
  # Set Query URL
  query_url <- paste0(layer, "/query")
  
  # Set the GeoJSON Query Params
  query_params <- list(
    token = token(),
    where = where,
    outFields = fields,
    returnGeometry = FALSE,
    f = "json"
  )
  
  # Use withProgress to show progress
  withProgress(message = 'Loading data from AGOL...', value = 0, {
    # Increment progress
    incProgress(0.5, detail = "Querying AGOL...")
    
    # Attempt to Call from AGOL
    tryCatch({
      
      # Send HTTP GET request
      response <- GET(query_url, query = query_params)
      
      # Check if the request was successful
      if (status_code(response) != 200) {
        stop(paste("HTTP request failed with status:", status_code(response)))
      }
      
      # Write the GeoJSON File from Content
      content <- content(response, as = "text", encoding = "UTF-8")
      
      # Convert to JSON
      json_data <- fromJSON(content)
      
      # Create DF
      data <- as.data.frame(json_data$features$attributes)
      
      # Increment progress
      incProgress(1, detail = "Processing completed.")
      
    }, error = function(e) {
      
      # Increment progress on error to reflect completion
      incProgress(1, detail = "Error occurred.")
      stop(paste("renderDataFrame Fail: ", e))
      
    })
  })
  
  return(data)
}




updateDataFrame <- function(layer, where = "1=1", fields = "*") {
  
  # Create Empty Data Frame
  data <- NULL
  
  # Set Query URL
  query_url <- paste0(layer, "/query")
  
  # Set the GeoJSON Query Params
  query_params <- list(
    token = token(),
    where = where,
    outFields = fields,
    returnGeometry = FALSE,
    f = "json"
  )
  

  # Attempt to Call from AGOL
  tryCatch({
    
    # Send HTTP GET request
    response <- GET(query_url, query = query_params)
    
    # Check if the request was successful
    if (status_code(response) != 200) {
      stop(paste("HTTP request failed with status:", status_code(response)))
    }
    
    # Write the GeoJSON File from Content
    content <- content(response, as = "text", encoding = "UTF-8")
    
    # Convert to JSON
    json_data <- fromJSON(content)
    
    # Create DF
    data <- as.data.frame(json_data$features$attributes)
  
    
  }, error = function(e) {
    
    stop(paste("updateDataFrame Fail: ", e))
    
  })
  
  return(data)
}






# Render a List from Table Data
renderList<- function(layer, field, where = "1=1") {
  
  #Create Empty Data Frame
  values_list <- NULL
  
  #Set Query URL
  query_url <- paste0(layer, "/query")
  
  # Set the GeoJSON Query Params
  query_params <- list(
    token = token(),
    where = where,
    outFields = "*",
    returnGeometry = FALSE,
    f = "json"
  )
  
  
  #Attempt to Call from AGOL
  tryCatch({
    
    # Send HTTP GET request
    response <- GET(query_url, query = query_params)
    
    # Write the GeoJSON File from Content
    content <- content(response, as = "text", encoding = "UTF-8")
    
    #Convert to JSON
    json_data <- fromJSON(content)
    
    #Create DF
    data <- as.data.frame(json_data$features$attributes)
    
    #Find Unique Values for Field
    unique_values <- unique(data[[field]])
    
    #Create list of Unique Values
    values_list <- as.list(unique_values)
    
    #Stop if the list is Null
    if (is.null(values_list)) {
      stop(paste("No unique values found in", field, "for", table))
    }
    
    
    #Produce Error if Fail
  }, error = function(e) {
    
    stop(paste("renderDataFrame Fail: ", e))
    
  })
  
  return(values_list)
  
}
    