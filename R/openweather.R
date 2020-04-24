openweatherDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-openweather", version = "2.1.0",
      src = system.file("htmlwidgets/lfx-openweather", package = "leaflet.extras2"),
      script = c(
        "leaflet-openweathermap.js",
        "leaflet-openweather-bindings.js"),
      stylesheet = "leaflet-openweathermap.css"
    )
  )
}

#' Add OpenWeatherMap Tiles
#' @param map A map widget object created from \code{\link[leaflet]{leaflet}}
#' @param apikey a valid Openweathermap-API key. Get one from
#'   \href{https://openweathermap.org/api}{here}.
#' @param layers character vector of layers you wish to add to the map
#' @param group name of the group
#' @param layerId the layer id
#' @param opacity opacity of the layer
#' @param options List of further options. See \code{\link{openweatherOptions}}
#'
#' @note Out of the box a legend image is only available for Pressure,
#'   Precipitation Classic, Clouds Classic, Rain Classic, Snow, Temperature and
#'   Wind Speed. Please add your own images if you need some more.
#'
#' @seealso \url{https://github.com/trafficonese/leaflet-openweathermap}
#' @family Openweather Plugin
#' @export
addOpenweatherTiles <- function(
  map, apikey = NULL, layers = NULL,
  group = NULL, layerId = NULL, opacity = 0.5,
  options = openweatherOptions()) {

  if (is.null(apikey)) {
    apikey <- Sys.getenv("OPENWEATHERMAP")
    if (apikey == "") {
      stop("You must either pass an `apikey` directly or save it as ",
           "system variable under `OPENWEATHERMAP`.")
    }
  }

  osm_layers <- c("clouds", "cloudsClassic", "precipitation", "precipitationClassic",
                  "rain", "rainClassic", "snow", "pressure", "pressureContour",
                  "temperature", "wind")

  if (!all(layers %in% osm_layers)) {
    idx <- which(layers %in% osm_layers)
    notfound <- setdiff(seq.int(layers), idx)
    if (length(notfound) != 0) {
      if (length(notfound) == 1) {
        warning("The layer `", layers[notfound], "` is not valid.")
      } else {
        warning("The layers `", paste(layers[notfound], collapse = ", "), "` are not valid.")
      }
    }
    layers <- layers[idx]
  }

  if (!is.null(layerId)) {
    if (length(layerId) != length(layers)) {
      warning("The length of `layers` and `layerId` does not match.",
              "The `layers`-names are taken instead.")
      layerId <- layers
    }
  }
  if (!is.null(group)) {
    if (length(group) == 1 && length(layers) > 1) {
      group <- rep(group, length(layers))[seq.int(layers)]
    }
  }

  options <- c(appId = apikey,
               opacity = opacity,
               options)

  map$dependencies <- c(map$dependencies, openweatherDependency())

  invokeMethod(map, NULL, "addOpenweather", layers,
               group, layerId, options)
}



#' OpenWeatherMap Options
#' @param showLegend If true and option 'legendImagePath' is set there will be a
#'   legend image on the map.
#' @param legendImagePath URL (is set to a default image for some layers, null
#'   for others, see below). URL or relative path to an image which is a legend
#'   to this layer.
#' @param legendPosition Position of the legend images on the map. Available are
#'   standard positions for Leaflet controls
#' @family Openweather Plugin
#' @export
openweatherOptions <-  function(showLegend = TRUE,
                                legendImagePath = NULL,
                                legendPosition = c('bottomleft', 'bottomright',
                                                   'topleft', 'topright')) {
  legendPosition <- match.arg(legendPosition)
  leaflet::filterNULL(list(
    showLegend = showLegend,
    legendImagePath = legendImagePath,
    legendPosition = legendPosition
  ))
}


#' Add current OpenWeatherMap Marker
#' @param map A map widget object created from \code{\link[leaflet]{leaflet}}
#' @param apikey a valid Openweathermap-API key. Get one from
#'   \href{https://openweathermap.org/api}{here}.
#' @param group name of the group
#' @param layerId the layer id
#' @param options List of further options. See
#'   \code{\link{openweatherCurrentOptions}}
#'
#' @seealso \url{https://github.com/trafficonese/leaflet-openweathermap}
#' @family Openweather Plugin
#' @export
addOpenweatherCurrent <- function(map, apikey = NULL, group = NULL,
                                  layerId = NULL,
                                  options = openweatherCurrentOptions()) {

  if (is.null(apikey)) {
    apikey <- Sys.getenv("OPENWEATHERMAP")
    if (apikey == "") {
      stop("You must either pass an `apikey` directly or save it as ",
           "system variable under `OPENWEATHERMAP`.")
    }
  }

  options <- c(appId = apikey,
               type = "city",
               options)

  map$dependencies <- c(map$dependencies, openweatherDependency())

  invokeMethod(map, NULL, "addOpenweatherCurrent", group, layerId, options)
}


#' openweatherCurrentOptions
#' @param lang 'en', 'de', 'ru', 'fr', 'es', 'ca'. Language of popup texts.
#'   Note: not every translation is finished yet.
#' @param minZoom Number (7). Minimal zoom level for fetching city data. Use
#'   smaller values only at your own risk.
#' @param interval Number (0). Time in minutes to reload city data. Please do
#'   not use less than 10 minutes.
#' @param ... Further options passed to \code{L.OWM.current}. See the
#'   \href{https://github.com/trafficonese/leaflet-openweathermap#options}{full
#'   list of options}
#' @family Openweather Plugin
#' @export
openweatherCurrentOptions <-  function(lang = "en",
                                       minZoom = 7,
                                       interval = 10,
                                       ...
                                       ) {
  leaflet::filterNULL(list(
    lang = lang,
    minZoom = minZoom,
    interval = interval,
    ...
  ))
}
