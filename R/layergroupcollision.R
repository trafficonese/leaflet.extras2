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
#' @return A leaflet map object
#' @export
#'
#' @inheritParams leaflet::addAwesomeMarkers
#' @references \url{https://github.com/Geovation/labelgun}
#'
#' @name LayerroupCollision
addLayerGroupCollision <- function(
    map, lng = NULL, lat = NULL, layerId = NULL, group = NULL,
    popup = NULL, popupOptions = NULL, label = NULL,
    labelOptions = NULL,
    className = NULL, html = NULL,
    options = markerOptions(), clusterOptions = NULL,
    clusterId = NULL, margin = 5, data = getMapData(map)
) {

  map$dependencies <- c(map$dependencies, layergroupCollisionDependency())

  ## Derive Points and Invoke Method ##################
  pts <- derivePoints(
    data, lng, lat, missing(lng), missing(lat),
    "addLayerGroupCollision"
  )
  invokeMethod(
    map, data, "addLayerGroupCollision", pts$lat, pts$lng,
    layerId, group, options,
    className, html,
    popup, popupOptions,
    label, labelOptions,
    clusterId, clusterOptions,
    margin,
    getCrosstalkOptions(data)
  ) %>%
    expandLimits(pts$lat, pts$lng)
}
