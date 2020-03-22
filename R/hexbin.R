hexbinDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-hexbin", version = "2.1.0",
      src = system.file("htmlwidgets/lfx-hexbin", package = "leaflet.extras2"),
      script = c(
        "d3.js",
        "d3-hexbin.js",
        "HexbinLayer.js",
        "hexbin-bindings.js")
    )
  )
}


#' Add a Hexbin layer
#'
#' @param map A map widget object created from \code{\link[leaflet]{leaflet}}
#' @param lng a numeric vector of longitudes, or a one-sided formula of the form
#'   ~x where x is a variable in data; by default (if not explicitly provided),
#'   it will be automatically inferred from data by looking for a column named
#'   lng, long, or longitude (case-insensitively)
#' @param lat a vector of latitudes or a formula (similar to the lng argument;
#'   the names lat and latitude are used when guessing the latitude column from
#'   data)
#' @param radius Radius of the hexbin layer
#' @param layerId the layer id
#' @param group the name of the group the newly created layers should belong to
#'   (for clearGroup and addLayersControl purposes). Human-friendly group names
#'   are permitted–they need not be short, identifier-style names. Any number of
#'   layers and even different types of layers (e.g. markers and polygons) can
#'   share the same group name.
#' @param opacity Opacity on the hexbin layer
#' @param options List of further options. See \code{\link{hexbinOptions}}
#' @param data the data object from which the argument values are derived; by
#'   default, it is the data object provided to leaflet() initially, but can be
#'   overridden.
#'
#' @note Currently doesn't respect \code{layerId} nor \code{group}
#'
#' @seealso https://github.com/Asymmetrik/leaflet-d3#hexbins-api
#' @family Hexbin-D3 Plugin
#' @export
addHexbin <- function(
  map, lng = NULL, lat = NULL, radius = 20,
  layerId = NULL, group = NULL, opacity = 0.5,
  options = hexbinOptions(),
  data = getMapData(map)) {

  options <- c(options,
    filterNULL(list(radius = radius,
                    extraJS = JS("function(d) { return d.length; }"),
                    opacity = opacity)))

  pts <- derivePoints(data, lng, lat, missing(lng), missing(lat),
                      "addCircleMarkers")
  pts <- as.matrix(pts)

  map$dependencies <- c(map$dependencies, hexbinDependency())

  invokeMethod(map, getMapData(map), "addHexbin", pts, layerId, group, options) %>%
    expandLimits(pts[,"lat"], pts[,"lng"])
}

#' updateHexbin
#' @param map A map widget object created from \code{\link[leaflet]{leaflet}}
#' @param lng a numeric vector of longitudes, or a one-sided formula of the form
#'   ~x where x is a variable in data; by default (if not explicitly provided),
#'   it will be automatically inferred from data by looking for a column named
#'   lng, long, or longitude (case-insensitively)
#' @param lat a vector of latitudes or a formula (similar to the lng argument;
#'   the names lat and latitude are used when guessing the latitude column from
#'   data)
#' @param data the data object from which the argument values are derived; by
#'   default, it is the data object provided to leaflet() initially, but can be
#'   overridden.
#' @param colorRange Sets the range of the color scale used to fill the
#'   hexbins on the layer.
#' @family Hexbin-D3 Plugin
#' @export
updateHexbin <- function(map, data = NULL, lng = NULL, lat = NULL, colorRange = NULL) {
  if (is.null(c(data, lng, lat))) {
    pts <- NULL
  } else {
    pts <- derivePoints(data, lng, lat, missing(lng), missing(lat),
                        "addCircleMarkers")
    pts <- as.matrix(pts)
  }
  invokeMethod(map, NULL, "updateHexbin", pts, colorRange)
}

#' clearHexbin
#' Clear the hexbinLayer
#' @param map The map widget
#' @family Hexbin-D3 Plugin
#' @export
clearHexbin <- function(map) {
  invokeMethod(map, NULL, "clearHexbin")
}

#' hideHexbin
#' Hide the hexbinLayer
#' @param map The map widget
#' @family Hexbin-D3 Plugin
#' @export
hideHexbin <- function(map) {
  invokeMethod(map, NULL, "hideHexbin")
}

#' showHexbin
#' Show the hexbinLayer
#' @param map The map widget
#' @family Hexbin-D3 Plugin
#' @export
showHexbin <- function(map) {
  invokeMethod(map, NULL, "showHexbin")
}

#' hexbinOptions
#' @param duration Transition duration for the hexbin layer
#' @param colorScaleExtent extent of the color scale for the hexbin layer. This
#'   is used to override the derived extent of the color values and is specified
#'   as a vector of the form c(min= numeric, max= numeric). Can be a numeric
#'   vector or a custom \code{\link[htmlwidgets]{JS}} array, like
#'   (\code{JS("[40, undefined]")})
#' @param radiusScaleExtent This is the same exact configuration option as
#'   colorScaleExtent, only applied to the radius extent.
#' @param colorRange Sets the range of the color scale used to fill the hexbins
#'   on the layer.
#' @param radiusRange Sets the range of the radius scale used to size the
#'   hexbins on the layer.
#' @param pointerEvents This value is passed directly to an element-level css
#'   style for pointer-events. You should only modify this config option if you
#'   want to change the mouse event behavior on hexbins. This will modify when
#'   the events are propagated based on the visibility state and/or part of the
#'   hexbin being hovered.
#' @param resizetoCount Resizes the hexbin to the count. Default is
#'   \code{FALSE}. If set to \code{TRUE} it will resize based on the amount of
#'   underlying elements. You can also pass a custom
#'   \code{\link[htmlwidgets]{JS}} function.
#' @param tooltip Should tooltips be displayed? If set to \code{TRUE}, it will
#'   show the amount of underlying elements. If a string is given, it will
#'   append the string before the count. To disable tooltips, please pass
#'   \code{NULL} or \code{FALSE}. You can also pass a custom
#'   \code{\link[htmlwidgets]{JS}} function.
#' @family Hexbin-D3 Plugin
#' @export
hexbinOptions = function(
  duration = 200,
  colorScaleExtent = NULL,
  radiusScaleExtent = NULL,
  colorRange = c('#f7fbff', '#08306b'),
  radiusRange = c(5, 15),
  pointerEvents = 'all',
  resizetoCount = FALSE,
  tooltip = "Count "
) {

  if (tooltip == FALSE) tooltip <- NULL

  filterNULL(list(
    duration = duration,
    colorScaleExtent = colorScaleExtent,
    radiusScaleExtent = radiusScaleExtent,
    colorRange = colorRange,
    radiusRange = radiusRange,
    pointerEvents = pointerEvents,
    resizetoCount = resizetoCount,
    tooltip = tooltip
  ))
}
