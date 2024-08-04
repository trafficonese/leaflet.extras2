# JS
# https://api.mapbox.com/mapbox.js/plugins/leaflet-markercluster/v0.4.0/leaflet.markercluster.js
# CSS
# https://api.mapbox.com/mapbox.js/plugins/leaflet-markercluster/v0.4.0/MarkerCluster.css
clusterchartsDependencies <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-clustercharts", version = "1.0.0",
      src = system.file("htmlwidgets/lfx-clustercharts", package = "leaflet.extras2"),
      stylesheet = c("MarkerCluster.css",
                     "MarkerCluster.Default.css",
                     "lfx-clustercharts.css"),
      script = c(
        "leaflet.markercluster.js",
        "d3.v3.min.js",
        "lfx-clustercharts-bindings.js"
        )
    )
  )
}


#' addClusterCharts
#' @description Adds a Great Circle to the map.
#' @param lat_center,lng_center lat/lng for the center
#' @param radius in meters
#' @param rmax The maxClusterRadius
#' @param categoryField in meters
#' @param popupFields in meters
#' @param options clusterchartOptions
#' @inheritParams leaflet::addCircleMarkers
#' @export
addClusterCharts <- function(
    map, lng = NULL, lat = NULL, layerId = NULL, group = NULL, type = c("pie","bar"),
    options = clusterchartOptions(),
    popup = NULL, popupOptions = NULL, label = NULL, labelOptions = NULL,
    clusterOptions = NULL, clusterId = NULL,
    categoryField, categoryMap, popupFields = NULL, popupLabels = NULL,
    markerOptions = NULL, legendOptions = list(title = "",
                                               position = "topright"),
    data = getMapData(map)) {

  ## Check type, labelOptions, popupFields, popupLabels, clusterOptions ############
  type <- match.arg(type)
  if (missing(labelOptions))
    labelOptions <- labelOptions()
  if (!is.null(popupFields) && is.null(popupLabels)) {
    popupLabels <- popupFields
  }
  if (!is.null(clusterOptions)) {
    clusterOptions$maxClusterRadius = NULL
    clusterOptions$iconCreateFunction = NULL
  }

  ## CSS string #############
  css <- paste(apply(categoryMap, 1, generate_css), collapse = "\n")
  size <- options$size
  if (length(size) == 1) size <- rep(size, 2)
  css <- paste0(css, "\n.clustermarker {",
                "width: ",size[1],"px; height: ",size[2],"px;",
                "margin-top: -",size[1]/2,"px; margin-left: -",size[2]/2,"px;",
                "}")
  csssrc <- list(
    htmltools::htmlDependency(
      "lfx-clustercharts-css", version = "1.0.0",
      head = as.character(tags$style(css)),
      src = system.file("htmlwidgets/lfx-clustercharts", package = "leaflet.extras2")
    )
  )
  categoryMap <- setNames(as.list(categoryMap$label), seq.int(as.list(categoryMap$label)))

  ## Add Deps ############
  map$dependencies <- c(map$dependencies, csssrc, clusterchartsDependencies())

  ## Make Geojson ###########
  geojson <- geojsonsf::sf_geojson(data)

  ## Derive Points and Invoke Method ##################
  points <- derivePoints(data, lng, lat, missing(lng), missing(lat),
                         "addClusterCharts")
  leaflet::invokeMethod(
    map, NULL, "addClusterCharts", geojson, layerId, group, type,
    options,
    popup, popupOptions, safeLabel(label, data), labelOptions,
    clusterOptions, clusterId,
    categoryField, categoryMap, popupFields, popupLabels,
    markerOptions, legendOptions
  ) %>%
    leaflet::expandLimits(points$lat, points$lng)
}

#' clusterchartOptions
#' @description Adds options for clusterCharts
#' @param rmax The maxClusterRadius
#' @param size the size
#' @param width the width
#' @param height the height
#' @param strokeWidth the strokeWidth
#' @param pieMultiplier the pieMultiplier
#' @param innerRadius the innerRadius
#' @export
clusterchartOptions <- function(rmax = 30, size = c(20, 20),
                                width = 40, height = 50,
                                strokeWidth = 1,
                                pieMultiplier = 2,
                                innerRadius = -10) {
  list(
    rmax = rmax,
    size = size,
    width = width,
    height = height,
    strokeWidth = strokeWidth,
    innerRadius = innerRadius
  )
}

generate_css <- function(row) {
  label <- row["label"]
  color <- row["color"]
  stroke <- row["stroke"]
  icons <- row['icons']
  if (is.null(color)) color <- stroke
  if (is.null(stroke)) stroke <- color

  # Replace spaces with dots in the class name
  class_name <- paste0("category-",gsub(" ", ".", label))

  css <- paste0(
    ".", class_name, " {\n",
    "  fill: ", color, ";\n",
    "  stroke: ", stroke, ";\n",
    "  background: ", color, ";\n",
    "  border-color: ", stroke, ";\n",
    "}\n"
  )
  if (!is.null(icons)) {
    css <- paste0(css,
                  ".icon-", gsub(" ", ".", label), " {\n",
                  "  background-image: url('", icons, "') !important;\n",
                  "  background-repeat: no-repeat !important;\n",
                  "  background-position: 0px 1px !important;\n",
                  "}"
                  )
  }
  css
}

