labelgunDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-labelgun",
      version = "1.0.0",
      src = system.file("htmlwidgets/lfx-labelgun", package = "leaflet.extras2"),
      script = c(
        "rbush.min.js",
        "labelgun.js",
        "labelgun-binding.js"
      ),
      all_files = TRUE
    )
  )
}

#' Add addLabelgun Plugin
#'
#' The plugin allows to avoid cluttering in marker labels and gives priority
#' to labels of your choice (with higher weight).
#'
#' @note It is important to invoke the function after the markers have been
#'   added to the map. Otherwise nothing will happen.
#'
#' @param map A map widget object created from \code{\link[leaflet]{leaflet}}
#' @param group The group name of the layer/s for which label collisions are
#'   to be avoided.
#'   To see the effects of this plugin the \code{labelOptions} of the markers must be
#'   configured with either \code{permanent = TRUE} or \code{noHide = TRUE}.
#' @param weight An optional weight for markers. If a vector is given, the
#'   length should match the number of all markers in the corresponding groups.
#'   If a numeric value is specified, it is used for each marker and thus no
#'   prioritization of the labels takes place.
#'   In all other cases a random integer is calculated.
#' @param entries A numeric value, a higher value relates to faster insertion
#'   and slower search, and vice versa. The default is 10
#'
#' @return A leaflet map object
#' @export
#'
#' @references \url{https://github.com/Geovation/labelgun}
#'
#' @name addLabelgun
#' @examples
#' library(leaflet)
#' library(leaflet.extras2)
#'
#' leaflet() %>%
#'   addTiles() %>%
#'   addMarkers(
#'     data = breweries91,
#'     label = ~brewery,
#'     group = "markers",
#'     labelOptions = labelOptions(permanent = TRUE)
#'   ) %>%
#'   addLabelgun("markers", 1)
addLabelgun <- function(map, group = NULL, weight = NULL, entries = NULL) {
  stopifnot("The group argument is NULL. Please define a valid group." = !is.null(group))
  map$dependencies <- c(map$dependencies, labelgunDependency())
  invokeMethod(map, NULL, "addLabelgun", group, weight, entries[1])
}
