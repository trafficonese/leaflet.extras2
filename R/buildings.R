buildingsDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-building", version = "2.1.0",
      src = system.file("htmlwidgets/lfx-building", package = "leaflet.extras2"),
      stylesheet = "osm-buildings.css",
      script = c(
        # "osm-buildings.js",
        "OSMBuildings.js",
        "osm-buildings-bindings.js")
    )
  )
}

#' Add OSM-Buildings
#'
#' @param map A map widget object created from \code{\link[leaflet]{leaflet}}
#' @param options List of further options. See \code{\link{hexbinOptions}}
#'
#' @note Out of the box a legend image is only available for Pressure,
#'   Precipitation Classic, Clouds Classic, Rain Classic, Snow, Temperature and
#'   Wind Speed.
#' @seealso https://osmbuildings.org/documentation/viewer/
#' @family OSM-Buildings Plugin
#' @export
addBuildings <- function(
  map, layerId = NULL, group = NULL, opacity = 0.5,
  attribution = '© Map tiles <a href="https://mapbox.com">Mapbox</a>') {

  # if (is.null(apikey)) {
  #   apikey <- Sys.getenv("MAPBOX")
  #   if (apikey == "") {
  #     stop("You must either pass an `apikey` directly or save it as ",
  #          "system variable under `MAPBOX`.")
  #   }
  # }

  map$dependencies <- c(map$dependencies, buildingsDependency())

  invokeMethod(map, getMapData(map), "addBuilding", layerId, group,
               opacity, attribution)
}


#' Update the Shadows OSM-Buildings with a POSIXct timestamp
#'
#' @param map A map widget object created from \code{\link[leaflet]{leaflet}}
#' @seealso https://osmbuildings.org/documentation/viewer/
#' @family OSM-Buildings Plugin
#' @export
updateBuildingTime <- function(map, time) {
  invokeMethod(map, NULL, "updateBuildingTime", as.POSIXct(time))
}
