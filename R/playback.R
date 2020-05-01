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
#' @param map a map widget
#' @param data data must be a POINT Simple Feature or a list of POINT Simple
#'   Feature's with a time column. It can also be a JSON string which must be in
#'   a specific form. See the Details for further information.
#' @param time The column name of the time column. Default is \code{"time"}.
#' @param icon an icon which can be created with \code{\link[leaflet]{makeIcon}}
#' @param pathOpts style the CircleMarker with
#'   \code{\link[leaflet]{pathOptions}}
#' @param options Lits of additional options. See \code{\link{playbackOptions}}
#' @description Add Leaflet Playback Plugin based on the
#'  \href{https://github.com/hallahan/LeafletPlayback}{LeafletPlayback plugin}
#' @details If data is a JSON string, it must have the following form:
#' \preformatted{
#' {
#'   "type": "Feature",
#'   "geometry": {
#'     "type": "MultiPoint",
#'     "coordinates": [
#'       [-123.2653968, 44.54962188],
#'       [-123.26542599, 44.54951009]
#'     ]
#' },
#'   "properties": {
#'     "time": [1366067072000, 1366067074000]
#'   }
#' }
#' }
#' Additional arrays can be inside the properties, but are not required and are
#' not used by the plugin. If the JSON is stored in a file you can load it to R
#' via: \code{data <- paste(readLines(json_file_path, warn = F), collapse = "")}
#' @note If used in Shiny, you can listen to 2 events
#' \itemize{
#'  \item `map-ID`+"_pb_mouseover"
#'  \item `map-ID`+"_pb_click"
#' }
#' @family Playback Functions
#' @seealso \url{https://github.com/hallahan/LeafletPlayback}
#' @export
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
#'
#' leaflet() %>%
#'   addTiles() %>%
#'   addPlayback(data = data,
#'               options = playbackOptions(radius = 3),
#'               pathOpts = pathOptions(weight = 5))
#'
#'
#' ## Multiple Elements
#' data <- sf::st_as_sf(leaflet::atlStorms2005[1:5,])
#' data$Name <- as.character(data$Name)
#' data <- st_cast(data, "POINT")
#' data <- split(data, f = data$Name)
#' lapply(1:length(data), function(x) {
#'   data[[x]]$time <<- as.POSIXct(
#'     seq.POSIXt(Sys.time() - 1000, Sys.time(), length.out = nrow(data[[x]])))
#' })
#'
#' leaflet() %>%
#'   addTiles() %>%
#'   addPlayback(data = data,
#'               options = playbackOptions(radius = 3,
#'                                         color = c("red","green","blue",
#'                                                   "orange","yellow")),
#'               pathOpts = pathOptions(weight = 5))
#' }
addPlayback <- function(map, data, time = "time", icon = NULL,
                        pathOpts = pathOptions(),
                        options = playbackOptions()){

  bounds = c(0, -90, 180, 90)

  if (inherits(data, "list")) {
    data <- lapply(data, function(x) {
      if (inherits(x, "Spatial")) x <- sf::st_as_sf(x)
      stopifnot(inherits(sf::st_geometry(x), c("sfc_POINT")))
      to_ms(x, time)
    })
    bounds <- as.numeric(sf::st_bbox(do.call(rbind, data)))
  }
  if (inherits(data, "Spatial")) data <- sf::st_as_sf(data)
  if (inherits(data, "sf")) {
    stopifnot(inherits(sf::st_geometry(data), c("sfc_POINT")))
    data <- to_ms(data, time)
    bounds <- as.numeric(sf::st_bbox(data))
  }

  map$dependencies <- c(map$dependencies, playbackDependencies())
  options <- leaflet::filterNULL(c(icon = list(icon),
                                  pathOptions = list(pathOpts),
                                  options))

  invokeMethod(map, NULL, "addPlayback", data, options) %>%
    expandLimits(lat = c(bounds[2], bounds[4]),
                 lng = c(bounds[1], bounds[3]))
}

#' to_ms
#' Change POSIX or Date to milliseconds
#' @param data The data
#' @param time Columnname of the time column.
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

#' playbackOptions
#' @description Extra options for \code{\link{addPlayback}}. For a full list
#'   please visit the \href{https://github.com/hallahan/LeafletPlayback}{plugin
#'   repository}
#' @param color colors of the CircleMarkers.
#' @param radius a numeric value for the radius of the CircleMarkers.
#' @param tickLen Set tick length in miliseconds. Increasing this value, may
#'   improve performance, at the cost of animation smoothness. Default is 250
#' @param speed Set float multiplier for default animation speed. Default is 1
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
#' @param staleTime Set time before a track is considered stale and faded out.
#'   Default is 60*60*1000 (1 hour)
#' @param ... Further arguments passed to `L.Playback`
#' @family Playback Functions
#' @seealso \url{https://github.com/hallahan/LeafletPlayback}
#' @export
playbackOptions = function(
  color = "blue",
  radius = 5,
  tickLen = 250,
  speed = 1,
  maxInterpolationTime = 5*60*1000,
  tracksLayer = TRUE,
  playControl = TRUE,
  dateControl = TRUE,
  sliderControl = TRUE,
  staleTime = 60*60*1000,
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
    staleTime = staleTime,
    ...
  ))
}

#' removePlayback
#' @param map the map widget.
#' @description Remove the reachability controls
#' @export
#' @family Playback Functions
removePlayback <- function(map){
  invokeMethod(map, NULL, "removePlayback")
}
