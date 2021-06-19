spinDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-spin", version = "1.0.0",
      src = system.file("htmlwidgets/lfx-spin", package = "leaflet.extras2"),
      script = c("spin.min.js",
                 "leaflet.spin.min.js",
                 "leaflet.spin-binding.js"),
      # stylesheet = c("spin.css"),
      all_files = TRUE
    )
  )
}

#' Add Spin Plugin
#'
#' Adds an animated loading spinning over the map.
#' @param map A map widget object created from \code{\link[leaflet]{leaflet}}
#'
#' @param options Spin.js options. Named list. See \url{http://spin.js.org}
#'
#' @return A leaflet map object
#' @export
#'
#' @references \url{https://github.com/makinacorpus/Leaflet.Spin}
#' @references \url{https://github.com/fgnass/spin.js}
#'
#' @name addSpinner
#'
#' @examples
#' library(leaflet)
#' library(leaflet.extras2)
#'
#' leaflet(data = quakes) %>%
#'   addTiles() %>%
#'   addSpinner() %>%
#'   startSpinner(options = list("lines" = 7, "length" = 20)) %>%
#'   addMarkers(~long, ~lat, popup = ~as.character(mag), label = ~as.character(mag)) %>%
#'   stopSpinner()
addSpinner <- function(
  map
) {
  map$dependencies <- c(map$dependencies, spinDependency())
  map
}

#' @export
#'
#' @rdname addSpinner
startSpinner <- function(
  map, options = NULL
) {
  invokeMethod(map, NULL, 'spinner', TRUE, options)
}

#' @export
#'
#' @rdname addSpinner
stopSpinner <- function(
  map
) {
  invokeMethod(map, NULL, 'spinner', FALSE)
}
