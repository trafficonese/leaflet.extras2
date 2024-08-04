# JS
# https://api.mapbox.com/mapbox.js/plugins/leaflet-markercluster/v0.4.0/leaflet.markercluster.js
# CSS
# https://api.mapbox.com/mapbox.js/plugins/leaflet-markercluster/v0.4.0/MarkerCluster.css
clusterchartsDependencies <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-clustercharts", version = "1.0.0",
      src = system.file("htmlwidgets/lfx-clustercharts", package = "leaflet.extras2"),
      stylesheet = c("lfx-clustercharts.css"),
      script = c(
        "d3.v3.min.js",
        "lfx-clustercharts-bindings.js"
        )
    )
  )
}


#' addClusterCharts
#' @description Adds cluster charts (either pie or bar charts) to a Leaflet map.
#' @param type The type of chart to use for clusters, either "pie" or "bar".
#' @param categoryField The name of the feature property used to categorize the charts.
#' @param categoryMap A data frame mapping categories to chart properties (label, color, icons, stroke).
#' @param popup Use the column name given in popup to collect the feature property with this name.
#' @param popupFields A string or vector of strings indicating the feature properties to include in popups.
#' @param popupLabels A string or vector of strings indicating the labels for the popup fields.
#' @param options Additional options for cluster charts (see \code{\link{clusterchartOptions}}).
#' @param legendOptions A list of options for the legend, including the title and position.
#' @param markerOptions Additional options for markers (see \code{\link[leaflet:markerOptions]{markerOptions::markerOptions()}}).
#' @inheritParams leaflet::addCircleMarkers
#' @export
#' @examples
#' # Example usage:
#' library(sf)
#' library(geojsonsf)
#' library(leaflet)
#' library(leaflet.extras2)
#'
#' data <- sf::st_as_sf(breweries91)
#' categories <- c("Schwer", "Mäßig", "Leicht", "kein Schaden")
#' data$category <- sample(categories, size = nrow(data), replace = TRUE)
#'
#' ## Pie Chart
#' leaflet() %>%
#'   addProviderTiles("CartoDB.Positron") %>%
#'   leaflet::addLayersControl(overlayGroups = "clustermarkers") %>%
#'   addClusterCharts(data = data
#'                    , categoryField = "category"
#'                    , categoryMap = data.frame(labels = categories,
#'                                               colors  = c("#F88", "#FA0", "#FF3", "#BFB"),
#'                                               strokes = "gray")
#'                    , group = "clustermarkers"
#'                    , popupFields = c("brewery", "address", "zipcode", "category")
#'                    , popupLabels = c("Brauerei", "Adresse", "PLZ", "Art")
#'                    , label = "brewery"
#'   )
#'
#' ## Bar Chart
#' leaflet() %>%
#'   addProviderTiles("CartoDB.Positron") %>%
#'   leaflet::addLayersControl(overlayGroups = "clustermarkers") %>%
#'   addClusterCharts(data = data
#'                    , type = "bar"
#'                    , categoryField = "category"
#'                    , categoryMap = data.frame(labels = categories,
#'                                               colors  = c("#F88", "#FA0", "#FF3", "#BFB"),
#'                                               strokes = "gray")
#'                    , group = "clustermarkers"
#'                    , popupFields = c("brewery", "address", "zipcode", "category")
#'                    , popupLabels = c("Brauerei", "Adresse", "PLZ", "Art")
#'                    , label = "brewery"
#'   )
addClusterCharts <- function(
    map, lng = NULL, lat = NULL, layerId = NULL, group = NULL, type = c("pie","bar","horizontal"),
    options = clusterchartOptions(),
    popup = NULL, popupOptions = NULL, label = NULL, labelOptions = NULL,
    clusterOptions = NULL, clusterId = NULL,
    categoryField, categoryMap, popupFields = NULL, popupLabels = NULL,
    markerOptions = NULL, legendOptions = list(title = "",
                                               position = "topright"),
    data = getMapData(map)) {

  ## Check arguments ############
  type <- match.arg(type)
  if (missing(labelOptions)) labelOptions <- labelOptions()
  if (missing(categoryMap)) {
    stop("The `categoryMap` is missing.\n",
            "A `categoryMap` is required to associate `labels`, `colors`, `icons`, and `strokes` with individual features\n",
            "based on the specified `categoryField`: ", categoryField, ".")
  }
  if (is.null(categoryMap$labels)) {
    warning("The `categoryMap` is missing a `labels` column.\n",
            "Values will be generated based on the unique values of `", categoryField, "` in `data`.\n",
            "Note: The order may be incorrect, so it is recommended to add a correct `labels` column in the `categoryMap`.")
    categoryMap$labels <- unique(data[[categoryField]])
  }
  if (is.null(categoryMap$colors)) {
    warning("The `categoryMap` is missing a `color` column.\n",
            "An automatic color palette will be assigned.")
    categoryMap$colors <- colorRampPalette(c("#fc8d8d", "white", "lightblue"))(nrow(categoryMap))
  }
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
  categoryMapList <- as.list(categoryMap$labels)
  names(categoryMapList) <- seq.int(categoryMapList)

  ## Add Deps ############
  map$dependencies <- c(map$dependencies,
                        csssrc,
                        leaflet::leafletDependencies$markerCluster(),
                        clusterchartsDependencies())

  ## Make Geojson ###########
  if (!inherits(sf::st_as_sf(data), "sf")) {
    data <- sf::st_as_sf(data)
  }
  geojson <- geojsonsf::sf_geojson(data)

  ## Derive Points and Invoke Method ##################
  points <- derivePoints(data, lng, lat, missing(lng), missing(lat),
                         "addClusterCharts")
  leaflet::invokeMethod(
    map, NULL, "addClusterCharts", geojson, layerId, group, type,
    options,
    popup, popupOptions, safeLabel(label, data), labelOptions,
    clusterOptions, clusterId,
    categoryField, categoryMapList, popupFields, popupLabels,
    markerOptions, legendOptions
  ) %>%
    leaflet::expandLimits(points$lat, points$lng)
}

#' clusterchartOptions
#' @description Adds options for clusterCharts
#' @param rmax The maximum radius of the clusters.
#' @param size The size of the cluster markers.
#' @param strokeWidth The stroke width in the chart.
#' @param width The width of the bar-chart.
#' @param height The height of the bar-chart.
#' @param innerRadius The inner radius of the pie-chart.
#' @export
clusterchartOptions <- function(rmax = 30, size = c(20, 20),
                                width = 40, height = 50,
                                strokeWidth = 1,
                                innerRadius = 10,
                                labelBackground = FALSE,
                                labelFill = "white",
                                labelStroke = "black",
                                labelColor = "black",
                                labelOpacity = 0.9) {
  filterNULL(list(
    rmax = rmax
    , size = size
    , width = width
    , height = height
    , strokeWidth = strokeWidth
    , innerRadius = innerRadius
    , labelBackground = labelBackground
    , labelFill = labelFill
    , labelStroke = labelStroke
    , labelColor = labelColor
    , labelOpacity = labelOpacity
  ))
}

generate_css <- function(row) {
  label <- row["labels"]
  color <- row["colors"]
  stroke <- row["strokes"]
  icon <- row['icons']
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
  if (!is.null(icon)) {
    css <- paste0(css,
                  ".icon-", gsub(" ", ".", label), " {\n",
                  "  background-image: url('", icon, "') !important;\n",
                  "  background-repeat: no-repeat !important;\n",
                  "  background-position: 0px 1px !important;\n",
                  "}"
                  )
  }
  css
}

