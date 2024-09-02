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

#' Add LayerroupCollision Plugin
#' Needs data to be ordered, as frst elements will have priority.
#' @return A leaflet map object
#' @export
#'
#' @inheritParams leaflet::addAwesomeMarkers
#' @references \url{https://github.com/Geovation/labelgun}
#'
#' @name LayerroupCollision
addLayerGroupCollision <- function(
    map, layerId = NULL, group = NULL,
    popup = NULL, popupOptions = NULL, label = NULL,
    labelOptions = NULL,
    className = NULL, html = NULL,
    options = markerOptions(),
    margin = 5, data = getMapData(map)
) {

  map$dependencies <- c(map$dependencies, layergroupCollisionDependency())

  ## Make Geojson ###########
  if (!inherits(data, "sf")) {
    data <- sf::st_as_sf(data)
  }
  geojson <- yyjsonr::write_geojson_str(data)
  class(geojson) <- c("geojson", "json")

  ## Derive Points and Invoke Method ##################
  pts <- derivePoints(
    data, NULL, NULL, TRUE, TRUE,
    "addLayerGroupCollision"
  )
  invokeMethod(
    map, data, "addLayerGroupCollision", geojson,
    layerId, group, options,
    className, html,
    popup, popupOptions,
    label, labelOptions,
    margin
  ) %>%
    expandLimits(pts$lat, pts$lng)
}
