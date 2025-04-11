geosearchDependencies <- function() {
  list(
    htmlDependency(
      "lfx-geosearch", "1.0.0",
      src = system.file("htmlwidgets/lfx-geosearch", package = "leaflet.extras2"),
      script = c(
        "bundle.min.js",
        "geosearch-bindings.js"
      ),
      stylesheet = "geosearch.css"
    )
  )
}

#' Add a GeoSearch control to a Leaflet map
#'
#' Adds a geocoding search widget to a leaflet map using the leaflet-geosearch plugin.
#' Supports multiple providers such as OpenStreetMap, Esri, Google, HERE, etc.
#'
#' @param map a map widget
#' @param provider A provider list object created with e.g. `geosearchProviderOSM()`.
#' @param options A list of control options created with `geosearchOptions()`.
#'
#' @family Geosearch Functions
#' @references \url{https://github.com/smeijer/leaflet-geosearch}
#' @inherit leaflet::addControl return
#' @export
#' @examples \dontrun{
#' library(leaflet)
#' library(leaflet.extras2)
#'
#' leaflet() %>%
#'   addTiles() %>%
#'   addGeosearch()
#' }
addGeosearch <- function(map,
                         provider = geosearchProvider(),
                         options = geosearchOptions()) {
  map$dependencies <- c(map$dependencies, geosearchDependencies())
  invokeMethod(map, NULL, "addGeosearch", provider, options)
}

#' geosearchOptions
#'
#' Add extra options. For a full list please visit the
#' \href{https://smeijer.github.io/leaflet-geosearch/}{plugin repository} or see
#' the
#' \href{https://github.com/smeijer/leaflet-geosearch/blob/main/src/SearchControl.ts#L23}{source code}
#'
#' @param style Character. UI style, one of "bar" or "button".
#' @param notFoundMessage Message shown if no result is found.
#' @param autoComplete Logical. Enable autocomplete suggestions.
#' @param autoCompleteDelay Delay in ms before suggestions appear.
#' @param showMarker Logical. Show marker for result location.
#' @param showPopup Logical. Show popup on result location.
#' @param draggable Logical. Make marker draggable.
#' @param popupFormat JS expression (string) for custom popup.
#' @param resultFormat JS expression (string) for result display.
#' @param maxMarkers Max number of markers shown.
#' @param retainZoomLevel Logical.
#' @param animateZoom Logical.
#' @param autoClose Logical. Close results after selection.
#' @param searchLabel Placeholder text.
#' @param keepResult Logical. Keep last result shown.
#' @param updateMap Logical. Pan/zoom map on result.
#' @param ... Further arguments passed to `addGeosearch`
#'
#' @family Geosearch Functions
#' @return A list of options for \code{addGeosearch}
#' @export
geosearchOptions <- function(style = c("button", "bar"),
                             resetButton = "🔍",
                             notFoundMessage = "Nothing found",
                             autoComplete = TRUE,
                             autoCompleteDelay = 250,
                             showMarker = TRUE,
                             showPopup = FALSE,
                             popupFormat = JS("function(query, result) { return result.result.label }"),
                             resultFormat = JS("function(result) { return result.result.label }"),
                             maxMarkers = 1,
                             retainZoomLevel = FALSE,
                             animateZoom = TRUE,
                             autoClose = FALSE,
                             searchLabel = "Enter address",
                             keepResult = FALSE,
                             updateMap = TRUE,
                             ...) {
  style <- match.arg(style)
  filterNULL(list(
    style = style,
    resetButton = resetButton,
    notFoundMessage = notFoundMessage,
    autoComplete = autoComplete,
    autoCompleteDelay = autoCompleteDelay,
    showMarker = showMarker,
    showPopup = showPopup,
    popupFormat = popupFormat,
    resultFormat = resultFormat,
    maxMarkers = maxMarkers,
    retainZoomLevel = retainZoomLevel,
    animateZoom = animateZoom,
    autoClose = autoClose,
    searchLabel = searchLabel,
    keepResult = keepResult,
    updateMap = updateMap,
    ...
  ))
}


#' Provider for GeoSearch
#' @param type The provider name
#' @param options Optional named list of options and parameters
#' @return A list describing the provider config
#' @export
geosearchProvider <- function(type = c("OSM","Bing","Esri","GeocodeEarth",
                                       "Google","Here","LocationIQ","OpenCage",
                                       "Pelias","Geoapify","AMap","GeoApiFr"),
                              options = list()) {
  if (type == "OpenStreetMap") type = "OSM"
  type <- match.arg(type)
  list(type = type, options = options)
}


#' removeGeosearch
#'
#' Remove the geosearch
#' @param map the map widget.
#' @inherit leaflet::addControl return
#' @export
#' @family Geosearch Functions
removeGeosearch <- function(map) {
  invokeMethod(map, NULL, "removeGeosearch")
}
