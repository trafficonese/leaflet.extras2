gibsDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-gibs", version = "2.1.0",
      src = system.file("htmlwidgets/lfx-gibs", package = "leaflet.extras2"),
      script = c(
        "GIBSLayer.js",
        "GIBSMetadata.js",
        "gibs-bindings.js")
    )
  )
}

#' Add GIBS Layers
#' @param map A map widget object created from \code{\link[leaflet]{leaflet}}
#' @param layers vector of GIBS-layers. See \code{\link{gibs_layers}}
#' @param dates Date object. If multiple \code{layers} are added, you can add
#'   a Date vector of the same length
#' @param group the name of the group the newly created layers should belong to
#'   (for\code{\link[leaflet]{clearGroup}} and
#'   \code{\link[leaflet]{addLayersControl}} purposes). Human-friendly group
#'   names are permitted–they need not be short, identifier-style names. Any
#'   number of layers and even different types of layers (e.g. markers and
#'   polygons) can share the same group name.
#' @param opacity numeric value determining the opacity. If multiple
#'   \code{layers} are added, you can add a numeric vector of the same length
#' @param transparent Should the layer be transparent. If multiple
#'   \code{layers} are added, you can add a boolean vector of the same length
#' @seealso \url{https://github.com/aparshin/leaflet-GIBS}
#' @family GIBS Functions
#' @export
#' @examples
#' library(leaflet)
#' library(leaflet.extras2)
#'
#' layers <- gibs_layers$title[c(35, 128, 185)]
#'
#' leaflet()  %>%
#'   addTiles() %>%
#'   setView(9, 50, 4) %>%
#'   addGIBS(layers = layers,
#'           dates = Sys.Date() - 1,
#'           group = layers) %>%
#'   addLayersControl(overlayGroups = layers)
addGIBS <- function(map, layers = NULL, group = NULL, dates = NULL,
                    opacity = 0.5, transparent = TRUE) {

  ## Check required args ######################
  if (is.null(layers))
    stop("You must define one or multiple `layers`.\n",
         "See `gibs_layers` for a list of all available layers and their attributes.")
  if (is.null(dates))
    stop("You must define one or multiple `dates` for each layer.")

  ## Check if layers exist ######################
  if (!all(layers %in% gibs_layers$title)) {
    stop("The layer is not valid. Did you mean: `",
         gibs_layers$title[which.min(adist(layers, gibs_layers$title))], "`?\n",
         "If not, please see `gibs_layers` for a list of all available layers and their attributes.")
  }

  ## If multiple layers passed, repeat single values, so JS can always assume an array
  lenlay = length(layers)
  if (lenlay > 1) {
    seqlen <- seq.int(lenlay)
    if (lenlay != length(group)) {
      group <- rep(group, lenlay)[seqlen]
    }
    if (lenlay != length(dates)) {
      dates <- rep(dates, lenlay)[seqlen]
    }
    if (lenlay != length(opacity)) {
      opacity <- rep(opacity, lenlay)[seqlen]
    }
    if (lenlay != length(transparent)) {
      transparent <- rep(transparent, lenlay)[seqlen]
    }
  }

  ## Add deps ################
  map$dependencies <- c(map$dependencies, gibsDependency())

  ## Invoke Leaflet ##########
  invokeMethod(map, getMapData(map), "addGIBS", layers, group, dates, opacity, transparent)
}

#' Set Date for GIBS Layers
#' @inheritParams addGIBS
#' @family GIBS Functions
#' @export
setDate <- function(map, layers = NULL, dates = NULL) {
  ## Check required args ######################
  if (is.null(layers))
    stop("You must define one or multiple `layers`.\n",
         "See `gibs_layers` for a list of all available layers and their attributes.")
  if (is.null(dates))
    stop("You must define one or multiple `dates`.")

  ## Invoke Leaflet ##########
  invokeMethod(map, NULL, "setDate", layers, dates)
}

#' Set Transparency for GIBS Layers
#' @inheritParams addGIBS
#' @family GIBS Functions
#' @export
setTransparent <- function(map, layers = NULL, transparent = TRUE) {
  ## Check required args ######################
  if (is.null(layers))
    stop("You must define one or multiple `layers`.\n",
         "See `gibs_layers` for a list of all available layers and their attributes.")

  ## Invoke Leaflet ##########
  invokeMethod(map, NULL, "setTransparent", layers, transparent)
}
