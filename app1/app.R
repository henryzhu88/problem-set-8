#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)
library(sf)
library(tigris)
library(ggthemes)
library(lubridate)
library(gganimate)
library(janitor)
brockton<- read_csv(url("http://justicetechlab.org/wp-content/uploads/2018/02/Brockton_ShotSpotterCSV.csv")) %>%
  clean_names() %>%
  filter(latitude!="NA") %>%
  mutate(year = year(time))

shapes <- places("ma", class = "sf", cb=TRUE) %>%
  filter(NAME == "Brockton")

brockton_locations <- brockton %>%
  st_as_sf(coords = c("longitude", "latitude"), 
           crs = st_crs(shapes)) 

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Gunfire Reports in Brockton, MA"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        tabsetPanel(
          tabPanel("Shooting Locations",
                   imageOutput("Map")),
          tabPanel("Acknowledgments",
                   textOutput("text"))
        )
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output)  {
  output$Map <- renderImage({
    list(src="plot1.gif",
         contentType="image/gif")
  }) 
  output$text <- renderText({
    "The Justice Tech Lab provided data to this project. Much appreciation to access to this data. \nCreated by Henry Zhu. 
    \nLink to Github:https://github.com/henryzhu88/problem-set-8" 
  })
   }

# Run the application 
shinyApp(ui = ui, server = server)

