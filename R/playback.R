playbackDependencies <- function() {
  list(
    htmlDependency(
      "leaflet.playback", "1.0.0",
      src = system.file("htmlwidgets/lfx-playback", package = "leaflet.extras2"),
      script = c("leaflet.playback.js",
                 "leaflet.playback.bindings.js")
    )
  )
}

#' Add Playback to Leaflet
#'
#' @param map a map widget
#' @param data data can either be a matrix or data.frame with coordinates,
#'   a POINT Simple Feature or a \code{SpatialPointsDataFrame}.
#'   It must contain a time column of class \code{POSIXct} or \code{numeric}.
#'   It can also be a JSON string which must be in a specific form. See the Details
#'   for further information.
#' @param time The column name of the time column. Default is \code{"time"}.
#' @param icon an icon which can be created with \code{\link{makeIcon}{leaflet}}
#' @param pathOptions style the CircleMarker with \code{\link{pathOptions}{leaflet}}
#' @param options see \code{\link{playbackOptions}}
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
#' Additional arrays can be inside the properties, but are not required and are not used
#' by the plugin. If the JSON is stored in a file you can load it to R via:
#' \code{data <- paste(readLines(json_file_path, warn = F), collapse = "")}
#'
#' @export
#' @family Playback Plugin
addPlayback <- function(map, data, time = "time", icon = NULL,
                        pathOptions = pathOptions(),
                        options = playbackOptions()){

  ## If data is a `data.frame` / `data.table` or `matrix`
  if (inherits(data, "data.frame") || inherits(data, "matrix")) {
    ## Check if the `time` column exists. It is required!
    if (!any(colnames(data) == time)) stop("No column named `", time, "` in data.")
    ## If the `time` column is present but not numeric, convert it
    if (!is.null(data[,time]) && !is.numeric(data[,time])) {
      data$time <- as.numeric(data[,time][[1]])
    }
    ## If there is no `geometry` column, check if lat/lng are given as columns
    if (!any(colnames(data) %in% c("geom","geometry"))) {
      ## Check if any column has lat/lon values
      latnams <- c("y","lat","latitude")
      lonnams <- c("x","lon","lng","longitude")
      has_lat <- tolower(colnames(data)) %in% latnams
      has_lng <- tolower(colnames(data)) %in% lonnams
      if (any(has_lat) && any(has_lng)) {
        ## If data has lat/lon columns, use `sf` if possible to transform to Simple Feature
        if (requireNamespace("sf", quietly = TRUE)) {
          data <- sf::st_as_sf(data.frame(data),  ## Convert to data.frame. Matrix wouldnt work otherwise
                               coords = c(colnames(data)[which(has_lng)],
                                          colnames(data)[which(has_lat)]))
        } else {
          ## If `sf` is not available, build a list which can be read by the plugin
          data <- list(
            coordinates = cbind(data[,colnames(data)[which(has_lng)]],
                                data[,colnames(data)[which(has_lat)]]),
            time = data[,time]
          )
        }
      } else {
        ## No lat/lng columns in data. Error
        stop("Cannot read Lat/Lon columns. The column names must match either: \n",
             paste(latnams, collapse = ","), " / ", paste(lonnams, collapse = ","))
      }
    }
  }

  ## If data is a `SpatialPointsDataFrame`
  if (inherits(data, "SpatialPointsDataFrame")) {
    if (requireNamespace("sf", quietly = TRUE)) {
      ## If `sf` is available, use it to transform to Simple Features
      data <- sf::st_as_sf(data)
    } else {
      ## If `sf` is not available, build a list with coordinates and the time column.
      coords <- sp::coordinates(data)
      data <- list(
        coordinates = cbind(coords[,1], coords[,2]),
        time = data[,time]
      )
    }
  }

  ## If data is a `character`
  if (inherits(data, "character")) {
    ## Since `basename` does not work, when the string is too long, we count
    ## the number of characters first. 300 is chosen randomly, but I doubt that
    ## file paths would be that long. If it's longer, we assume that its a JSON string already
    if (nchar(data) < 300) {
      ## Check if it's a path or URL to a json file
      fileext <- gsub(".*\\.", "", basename(data))
      if (fileext == "json" || fileext == "geojson") {
        data <- jsonlite::read_json(data)
      }
    }
    ## Otherwise just pass the string (do nothing)
  }

  map$dependencies <- c(map$dependencies, playbackDependencies())
  options = leaflet::filterNULL(c(icon = list(icon),
                                  pathOptions = list(pathOptions),
                                  options))

  invokeMethod(map, NULL, "addPlayback", data, options)
}

#' playbackOptions
#'
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
#' @description Add extra options to \code{\link{addPlayback}}. For a full list
#'   please visit the \href{https://github.com/hallahan/LeafletPlayback}{plugin repository}
#' @export
#' @family Playback Plugin
playbackOptions = function(
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
#' @family Playback Plugin
removePlayback <- function(map){
  invokeMethod(map, NULL, "removePlayback")
}
