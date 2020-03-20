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
#' @param map a map widget object created from \code{\link[leaflet]{leaflet}}
#' @export
addHexbin <- function(map, group = NULL, layerId = NULL, data = NULL, options = list()) {

  map$dependencies <- c(map$dependencies, hexbinDependency())

  invokeMethod(map, getMapData(map), "addHexbin", data, layerId, group, options)
}
