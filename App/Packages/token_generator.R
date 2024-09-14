# R Token Generator Function for ArcGIS Online (AGOL)
#
# Description:
#   This function generates an authentication token for ArcGIS Online (AGOL) using
#   HTTP POST request to the token generation endpoint. It takes a username and password
#   as input and returns the generated token if successful.
#
# Packages Required:
#   - httr: For making HTTP requests in R.
#
# Usage Notes:
#   1. Ensure the 'httr' package is installed:
#      install.packages("httr")
#
#   2. The function 'tokenGenerator' requires a valid ArcGIS Online (AGOL) username and password.
#      Ensure these credentials are correctly provided when calling the function.
#
#   3. Modify the 'url' variable if the token generation endpoint changes.
#
#   4. Handle errors and exceptions gracefully, especially when dealing with network failures,
#      invalid credentials, or changes in the AGOL API.
#
# Author:
#   Charles Ross  
#   Michael Baker International
#
# Date Created: 07/15/2024
# Last Updated: 07/16/2024



library(shiny)
library(httr)


tokenGenerator <- function(session, username, password) {
    
    #Set Error
    error = NULL
    
    #Token URL
    url = 'https://www.arcgis.com/sharing/rest/generateToken'
    
    #User Data to Generate Token
    data <- list(
      username = username,
      password = password,
      referer = 'https://www.arcgis.com'
    )
    
    #Additional Parameters
    params = list(
      f  = 'json'
    )
    
    #Return Token Response from AGOL
    response <- POST(url, query = params, body = data, encode = "form")
    
    
    # Check if token is correctly returned
    response_json <- content(response, "parsed")
    
    
    
    # Check if Token in Repsonse
    if ("token" %in% names(response_json)) {
      
      # Token Found
      token <- response_json$token
      
      # Returning Token
      return(token)
      
      
      
      # Token Not Found
    } else {
      
      # Simulate an error if token is not found
      stop("Token not found in response.")
      
      
    }
  }