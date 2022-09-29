arrowheadDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-arrowhead", version = "1.0.0",
      src = system.file("htmlwidgets/lfx-arrowhead", package = "leaflet.extras2"),
      script = c("leaflet.geometryutil.js",
                 "leaflet-arrowheads.js",
                 "leaflet-arrowheads-bindings.js")
    )
  )
}

#' Add Lines with an arrowhead
#'
#' Can be used almost exactly like \code{addPolylines} but instead of
#' \code{pathOptions} you can use \code{\link{arrowheadOptions}}. See
#' \href{https://github.com/slutske22/leaflet-arrowheads}{leaflet-arrowheads}
#' for further details.
#'
#' @inheritParams leaflet::addPolylines
#' @param options A named list of options. See \code{\link{arrowheadOptions}}
#' @family Arrowhead Functions
#' @references \url{https://github.com/slutske22/leaflet-arrowheads}
#' @return A modified leaflet map with a polyline with arrowheads
#' @export
#' @examples
#' library(leaflet)
#' leaflet() %>%
#'   addArrowhead(data = atlStorms2005)
addArrowhead <- function(map, lng = NULL, lat = NULL, layerId = NULL,
                       group = NULL, stroke = TRUE, color = "#03F", weight = 5,
                       opacity = 0.5, fill = FALSE, fillColor = color,
                       fillOpacity = 0.2, dashArray = NULL, smoothFactor = 1,
                       noClip = FALSE, popup = NULL, popupOptions = NULL,
                       label = NULL, labelOptions = NULL,
                       options = arrowheadOptions(), highlightOptions = NULL,
                       data = getMapData(map)) {

  if (missing(labelOptions))
    labelOptions <- labelOptions()

  arrowheadOptions <- options
  options <- filterNULL(
    c(list(stroke = stroke, color = color, weight = weight,
         opacity = opacity, fill = fill, fillColor = fillColor,
         fillOpacity = fillOpacity, dashArray = dashArray,
         smoothFactor = smoothFactor, noClip = noClip),
      arrowheadOptions))


  pgons <- derivePolygons(data, lng, lat, missing(lng), missing(lat),
                          "addPolylines")

  map$dependencies <- c(map$dependencies, arrowheadDependency())

  invokeMethod(map, data, "addArrowhead", pgons, layerId, group,
               options, popup, popupOptions, safeLabel(label, data),
               labelOptions, highlightOptions, arrowheadOptions) %>%
    expandLimitsBbox(pgons)
}

#' Arrowhead Options
#'
#' Additional list of options for polylines with arrowheads. You can also pass
#' options inherited from
#' \href{https://leafletjs.com/reference-1.6.0.html#path}{L.Path}
#'
#' @param yawn Defines the width of the opening of the arrowhead, given in
#'   degrees. The larger the angle, the wider the arrowhead.
#' @param size Determines the size of the arrowhead. Accepts three types of
#'   values:
#'   \itemize{
#'   \item A string with the suffix \code{'m'}, i.e. \code{'500m'} will set the
#'   size of the arrowhead to that number of meters.
#'   \item A string with the suffix \code{'\%'}, i.e. \code{'15\%'} will render
#'   arrows whose size is that percentage of the size of the parent polyline. If
#'   the polyline has multiple segments, it will take the percent of the
#'   average size of the segments.
#'   \item A string the suffix \code{'px'}, i.e. \code{'20px'} will render an
#'   arrowhead whose size stays at a constant pixel value, regardless of zoom
#'   level. Will look strange at low zoom levels or for smaller parent vectors.
#'   Ideal for larger parent vectors and at higher zoom levels.
#' }
#' @param frequency How many arrowheads are rendered on a polyline.
#'   \itemize{
#'   \item \code{'allvertices'} renders an arrowhead on each vertex.
#'   \item \code{'endonly'} renders only one at the end.
#'   \item A numeric value renders that number of arrowheads evenly spaced
#'   along the polyline.
#'   \item A string with suffix \code{'m'}, i.e. \code{'100m'} will render
#'   arrowheads spaced evenly along the polyline with roughly that many meters
#'   between each one.
#'   \item A string with suffix \code{'px'}, i.e. \code{'30px'} will render
#'   arrowheads spaced evenly with roughly that many pixels between each,
#'   regardless of zoom level. }
#' @param proportionalToTotal Only relevant when size is given as a percent.
#'   Useful when frequency is set to \code{'endonly'}. Will render the
#'   arrowheads with a size proportional to the entire length of the
#'   multi-segmented polyline, rather than proportional to the average length of
#'   all the segments.
#' @param offsets Enables the developer to have the arrowheads start or end at
#'   some offset from the start and/or end of the polyline. This option can be a list
#'   with `start` and `end` names. The values must be strings
#'   defining the size of the offset in either meters or pixels, i.e.
#'   \code{list('start' = '100m', 'end' = '15px')}.
#' @param perArrowheadOptions Enables the developer to customize arrowheads on a
#'   one-by-one basis. Must be in the form of a function of i, which is the
#'   index of the arrowhead as it is rendered in the loop through all
#'   arrowheads. Must return an options object. Cannnot
#'   account for \code{frequency} or \code{proportionalToTotal} from within the
#'   \code{perArrowheadOptions} callback. See the example for details.
#' @param ... Additional options for arrowheads, inherited from
#'   \href{https://leafletjs.com/reference-1.6.0.html#path}{L.Path}
#' @references \url{https://github.com/slutske22/leaflet-arrowheads#options}
#' @family Arrowhead Functions
#' @return A list of options for \code{addArrowhead} polylines
#' @export
arrowheadOptions <- function(
  yawn = 60,
  size = '15%',
  frequency = 'allvertices',
  proportionalToTotal = FALSE,
  offsets = NULL,
  perArrowheadOptions = NULL,
  ...) {

  filterNULL(list(
    yawn = yawn,
    size = size,
    frequency = frequency,
    proportionalToTotal = proportionalToTotal,
    offsets = offsets,
    perArrowheadOptions = perArrowheadOptions,
    ...
  ))
}

#' Remove arrowheads from Lines by group
#'
#' @param map the map
#' @param group A group name
#' @family Arrowhead Functions
#' @return A modified leaflet map
#' @export
clearArrowhead <- function(map, group) {
  invokeMethod(map, getMapData(map), "clearArrowhead", group)
}

#' Remove arrowheads from Lines by layerId
#'
#' @param map the map
#' @param layerId A single layerId or a vector of layerId's
#' @family Arrowhead Functions
#' @return A modified leaflet map
#' @export
removeArrowhead <- function(map, layerId) {
  invokeMethod(map, getMapData(map), "removeArrowhead", layerId)
}

