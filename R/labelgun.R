labelgunDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-labelgun", version = "1.0.0",
      src = system.file("htmlwidgets/lfx-labelgun", package = "leaflet.extras2"),
      script = c("rbush.min.js",
                 "labelgun.js",
                 "labelgun-binding.js"),
      all_files = TRUE
    )
  )
}

#' Add addLabelgun Plugin
#'
#' @param map A map widget object created from \code{\link[leaflet]{leaflet}}
#' @param group a group name
#' @param entries Higher value relates to faster insertion and slower search, and vice versa
#' @param weight the weight
#'
#' @return A leaflet map object
#' @export
#'
#' @references \url{https://github.com/Geovation/labelgun}
#'
#' @name addLabelgun
addLabelgun <- function(map, group, entries, weight) {
  map$dependencies <- c(map$dependencies, labelgunDependency())
  invokeMethod(map, NULL, "addLabelgun", group, entries, weight)
}
