layergroupCollisionDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-layergroupcollision", version = "1.0.0",
      src = system.file("htmlwidgets/lfx-layergroupcollision",
                        package = "leaflet.extras2"),
      script = c("rbush.min.js",
                 "Leaflet.LayerGroup.Collision.js",
                 "layergroup-binding.js"),
      all_files = TRUE
    )
  )
}

#' Add LayerGroup Collision Plugin to Leaflet Map
#'
#' @description Integrates the LayerGroup Collision plugin into a Leaflet map,
#' which hides overlapping markers and only displays the first added marker in a
#' collision group. Markers must be static; dynamic changes, dragging, and
#' deletions are not supported.

#' The function transforms spatial data into GeoJSON format and uses `L.DivIcon`,
#' allowing you to pass HTML content and CSS classes to style the markers.
#'
#' @param group the name of the group. It needs to be single string.
#' @return A leaflet map object with the LayerGroup Collision plugin added.
#' @export
#'
#' @inheritParams addDivicon
#' @references \url{https://github.com/MazeMap/Leaflet.LayerGroup.Collision}
#'
#' @name LayerroupCollision
#' @examples
#' library(leaflet)
#' library(sf)
#' library(leaflet.extras2)
#'
#' df <- sf::st_as_sf(atlStorms2005)
#' df <- suppressWarnings(st_cast(df, "POINT"))
#' df <- df[sample(1:nrow(df), 150, replace = F),]
#' df$classes = sample(x = 1:5, nrow(df), replace = TRUE)
#'
#' leaflet() %>%
#'   addProviderTiles("CartoDB.Positron") %>%
#'   leaflet::addLayersControl(overlayGroups = c("Labels")) %>%
#'   addLayerGroupCollision(data = df
#'                          , html = ~paste0(
#'                            '<div style="width: 70px" class="custom-html">',
#'                            '<div class="title">', Name, '</div>',
#'                            '<div class="subtitle">MaxWind: ', MaxWind, '</div>',
#'                            '</div>'
#'                          )
#'                          , className = ~paste0("my-label my-label-", classes)
#'                          , group = "Labels"
#'   )
addLayerGroupCollision <- function(
    map, group = NULL,
    className = NULL, html = NULL,
    margin = 5, data = getMapData(map)) {

  map$dependencies <- c(map$dependencies, layergroupCollisionDependency())

  ## Make Geojson and Assign Class & HTML columns ###########
  if (!inherits(data, "sf")) {
    data <- sf::st_as_sf(data)
  }
  data$className__ <- evalFormula(className, data)
  data$html__ <- evalFormula(html, data)
  geojson <- yyjsonr::write_geojson_str(data)
  class(geojson) <- c("geojson", "json")

  ## Derive Points and Invoke Method ##################
  pts <- derivePoints(
    data, NULL, NULL, TRUE, TRUE,
    "addLayerGroupCollision"
  )
  invokeMethod(
    map, NULL, "addLayerGroupCollision",
    geojson, group, margin
  ) %>%
    expandLimits(pts$lat, pts$lng)
}
