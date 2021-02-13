# Map US 2020 Presidential Election Results by Precinct from UpshotData

This R code helps you prep New York Time Upshot data on the 2020 US Presidential Election by precinct. You can find out more about the data at [https://github.com/TheUpshot/presidential-precinct-map-2020](https://github.com/TheUpshot/presidential-precinct-map-2020).

## This repo

_00_packages_needed.R_ will install any packages needed that aren't already on your system.

_01_dataprep.R_ has code to wrangle the data for mapping. It includes this commented-out code to download The Upshot data file is you don't already have it (the code assumes a data subdirectory in your working R project session).

`all_data <- geojson_sf(gzfile("data/precincts-with-results.geojson.gz"))`

_02_maps.R_ has code to create maps. I suggest subsetting the data for a specific state, county, or other smaller region since mapping the entire data set will take quite awhile.

The function for creating a Leaflet map from wrangled data is in the file _map_function.R_.

Many thanks to The Upshot for open-sourcing this data!

Sharon Machlis
