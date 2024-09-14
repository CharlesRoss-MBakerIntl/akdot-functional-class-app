library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyauthr)
library(shinyalert)
library(leaflet)
library(leaflet.esri)
library(htmlwidgets)


# Load Body Source Files
source("Modules/Login/login_ui.R")
source("Modules/MapPage/map_ui.R")



# UI definition
ui <- dashboardPage(
  
  
  ##### HEADER #####
  dashboardHeader(
    
    # Title
    title =  tags$img(src = "https://dot.alaska.gov/branding/img/Logos/DOTPF-logo-color-webres-150x150-transparent.png", height = "100%", style = "padding: 0;"), # Add logo image,
    
    # Header Width
    titleWidth = 500,
    
    #Provide Logout Button
    tags$li(class = "dropdown", style = "padding: 8px;", shinyauthr::logoutUI(id = "logout")),
    
    disable = TRUE
    
  ),
  
  
  
  
  
  ##### SIDEBAR #####
  dashboardSidebar(
    disable = TRUE,
    sidebarMenu(
      
      # Log In 
      #menuItem("Log In", tabName = "login", icon = icon("home"), selected = TRUE),
      
      # Project Map
      menuItem("EDITOR", tabName = "editor", icon = icon("map"), selected = TRUE)
      
    )
  ),
  
  
  
  
  
  ###### BODY ######
  dashboardBody(
    
    # Load ShinyJS
    shinyjs::useShinyjs(),
    
    #Add CSS Styling
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "html_styles.css")
    ),
    
    
    # Display Menu Pages
    tabItems(
      
      # LOGIN
      #tabItem(tabName = "login", loginUI),
      
      # MAP
      tabItem(tabName = "editor", mapUI)
      
    )
  )
)
