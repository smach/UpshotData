# Load packages, including tidycensus for fips codes
library(sf)
library(geojsonsf)
library(dplyr)
library(tidycensus)
data("fips_codes")
str(fips_codes)

# Download file from NYTimes Upshot GitHub if you need to. It is not in this GitHub repo.
# download.file("https://int.nyt.com/newsgraphics/elections/map-data/2020/national/precincts-with-results.geojson.gz", destfile = "data/precincts-with-results.geojson.gz")

# Load data from NY Times Upshot file into R.
# This is a large file so may take awhile. My file is in a project
# data subdirectory
all_data <- geojson_sf(gzfile("data/precincts-with-results.geojson.gz"))

# Create a geoid id column with just the five characters needed
all_data$id <- substr(all_data$GEOID, 1, 5)

# Create a 5-character geoid column from tidycensus fips codes data frame
fips_codes <- mutate(fips_codes, geoid = paste0(state_code, county_code))

# Subset data by state since this is an enormous file. Select the states you want, if any!

# Get MA fips codes in preparation for filtering for MA
ma_ids <- fips_codes[fips_codes$state == "MA",] %>%
  pull(geoid)

# Get NY fips codes
ny_ids <- fips_codes[fips_codes$state == "NY",] %>%
  pull(geoid)

# Create separate objects for MA and NY. Select the states you want, if any!

ma_geojson <- all_data[all_data$id %in% ma_ids,]
ny_geojson <- all_data[all_data$id %in% ny_ids,]

# It might be useful to have the fips_codes separate state and county columns in main data

ma_geojson <- merge(ma_geojson, fips_codes, by.x = "id", by.y = "geoid", all.x = TRUE, all.y = FALSE)

ny_geojson <- merge(ny_geojson, fips_codes, by.x = "id", by.y = "geoid", all.x = TRUE, all.y = FALSE)

# There is some missing data in the NY file, so I'll filter that out:

ny_geojson <- ny_geojson[!is.na(ny_geojson$votes_total) & ny_geojson$votes_total > 0,]

# Test (this will take awhile to run)
plot(ma_geojson)

# Data is ready!