# R Script for Pulling and Validating GeoJSON from ArcGIS Online (AGOL)
#
# Description:
#   This script defines functions to interact with ArcGIS Online (AGOL) services to pull GeoJSON data
#   and validate its content. It utilizes the 'sf' and 'httr' packages for handling spatial data and
#   HTTP requests, respectively.
#
# Packages Required:
#   - sf           : For handling spatial data objects and operations.
#   - httr         : For making HTTP requests to ArcGIS Online services.
#   - jsonlite     : For handling JSON content in R.
#   - shiny        : For building interactive web applications with R (used for progress bars).
#
# Functions:
#   - validateGeoJSON: Function to validate GeoJSON content using 'jsonlite'.
#   - pullGeoJSON: Function to pull GeoJSON data from AGOL using specified service URL, layer, token,
#                  and save it locally.
#   - pullGeospatial: Function to update geospatial data by calling 'pullGeoJSON' for footprints and
#                     locations layers from AGOL.
#
# Usage Notes:
#   1. Ensure that the required packages (sf, httr, jsonlite, shiny) are installed:
#      install.packages(c("sf", "httr", "jsonlite", "shiny"))
#
#   2. Set 'footprints', 'locations', 'token()', and file paths ('footprints_file', 'locations_file')
#      according to your AGOL service details and save in the global R file.
#
#   3. Customize the 'validateGeoJSON' function to meet specific GeoJSON validation criteria if needed.
#
#   4. Use 'pullGeospatial' function in a Shiny application or other R scripts to update geospatial data
#      from AGOL periodically or as needed.
#
# Author:
#   Charles Ross
#   Michael Baker International
#
# Date Created: 07/16/2024
# Last Updated: 07/22/2024



# Load Libraries
library(sf)
library(geojsonio)
library(httr)
library(jsonlite)


#####  BASIC FUNCTIONS   #####

# Function to validate GeoJSON (you may need to adjust this based on your specific validation criteria)
validateGeoJSON <- function(content) {
  tryCatch(
    {
      jsonlite::fromJSON(content)
      return(TRUE)
    },
    error = function(e) {
      return(FALSE)
    }
  )
}



# Function to Create Custom Where Statments
where_statement <- function(field, values, format) {
  
  # Check if any of the parameters are NULL
  if (is.null(field) || is.null(values) || is.null(format)) {
    return("1=1")
  }
  
  # Function to wrap a value in quotes if it's a character
  wrap_in_quotes <- function(value) {
    if (format == "int") {
      return(as.numeric(value))  # Numeric value, return as is
      
    } else if (format == "str") {
      return(paste0("'", as.character(value), "'"))
      
    } else {
      stop("Unsupported value type")  # Handle unexpected types
    }
  } 
  

  # Check if there is only one value
  if (length(values) == 1) {
    # If only one value, create a single condition
    where_statement <- paste(field, "=", wrap_in_quotes(values))
  } else {
    # Create a vector of conditions for each value
    conditions <- paste(field, "=", sapply(values, wrap_in_quotes))
    # Combine the conditions with ' OR '
    where_statement <- paste(conditions, collapse = " OR ")
  }
  return(where_statement)
}




# Function to Pull Centroids of Polygons
pullCentroids <- function(data) {
  
  #Set Empty Centroids Return
  centroids <- NULL
  
  #Attempt to Convert
  tryCatch({
    
    # Check and make geometries valid
  invalid_geometries <- !st_is_valid(data)
  if (any(invalid_geometries)) {
    cat("There are invalid geometries in your data.\n")
    data <- st_make_valid(data)
  }
  
  # Calculate centroids of polygons
  centroids <- st_centroid(data)
  
  # Extract coordinates for the centroids
  centroid_coords <- st_coordinates(centroids)
  
  # Combine centroid coordinates with original data
  centroids$centroid_long <- centroid_coords[,1]
  centroids$centroid_lat <- centroid_coords[,2]
    
    
  }, error = function(e) {
    
    # Stop progress and produce error if fail
    stop(paste("pullCentroids Fail: ", e))
    
  })
  
  
  return(centroids)
  
}








#####  GEOJSON FUNCTIONS   #####


returnAGOLGeoJSON <- function(layer, where, fields) {
  
    # Set query URL
    query_url <- paste0(layer, "/query")
    
    # Set query parameters
    query_params <- list(
      token = token(),
      where = where,
      outFields = fields,
      outSR = 4326,
      f = "geojson"
    )
    
    
    # Attempt to call from AGOL
    tryCatch({
      
      # Pull response from GeoJSON
      response <- GET(query_url, query = query_params)
      
      # Pull GeoJSON file
      content <- content(response, as = "text", encode = "UTF-8")
      
      #Convert Content to GeoJSON SF File
      geojson <- st_read(content, stringsAsFactors = FALSE)
      
      
    }, error = function(e) {
      
      # Stop progress and produce error if fail
      incProgress(1, detail = "Error encountered")
      stop(paste("Failed Pull from AGOL", e))
      
    })
    
}
    
    
   
returnLocalGeoJSON <- function(file, field, values){
  
  #Attempt to Pull Local File
  tryCatch({
    
    # Pull GeoJSON from Local File
    geojson <- sf::st_read(file)
    
    # Filter GeoJSON if field and values are not NULL
    if (!is.null(field) && !is.null(values)) {
      
      if (field %in% names(geojson)) {
        
        geojson <- geojson %>%
          filter(.data[[field]] %in% values)
        
      } else {
        stop(paste("Field", field, "does not exist in the GeoJSON data"))
      }
    }
    
  }, error = function(e) {
    
    # Stop progress and produce error if fail
    incProgress(1, detail = "Error encountered")
    stop(paste("Failed Pull from Local File", e))
    
  })
  
  return(geojson)
  
}
    
    





#Return GeoJSON, Filtered if Neccessary
returnSpatial <- function(data){
  
  #Set Empty GeoJSON
  spatial <- NULL
  
  # Set Max and Min Lat,Lng
  min_lat <- Inf
  max_lat <- -Inf
  min_lng <- Inf
  max_lng <- -Inf
  
  
  #Attempt to Convert GEOJSON and Find Extent
  tryCatch({
    
    # Convert GeoJSON to sf
    #data <- st_read(content, stringsAsFactors = FALSE)
    
    # Find Bounding Box for File
    bbox <- st_bbox(data)
    
    # Find Max, Min Lat, Lng
    min_lng = mean(bbox["xmin"]) 
    min_lat = mean(bbox["ymin"])
    max_lng = mean(bbox["xmax"])
    max_lat = mean(bbox["ymax"])
    
    # Create Extent List
    extent = list(max_lat = max_lat, min_lat = min_lat, max_lng = max_lng, min_lng = min_lng)
    
    #Pull Centroids for Labels
    centroids = pullCentroids(data)
    
    #Produce Error if Fail
  }, error = function(e) {
    
    stop(paste("geoJSONPoints Fail: ", e))
    
  })
  
  #Return All Items
  result <- list(spatial = data, extent = extent, centroids = centroids)
  
}









#####  PULL GEOSPATIAL FUNCTIONS   #####

#First Time Render of 
renderPolygons <- function(layer = NULL, file = NULL, field = NULL, values = NULL, format = NULL) {
  
  # Define progress steps
  withProgress(message = 'Processing...', value = 0, {
    
    # Update progress to indicate the start of layer assignment
    incProgress(0.1, detail = "Assigning layer based on group")
    
    # Create empty package for spatial data
    spatial_package <- NULL
    
    
    
    # AGOL SOURCE
    if ((is.null(layer) == FALSE) & (is.null(file) == TRUE)) {
      
      # Update progress to indicate the start of data retrieval
      incProgress(0.3, detail = "Retrieving data from AGOL")
      
      # Convert AGOL Content to SF GeoJSON
      geojson <- returnAGOLGeoJSON(layer = layer, 
                                   where = where_statement(field, values, format), 
                                   fields = "*")
      
      
      
    # If Source Local
    } else if ((is.null(layer) == TRUE) & (is.null(file) == FALSE)) {
      
      # Update progress to indicate the start of data retrieval
      incProgress(0.3, detail = "Retrieving data from Local File")
      
      # Convert Local File to SF GeoJSON
      geojson <- returnLocalGeoJSON(file = file, 
                                    fields = field, 
                                    values = values)
      
    }
    
    
    
    # Attempt to Convert GeoJSON
    tryCatch({
      
      # Update progress to indicate parsing the GeoJSON
      incProgress(0.5, detail = "Parsing GeoJSON")
      
      # Pull extent
      spatial_package <- returnSpatial(geojson)
      
      # Update progress to indicate completion
      incProgress(0.7, detail = "Processing complete")
      
    }, error = function(e) {
      
      # Stop progress and produce error if fail
      incProgress(1, detail = "Error encountered")
      stop(paste("renderBoundaries Fail: ", e))
      
    })
    
    # Final update to indicate completion
    incProgress(1, detail = "Returning results")
    
  })  # End of withProgressc
  
  
  # Return GeoJSON and extent
  return(spatial_package)
  
}






# UPDATE POLYGONS ON MAP
updatePolygons <- function(layer = NULL, file = NULL, where = "1=1", fields = "*") {
  
  # Create empty points to return
  boundaries <- NULL
  
  # Set query URL
  query_url <- paste0(layer, "/query")
  
  # Set query parameters
  query_params <- list(
    token = token(),
    where = where,
    outFields = fields,
    outSR = 4326,
    f = "geojson"
  )
    
    
  # Attempt to call from AGOL
  tryCatch({
    
    # Pull response from GeoJSON
    response <- GET(query_url, query = query_params)
    
    # Pull GeoJSON file
    geojson <- content(response, as = "text", encode = "UTF-8")
    
    # Pull extent
    boundaries <- returnGeoJSON(geojson)
    
    
  }, error = function(e) {
    
    stop(paste("updateBoundaries Fail: ", e))
    
  })
    
  
  # Return GeoJSON and extent
  return(boundaries)
  
}

















  


