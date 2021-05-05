diviconDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-divicon", version = "1.0.0",
      src = system.file("htmlwidgets/lfx-divicon", package = "leaflet.extras2"),
      script = "lfx-divicon-bindings.js",
      all_files = TRUE
    )
  )
}

#' Add DivIcon
#'
#' The function expects either line or point data as spatial data or as Simple Feature.
#' Alternatively, coordinates can also be passed as numeric vectors.
#' @param map the map to add moving markers
#' @inheritParams leaflet::addAwesomeMarkers
#' @param duration Duration in milliseconds per line segment between 2 points.
#'   Can be a vector or a single number. Default is \code{1000}
#' @param movingOptions a list of extra options for moving markers.
#'   See \code{\link{movingMarkerOptions}}
#' @param layerId In order to be able to address the moving markings
#'   individually, a layerId is required. If none is specified, one is created
#'   that is derived from the current timestamp.
#' @param options a list of extra options for markers. See
#'   \code{\link[leaflet]{markerOptions}}
#' @family Divicon Functions
#' @references \url{https://github.com/ewoken/Leaflet.MovingMarker}
#' @inherit leaflet::addMarkers return
#' @export
#' @examples
#' library(sf)
#' library(leaflet)
#' library(leaflet.extras2)
#'
#' df <- sf::st_as_sf(atlStorms2005)[1,]
#' leaflet()  %>%
#'   addTiles() %>%
#'   addPolylines(data = df) %>%
#'   addMovingMarker(data = df,
#'                   movingOptions = movingMarkerOptions(autostart = TRUE, loop = TRUE),
#'                   label="I am a pirate!",
#'                   popup="Arrr")
#'
addDivicon <- function (map, lng = NULL, lat = NULL, layerId = NULL, group = NULL,
                        icon = NULL, popup = NULL, popupOptions = NULL, label = NULL,
                        labelOptions = NULL, options = markerOptions(), clusterOptions = NULL,
                        clusterId = NULL, data = getMapData(map))
{
  if (missing(labelOptions))
    labelOptions <- labelOptions()

  map$dependencies <- c(map$dependencies,
                        diviconDependency())
  pts <- derivePoints(data, lng, lat, missing(lng), missing(lat),
                      "addMarkers")
  invokeMethod(map, data, "addDivicon", pts$lat, pts$lng,
               NULL, layerId, group, options, popup, popupOptions,
               label, labelOptions) %>%
    expandLimits(pts$lat, pts$lng)
}


