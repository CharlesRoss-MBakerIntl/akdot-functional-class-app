# R Shiny Dashboard with Authentication UI
#
# Description:
#   This script sets up a Shiny dashboard with authentication functionality using
#   the shinyauthr package. It includes UI components for login and logout, and
#   displays user information in a table upon successful login.
#
# Packages Required:
#   - shiny         : For building interactive web applications with R.
#   - shinydashboard: For creating dashboards with Shiny.
#   - shinyauthr    : For user authentication and session management in Shiny apps.
#   - DT            : For interactive tables in the Shiny app.
#   - shinyjs       : For adding JavaScript functionality to Shiny apps.
#
# Usage Notes:
#   1. Ensure that the required packages (shiny, shinydashboard, shinyauthr, DT, shinyjs) are installed:
#      install.packages(c("shiny", "shinydashboard", "shinyauthr", "DT", "shinyjs"))
#
#   2. Customize the loginUI function as needed for your application's login interface.
#
#   3. Modify the 'user_table' output to display relevant user information based on your
#      application's requirements and user authentication data.
#
#   4. Handle user authentication and session management securely, especially in production environments.
#
# Author:
#   Charles Ross  
#   Michael Baker International
#
# Date Created: 07/15/2024
# Last Updated: 07/16/2024



library(shiny)
library(shinydashboard)
library(shinyauthr)
library(DT)

# Define UI for login page
loginUI <- fluidPage(
  
    # must turn shinyjs on
    shinyjs::useShinyjs(),
    
    # add logout button UI 
    div(class = "pull-right", shinyauthr::logoutUI(id = "logout")),
    
    # add login panel UI function
    shinyauthr::loginUI(id = "login"),
    
    # setup table output to show user info after login
    tableOutput("user_table")
  
)