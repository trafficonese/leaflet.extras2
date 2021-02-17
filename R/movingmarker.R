movingmarkerDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-movingmarker", version = "1.0.0",
      src = system.file("htmlwidgets/lfx-movingmarker", package = "leaflet.extras2"),
      script = c("MovingMarker.js",
                 "lfx-movingmarker-bindings.js"),
      all_files = TRUE
    )
  )
}

#' Add Moving Markers
#' @param map the map to add mapkey Markers to.
#' @inheritParams leaflet::addAwesomeMarkers
#' @param duration Duration in milliseconds per line segment between 2 points.
#'   Can be a vector or a single number. Default is \code{1000}
#' @param options a list of extra options for markers. See
#'   \code{\link[leaflet]{markerOptions}}
#' @family MovingMarker Functions
#' @references \url{https://github.com/ewoken/Leaflet.MovingMarker}
#' @inherit leaflet::addMarkers return
#' @export
#' @examples
#' library(leaflet)
#'
#' leaflet()  %>%
#'   addTiles() %>%
#'   addMapkeyMarkers(data = breweries91,
#'                 icon = makeMapkeyIcon(icon = "mapkey",
#'                                       iconSize = 30,
#'                                       boxShadow = FALSE,
#'                                       background = "transparent"),
#'                 group = "mapkey",
#'                 label = ~state, popup = ~village)
addMovingMarker = function(
  map, lng = NULL, lat = NULL, layerId = NULL, group = NULL,
  duration = 1000,
  icon = NULL,
  popup = NULL,
  popupOptions = NULL,
  label = NULL,
  labelOptions = NULL,
  movingOptions = movingMarkerOptions(),
  options = leaflet::markerOptions(),
  data = leaflet::getMapData(map)
) {
  map$dependencies <- c(map$dependencies,
                        movingmarkerDependency())

  df <- st_coordinates(data)

  duration <- evalFormula(duration, data)

  options <- filterNULL(c(options, movingOptions))

  leaflet::invokeMethod(
    map, data, "addMovingMarker", df[,c(2,1)],
    duration, icon, layerId,
    group, options, popup, popupOptions,
    leaflet::safeLabel(label, data), labelOptions
  ) %>%
    expandLimits(df[,2], df[,1])
}


#' Set options for Moving Markers
#' @param autostart If \code{TRUE} the marker will start automatically after it
#'   is added to map. Default is \code{FALSE}
#' @param loop if \code{TRUE} the marker will start automatically at the
#'   beginning of the polyline when the it arrives at the end.
#'   Default is \code{FALSE}
#' @family MovingMarker Functions
#' @references \url{https://github.com/ewoken/Leaflet.MovingMarker}
#' @export
movingMarkerOptions <- function(autostart = FALSE, loop = FALSE) {
  list(
    autostart = autostart,
    loop = loop
  )
}


#' Interact with the moving markers
#'
#' The marker begins its path or resumes if it is paused.
#' @param map The leafletProxy object
#' @param latlng Coordinates as matrix
#' @param duration Duration in milliseconds
#' @param pointIndex Index of a certain point
#' @family MovingMarker Functions
#' @references \url{https://github.com/ewoken/Leaflet.MovingMarker}
#' @export
startMoving <- function(map) {
  leaflet::invokeMethod(map, NULL, "startMoving")
}

#' @describeIn startMoving Manually stops the marker, if you call \code{start}
#'   after, the marker starts again the polyline at the beginning.
#' @aliases stopMoving
#' @export
stopMoving <- function(map) {
  leaflet::invokeMethod(map, NULL, "stopMoving")
}

#' @describeIn startMoving Pauses the marker
#' @export
pauseMoving <- function(map) {
  leaflet::invokeMethod(map, NULL, "pauseMoving")
}

#' @describeIn startMoving The marker resumes its animation
#' @export
resumeMoving <- function(map) {
  leaflet::invokeMethod(map, NULL, "resumeMoving")
}

#' @describeIn startMoving Adds a point to the polyline.
#'   Useful, if we have to set the path one by one.
#' @export
addLatLngMoving <- function(map, latlng, duration) {
  leaflet::invokeMethod(map, NULL, "addLatLngMoving", latlng, duration)
}

#' @describeIn startMoving Stop the current animation and make the marker move
#'   to \code{latlng} in \code{duration} ms.
#' @export
moveToMoving <- function(map, latlng, duration) {
  leaflet::invokeMethod(map, NULL, "moveToMoving", latlng, duration)
}

#' @describeIn startMoving The marker will stop at the \code{pointIndex} point
#'   of the polyline for \code{duration} milliseconds. You can't add a station
#'   at the first or last point of the polyline.
#' @export
addStationMoving <- function(map, pointIndex, duration) {
  leaflet::invokeMethod(map, NULL, "addStationMoving", pointIndex, duration)
}

