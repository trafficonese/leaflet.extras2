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
#' @description
#' A Leaflet plugin for working with Web Map services, providing:
#' single-tile/untiled/nontiled layers, shared WMS sources, and
#' \bold{GetFeatureInfo}-powered identify.
#'
#' You can also use \bold{CQL-Filters} by appending a string to the \code{'baseUrl'}.
#'
#' Something like \code{'http://server/wms?cql_filter=attribute=value'}
#'
#' @inheritParams leaflet::addWMSTiles
#' @param checkempty Should the returned HTML-content be checked for emptiness?
#'   If the HTML-body is empty no popup is opened. Default is \code{FALSE}
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
#'       checkempty = TRUE,
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
