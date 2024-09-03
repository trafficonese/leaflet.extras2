timesliderDependencies <- function() {
  list(
    htmlDependency(
      "lfx-timeslider", "1.0.0",
      src = system.file("htmlwidgets/lfx-timeslider",
        package = "leaflet.extras2"
      ),
      stylesheet = "jquery-ui.css",
      script = c(
        "jquery-ui.min.js",
        "leaflet.SliderControl.min.js",
        "leaflet.SliderControl-bindings.js"
      )
    )
  )
}

#' Add Time Slider to Leaflet
#'
#' The \href{https://github.com/dwilhelm89/LeafletSlider}{LeafletSlider plugin}
#' enables you to dynamically add and remove Markers/Lines on a map by using a
#' JQuery UI slider.
#' @param map a map widget
#' @param data data must be a Simple Feature collection of type POINT or LINESTRING
#'    with a column of class Date or POSIXct.
#' @param ordertime boolean value indicating whether to order the data by the
#'    time column. The slider will adopt the order of the timestamps.
#'    The default is \code{TRUE}.
#' @param options List of additional options. See \code{\link{timesliderOptions}}
#' @family Timeslider Functions
#' @references \url{https://github.com/dwilhelm89/LeafletSlider}
#' @export
#' @inheritParams leaflet::addCircleMarkers
#' @inherit leaflet::addMarkers return
#' @examples
#' library(leaflet)
#' library(leaflet.extras2)
#' library(sf)
#'
#' data <- sf::st_as_sf(leaflet::atlStorms2005[1, ])
#' data <- st_cast(data, "POINT")
#' data$time <- as.POSIXct(
#'   seq.POSIXt(Sys.time() - 1000, Sys.time(), length.out = nrow(data))
#' )
#'
#' leaflet() %>%
#'   addTiles() %>%
#'   addTimeslider(
#'     data = data,
#'     options = timesliderOptions(
#'       position = "topright",
#'       timeAttribute = "time",
#'       range = TRUE
#'     )
#'   ) %>%
#'   setView(-72, 22, 4)
addTimeslider <- function(map, data, radius = 10,
                          stroke = TRUE, color = "#03F",
                          weight = 5, opacity = 0.5, fill = TRUE,
                          fillColor = color,
                          fillOpacity = 0.2, dashArray = NULL,
                          popup = NULL, popupOptions = NULL,
                          label = NULL, labelOptions = NULL,
                          ordertime = TRUE,
                          options = timesliderOptions()) {
  ## Style Options
  data$radius <- leaflet::evalFormula(radius, data)
  data$stroke <- leaflet::evalFormula(stroke, data)
  data$color <- leaflet::evalFormula(color, data)
  data$weight <- leaflet::evalFormula(weight, data)
  data$fillColor <- leaflet::evalFormula(fillColor, data)
  data$opacity <- leaflet::evalFormula(opacity, data)
  data$fill <- leaflet::evalFormula(fill, data)
  data$dashArray <- leaflet::evalFormula(dashArray, data)
  data$fillOpacity <- leaflet::evalFormula(fillOpacity, data)

  ## Order by time
  if (ordertime) {
    data <- data[order(data[[options$timeAttribute]]), ]
  }

  ## Popup
  if (!is.null(popup) && !isFALSE(popup)) {
    data$popup <- leaflet::evalFormula(popup, data)
  }

  ## Label
  if (!is.null(label) && !isFALSE(label)) {
    data$label <- leaflet::evalFormula(label, data)
  }

  ## BBOX
  if (!requireNamespace("sf")) {
    stop(
      "The package `sf` is needed for this plugin. ",
      "Please install it with:\ninstall.packages('sf')"
    )
  }
  bbox <- sf::st_bbox(data)

  ## Make GeoJSON
  if (!requireNamespace("yyjsonr")) {
    stop(
      "The package `yyjsonr` is needed for this plugin. ",
      "Please install it with:\ninstall.packages('yyjsonr')"
    )
  }
  data <- yyjsonr::write_geojson_str(data)
  class(data) <- c("geojson", "json")

  ## Add Deps and invoke Leaflet
  map$dependencies <- c(map$dependencies, timesliderDependencies())
  invokeMethod(
    map, NULL, "addTimeslider", data, options,
    popupOptions, labelOptions
  ) %>%
    expandLimits(bbox[c(2, 4)], bbox[c(1, 3)])
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
#' @param timeStrLength the size of \code{yyyy-mm-dd hh:mm:ss} - if milliseconds are
#'   present this will be larger. Default is \code{19}
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
#' @param sameDate Show only data with the current selected time.
#'   Default is \code{FALSE}
#' @family Timeslider Functions
#' @return A list of options for \code{addTimeslider}
#' @references \url{https://github.com/dwilhelm89/LeafletSlider}
#' @export
timesliderOptions <- function(
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
    rezoom = NULL,
    sameDate = FALSE) {
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
    rezoom = rezoom,
    sameDate = sameDate
  ))
}

#' removeTimeslider
#'
#' Remove the Timeslider controls and markers.
#' @param map the map widget
#' @export
#' @inherit leaflet::addMarkers return
#' @family Timeslider Functions
removeTimeslider <- function(map) {
  invokeMethod(map, NULL, "removeTimeslider")
}
