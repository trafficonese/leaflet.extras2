layerGroupConditionalDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-conditional",
      version = "1.0.0",
      src = system.file("htmlwidgets/lfx-conditional", package = "leaflet.extras2"),
      script = c(
        "leaflet.layergroup.conditional.js",
        "leaflet.layergroup.conditional-bindings.js"
      )
    )
  )
}

#' addLayerGroupConditional
#'
#' @param map A map widget object created from \code{\link[leaflet]{leaflet}}.
#' @param groups A character vector of layer group names already added to the map.
#' These layer groups will be conditionally displayed based on the specified \code{conditions}.
#' @param conditions A named list where:
#'   - Each **name** is a JavaScript function (using \code{\link[leaflet]{JS}}) defining a condition for displaying a layer group.
#'   - Each **value** corresponds to a layer group name (or names) from the \code{layers} parameter.
#'   Example:
#'   \preformatted{
#'     condition = list(
#'       "(zoomLevel) => zoomLevel < 4" = "group1",
#'       "(zoomLevel) => zoomLevel >= 4 && zoomLevel < 6" = "group2",
#'       "(zoomLevel) => zoomLevel >= 6" = c("group3", "group4")
#'     )
#'   }
#'
#' @seealso \url{https://github.com/Solfisk/Leaflet.LayerGroup.Conditional?tab=readme-ov-file} for more details about the plugin.
#' @family LayerGroupConditional Plugin
#' @export
#' @examples
#' library(leaflet)
#' library(sf)
#' library(leaflet.extras2)
#'
#' breweries91 <- st_as_sf(breweries91)
#' lines <- st_as_sf(atlStorms2005)
#' polys <- st_as_sf(leaflet::gadmCHE)
#' groups <- c("atlStorms","breweries","gadmCHE")
#'
#' leaflet()  %>%
#' addTiles() %>%
#'   #leafem::addMouseCoordinates() %>%
#'   addPolylines(data = lines, label = ~Name, group = groups[1]) %>%
#'   addCircleMarkers(data = breweries91, label = ~brewery, group = groups[2]) %>%
#'   addPolygons(data = polys, label = ~NAME_1, group = groups[3]) %>%
#'   addLayerGroupConditional(groups = groups,
#'                            conditions = list(
#'                              "(zoomLevel) => zoomLevel < 4" = groups[1],
#'                              "(zoomLevel) => zoomLevel >= 4 & zoomLevel < 6 " = groups[2],
#'                              "(zoomLevel) => zoomLevel >= 6" = groups[3]
#'                            )) %>%
#'   hideGroup(groups) %>%
#'   addLayersControl(overlayGroups = groups,
#'                    options = layersControlOptions(collapsed=FALSE))
#'
addLayerGroupConditional <- function(map, groups = NULL, conditions = NULL) {
  map$dependencies <- c(map$dependencies, layerGroupConditionalDependency())
  invokeMethod(
    map, getMapData(map), "addLayerGroupConditional",
    groups, conditions
  )
}

#' removeConditionalLayer
#'
#' @inheritParams addLayerGroupConditional
#' @family LayerGroupConditional Plugin
#' @export
removeConditionalLayer <- function(map, groups) {
  invokeMethod(map, getMapData(map), "removeConditionalLayer", groups)
}

#' clearConditionalLayers
#'
#' @inheritParams addLayerGroupConditional
#' @family LayerGroupConditional Plugin
#' @export
clearConditionalLayers <- function(map) {
  invokeMethod(map, getMapData(map), "clearConditionalLayers")
}
