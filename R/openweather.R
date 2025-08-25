openweatherDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-openweather",
      version = "1.0.0",
      src = system.file("htmlwidgets/lfx-openweather", package = "leaflet.extras2"),
      script = c(
        "leaflet-openweathermap.js",
        "leaflet-openweathermap-bindings.js"
      ),
      attachment = c("owmloading.gif"),
      stylesheet = "leaflet-openweathermap.css"
    )
  )
}

#' Add OpenWeatherMap Tiles
#' @inheritParams leaflet::addWMSTiles
#' @param apikey a valid OpenWeatherMap-API key.
#' @param layers character vector of layers you wish to add to the map. The
#'   following layers are currently possible \code{c("clouds", "cloudsClassic",
#'   "precipitation", "precipitationClassic", "rain", "rainClassic", "snow",
#'   "pressure", "pressureContour", "temperature", "wind")}.
#' @param opacity opacity of the layer
#' @param options List of further options. See \code{\link{openweatherOptions}}
#'
#' @note Out of the box a legend image is only available for Pressure,
#'   Precipitation Classic, Clouds Classic, Rain Classic, Snow, Temperature and
#'   Wind Speed. Please add your own images if you need some more.
#'
#' @references \url{https://github.com/trafficonese/leaflet-openweathermap}
#' @family Openweathermap Functions
#' @inherit leaflet::addWMSTiles return
#' @export
#' @examples \dontrun{
#' library(leaflet)
#' library(leaflet.extras2)
#'
#' Sys.setenv("OPENWEATHERMAP" = "Your_API_Key")
#'
#' leaflet() %>%
#'   addTiles() %>%
#'   setView(9, 50, 6) %>%
#'   addOpenweatherTiles(layers = "wind")
#' }
addOpenweatherTiles <- function(
    map, apikey = NULL, layers = NULL,
    group = NULL, layerId = NULL, opacity = 0.5,
    options = openweatherOptions()) {
  if (is.null(apikey)) {
    apikey <- Sys.getenv("OPENWEATHERMAP")
    if (apikey == "") {
      stop(
        "You must either pass an `apikey` directly or save it as ",
        "system variable under `OPENWEATHERMAP`."
      )
    }
  }

  osm_layers <- c(
    "clouds", "cloudsClassic", "precipitation", "precipitationClassic",
    "rain", "rainClassic", "snow", "pressure", "pressureContour",
    "temperature", "wind"
  )

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
      warning(
        "The lengths of `layers` and `layerId` do not match.",
        "Instead, the `layers` are used as the `layerID`."
      )
      layerId <- layers
    }
  } else {
    layerId <- layers
  }
  if (!is.null(group)) {
    if (length(group) == 1 && length(layers) > 1) {
      group <- rep(group, length(layers))[seq.int(layers)]
    }
  } else {
    group <- layers
  }

  options <- c(
    appId = apikey,
    opacity = opacity,
    options
  )

  map$dependencies <- c(map$dependencies, openweatherDependency())

  invokeMethod(
    map, NULL, "addOpenweather", layers,
    group, layerId, options
  )
}

#' OpenWeatherMap Options
#' @param showLegend If \code{TRUE} and option \code{legendImagePath} is set
#'   there will be a legend image on the map
#' @param legendImagePath A URL (is set to a default image for some layers, null
#'   for others, see below). URL or relative path to an image which is a legend
#'   to this layer
#' @param legendPosition Position of the legend images on the map. Must be one
#'   of \code{'bottomleft', 'bottomright', 'topleft', 'topright'}
#' @return A list of options for \code{addOpenweatherTiles}
#' @family Openweathermap Functions
#' @export
openweatherOptions <- function(showLegend = TRUE,
                               legendImagePath = NULL,
                               legendPosition = c(
                                 "bottomleft", "bottomright",
                                 "topleft", "topright"
                               )) {
  legendPosition <- match.arg(legendPosition)
  leaflet::filterNULL(list(
    showLegend = showLegend,
    legendImagePath = legendImagePath,
    legendPosition = legendPosition
  ))
}

#' Add current OpenWeatherMap Marker
#' @inheritParams leaflet::addMarkers
#' @param apikey a valid Openweathermap-API key.
#' @param options List of further options. See
#'   \code{\link{openweatherCurrentOptions}}
#'
#' @references \url{https://github.com/trafficonese/leaflet-openweathermap}
#' @note The current weather icons will appear beginning with zoom level 9
#' and if used in Shiny, a click on an icon will update a Shiny input at
#' \code{input$MAPID_owm_click}.
#' @family Openweathermap Functions
#' @inherit leaflet::addMarkers return
#' @export
#' @examples \dontrun{
#' library(leaflet)
#' library(leaflet.extras2)
#'
#' Sys.setenv("OPENWEATHERMAP" = "Your_API_Key")
#'
#' leaflet() %>%
#'   addTiles() %>%
#'   setView(9, 50, 9) %>%
#'   addOpenweatherCurrent(options = openweatherCurrentOptions(
#'     lang = "en", popup = TRUE
#'   ))
#' }
addOpenweatherCurrent <- function(map, apikey = NULL, group = NULL,
                                  layerId = NULL,
                                  options = openweatherCurrentOptions()) {
  if (is.null(apikey)) {
    apikey <- Sys.getenv("OPENWEATHERMAP")
    if (apikey == "") {
      stop(
        "You must either pass an `apikey` directly or save it as ",
        "system variable under `OPENWEATHERMAP`."
      )
    }
  }

  options <- c(
    appId = apikey,
    type = "city",
    options
  )

  map$dependencies <- c(map$dependencies, openweatherDependency())

  invokeMethod(map, NULL, "addOpenweatherCurrent", group, layerId, options)
}

#' openweatherCurrentOptions
#' @param lang 'en', 'de', 'ru', 'fr', 'es', 'ca'. Language of popup texts.
#'   Note: not every translation is finished yet.
#' @param minZoom Number (7). Minimal zoom level for fetching city data. Use
#'   smaller values only at your own risk.
#' @param interval Number (10). Time in minutes to reload city data. Please do
#'   not use less than 10 minutes.
#' @param imageLoadingUrl URL of the loading image.
#' @param ... Further options passed to \code{L.OWM.current}. See the
#'   \href{https://github.com/trafficonese/leaflet-openweathermap#options}{full
#'   list of options}
#' @family Openweathermap Functions
#' @return A list of options for \code{addOpenweatherCurrent}
#' @export
openweatherCurrentOptions <- function(lang = "en",
                                      minZoom = 7,
                                      interval = 10,
                                      imageLoadingUrl = paste0(
                                        openweatherDependency()[[1]]$name, "-",
                                        openweatherDependency()[[1]]$version,
                                        "/owmloading.gif"
                                      ),
                                      ...) {
  leaflet::filterNULL(list(
    lang = lang,
    minZoom = minZoom,
    interval = interval,
    imageLoadingUrl = imageLoadingUrl,
    ...
  ))
}
