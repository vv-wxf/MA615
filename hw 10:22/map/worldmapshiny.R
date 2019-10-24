#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


library(ggmap)
library(maptools)
library(maps)

m1 <- ggplot(mapWorld, aes(x=long, y=lat, group=group))+
    geom_polygon(fill="white", color="black") +
    coord_map(xlim=c(-180,180), ylim=c(-60, 90))

# Define UI for application that draws a histogram
ui <- fluidPage(
    # Application title
    titlePanel("World Map Different Projection"),
    sidebarLayout(
        sidebarPanel(
            selectInput("projection", label = "Choose a Projection", choices = c("cylindrical","mercator"))
            ),
        # Show a plot of the generated map plot
        mainPanel(
            plotOutput("map")
        )
    )
)

# Define server to plot the maps
server <- function(input, output) {
    output$map <- renderPlot({
        m1+coord_map(input$projection,xlim=c(-180,180), ylim=c(-60, 90))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
