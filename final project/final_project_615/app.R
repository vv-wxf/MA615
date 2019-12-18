#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
##install.packages('rsconnect')
# library(rsconnect)
library(tm)
library(wordcloud)
library(memoise)
library(png)

# The list of valid books
restaurants <<- list("No.1 Restaurant" = "text1",
               "No.2 Restaurant" = "text2",
               "No.3 Restaurant" = "text3",
               "No.4 Restaurant" = "text4",
               "No.5 Restaurant" = "text5")

# Using "memoise" to automatically cache the results
getTermMatrix <- memoise(function(restaurant) {
    # Careful not to let just any name slip in here; a
    # malicious user could manipulate this value.
    if (!(restaurant %in% restaurants))
        stop("Unknown restaurant")
    input <- paste (restaurant, ".Rdata", sep = "", collapse = NULL)
    text <- readRDS(input)
    text = text[c(1:1000)]
    docs <- Corpus(VectorSource(text))
    dtm <- TermDocumentMatrix(docs)
    m <- as.matrix(dtm)
    sort(rowSums(m),decreasing=TRUE)
})

# Define UI for application that draws a histogram
ui <- fluidPage(
    # Application title
    navbarPage(
        # theme = "cerulean",  # <--- To use a theme, uncomment this
        "Yelp Business & Reviews",
        tabPanel("World Cloud",
                 titlePanel("Word Cloud for The Top Reviewed Restaurants"),
                 sidebarLayout(
                     # Sidebar with a slider and selection inputs
                     
                     sidebarPanel(
                         selectInput("selection", "Choose Restaurants:",
                                     choices = restaurants),
                         actionButton("update", "Change"),
                         hr(),
                         sliderInput("freq",
                                     "Minimum Frequency:",
                                     min = 50,  max = 100, value = 75),
                         sliderInput("max",
                                     "Maximum Number of Words:",
                                     min = 1,  max = 200,  value = 100)
                     ),# Show Word Cloud
                     mainPanel(
                         plotOutput("plot"),
                         h4("Table"),
                         tableOutput("table")
                     )
                 )
        ),
        tabPanel("Business Overall", 
            mainPanel(
                tabsetPanel(
                    tabPanel("World Map of Yelp Business",
                        plotOutput("worldPlot")
                    ),
                    tabPanel("US Map of Yelp Business", 
                        plotOutput("USPlot")
                    )
                )
            )
        ),
        tabPanel("Discover By States", 
            mainPanel(
                tabsetPanel(
                    tabPanel("Business Density",
                            plotOutput("distribution")
                    ),
                    tabPanel("Review Density", 
                            plotOutput("density")
                    ),
                    tabPanel("Star Rate", 
                             plotOutput("averageRate")
                    )
                )
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    # Define a reactive expression for the document term matrix
    terms <- reactive({
        # Change when the "update" button is pressed...
        input$update
        # ...but not for anything else
        isolate({
            withProgress({
                setProgress(message = "Processing corpus...")
                getTermMatrix(input$selection)
            })
        })
    })
    
    # Make the wordcloud drawing predictable during a session
    wordcloud_rep <- repeatable(wordcloud)
    
    output$plot <- renderPlot({
        v <- terms()
        d <- data.frame(word = names(v),freq=v)
        set.seed(1234)
        wordcloud(words = d$word, freq = d$freq, min.freq = input$freq,
                  max.words=input$max, random.order=FALSE, rot.per=0.35, 
                  colors=brewer.pal(8, "Dark2"))
    })
 
    output$table <- renderTable({
        # take a look at the top 10 frequent words. 
        input <- paste (input$selection, ".Rdata", sep = "", collapse = NULL)
        text <- readRDS(input)
        words10 <- sort(table(text), decreasing=T)[1:10]
    })
    
    output$worldPlot <- renderPlot({
        img1 <- readPNG("businessWorld.png")
        grid::grid.raster(img1)
    })
    
    output$USPlot <- renderPlot({
        img2 <- readPNG("businessUS.png")
        grid::grid.raster(img2)
    })
    
    output$distribution <- renderPlot({
        img3 <- readPNG("distribution.png")
        grid::grid.raster(img3)
    })
    
    output$density <- renderPlot({
        img4 <- readPNG("density.png")
        grid::grid.raster(img4)
    })
    
    output$averageRate <- renderPlot({
        img5 <- readPNG("average.png")
        grid::grid.raster(img5)
    })
}
# Run the application 
shinyApp(ui = ui, server = server)
