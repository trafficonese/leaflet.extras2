buildingsDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-building", version = "2.1.0",
      src = system.file("htmlwidgets/lfx-building", package = "leaflet.extras2"),
      script = c(
        "osm-buildings.js",
        "osm-buildings-bindings.js"),
      stylesheet = "osm-buildings.css"
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
  map, apikey = NULL, layerId = NULL, group = NULL, opacity = 0.5) {

  if (is.null(apikey)) {
    apikey <- Sys.getenv("MAPBOX")
    if (apikey == "") {
      stop("You must either pass an `apikey` directly or save it as ",
           "system variable under `MAPBOX`.")
    }
  }

  map$dependencies <- c(map$dependencies, buildingsDependency())

  invokeMethod(map, getMapData(map), "addBuilding", apikey, layerId, group, opacity)
}
