# JS
# https://api.mapbox.com/mapbox.js/plugins/leaflet-markercluster/v0.4.0/leaflet.markercluster.js
# CSS
# https://api.mapbox.com/mapbox.js/plugins/leaflet-markercluster/v0.4.0/MarkerCluster.css
pruneClusterDependencies <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-prunecluster", version = "1.0.0",
      src = system.file("htmlwidgets/lfx-prunecluster", package = "leaflet.extras2"),
      stylesheet = c("LeafletStyleSheet.css"),
      script = c(
        # "d3.v3.min.js",
        "PruneCluster.js",
        "lfx-prunecluster-bindings.js"
      )
    )
  )
}

#' addPruneCluster
#' @description Adds cluster charts (pie, bar, horizontal, or custom) to a Leaflet map.
#' @param type The type of chart to use for clusters: \code{"pie"}, \code{"bar"}, \code{"horizontal"}, or \code{"custom"}.
#' @param categoryField The column name used to categorize the charts.
#' @param icon An icon or set of icons to include, created with \code{makeIcon} or \code{iconList}.
#' @param popup The column name used to retrieve feature properties for the popup.
#' @param popupFields A string or vector of strings indicating the column names to include in popups.
#' @param popupLabels A string or vector of strings indicating the labels for the popup fields.
#' @param options Additional options for cluster charts (see \code{\link{clusterchartOptions}}).
#' @param legendOptions A list of options for the legend, including the title and position.
#' @param markerOptions Additional options for markers (see \code{\link[leaflet:markerOptions]{markerOptions::markerOptions()}}).
#' @inheritParams leaflet::addCircleMarkers
#'
#' @family pruneCluster
#' @details
#' The `clusterCharts` use Leaflet's `L.DivIcon`, allowing you to fully customize
#' the styling of individual markers and clusters using CSS. Each individual marker
#' within a cluster is assigned the CSS class `clustermarker`, while the entire
#' cluster is assigned the class `clustermarker-cluster`. You can modify the appearance
#' of these elements by targeting these classes in your custom CSS.
#' @export
addPruneCluster <- function(
    map, lng = NULL, lat = NULL, layerId = NULL, group = NULL,
    icon = NULL, categoryField = NULL,
    color = NULL,
    popup = NULL, popupOptions = NULL, label = NULL, labelOptions = NULL,
    clusterOptions = NULL, clusterId = NULL,
    markerOptions = NULL, data = getMapData(map)) {

  ## Check arguments ############
  if (missing(labelOptions)) labelOptions <- labelOptions()

  ## Add Deps ############
  map$dependencies <- c(map$dependencies,
                        pruneClusterDependencies())

  ## Make Geojson ###########
  if (!inherits(data, "sf")) {
    data <- sf::st_as_sf(data)
  }
  geojson <- yyjsonr::write_geojson_str(data)
  class(geojson) <- c("geojson","json")

  if (is.null(icon)) {
    if (inherits(icon, "leaflet_icon_set")) {
      icon <- icon[["category"]]
    }
    # Pack and encode each URL vector; this will be reversed on the client
    icon$iconUrl         <- b64EncodePackedIcons(packStrings(icon$iconUrl))
    icon$iconRetinaUrl   <- b64EncodePackedIcons(packStrings(icon$iconRetinaUrl))
    icon$shadowUrl       <- b64EncodePackedIcons(packStrings(icon$shadowUrl))
    icon$shadowRetinaUrl <- b64EncodePackedIcons(packStrings(icon$shadowRetinaUrl))

    # if iconSize is of length 2 and there is one icon url, wrap the icon size in a list
    if (length(icon$iconSize) == 2) {
      if (is.numeric(icon$iconSize[[1]]) && is.numeric(icon$iconSize[[2]])) {
        icon$iconSize <- list(icon$iconSize)
      }
    }

    icon <- filterNULL(icon)
  }

  color_sets <- unique(data.frame(category = data[[categoryField]], color = data[[color]]))

  ## Derive Points and Invoke Method ##################
  points <- derivePoints(data, lng, lat, missing(lng), missing(lat),
                         "addPruneCluster")
  leaflet::invokeMethod(
    map, NULL, "addPruneCluster", geojson, layerId, group,
    options, icon, categoryField, color_sets,
    popup, popupOptions, safeLabel(label, data), labelOptions,
    clusterOptions, clusterId, markerOptions
    ) %>%
    leaflet::expandLimits(points$lat, points$lng)
}
