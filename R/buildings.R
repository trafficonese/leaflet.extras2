buildingsDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-building", version = "2.1.0",
      src = system.file("htmlwidgets/lfx-building", package = "leaflet.extras2"),
      stylesheet = "osm-buildings.css",
      script = c(
        "osm-buildings.js",
        "osm-buildings-bindings.js")
    )
  )
}

#' Add OSM-Buildings to a Leaflet Map
#'
#' This function adds 2.5D buildings to a Leaflet map using the OSM Buildings plugin.
#'
#' @param map A map widget object created from \code{\link[leaflet]{leaflet}}.
#' @param buildingURL The URL template for the building data. Default is the OSM Buildings tile server: \cr
#'   \code{"https://{s}.data.osmbuildings.org/0.2/59fcc2e8/tile/{z}/{x}/{y}.json"}.
#' @param group The name of the group the buildings will be added to.
#' @param eachFn A JavaScript function (using \code{\link[htmlwidgets]{JS}}) that will be called for each building feature. Use this to apply custom logic to each feature.
#' @param clickFn A JavaScript function (using \code{\link[htmlwidgets]{JS}}) that will be called when a building is clicked. Use this to handle click events on buildings.
#' @param data A GeoJSON object containing Polygon features representing the buildings. The properties of these polygons can include attributes like \code{height}, \code{color}, \code{roofColor}, and others as specified in the OSM Buildings documentation.
#'
#' @details
#' The `data` parameter allows you to provide custom building data as a GeoJSON object. The following properties can be used within the GeoJSON:
#' \itemize{
#'   \item \strong{height}
#'   \item \strong{minHeight}
#'   \item \strong{color/wallColor}
#'   \item \strong{material}
#'   \item \strong{roofColor}
#'   \item \strong{roofMaterial}
#'   \item \strong{shape}
#'   \item \strong{roofShape}
#'   \item \strong{roofHeight}
#' }
#'
#' See the OSM Wiki: \href{https://wiki.openstreetmap.org/wiki/Simple_3D_Buildings}
#'
#' @seealso \url{https://github.com/kekscom/osmbuildings/} for more details on the OSM Buildings plugin and available properties.
#' @family OSM-Buildings Plugin
#' @export
addBuildings <- function(
  map,
  buildingURL = "https://{s}.data.osmbuildings.org/0.2/59fcc2e8/tile/{z}/{x}/{y}.json",
  group = NULL,
  eachFn = NULL, clickFn = NULL, data = NULL) {

  map$dependencies <- c(map$dependencies, buildingsDependency())

  invokeMethod(map, getMapData(map), "addBuilding",
               buildingURL, group,
               eachFn, clickFn, data)
}


#' Update the Shadows OSM-Buildings with a POSIXct timestamp
#'
#' @inheritParams addBuildings
#' @param time a timestamp that can be converted to POSIXct
#' @family OSM-Buildings Plugin
#' @export
updateBuildingTime <- function(map, time) {
  invokeMethod(map, NULL, "updateBuildingTime", time)
}

#' Update the OSM-Buildings Style
#'
#' @inheritParams addBuildings
#' @param style A named list of styles
#' @family OSM-Buildings Plugin
#' @export
setBuildingStyle <- function(map, style = list(color = "#ffcc00",
                                               wallColor = "#ffcc00",
                                               roofColor = "orange",
                                               shadows = TRUE)) {
  invokeMethod(map, NULL, "setBuildingStyle", style)
}

#' Update the OSM-Buildings Data
#'
#' @inheritParams addBuildings
#' @family OSM-Buildings Plugin
#' @export
setBuildingData <- function(map, data) {
  invokeMethod(map, NULL, "setBuildingData", data)
}
