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

#' Add OpenWeather Layers
#'
#' @param map A map widget object created from \code{\link[leaflet]{leaflet}}
#' @param options List of further options. See \code{\link{hexbinOptions}}
#'
#' @note Out of the box a legend image is only available for Pressure,
#'   Precipitation Classic, Clouds Classic, Rain Classic, Snow, Temperature and
#'   Wind Speed.
#' @seealso https://github.com/Asymmetrik/leaflet-d3#hexbins-api
#' @family Openweather Plugin
#' @export
addOpenweatherTiles <- function(
  map, apikey = NULL, layers = NULL, addControl = TRUE,
  group = NULL, opacity = 0.5) {

  # showLegend
  # legendImagePath
  # legendPosition <- c('topright', 'topleft', 'bottomright', 'bottomleft')

  if (is.null(apikey)) {
    apikey <- Sys.getenv("OPENWEATHER")
    if (apikey == "") {
      stop("You must either pass an `apikey` directly or save it as ",
           "system variable under `OPENWEATHER`.")
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

  if (length(opacity) == 1)
    opacity <- rep(opacity, length(layers))

  map$dependencies <- c(map$dependencies, openweatherDependency())

  invokeMethod(map, getMapData(map), "addOpenweather", apikey, layers,
               addControl, group, opacity)
}

#' Add OpenWeather Layers
#'
#' @param map A map widget object created from \code{\link[leaflet]{leaflet}}
#' @param options List of further options. See \code{\link{hexbinOptions}}
#'
#' @note Out of the box a legend image is only available for Pressure,
#'   Precipitation Classic, Clouds Classic, Rain Classic, Snow, Temperature and
#'   Wind Speed.
#' @seealso https://github.com/Asymmetrik/leaflet-d3#hexbins-api
#' @family Openweather Plugin
#' @export
addOpenweatherCurrent <- function(
  map, apikey = NULL, layers = NULL, addControl = TRUE,
  group = NULL, opacity = 0.5) {


  if (is.null(apikey)) {
    apikey <- Sys.getenv("OPENWEATHER")
    if (apikey == "") {
      stop("You must either pass an `apikey` directly or save it as ",
           "system variable under `OPENWEATHER`.")
    }
  }

  map$dependencies <- c(map$dependencies, openweatherDependency())

  invokeMethod(map, getMapData(map), "addOpenweatherCurrent", apikey, layers,
               addControl, group, opacity)
}


# appId: String ( null ). Please get a free API key (called APPID) if you're using OWM's current weather data regulary.
# lang: 'en', 'de', 'ru', 'fr', 'es', 'ca'. Language of popup texts. Note: not every translation is finished yet.
# minZoom: Number ( 7 ). Minimal zoom level for fetching city data. Use smaller values only at your own risk.
# interval: Number ( 0 ). Time in minutes to reload city data. Please do not use less than 10 minutes. 0 no reload (default)
# progressControl: true or false. Whether a progress control should be used to tell the user that data is being loaded at the moment.
# imageLoadingUrl: URL ( 'owmloading.gif' ). URL of the loading image, or a path relative to the HTML document. This is important when the image is not in the same directory as the HTML document!
# imageLoadingBgUrl: URL ( null ). URL of background image for progress control if you don't like the default one.
# temperatureUnit: 'C', 'F', 'K'. Display temperature in Celsius, Fahrenheit or Kelvin.
# temperatureDigits: Number ( 1 ). Number of decimal places for temperature.
# speedUnit: 'ms', 'kmh' or 'mph'. Unit of wind speed (m/s, km/h or mph).
# speedDigits: Number ( 0 ). Number of decimal places for wind speed.
# popup: true or false. Whether to bind a popup to the city marker.
# keepPopup: true or false. When true it tries to reopen an already open popup on move or reload. Can result in an additional map move (after reopening the popup) with closing and reopening the popup once again.
# showOwmStationLink: true or false. Whether to link city name to OWM.
# showWindSpeed: 'speed', 'beaufort' or 'both'. Show wind speed as speed in speedUnit or in beaufort scala or both.
# showWindDirection: 'deg', 'desc' or 'both'. Show wind direction as degree, as description (e.g. NNE) or both.
# showTimestamp: true or false. Whether to show the timestamp of the data.
# showTempMinMax: true or false. Whether to show temperature min/max.
# useLocalTime: true or false. Whether to use local time or UTC for the timestamp.
# clusterSize: Number ( 150 ). If some cities are too close to each other, they are hidden. In an area of the size clusterSize pixels * clusterSize pixels only one city is shown. If you zoom in the hidden cities will appear.
# imageUrlCity: URL ( 'https://openweathermap.org/img/w/{icon}.png' ). URL template for weather condition images of cities. {icon} will be replaced by the icon property of city's data. See http://openweathermap.org/img/w/ for some standard images.
# imageWidth: Number ( 50 ). Width of city's weather condition image.
# imageHeight: Number ( 50 ). Height of city's weather condition image.
# markerFunction: Function ( null ). User defined function for marker creation. Needs one parameter for city data.
# popupFunction: Function ( null ). User defined function for popup creation. Needs one parameter for city data.
# caching: true or false. Use caching of current weather data. Cached data is reloaded when it is too old or the new bounding box doesn't fit inside the cached bounding box.
# cacheMaxAge: Number ( 15 ). Maximum age in minutes for cached data before it is considered as too old.
# keepOnMinZoom: false or true. Keep or remove markers when zoom < minZoom.
# baseUrl: Defaults to "https://{s}.tile.openweathermap.org/map/{layername}/{z}/{x}/{y}.png" - only change it when you know what you're doing.

