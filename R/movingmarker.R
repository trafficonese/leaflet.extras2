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
#'
#' The function expects either line or point data as spatial data or as Simple Feature.
#' Alternatively, coordinates can also be passed as numeric vectors.
#' @param map the map to add mapkey Markers to.
#' @inheritParams leaflet::addAwesomeMarkers
#' @param duration Duration in milliseconds per line segment between 2 points.
#'   Can be a vector or a single number. Default is \code{1000}
#' @param movingOptions a list of extra options for moving markers.
#'   See \code{\link{movingMarkerOptions}}
#' @param options a list of extra options for markers. See
#'   \code{\link[leaflet]{markerOptions}}
#' @family MovingMarker Functions
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
addMovingMarker = function(
  map, lng = NULL, lat = NULL, layerId = NULL, group = NULL,
  duration = 2000,
  icon = NULL,
  popup = NULL, popupOptions = NULL,
  label = NULL, labelOptions = NULL,
  movingOptions = movingMarkerOptions(),
  options = leaflet::markerOptions(),
  data = leaflet::getMapData(map)) {

  if (missing(labelOptions))
    labelOptions <- labelOptions()

  if (!is.null(data)) {
    if (!requireNamespace("sf")) {
      stop("The package `sf` is needed for this plugin. ",
           "Please install it with:\ninstall.packages('sf')")
    }
    if (inherits(data, "Spatial")) {
      data <- sf::st_as_sf(data)
    }
    if (!inherits(sf::st_geometry(data), "sfc_POINT")) {
      data <- sf::st_cast(data, "POINT")
    }
  }

  pts <- derivePoints(data, lng, lat, missing(lng), missing(lat), "addMovingMarker")

  duration <- evalFormula(duration, data)
  options <- filterNULL(c(options, movingOptions))

  map$dependencies <- c(map$dependencies,
                        movingmarkerDependency())

  leaflet::invokeMethod(
    map, data, "addMovingMarker", cbind(pts$lat, pts$lng),
    duration, icon, layerId,
    group, options, popup, popupOptions,
    leaflet::safeLabel(label, data), labelOptions) %>%
    expandLimits(pts$lat, pts$lng)
}


#' Set options for Moving Markers
#' @param autostart If \code{TRUE} the marker will start automatically after it
#'   is added to map. Default is \code{FALSE}
#' @param loop if \code{TRUE} the marker will start automatically at the
#'   beginning of the polyline when the it arrives at the end.
#'   Default is \code{FALSE}
#' @param pauseOnZoom Pause the marker while zooming. While this improves the
#'   animation, it is not recommended because the animation time is lost and
#'   the marker will not appear at the correct time at the next station.
#'   Default is \code{FALSE}
#' @family MovingMarker Functions
#' @references \url{https://github.com/ewoken/Leaflet.MovingMarker}
#' @return A list of extra options for moving markers
#' @export
movingMarkerOptions <- function(autostart = FALSE, loop = FALSE,
                                pauseOnZoom = FALSE) {
  list(
    autostart = autostart,
    loop = loop,
    pauseOnZoom = pauseOnZoom
  )
}


#' Interact with the moving markers
#'
#' The marker begins its path or resumes if it is paused.
#' @param map The leafletProxy object
#' @param latlng Coordinates as list (e.g.: \code{list(33, -67)} or
#'   \code{list(lng=-65, lat=33)})
#' @param duration Duration in milliseconds
#' @param pointIndex Index of a certain point
#' @family MovingMarker Functions
#' @references \url{https://github.com/ewoken/Leaflet.MovingMarker}
#' @aliases startMoving
#' @return the new \code{map} object
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
#' @aliases pauseMoving
#' @export
pauseMoving <- function(map) {
  leaflet::invokeMethod(map, NULL, "pauseMoving")
}

#' @describeIn startMoving The marker resumes its animation
#' @aliases resumeMoving
#' @export
resumeMoving <- function(map) {
  leaflet::invokeMethod(map, NULL, "resumeMoving")
}

#' @describeIn startMoving Adds a point to the polyline.
#'   Useful, if we have to set the path one by one.
#' @aliases addLatLngMoving
#' @export
addLatLngMoving <- function(map, latlng, duration) {
  leaflet::invokeMethod(map, NULL, "addLatLngMoving", latlng, duration)
}

#' @describeIn startMoving Stop the current animation and make the marker move
#'   to \code{latlng} in \code{duration} ms.
#' @aliases moveToMoving
#' @export
moveToMoving <- function(map, latlng, duration) {
  leaflet::invokeMethod(map, NULL, "moveToMoving", latlng, duration)
}

#' @describeIn startMoving The marker will stop at the \code{pointIndex} point
#'   of the polyline for \code{duration} milliseconds. You can't add a station
#'   at the first or last point of the polyline.
#' @aliases addStationMoving
#' @export
addStationMoving <- function(map, pointIndex, duration) {
  leaflet::invokeMethod(map, NULL, "addStationMoving", pointIndex, duration)
}

