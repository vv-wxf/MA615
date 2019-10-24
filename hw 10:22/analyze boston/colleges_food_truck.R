library(shiny)
library(leaflet)
library(maps)
library(dplyr)
library(magrittr)



sites <- read.csv("Colleges_and_Universities.csv") 
sites %<>% filter(Longitude!=0)

bounds <- map('county', 'Massachusetts', fill=TRUE, plot=FALSE)

icons1 <- awesomeIcons(
    icon = 'home',
    iconColor = 'rgba',
    library = 'fa', 
    markerColor = 'lightblue',
    squareMarker = F,
    spin=T
)

food_trunk <- read.csv("food_truck_schedule.csv")

icons2 <- awesomeIcons(
    icon = 'cog',
    iconColor = 'rgba',
    library = 'fa', 
    markerColor = 'beige',
    squareMarker = F,
    spin=T
)


ui <- fluidPage(
    
    titlePanel("Colleges and Food Trunk Locations"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("day", "Weekdays:", unique(food_trunk$Day)),
            selectInput("meal", "Meal: ", c("Lunch", "Dinner"))
        ),
        
        mainPanel(
            leafletOutput(outputId = "mymap"),
            width = 12
        )
    )
)


server <- function(input, output) {
    
    output$mymap <- renderLeaflet({
        food_trunk1 <- food_trunk %>% filter(Day==input$day & Time==input$meal)
        leaflet(sites) %>% 
            setView(-71.098849, 42.350434, zoom = 12) %>% 
            addProviderTiles("CartoDB.Positron", group = "Map") %>%
            addProviderTiles("Esri.WorldImagery", group = "Satellite")%>% 
            addProviderTiles("OpenStreetMap", group = "Mapnik")%>%
            # Marker data are from the sites data frame. We need the ~ symbols
            # to indicate the columns of the data frame.
            addAwesomeMarkers(~Longitude, ~Latitude, label = ~Name, group = "Sites",icon = icons1) %>% 
            addAwesomeMarkers(~food_trunk1$x, ~food_trunk1$y, label = ~food_trunk1$Truck, group = "Sites", icon=icons2) %>%
            addPolygons(data=bounds, group="States", weight=2, fillOpacity = 0) 
    })
}

# Run the application 
shinyApp(ui = ui, server = server)