velocityDependencies <- function() {
  list(
    htmlDependency(
      "lfx-velocity", "1.0.0",
      src = system.file("htmlwidgets/lfx-velocity", package = "leaflet.extras2"),
      script = c("leaflet-velocity.js",
                 "leaflet-velocity-bindings.js"),
      stylesheet = "leaflet-velocity.css"
    )
  )
}

#' Add Velocity Animation
#'
#' @param map a map widget
#' @param layerId the layer id
#' @param group the name of the group the newly created layers should belong to
#'   (for \code{clearGroup} and \code{addLayersControl} purposes).
#'   Human-friendly group names are permitted–they need not be short,
#'   identifier-style names. Any number of layers and even different types of
#'   layers (e.g. markers and polygons) can share the same group name.
#' @param content the path or URL to a JSON file representing the velocity data
#'   or a data.frame which can be transformed to such a JSON file. Please see the
#'   \href{https://github.com/danwild/leaflet-velocity/tree/master/demo}{demo
#'   files} for some example data.
#' @param options see \code{\link{velocityOptions}}
#' @description Add velocity animated data to leaflet. Based on the
#'   \href{https://github.com/danwild/leaflet-velocity}{leaflet-velocity plugin}
#' @export
#' @family Velocity Functions
#' @seealso \url{https://github.com/danwild/leaflet-velocity}
#' @examples \dontrun{
#' library(leaflet)
#' library(leaflet.extras2)
#' content <- "https://raw.githubusercontent.com/danwild/leaflet-velocity/master/demo/wind-gbr.json"
#' leaflet() %>%
#'   addTiles(group = "base") %>%
#'   setView(145, -20, 4) %>%
#'   addVelocity(content = content, group = "velo", layerId = "veloid") %>%
#'   addLayersControl(baseGroups = "base", overlayGroups = "velo")
#' }
addVelocity <- function(map, layerId = NULL, group = NULL,
                        content = NULL, options = velocityOptions()) {

  if (!requireNamespace("jsonlite")) {
    stop("Package `jsonlite` must be loaded to parse the `content`")
  }
  ## Check Content
  if (is.null(content)) stop("The velocity-content is NULL")
  if (inherits(content, "character")) {
    content <- jsonlite::fromJSON(content)
    content <- jsonlite::toJSON(content)
  } else if (inherits(content, "data.frame")) {
    content <- jsonlite::toJSON(content)
  } else if (inherits(content, "json")) {
  } else {
    stop("Content does not point to a JSON file nor is it a data.frame")
  }

  map$dependencies <- c(map$dependencies, velocityDependencies())

  options <- filterNULL(options)

  invokeMethod(
    map, NULL, "addVelocity",
    layerId, group, content, options
  )
}

#' velocityOptions
#' @description Define further options for the velocity layer.
#' @param speedUnit Could be 'm/s' for meter per second, 'k/h' for kilometer
#'   per hour or 'kt' for knots
#' @param minVelocity velocity at which particle intensity is minimum
#' @param maxVelocity velocity at which particle intensity is maximum
#' @param velocityScale scale for wind velocity
#' @param colorScale A vector of hex colors or an RGB matrix
#' @param ... Further arguments passed to the Velocity layer and Windy.js.
#'   For more information, please visit \href{https://github.com/danwild/leaflet-velocity}{leaflet-velocity plugin}
#' @export
#' @family Velocity Functions
velocityOptions <- function(speedUnit = c("m/s", "k/h", "kt"),
                            minVelocity = 0,
                            maxVelocity = 10,
                            velocityScale = 0.005,
                            colorScale = NULL,
                            ...){
  if (!is.null(colorScale) && is.matrix(colorScale)) {
    colorScale <- as.matrix(
      paste0("rgb(", apply(colorScale, 1, function(x)
        paste(x, collapse = ",")), ")"))
  }
  speedUnit <- match.arg(speedUnit)
  list(
    speedUnit = speedUnit,
    minVelocity = minVelocity,
    maxVelocity = maxVelocity,
    velocityScale = velocityScale,
    colorScale = colorScale,
    ...
  )
}

#' removeVelocity
#' @param map the map widget
#' @param group the group to remove
#' @export
#' @family Velocity Functions
removeVelocity <- function(map, group){
  invokeMethod(map, NULL, "removeVelocity", group)
}

#' setOptionsVelocity
#' @param map the map widget
#' @param layerId the layer id
#' @param options see \code{\link{velocityOptions}}
#' @export
#' @family Velocity Functions
setOptionsVelocity <- function(map, layerId, options){
  options <- filterNULL(options)
  invokeMethod(map, NULL, "setOptionsVelocity", layerId, options)
}
