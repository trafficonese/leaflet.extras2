playbackDependencies <- function() {
  list(
    htmlDependency(
      "lfx-playback", "1.0.0",
      src = system.file("htmlwidgets/lfx-playback", package = "leaflet.extras2"),
      script = c("leaflet.playback.js",
                 "leaflet.playback-bindings.js")
    )
  )
}

#' Add Playback to Leaflet
#'
#' The \href{https://github.com/hallahan/LeafletPlayback}{LeafletPlayback plugin}
#' provides the ability to replay GPS Points in the form of
#' POINT Simple Features. Rather than simply animating a marker along a
#' polyline, the speed of the animation is synchronized to a clock. The playback
#' functionality is similar to a video player; you can start and stop playback or
#' change the playback speed.
#' @param map a map widget
#' @param data data must be a POINT Simple Feature or a list of POINT Simple
#'   Feature's with a time column.
#' @param popup A formula with the column names for the popup content
#' @param label A formula with the column names for the label content
#' @param time The column name of the time column. Default is \code{"time"}.
#' @param icon an icon which can be created with \code{\link[leaflet]{makeIcon}}
#' @param pathOpts style the CircleMarkers with
#'   \code{\link[leaflet]{pathOptions}}
#' @param options List of additional options. See \code{\link{playbackOptions}}
#' @note If used in Shiny, you can listen to 2 events
#' \itemize{
#'  \item `map-ID`+"_pb_mouseover"
#'  \item `map-ID`+"_pb_click"
#' }
#' @family Playback Functions
#' @references \url{https://github.com/hallahan/LeafletPlayback}
#' @export
#' @inheritParams leaflet::addMarkers
#' @inherit leaflet::addMarkers return
#' @examples \dontrun{
#' library(leaflet)
#' library(leaflet.extras2)
#' library(sf)
#'
#' ## Single Elements
#' data <- sf::st_as_sf(leaflet::atlStorms2005[1,])
#' data <- st_cast(data, "POINT")
#' data$time = as.POSIXct(
#'   seq.POSIXt(Sys.time() - 1000, Sys.time(), length.out = nrow(data)))
#' data$label <- as.character(data$time)
#'
#' leaflet() %>%
#'   addTiles() %>%
#'   addPlayback(data = data, label = ~label,
#'               popup = ~sprintf("I am a popup for <b>%s</b> and <b>%s</b>",
#'                                Name, label),
#'               popupOptions = popupOptions(offset = c(0, -35)),
#'               options = playbackOptions(radius = 3,
#'                                         tickLen = 36000,
#'                                         speed = 50,
#'                                         maxInterpolationTime = 1000),
#'               pathOpts = pathOptions(weight = 5))
#'
#'
#' ## Multiple Elements
#' data <- sf::st_as_sf(leaflet::atlStorms2005[1:5,])
#' data$Name <- as.character(data$Name)
#' data <- st_cast(data, "POINT")
#' data$time <- unlist(lapply(rle(data$Name)$lengths, function(x) {
#'   seq.POSIXt(as.POSIXct(Sys.Date()-2), as.POSIXct(Sys.Date()), length.out = x)
#' }))
#' data$time <- as.POSIXct(data$time, origin="1970-01-01")
#' data$label <- paste0("Time: ", data$time)
#' data$popup = sprintf("<h3>Customized Popup</h3><b>Name</b>: %s<br><b>Time</b>: %s",
#'                      data$Name, data$time)
#' data <- split(data, f = data$Name)
#'
#' leaflet() %>%
#'   addTiles() %>%
#'   addPlayback(data = data,
#'              popup = ~popup,
#'              label = ~label,
#'              popupOptions = popupOptions(offset=c(0,-35)),
#'              labelOptions = labelOptions(noHide = TRUE),
#'              options = playbackOptions(radius = 3,
#'                                        tickLen = 1000000,
#'                                        speed = 5000,
#'                                        maxInterpolationTime = 10000,
#'                                        transitionpopup = FALSE,
#'                                        transitionlabel = FALSE,
#'                                        playCommand = "Let's go",
#'                                        stopCommand = "Stop it!",
#'                                        color = c("red","green","blue",
#'                                                  "orange","yellow")),
#'               pathOpts = pathOptions(weight = 5))
#' }
addPlayback <- function(map, data, time = "time", icon = NULL,
                        pathOpts = pathOptions(),
                        popup = NULL,
                        label = NULL,
                        popupOptions = NULL,
                        labelOptions = NULL,
                        options = playbackOptions()){

  if (!requireNamespace("sf")) {
    stop("The package `sf` is needed for this plugin. ",
         "Please install it with:\ninstall.packages('sf')")
  }

  if (inherits(data, "list")) {
    data <- lapply(data, function(x) {
      to_jsonformat(x, time, popup, label)
    })
    bounds <- do.call(rbind, lapply(data, function(x) x$geometry$coordinates))
  } else {
    data <- to_jsonformat(data, time, popup, label)
    bounds <- data$geometry$coordinates
  }

  map$dependencies <- c(map$dependencies, playbackDependencies())
  options <- leaflet::filterNULL(c(icon = list(icon),
                                  pathOptions = list(pathOpts),
                                  popupOptions = list(popupOptions),
                                  labelOptions = list(labelOptions),
                                  popups = if(is.null(popup)) NULL else TRUE,
                                  labels = if(is.null(label)) NULL else TRUE,
                                  options))

  invokeMethod(map, NULL, "addPlayback", data, options) %>%
    expandLimits(lat = as.numeric(bounds[,"Y"]),
                 lng = as.numeric(bounds[,"X"]))
}

#' playbackOptions
#'
#' A list of options for \code{\link{addPlayback}}. For a full list please visit
#' the \href{https://github.com/hallahan/LeafletPlayback}{plugin repository}.
#' @param color colors of the CircleMarkers.
#' @param radius a numeric value for the radius of the CircleMarkers.
#' @param tickLen Set tick length in milliseconds. Increasing this value, may
#'   improve performance, at the cost of animation smoothness. Default is 250
#' @param speed Set float multiplier for default animation speed. Default is 50
#' @param maxInterpolationTime Set max interpolation time in seconds.
#'   Default is 5*60*1000 (5 minutes).
#' @param tracksLayer Set \code{TRUE} if you want to show layer control on the
#'   map. Default is \code{TRUE}
#' @param playControl Set \code{TRUE} if play button is needed.
#'   Default is \code{TRUE}
#' @param dateControl Set \code{TRUE} if date label is needed.
#'   Default is \code{TRUE}
#' @param sliderControl Set \code{TRUE} if slider control is needed.
#'   Default is \code{TRUE}
#' @param orientIcons Set \code{TRUE} if you want icons to orient themselves on each
#'   tick based on the bearing towards their next location. Default: \code{FALSE}
#' @param staleTime Set time before a track is considered stale and faded out.
#'   Default is 60*60*1000 (1 hour)
#' @param transitionpopup Should the position of the popup move smoothly,
#'   like the marker icon? Default: \code{TRUE}
#' @param transitionlabel Should the position of the label move smoothly,
#'   like the marker icon? Default: \code{TRUE}
#' @param ... Further arguments passed to `L.Playback`
#' @family Playback Functions
#' @return A list of options for \code{addPlayback}
#' @references \url{https://github.com/hallahan/LeafletPlayback}
#' @export
playbackOptions = function(
  color = "blue",
  radius = 5,
  tickLen = 250,
  speed = 50,
  maxInterpolationTime = 5*60*1000,
  tracksLayer = TRUE,
  playControl = TRUE,
  dateControl = TRUE,
  sliderControl = TRUE,
  orientIcons = FALSE,
  staleTime = 60*60*1000,
  transitionpopup = TRUE,
  transitionlabel = TRUE,
  ...) {
  leaflet::filterNULL(list(
    color = color,
    radius = radius,
    tickLen = tickLen,
    speed = speed,
    maxInterpolationTime = maxInterpolationTime,
    tracksLayer = tracksLayer,
    playControl = playControl,
    dateControl = dateControl,
    sliderControl = sliderControl,
    orientIcons = orientIcons,
    staleTime = staleTime,
    transitionpopup = transitionpopup,
    transitionlabel = transitionlabel,
    ...
  ))
}

#' removePlayback
#'
#' Remove the Playback controls and markers.
#' @param map the map widget
#' @export
#' @inherit leaflet::addMarkers return
#' @family Playback Functions
removePlayback <- function(map){
  invokeMethod(map, NULL, "removePlayback")
}




#' to_jsonformat
#' Transform object to JSON expected format
#' @param data The data
#' @param time Name of the time column.
#' @param popup Name of the popup column.
#' @param label Name of the label column.
#' @return A list that is transformed to the expected JSON format
to_jsonformat <- function(data, time, popup=NULL, label=NULL) {
  if (inherits(data, "Spatial")) data <- sf::st_as_sf(data)
  if (inherits(data, "sf")) {
    stopifnot(inherits(sf::st_geometry(data), c("sfc_POINT")))
    data <- to_ms(data, time)
    dataorig <- data
    data <- list("type"="Feature",
                 "geometry"=list(
                   "type"="MultiPoint",
                   "coordinates"=sf::st_coordinates(data)
                 ),
                 "properties"=list(
                   "time"=data$time
                 ))

    if (!is.null(popup)) {
      data <- c(data, list("popupContent" = evalFormula(popup, dataorig)))
    }
    if (!is.null(label)) {
      data <- c(data, list("tooltipContent" = evalFormula(label, dataorig)))
    }
  }
  data
}

#' to_ms
#' Change POSIX or Date to milliseconds
#' @inheritParams to_jsonformat
#' @return A data.frame with the time column in milliseconds
to_ms <- function(data, time) {
  coln <- colnames(data)
  if (!any(coln == time)) {
    stop("No column named `", time, "` found.")
  }
  if (time != "time") {
    colnames(data)[coln == time] <- "time"
  }
  stopifnot(inherits(data[["time"]], c("POSIXt", "Date", "numeric")))
  if (inherits(data[["time"]], "POSIXt")) {
    data[["time"]] <- as.numeric(data[["time"]]) * 1000
  } else if (inherits(data[["time"]], "Date")) {
    data[["time"]] <- as.numeric(data[["time"]]) * 86400000
  }
  data
}
