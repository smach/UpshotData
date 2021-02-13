# For speeder execution, I'll map one county to start: Suffolk County, NY  (interesting because vote was very close)

suffolk_ny <- ny_geojson[ny_geojson$county == "Suffolk County",]

# test with basic (slow) plot
plot(suffolk_ny)

# Next I'll try a basic choropleth map with tmap
library(tmap)
tmap_mode("view") # makes the map interative
tm_shape(suffolk_ny) +
  tm_polygons("pct_dem_lead", id = "GEOID")

# I'll create a couple of more sf objects with different counties:
nassau_ny <- ny_geojson[ny_geojson$county == "Nassau County",]
middlesex_ma <- ma_geojson[ma_geojson$county == "Middlesex County",]

# I wrote a function  to generate a leaflet map with the usual red/blue palette, plus an address search option (click on the search icon), from this Upshot data after wrangling it with the previous instructions. Code for the generate_leaflet_map() function is in the separate map_function.R file.

library(leaflet)
library(leaflet.extras)
source("map_function.R")

generate_leaflet_map(suffolk_ny)

generate_leaflet_map(middlesex_ma)

# You can save a map as a self-contained HTML file
library(htmlwidgets)
eastern_ma <- ma_geojson[ma_geojson$county %in% c("Suffolk County", "Middlesex County", "Norfolk County", "Essex County", "Plymouth County", "Barnstable County", "Bristol County", "Dukes County", "Nantucket County"), ]
eastern_ma_map <- generate_leaflet_map(eastern_ma)

eastern_ma_map
saveWidget(eastern_ma_map, file = "eastern_ma_2020_presidential_election_results.html")

