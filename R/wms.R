wmsDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-wms",
      version = "1.0.4",
      src = system.file("htmlwidgets/lfx-wms", package = "leaflet.extras2"),
      script = c(
        "leaflet.wms.js",
        "leaflet.wms-bindings.js"
      )
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
#' You can also use \bold{CQL-Filters} by appending a string
#' to the \code{'baseUrl'}.
#'
#' Something like \code{'http://server/wms?cql_filter=attribute=value'}
#'
#' @note The WMS attribution is shown only while the layer (or its
#'   \code{group}) is visible, matching \code{\link[leaflet]{addWMSTiles}}.
#'   GetFeatureInfo requests accept HTTP redirects (e.g. 301) and upgrade
#'   \code{http://} WMS URLs to \code{https://} on HTTPS pages so popups
#'   still work behind a reverse proxy.
#'   To change WMS request parameters such as \code{time} in Shiny, keep the
#'   map in \code{renderLeaflet()} and call \code{\link{setWMSParams}} on a
#'   \code{\link[leaflet]{leafletProxy}} instead of recreating the whole map.
#'   Custom \code{headers} (Basic/Bearer) are sent for tiles, the single-image
#'   overlay and GetFeatureInfo. The WMS server must allow CORS for those
#'   header names. Tokens travel in the browser; do not use them for secrets
#'   that must stay on the server.
#'
#' @inheritParams leaflet::addWMSTiles
#' @param checkempty Should the returned HTML-content be checked for emptiness?
#'   If the HTML-body is empty no popup is opened. Default is \code{FALSE}
#' @param popupOptions List of popup options. See
#'   \code{\link[leaflet]{popupOptions}}. Default is NULL.
#' @param headers Optional HTTP headers for authenticated WMS requests,
#'   as a named character vector
#'   (\code{c(Authorization = "Bearer <token>")}) or a list of
#'   \code{list(header = "Authorization", value = "Bearer <token>")}.
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
#'   addWMS(
#'     baseUrl = "https://maps.dwd.de/geoserver/dwd/wms",
#'     layers = "dwd:BRD_1km_winddaten_10m",
#'     popupOptions = popupOptions(maxWidth = 600),
#'     checkempty = TRUE,
#'     options = WMSTileOptions(
#'       transparent = TRUE,
#'       format = "image/png",
#'       info_format = "text/html"
#'     )
#'   )
addWMS <- function(map, baseUrl, layerId = NULL, group = NULL,
                   options = WMSTileOptions(),
                   attribution = NULL,
                   layers = NULL,
                   popupOptions = NULL,
                   checkempty = FALSE,
                   headers = NULL,
                   data = getMapData(map)) {
  if (is.null(layers)) {
    stop("layers is a required argument with comma-separated list of WMS layers to show")
  }
  options$attribution <- attribution
  options$layers <- layers
  options$checkempty <- checkempty
  options$headers <- normalize_wms_headers(headers)

  map$dependencies <- c(map$dependencies, wmsDependency())

  invokeMethod(
    map, data, "addWMS", baseUrl, layerId,
    group, options, popupOptions
  )
}

normalize_wms_headers <- function(headers) {
  if (is.null(headers) || (is.list(headers) && !length(headers))) {
    return(NULL)
  }
  as_entry <- function(name, value) {
    list(header = as.character(name)[1], value = as.character(value)[1])
  }
  if (is.character(headers)) {
    if (is.null(names(headers)) || any(!nzchar(names(headers)))) {
      stop("`headers` must be a named character vector or a list of list(header, value)")
    }
    return(unname(lapply(names(headers), function(nm) as_entry(nm, headers[[nm]]))))
  }
  if (!is.list(headers)) {
    stop("`headers` must be a named character vector or a list of list(header, value)")
  }
  nms <- names(headers)
  if (!is.null(nms) && all(nzchar(nms)) &&
    all(vapply(headers, function(x) is.character(x) && length(x) == 1, logical(1)))) {
    return(unname(lapply(nms, function(nm) as_entry(nm, headers[[nm]]))))
  }
  lapply(headers, function(h) {
    if (is.null(h$header) || is.null(h$value)) {
      stop("Each header entry needs `header` and `value`")
    }
    as_entry(h$header, h$value)
  })
}

#' Update WMS request parameters
#'
#' Change WMS parameters such as \code{time}, \code{styles} or
#' \code{cql_filter} on an existing layer without rebuilding the map.
#' In Shiny, call this on \code{\link[leaflet]{leafletProxy}}.
#'
#' @inheritParams addWMS
#' @param ... Named WMS request parameters to set, for example
#'   \code{time = "2022-11-10T21:00:00Z"}.
#' @inherit leaflet::addWMSTiles return
#' @family WMS Functions
#' @export
#' @examples
#' library(leaflet)
#' library(leaflet.extras2)
#'
#' leaflet() %>%
#'   addTiles() %>%
#'   addWMS(
#'     baseUrl = "https://gibs.earthdata.nasa.gov/wms/epsg3857/best/wms.cgi",
#'     layers = "MODIS_Terra_CorrectedReflectance_TrueColor",
#'     layerId = "modis",
#'     options = WMSTileOptions(format = "image/jpeg", time = "2022-11-10")
#'   ) %>%
#'   setWMSParams(layerId = "modis", time = "2022-11-11")
setWMSParams <- function(map, layerId = NULL, group = NULL, ...) {
  params <- list(...)
  if (!length(params)) {
    stop("setWMSParams() requires at least one WMS parameter, e.g. time = '...'")
  }
  invokeMethod(map, NULL, "setWMSParams", layerId, group, params)
}
