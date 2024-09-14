library(shiny)
library(shinydashboard)
library(shinyauthr)
library(shinyalert)
library(leaflet)
library(leaflet.esri)
library(htmlwidgets)
library(DT)
library(shinyWidgets)
library(jsonlite)


# Load Login Server Logic
source("Modules/Login/login_server.R")
source("Modules/MapPage/map_server.R")



#Initiate Server
function(input, output, session) {
  
  #REMOVE WHEN PUTTING IN LOADING PAGE AGAIN
  
  # Test Username and Password for Token Generation
  #token <- tokenGenerator(session, 'AKDOT_APEX', '@KD0T_@p3x')
  
  # Update Token in Global File
  #token(token)

  
  #####   LOGIN   #####
  
  # Load LOGIN Panel Server Functions
  #loginServer(input, output, session)
  
  
  
  
  #####   PROGRESS PAGE   ######
  
  # Monitor if Token No Longer Null
  observe({
  
    
    # Check if token is no longer null
    if (is.null(token())) {
      
      #Run Map Server
      mapServer(input, output, session)
      
    }
    
  })
  
  
  
  
  
  
  
  
  #####   SUBMISSION LOG   ######
  
  
  
  
  
  
  
  
  #####   ALASKA 511 LOG   ######
  
  
  
  
  
  
  
  #####   MESSAGE CENTER   ######
  
  
}
