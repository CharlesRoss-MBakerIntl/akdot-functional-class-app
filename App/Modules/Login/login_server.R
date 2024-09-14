# R Shiny Authentication and Token Generation Script
#
# Description:
#   This script implements user authentication using the shinyauthr package and generates
#   a token upon successful login. It allows users with specific credentials to access
#   authenticated parts of the application and manages login/logout functionalities.
#
# Packages Required:
#   - shiny        : For building interactive web applications with R.
#   - shinyauthr   : For user authentication and session management in Shiny apps.
#   - shinyalert   : For displaying user-friendly alerts in the Shiny app.
#   - DT           : For interactive tables in the Shiny app.
#   - tibble       : For creating data frames.
#
# Usage Notes:
#   1. Ensure that the required packages (shiny, shinyauthr, shinyalert, DT, tibble) are installed:
#      install.packages(c("shiny", "shinyauthr", "shinyalert", "DT", "tibble"))
#
#   2. Make sure to have the 'token_generator.R' script available in the same directory or specify
#      its location correctly using the 'source()' function.
#
#   3. Modify the 'user_base' tibble to include actual usernames, passwords, permission levels,
#      and user names according to your application's needs.
#
#   4. Customize the token generation process in the 'loginServer' function's 'observeEvent' block
#      to fit your specific token generation requirements.
#
#   5. Use caution when handling user authentication and token generation in production environments
#      to ensure security best practices are followed (e.g., secure storage and transmission of passwords).
#
# Author:
#   Charles Ross  
#   Michael Baker International
#
# Date Created: 07/15/2024
# Last Updated: 07/16/2024



library(shiny)
library(shinyauthr)
library(shinyalert)
library(DT)


source("Packages/token_generator.R")

# Set Data Frame for Users and Passwords
user_base <- tibble::tibble(
  # Set Usernames
  user = c("AKDOT_APEX", "EDITORS_MB", 'Caitlin.Frye', 'a', 'Malia.Walters'),
  #Set Passwords for Users
  password = c("@KD0T_@p3x", "Traffic907$", 'caitlin.frye', 'a', 'malia.walters'),
  #Set Permission Levels
  permissions = c("Admin", "Editor", 'Admin', 'Admin', "Editor"),
  #AGOL Username
  agol_user = c("AKDOT_APEX", "EDITORS_MB", 'AKDOT_APEX', "AKDOT_APEX", "EDITORS_MB"),
  #AGOL Password
  agol_pass = c("@KD0T_@p3x", "Traffic907$", '@KD0T_@p3x', '@KD0T_@p3x', "Traffic907$"),
  #Set Names for Users
  name = c("AKDOT APEX Admin", "Michael Baker Editor", "Caitlin Frye", "Charles Ross", "Malia Walters")
)



loginServer <- function(input, output, session) {
  
  # call the logout module with reactive trigger to hide/show
  logout_init <- shinyauthr::logoutServer(
    id = "logout",
    active = reactive(credentials()$user_auth)
  )
  

  #SET LOGIN CREDENTIALS FOR 
  credentials <- shinyauthr::loginServer(
    id = "login",
    data = user_base,
    user_col = user,
    pwd_col = password,
    sodium_hashed = FALSE,
    log_out = reactive(logout_init())
  )
  
  # Pulls out the user information returned from login module
  user_data <- reactive({credentials()$info})
  
  
  # Update Global Values
  observeEvent(credentials()$user_auth, {
    
    if (credentials()$user_auth) {
      
      # Attempt to Generate Token 
      tryCatch({
        
        # Test Username and Password for Token Generation
        token <- tokenGenerator(session, credentials()$info$agol_user, credentials()$info$agol_pass)
        
        # Update Token in Global File
        token(token)
        
        #Catch Error in Token Generation
      }, error = function(e) {
        
        #Produce Shiny Alert on Main Page
        shinyalert(
          title = "Token Generation Error",
          text = "Failed to generate token. Please try again.",
          type = "error",
          callbackR = session$reload  # Reload session upon closing the alert
        )
        
      })
    }
  })
  
  
  # Token Successful, Update Global Values
  observe({
    
    # Check if token is no longer null
    if (!is.null(token())) {
      
      # Update Logged In Statuse
      logged_in(TRUE)
      
      # Update AGOL Credentials Login
      agol_username(credentials()$info$agol_user)
      agol_password(credentials()$info$agol_pass)
      
      # Update User Information
      user_name(credentials()$info$user) 
      user_pass(credentials()$info$password) 
      name(credentials()$info$name) 
      user_permission(credentials()$info$permissions) 
      
    }
  })
  
  
  #Output Render on Login Page after Successful Login
  output$user_table <- renderTable({
    
    # use req to only render results when credentials()$user_auth is TRUE
    req(credentials()$user_auth)
    
    user_data()
    
  })
  
  
  
}
