source("Packages/pull_geospatial.R")




#########   AGOL SOURCES    #########

feature_service <- 'https://services.arcgis.com/r4A0V7UzH9fcLVvv/arcgis/rest/services/Functional_Class_Update/FeatureServer'

routes_url <- paste0(feature_service, '/0')

census_tracts_url <- paste0(feature_service, '/2')

bor_census_url <- paste0(feature_service, '/3')




#########   LOCAL GEOSPATIAL SOURCES    #########

route_file <- "C:/git/Route Review/App/Data/Geospatial/Routes.geojson"

census_tract_file <- "C:/git/Route Review/App/Data/Geospatial/Census_Tracts.geojson"

bor_census_file <- "C:/git/Route Review/App/Data/Geospatial/Borough_Census.geojson"



##########  SPATIAL LAYERS  ##########

routes <- reactiveVal(NULL)

census_tracts <- reactiveVal(NULL)

bor_census <- reactiveVal(NULL)



##########  STYLE LAYERS  ##########
status_levels <- c("Not Started", "In Progress", "Complete")

status_colors <- c(
  "Not Started" = "#ffa62b",  # Color for "Not Started"
  "In Progress" = "#149ece",  # Color for "In Progress"
  "Complete" = "#a7c636"      # Color for "Complete"
)




#####   STATUS   ######

# Logged In Status
logged_in <- reactiveVal(FALSE)





#########   LOGIN CREDENTIALS    #########

# TOKEN
token_status <- reactiveVal("Not Generated")
token <- reactiveVal(NULL)

# USER INFORMATION
user_name <- reactiveVal(NULL)
user_pass <- reactiveVal(NULL)
name <- reactiveVal(NULL)
user_permission <- reactiveVal(NULL)

# AGOL LOGIN CREDENTIALS
agol_username <- reactiveVal(NULL)
agol_password <- reactiveVal(NULL)






#########   MAP DATA   #########

mapDataBoroughDefault <- reactiveVal(NULL)

mapData <- reactiveVal(NULL)
malLables <- reactive(NULL)

mapMaxLat <- reactiveVal(NULL)
mapMinLat <- reactiveVal(NULL)
mapMaxLng <- reactiveVal(NULL)
mapMinLng <- reactiveVal(NULL)





#########   DATA TABLES  #########
boroughTable <- reactiveVal(NULL)
boroughTableDefault <- reactiveVal(NULL)

censusTable <- reactiveVal(NULL)
censusTableDefault <- reactiveVal(NULL)

routeTable <- reactiveVal(NULL)
routeTableDefault <- reactiveVal(NULL)




#########   SELECTED VALUES  #########
boroughSel <- reactiveVal(list())
boroughActive <- reactiveVal(FALSE)

censusSel <- reactiveVal(list())
censusActive <- reactiveVal(FALSE)
