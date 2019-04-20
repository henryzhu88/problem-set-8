library(tidyverse)
library(sf)
library(tigris)
library(ggthemes)

camden <- read_csv(url("http://justicetechlab.org/wp-content/uploads/2019/04/camdencounty_nj.csv"))

raw_shapes <- urban_areas(class="sf") 

shape <- raw_shapes %>%
  filter(NAME10== "Camden, NJ")

camden_shot_locations <- st_as_sf(camden, 
                               coords = c("latitude", "longitude"), 
                               crs = 4326) 
ggplot(data = shape) +
  geom_sf() +
  geom_sf(data = camden_shot_locations) +
  theme_map()