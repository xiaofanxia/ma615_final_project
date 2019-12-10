#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

pacman::p_load("shiny","tidyverse","leaflet","leaflet.extras")

#Read in data
df <- read.csv("/Users/XiaofanXia/Desktop/MA615/ma615_final project/airbnb-amsterdam/listings.csv")


#Data Cleaning
df_new <- 
    df %>% 
    select(room_type,neighbourhood,price,latitude,longitude)

colnames(df_new) <- c("Room Type","Neighbourhood","Price","Latitude","Longitude")
map <- df_new
map$lat <- as.numeric(map$Latitude)
map$long<- as.numeric(map$Longitude)
map$roomtype <- as.character(map$`Room Type`)
map$neighbourhood <- as.character(map$Neighbourhood)
map$price <- as.numeric(map$Price)
na.omit(map)


#Define room type
#roomtype <- unique(map$`Room Type`)
                       
#Define neighbourhood
#neighbourhood <- unique(map$Neighbourhood)

#Define price
#price <- unique(map$Price)


#Layout
ui <- fluidPage(
    titlePanel("Airbnb in Amsterdam"),
    sidebarLayout(
        sidebarPanel(
            selectInput("t", "Room Type", map$roomtype),
            selectInput("n", "Neighbourhood", map$neighbourhood),
            #sliderInput("p","Price Range",map$price,max = 8500,min = 0,value = c(0,1500)),
            actionButton("resetBeatSelection", "Reset Map Selection")
        ),
        mainPanel(
            leafletOutput(outputId = "mymap")
        )
    )
)

#Server
server <- function(input, output) {
    # pull out the data
    selected <- reactive( 
        map %>% filter(roomtype==input$t & neighbourhood==input$n  )
    )
    # output the map 
    output$mymap <- renderLeaflet(
        selected() %>% leaflet() %>% addTiles() %>%
            addMarkers(~long, ~lat)
    )
    
}
shinyApp(ui, server)