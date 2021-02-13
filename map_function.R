
#' Generate Leaflet map from sf object downloaded from The Upshot (NYTimes)
#'
#' @param sf_object sf object created from downloaded Upshot election data
#' @param map_tiles character string available Leaflet tiles, defaults to "CartoDB.Positron"
#' @param color_opacity number from 0 to 1, defaults to 0.7
#' @param winner_name character string defaults to "Biden"
#' @param loser_name character string defaults to "Trump"
#'
#' @return leaflet object and htmlwidget interactive map
#' @export
#'

generate_leaflet_map <- function(sf_object, map_tiles = "CartoDB.Positron", color_opacity = 0.7, winner_name = "Biden", loser_name = "Trump") {

  
  # Popups

  dem_winner_palette <- colorNumeric("Blues", domain = c(0.00001, 100))
  gop_loser_palette <- colorNumeric("Reds", domain = c(-0.00001, -100), reverse = TRUE)
  
  winner_df <- sf_object[sf_object$pct_dem_lead > 0,]
  loser_df <- sf_object[sf_object$pct_dem_lead < 0,]
  tie_df <- sf_object[sf_object$votes_dem == sf_object$votes_rep & !(is.na(sf_object$votes_total)) & sf_object$votes_total !=0,]
  
  winner_popup <- glue::glue("<strong>Precinct: {winner_df[['GEOID']]}</strong><br /><strong>Winner: {winner_name} by {winner_df[['pct_dem_lead']]}%</strong><br />{winner_name}: {scales::comma(winner_df[['votes_dem']], accuracy = 1) } votes<br />{loser_name}: {scales::comma(winner_df[['votes_rep']], accuracy = 1)} votes")  %>%   lapply(htmltools::HTML)
  
  loser_popup <- glue::glue("<strong>Precinct: {loser_df[['GEOID']]}</strong><br /><strong>Winner: {loser_name} by {abs(loser_df[['pct_dem_lead']])}%</strong><br />{winner_name}: {scales::comma(loser_df[['votes_dem']], accuracy = 1) } votes<br />{loser_name}: {scales::comma(loser_df[['votes_rep']], accuracy = 1)} votes")  %>%   lapply(htmltools::HTML)
  
  tie_popup <- glue::glue("<strong>Precinct: {tie_df[['GEOID']]}</strong><br /><br />{winner_name}: {scales::comma(tie_df[['votes_dem']], accuracy = 1) } votes<br />{loser_name}: {scales::comma(tie_df[['votes_rep']], accuracy = 1)} votes")  %>%   lapply(htmltools::HTML)
  
  
  my_map <- leaflet() %>%
    addProviderTiles(map_tiles) %>%
    addSearchOSM(options = searchOptions(autoCollapse = FALSE, minLength = 2)) %>%
    addPolygons(
      data = winner_df,
      stroke = TRUE,
      smoothFactor = 0.2,
      fillOpacity = color_opacity,
      fillColor = ~dem_winner_palette(winner_df[['pct_dem_lead']]),
      color = "#666",
      weight = 1,
      label = winner_popup
    )
  
  if(nrow(loser_df) > 0) {
    my_map <- my_map %>%
      addPolygons(
        data = loser_df,
        stroke = TRUE,
        smoothFactor = 0.2,
        fillOpacity = color_opacity,
        fillColor = ~gop_loser_palette(loser_df[['pct_dem_lead']]),
        color = "#666",
        weight = 1,
        label = loser_popup
      )
  }
  
  if(nrow(tie_df) > 0) {
    
    my_map <- my_map %>%
      addPolygons(
        data = tie_df,
        stroke = TRUE,
        smoothFactor = 0.2,
        fillOpacity = color_opacity,
        fillColor = "white" ,
        color = "#666",
        weight = 1,
        label = tie_popup
      )
  }
  
  tagline <- htmltools::tags$div(
    htmltools::HTML('Data source: <a href="https://github.com/TheUpshot/presidential-precinct-map-2020">The Upshot, NY Times</a>')
  )  
  
  my_map <- my_map %>%
    addControl(tagline, position = "bottomleft")
  
  return(my_map)
  
  
}
