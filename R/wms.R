wmsDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-wms", version = "1.0.0",
      src = system.file("htmlwidgets/lfx-wms", package = "leaflet.extras2"),
      script = c("leaflet.wms.js",
                 "leaflet.wms-bindings.js")
    )
  )
}

#' Add Queryable WMS Layer
#'
#' A Leaflet plugin for working with Web Map services, providing:
#' single-tile/untiled/nontiled layers, shared WMS sources, and
#' GetFeatureInfo-powered identify.
#' @inheritParams leaflet::addWMSTiles
#' @param popupOptions List of popup options. See
#'   \code{\link[leaflet]{popupOptions}}. Default is NULL.
#' @inherit leaflet::addWMSTiles return
#' @references \url{https://github.com/heigeo/leaflet.wms}
#' @family WMS Functions
#' @export
#' @examples
#' library(leaflet)
#' library(leaflet.extras2)
#'
#' leaflet() %>%
#'   addTiles(group = "base") %>%
#'   setView(9, 50, 5) %>%
#'   addWMS(baseUrl = "https://maps.dwd.de/geoserver/dwd/wms",
#'          layers = "dwd:BRD_1km_winddaten_10m",
#'       popupOptions = popupOptions(maxWidth = 600),
#'       options = WMSTileOptions(
#'         transparent = TRUE,
#'         format = "image/png",
#'         info_format = "text/html"))
addWMS <- function(map, baseUrl, layerId = NULL, group = NULL,
                   options = WMSTileOptions(),
                   attribution = NULL,
                   layers = NULL,
                   popupOptions = NULL,
                   checkempty = FALSE,
                   data = getMapData(map)) {

  if (is.null(layers)) {
    stop("layers is a required argument with comma-separated list of WMS layers to show")
  }
  options$attribution <- attribution
  options$layers <- layers
  options$checkempty <- checkempty

  map$dependencies <- c(map$dependencies, wmsDependency())

  invokeMethod(map, data, "addWMS", baseUrl, layerId,
               group, options, popupOptions)
}
