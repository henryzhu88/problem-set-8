#Loaded necessary libraries. Tidyverse to parse data, Sf and tigris to locate city plot and create map

library(tidyverse)
library(sf)
library(tigris)

#janitor to clean data, gganimate and lubridate to alternate based on year
library(ggthemes)
library(lubridate)
library(gganimate)
library(janitor)

#I chose the city of Brockton and read in the url csv from the Justice Tech Lab website, cleaning the variable names.

brockton<- read_csv(url("http://justicetechlab.org/wp-content/uploads/2018/02/Brockton_ShotSpotterCSV.csv")) %>%
  clean_names() %>%

#I removed any reports in which a specific location was not designated through filtering out latitude.
  
  filter(latitude!="NA") %>%

#To create an animation, I added an extra time column that specifies the year of the incident.
  
  mutate(year = year(time))

#The shape file of the city of Brockton is located, which I will need to plot my shooting points over.

shapes <- places("ma", class = "sf", cb=TRUE) %>%
  filter(NAME == "Brockton")

#From my Brockton report data, I plotted the shooting points using the sf commands, over my shapes file.

brockton_locations <- brockton %>%
  st_as_sf(coords = c("longitude", "latitude"), 
           crs = st_crs(shapes)) 

# Define UI for application that draws a map

ui <- fluidPage(
   
   # Application title
  
   titlePanel("Gunfire Reports in Brockton, MA"),

      # I created two tabs, one that shows my shooting map, the second with Acknowledgements.
   
      mainPanel(
        tabsetPanel(
          tabPanel("Shooting Locations",
                   imageOutput("Map")),
          tabPanel("Acknowledgments",
                   htmlOutput("text"))
        )
      )
   )

# Define server logic required to draw a gif 

server <- function(input, output)  {
  output$Map <- renderImage({
    
#The comments below indicate how I created the map of shooting locations
  
    #plot1 <- ggplot(data = shapes) +

    #The geom_sf and ggthemes packages are needed to label the shooting locations
    
    #geom_sf() +
    #geom_sf(data = brockton_locations) +
    #theme_map() +

#Appropriate titles are given, with the animated years revolved through current frame
    
    #labs(title = "Location of gun shots in Brockton, MA",
    #subtitle = "Year: {current_frame}",
    #caption = "Data from Justice Tech Lab") +
    
#I decided to animate the data based on year, thus choosing the year transition
   
     #transition_manual(year) 
    
#The completed plot is saved as a gif, with the animation function preserved.
    
    #anim_save("plot1.gif", animate(plot1)) 
    
#The gif image is rendered on the shiny app using the following code and prevented from deleting.
    
    list(src="plot1.gif",
         contentType="image/gif")
  }, deleteFile = FALSE) 
  
#The second tab of Acknowledgments is created and rendered as an html.
  
  output$text <- renderUI({
    HTML("The Justice Tech Lab provided data to this project, from http://justicetechlab.org/shotspotter-data/. 
    Much appreciation for access to this data.
    <br />
    Link to Github:https://github.com/henryzhu88/problem-set-8. Created by Henry Zhu.") 
    
  })
   }

# Run the application 
shinyApp(ui = ui, server = server)

