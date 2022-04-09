antpathDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-antpath", version = "1.0.0",
      src = system.file("htmlwidgets/lfx-antpath", package = "leaflet.extras2"),
      script = c("lfx-ant-path.js",
                 "lfx-ant-path-bindings.js")
    )
  )
}

#' Add Antpath Lines
#'
#' Can be used almost exactly like \code{addPolylines} but instead of
#' \code{pathOptions} you can use \code{\link{antpathOptions}} to adapt the
#' Antpath behaviour. See
#' \href{https://github.com/rubenspgcavalcante/leaflet-ant-path}{leaflet-ant-path}
#' for further details.
#'
#' @inheritParams leaflet::addPolylines
#' @param options A named list of options. See \code{\link{antpathOptions}}
#' @family Antpath Functions
#' @references \url{https://github.com/rubenspgcavalcante/leaflet-ant-path}
#' @return A modified leaflet map, with an 'ant-path' animated polyline
#' @export
#' @examples
#' library(leaflet)
#' leaflet() %>%
#'   addAntpath(data = atlStorms2005)
addAntpath <- function(map, lng = NULL, lat = NULL, layerId = NULL,
                       group = NULL, stroke = TRUE, color = "#03F", weight = 5,
                       opacity = 0.5, fill = FALSE, fillColor = color,
                       fillOpacity = 0.2, dashArray = NULL, smoothFactor = 1,
                       noClip = FALSE, popup = NULL, popupOptions = NULL,
                       label = NULL, labelOptions = NULL,
                       options = antpathOptions(), highlightOptions = NULL,
                       data = getMapData(map)) {

  if (missing(labelOptions))
    labelOptions <- labelOptions()

  options <- c(options, filterNULL(
    list(stroke = stroke, color = color, weight = weight,
         opacity = opacity, fill = fill, fillColor = fillColor,
         fillOpacity = fillOpacity, dashArray = dashArray,
         smoothFactor = smoothFactor, noClip = noClip)))

  pgons <- derivePolygons(data, lng, lat, missing(lng), missing(lat),
                          "addPolylines")

  map$dependencies <- c(map$dependencies, antpathDependency())

  invokeMethod(map, data, "addAntpath", pgons, layerId, group,
               options, popup, popupOptions, safeLabel(label, data),
               labelOptions, highlightOptions) %>%
    expandLimitsBbox(pgons)
}

#' Antpath Options
#'
#' Additional list of options for 'ant-path' animated polylines.
#' @inheritParams leaflet::pathOptions
#' @param delay Add a delay to the animation flux. Default is \code{400}
#' @param paused Should the animation be paused. Default is \code{FALSE}
#' @param reverse Defines if the flow follows the path order or not. Default is
#'   \code{FALSE}
#' @param hardwareAccelerated Makes the animation run with hardware
#'   acceleration. Default is \code{FALSE}
#' @param dashArray The size of the animated dashes. Default is \code{c(10, 20)}
#' @param pulseColor Adds a color to the dashed flux. Default is \code{#ffffff}
#' @family Antpath Functions
#' @return A list of options for \code{addAntpath} animated polylines
#' @export
antpathOptions = function(
  delay = 400,
  paused = FALSE,
  reverse = FALSE,
  hardwareAccelerated = FALSE,
  dashArray = c(10, 20),
  pulseColor = "#ffffff",
  lineCap = NULL, lineJoin = NULL,
  interactive = TRUE, pointerEvents = NULL,
  className = "") {

  filterNULL(list(
    delay = delay,
    paused = paused,
    reverse = reverse,
    hardwareAccelerated = hardwareAccelerated,
    dashArray = dashArray,
    pulseColor = pulseColor,
    lineCap = lineCap,
    lineJoin = lineJoin,
    interactive = interactive,
    pointerEvents = pointerEvents,
    className = className
  ))
}

#' removeAntpath
#'
#' Remove one or more Antpaths from a map, identified by \code{layerId}.
#' @inheritParams leaflet::removeShape
#' @family Antpath Functions
#' @inherit leaflet::removeShape return
#' @export
removeAntpath <- function(map, layerId = NULL) {
  invokeMethod(map, NULL, "removeAntpath", layerId)
}

#' clearAntpath
#'
#' Clear all Antpaths
#' @inheritParams leaflet::clearShapes
#' @family Antpath Functions
#' @inherit leaflet::clearShapes return
#' @export
clearAntpath <- function(map) {
  invokeMethod(map, NULL, "clearAntpath")
}
