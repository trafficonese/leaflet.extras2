timesliderDependencies <- function() {
  list(
    htmlDependency(
      "lfx-timeslider", "1.0.0",
      src = system.file("htmlwidgets/lfx-timeslider", package = "leaflet.extras2"),
      stylesheet = "jquery-ui.css",
      script = c(
        "jquery-ui.min.js",
        "leaflet.SliderControl.min.js",
        "leaflet.SliderControl-bindings.js")
    )
  )
}

#' Add Time Slider to Leaflet
#'
#' The \href{https://github.com/dwilhelm89/LeafletSlider}{LeafletSlider plugin}
#' enables you to dynamically add and remove Markers on a map by using a
#' JQuery UI slider.
#' @param map a map widget
#' @param data data must be a POINT Simple Feature with a time column.
#' @param options List of additional options. See \code{\link{timesliderOptions}}
#' @family Timeslider Functions
#' @references \url{https://github.com/dwilhelm89/LeafletSlider}
#' @export
#' @inherit leaflet::addMarkers return
#' @examples \dontrun{
#' library(leaflet)
#' library(leaflet.extras2)
#' library(sf)
#' library(geojsonsf)
#'
#' data <- sf::st_as_sf(leaflet::atlStorms2005[1,])
#' data <- st_cast(data, "POINT")
#' data$time = as.POSIXct(
#'   seq.POSIXt(Sys.time() - 1000, Sys.time(), length.out = nrow(data)))
#'
#' leaflet() %>%
#'   addTiles() %>%
#'   addTimeslider(data = data,
#'              options = timesliderOptions(
#'                position = "topright",
#'                timeAttribute = "time",
#'                range = TRUE)) %>%
#'   setView(-72, 22, 4)
#' }
addTimeslider <- function(map, data, options = timesliderOptions()){

  if (!requireNamespace("geojsonsf")) {
    stop("The package `geojsonsf` is needed for this plugin. ",
         "Please install it with:\ninstall.packages('geojsonsf')")
  }

  data <- geojsonsf::sf_geojson(data)

  map$dependencies <- c(map$dependencies, timesliderDependencies())

  invokeMethod(map, NULL, "addTimeslider", data, options)
}

#' timesliderOptions
#'
#' A list of options for \code{\link{addTimeslider}}.
#' @param position position of control: "topleft", "topright", "bottomleft", or
#'   "bottomright". Default is \code{topright}.
#' @param timeAttribute The column name of the time property.
#'   Default is \code{"time"}
#' @param isEpoch whether the time attribute is seconds elapsed from epoch.
#'   Default is \code{FALSE}
#' @param startTimeIdx where to start looking for a timestring
#'   Default is \code{0}
#' @param timeStrLength the size of yyyy-mm-dd hh:mm:ss - if milliseconds are present this will be larger
#'   Default is \code{19}
#' @param maxValue Set the maximum value of the slider. Default is \code{-1}
#' @param minValue Set the minimum value of the slider. Default is \code{0}
#' @param showAllOnStart Specify whether all markers should be initially visible.
#'   Default is \code{FALSE}
#' @param range To use a range-slider, set to \code{TRUE.} Default is \code{FALSE}
#'   Default is \code{FALSE}
#' @param follow To display only the markers at the specific timestamp specified
#'   by the slider. Specify a value of 1 (or true) to display only a single data
#'   point at a time, and a value of null (or false) to display the current marker
#'   and all previous markers. The range property overrides the follow property.
#'   Default is \code{FALSE}
#' @param alwaysShowDate Should the Date always be visible. Default is \code{FALSE}
#' @param rezoom Use the rezoom property to ensure the markers being displayed
#'   remain in view. Default is \code{NULL}
#' @family Timeslider Functions
#' @return A list of options for \code{addTimeslider}
#' @references \url{https://github.com/dwilhelm89/LeafletSlider}
#' @export
timesliderOptions = function(
  position = c("topright", "bottomleft", "bottomright", "topleft"),
  timeAttribute = "time",
  isEpoch = FALSE,
  startTimeIdx = 0,
  timeStrLength = 19,
  maxValue = -1,
  minValue = 0,
  showAllOnStart = FALSE,
  range = FALSE,
  follow = FALSE,
  alwaysShowDate = FALSE,
  rezoom = NULL) {

  leaflet::filterNULL(list(
    position = match.arg(position),
    timeAttribute = timeAttribute,
    isEpoch = isEpoch,
    startTimeIdx = startTimeIdx,
    timeStrLength = timeStrLength,
    maxValue = maxValue,
    minValue = minValue,
    showAllOnStart = showAllOnStart,
    range = range,
    follow = follow,
    alwaysShowDate = alwaysShowDate,
    rezoom = rezoom
  ))
}

#' removeTimeslider
#'
#' Remove the Timeslider controls and markers.
#' @param map the map widget
#' @export
#' @inherit leaflet::addMarkers return
#' @family Timeslider Functions
removeTimeslider <- function(map){
  invokeMethod(map, NULL, "removeTimeslider")
}
