wmsheaderDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-wmsheader",
      version = "1.0.0",
      src = system.file("htmlwidgets/lfx-wmsheader", package = "leaflet.extras2"),
      script = c(
        "leaflet.wmsheader.js",
        "leaflet.wmsheader-bindings.js"
      )
    )
  )
}

#' Add WMS Layerwith custom Header
#'
#' @description
#' Custom headers on Leaflet TileLayer WMS. It's a simple plugin that allow to
#' set custom header for WMS interface.
#'
#' @inheritParams leaflet::addWMSTiles
#' @inherit leaflet::addWMSTiles return
#' @references \url{https://github.com/ticinum-aerospace/leaflet-wms-header}
#' @family WMS Functions
#' @export
addWMSHeader <- function(map, baseUrl, layerId = NULL, group = NULL,
                   options = WMSTileOptions(),
                   attribution = NULL,
                   layers = NULL,
                   header = NULL,
                   data = getMapData(map)) {
  if (is.null(layers)) {
    stop("layers is a required argument with comma-separated list of WMS layers to show")
  }
  options$attribution <- attribution
  options$layers <- layers

  map$dependencies <- c(map$dependencies, wmsheaderDependency())

  invokeMethod(
    map, data, "addWMSHeader", baseUrl, layerId,
    group, options, header
  )
}
