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

  bbox = list(lat = c(-90, 90), lng = c(0, 180))

  if (inherits(data, "data.frame") || inherits(data, "matrix")) {
    ## Check if the `time` column exists. It is required!
    if (!any(colnames(data) == time)) stop("No column named `", time, "` in data.")
    data$time <- data[,time]
    ## If the `time` column is present but not numeric, convert it to milliseconds
    if (!is.null(data$time) && !is.numeric(data$time)) {
      data$time <- as.numeric(data$time) * 1000
    }
    ## If there is no `geometry` column, check if lat/lng are given as columns
    if (!any(colnames(data) %in% c("geom","geometry"))) {
      ## Check if any column has lat/lon values
      latnams <- c("y","lat","latitude")
      lonnams <- c("x","lon","lng","longitude")
      has_lat <- tolower(colnames(data)) %in% latnams
      has_lng <- tolower(colnames(data)) %in% lonnams
      if (any(has_lat) && any(has_lng)) {
        data <- list(
          geometry = cbind(data[,colnames(data)[which(has_lng)]],
                           data[,colnames(data)[which(has_lat)]]),
          time = data$time
        )
      } else {
        ## No lat/lng columns in data. Error
        stop("Cannot read Lat/Lon columns. The column names must match either: \n",
             paste(latnams, collapse = ","), " / ", paste(lonnams, collapse = ","))
      }
    }
    if (inherits(data$geometry, "sfc")) {
      bboxtmp <- matrix(unlist(data$geometry), ncol = 2, byrow = T)
    } else {
      bboxtmp <- matrix(unlist(data$geometry), ncol = 2, byrow = F)
    }
    bbox$lat <- bboxtmp[,2]
    bbox$lng <- bboxtmp[,1]
  }
  else if (inherits(data, "list")) {
    bboxtmp <- matrix(unlist(do.call(rbind, data)$geometry), ncol = 2, byrow = T)
    bbox$lat <- bboxtmp[,2]
    bbox$lng <- bboxtmp[,1]
    lendf <- length(data)
    if (length(options$color) != lendf) {
      options$color <- rep(options$color, lendf)[seq.int(lendf)]
    }
    lapply(1:lendf, function(x) {
      ## Check if the `time` column exists. It is required!
      if (!any(colnames(data[[x]]) == time)) stop("No column named `", time, "` in data.")
      data[[x]]$time <- data[[x]][,time]
      ## If the `time` column is present but not numeric, convert it
      if (!is.null(data[[x]]$time) && !is.numeric(data[[x]]$time)) {
        data[[x]]$time <<- as.numeric(data[[x]]$time) * 1000
      }
      ## If there is no `geometry` column, check if lat/lng are given as columns
      if (!any(colnames(data[[x]]) %in% c("geom","geometry"))) {
        ## Check if any column has lat/lon values
        latnams <- c("y","lat","latitude")
        lonnams <- c("x","lon","lng","longitude")
        has_lat <- tolower(colnames(data[[x]])) %in% latnams
        has_lng <- tolower(colnames(data[[x]])) %in% lonnams
        if (any(has_lat) && any(has_lng)) {
          data <<- list(
            geometry = cbind(data[[x]][,colnames(data)[which(has_lng)]],
                             data[[x]][,colnames(data)[which(has_lat)]]),
            time = data[[x]]$time
          )
        }
      }
    })
  }
  else if (inherits(data, "character")) {
    ## Since `basename` does not work, when the string is too long, we count
    ## the number of characters first. 300 is chosen randomly, but I doubt that
    ## file paths would be that long. If it's longer, we assume that its a JSON string already
    if (nchar(data) < 300) {
      ## Check if it's a path or URL to a json file
      fileext <- gsub(".*\\.", "", basename(data))
      if (fileext == "json" || fileext == "geojson") {
        if (!requireNamespace("jsonlite")) {
          stop("Package `jsonlite` must be loaded to parse the `content`")
        }
        data <- jsonlite::read_json(data)
      }
    }
  }
  else {
    stop("Cannot parse data")
  }

  map$dependencies <- c(map$dependencies, playbackDependencies())
  options <- leaflet::filterNULL(c(icon = list(icon),
                                  pathOptions = list(pathOpts),
                                  options))

  invokeMethod(map, NULL, "addPlayback", data, options) %>%
    expandLimits(bbox$lat, bbox$lng)
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
