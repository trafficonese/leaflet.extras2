wmsDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-wms", version = "2.1.0",
      src = system.file("htmlwidgets/lfx-wms", package = "leaflet.extras2"),
      script = c("leaflet.wms.js",
                 "leaflet.wms-bindings.js")
    )
  )
}

#' Add Queryable WMS Layer
#'
#' @param map a map widget object created from \code{\link[leaflet]{leaflet}}
#' @param baseUrl a base URL of the WMS service
#' @param layers vector or list of WMS layers to show. The name of the layer is
#'   used as the \code{layerId} (for \code{\link[leaflet]{removeTiles}}
#'   purposes)
#' @param group the name of the group the newly created layers should belong to
#'   (for clearGroup and addLayersControl purposes). Human-friendly group names
#'   are permitted–they need not be short, identifier-style names. Any number of
#'   layers and even different types of layers (e.g. markers and polygons) can
#'   share the same group name. NOTE: If multiple \code{layers} are included,
#'   the group argument will be ignored and the the layer-names will serve as
#'   group names.
#' @param options List of further options. See
#'   \code{\link[leaflet]{WMSTileOptions}}
#' @param attribution the attribution text of the tile layer (HTML)
#' @param data the data object from which the argument values are derived; by
#'   default, it is the data object provided to \code{\link[leaflet]{leaflet}}
#'   initially, but can be overridden.
#' @param popupOptions List of popup options. See
#'   \code{\link[leaflet]{popupOptions}}. Default is NULL.
#'
#' @seealso \url{https://github.com/heigeo/leaflet.wms}
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
addWMS <- function(map, baseUrl, layers = NULL, group = NULL,
                   options = WMSTileOptions(), attribution = NULL,
                   popupOptions = NULL,
                   data = getMapData(map)) {

  if (is.null(layers)) {
    stop("layers is a required argument")
  }
  options$attribution <- attribution
  options$layers <- layers
  options$popupOptions <- popupOptions

  map$dependencies <- c(map$dependencies, wmsDependency())

  invokeMethod(map, data, "addWMS", baseUrl, layers,
               group, options)
}
