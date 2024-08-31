diviconDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-divicon", version = "1.0.0",
      src = system.file("htmlwidgets/lfx-divicon", package = "leaflet.extras2"),
      script = "lfx-divicon-bindings.js",
      all_files = TRUE
    )
  )
}

#' Add DivIcon
#'
#' The function expects either line or point data as spatial data or as Simple Feature.
#' Alternatively, coordinates can also be passed as numeric vectors.
#' @param map the map to add moving markers
#' @inheritParams leaflet::addAwesomeMarkers
#' @param classes A single or vector of CSS-classes
#' @param htmls A single or vector of HTML objects
#' @param options a list of extra options for markers. See
#'   \code{\link[leaflet]{markerOptions}}
#' @family Divicon Functions
#' @references \url{https://github.com/ewoken/Leaflet.MovingMarker}
#' @inherit leaflet::addMarkers return
#' @export
#' @examples
addDivicon <- function (map, lng = NULL, lat = NULL, layerId = NULL, group = NULL,
                        icon = NULL, popup = NULL, popupOptions = NULL, label = NULL,
                        labelOptions = NULL,
                        classes = NULL, htmls = NULL,
                        options = markerOptions(), clusterOptions = NULL,
                        clusterId = NULL, data = getMapData(map)) {
  if (missing(labelOptions))
    labelOptions <- labelOptions()

  map$dependencies <- c(map$dependencies,
                        diviconDependency())
  pts <- derivePoints(data, lng, lat, missing(lng), missing(lat),
                      "addDivicon")
  invokeMethod(map, data, "addDivicon", pts$lat, pts$lng,
               icon, layerId, group, options,
               classes, htmls,
               popup, popupOptions,
               label, labelOptions,
               clusterId, clusterOptions) %>%
    expandLimits(pts$lat, pts$lng)
}


