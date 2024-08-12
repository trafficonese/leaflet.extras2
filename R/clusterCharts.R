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
#' @description Adds cluster charts (pie, bar, horizontal, or custom) to a Leaflet map.
#' @param type The type of chart to use for clusters: \code{"pie"}, \code{"bar"}, \code{"horizontal"}, or \code{"custom"}.
#' @param categoryField The column name used to categorize the charts.
#' @param categoryMap A data.frame mapping categories to chart properties (e.g., label, color, icons, stroke).
#' @param aggregation The aggregation method to use when \code{type = "custom"}.
#' @param valueField The column name containing values to be aggregated when \code{type = "custom"}.
#' @param icon An icon or set of icons to include, created with \code{makeIcon} or \code{iconList}.
#' @param html The column name containing the HTML content to include in the markers.
#' @param popup The column name used to retrieve feature properties for the popup.
#' @param popupFields A string or vector of strings indicating the column names to include in popups.
#' @param popupLabels A string or vector of strings indicating the labels for the popup fields.
#' @param options Additional options for cluster charts (see \code{\link{clusterchartOptions}}).
#' @param legendOptions A list of options for the legend, including the title and position.
#' @param markerOptions Additional options for markers (see \code{\link[leaflet:markerOptions]{markerOptions::markerOptions()}}).
#' @inheritParams leaflet::addCircleMarkers
#'
#' @family clusterCharts
#' @details
#' The `clusterCharts` use Leaflet's `L.DivIcon`, allowing you to fully customize
#' the styling of individual markers and clusters using CSS. Each individual marker
#' within a cluster is assigned the CSS class `clustermarker`, while the entire
#' cluster is assigned the class `clustermarker-cluster`. You can modify the appearance
#' of these elements by targeting these classes in your custom CSS.
#' @export
#' @examples
#' # Example usage:
#' library(sf)
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
#'                    , label = "brewery")
#'
#' ## Custom Pie Chart with "mean" aggregation on column "value"
#' data <- sf::st_as_sf(breweries91)
#' categories <- c("Schwer", "Mäßig", "Leicht", "kein Schaden")
#' data$category <- sample(categories, size = nrow(data), replace = TRUE)
#' data$value <- round(runif(nrow(data), 0, 100), 0)
#'
#' leaflet() %>%
#'   addProviderTiles("CartoDB.Positron") %>%
#'   leaflet::addLayersControl(overlayGroups = "clustermarkers") %>%
#'   addClusterCharts(data = data
#'                    , type = "custom"
#'                    , valueField = "value"
#'                    , aggregation = "mean"
#'                    , categoryField = "category"
#'                    , categoryMap = data.frame(labels = categories,
#'                                               colors  = c("#F88", "#FA0", "#FF3", "#BFB"),
#'                                               strokes = "gray")
#'                    , options = clusterchartOptions(rmax=50, digits=0, innerRadius = 20)
#'                    , group = "clustermarkers"
#'                    , popupFields = c("brewery", "address", "zipcode", "category","value")
#'                    , popupLabels = c("Brauerei", "Adresse", "PLZ", "Art", "Value")
#'                    , label = "brewery"
#'   )
#'
#' ## For Shiny examples, please run:
#' # runApp(system.file("examples/clusterCharts_app.R", package = "leaflet.extras2"))
#' # runApp(system.file("examples/clustercharts_sum.R", package = "leaflet.extras2"))
addClusterCharts <- function(
    map, lng = NULL, lat = NULL, layerId = NULL, group = NULL,
    type = c("pie","bar","horizontal","custom"),
    aggregation = c("sum","min","max","mean","median"),
    valueField = NULL,
    options = clusterchartOptions(),
    icon = NULL, html = NULL,
    popup = NULL, popupOptions = NULL, label = NULL, labelOptions = NULL,
    clusterOptions = NULL, clusterId = NULL,
    categoryField, categoryMap, popupFields = NULL, popupLabels = NULL,
    markerOptions = NULL, legendOptions = list(title = "",
                                               position = "topright"),
    data = getMapData(map)) {

  ## Check arguments ############
  type <- match.arg(type)
  aggregation <- match.arg(aggregation)
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
  options$aggregation = aggregation
  options$valueField = valueField

  ## CSS string #############
  css <- paste(apply(categoryMap, 1, generate_css, icon), collapse = "\n")
  size <- options$size
  if (length(size) == 1) size <- rep(size, 2)
  css <- paste0(css, "\n.clustermarker {",
                "width: ",size[1],"px; height: ",size[2],"px;",
                "margin-top: -",size[2]/2,"px; margin-left: -",size[1]/2,"px;",
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
  if (!inherits(data, "sf")) {
    data <- sf::st_as_sf(data)
  }
  geojson <- yyjsonr::write_geojson_str(data)
  class(geojson) <- c("geojson","json")

  ## Derive Points and Invoke Method ##################
  points <- derivePoints(data, lng, lat, missing(lng), missing(lat),
                         "addClusterCharts")
  leaflet::invokeMethod(
    map, NULL, "addClusterCharts", geojson, layerId, group, type,
    options, icon, html,
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
#' @param strokeWidth The stroke width of the chart.
#' @param width The width of the bar-charts.
#' @param height The height of the bar-charts.
#' @param innerRadius The inner radius of pie-charts.
#' @param labelBackground Should the label have a background? Default is `FALSE`
#' @param labelFill The label background color. Default is `white`
#' @param labelStroke The label stroke color. Default is `black`
#' @param labelColor The label color. Default is `black`
#' @param labelOpacity The label color. Default is `0.9`
#' @param digits The amount of digits. Default is `2`
#' @param sortTitlebyCount Should the svg-title be sorted by count or by the categories.
#'
#' @family clusterCharts
#' @export
clusterchartOptions <- function(rmax = 30, size = c(20, 20),
                                width = 40, height = 50,
                                strokeWidth = 1,
                                innerRadius = 10,
                                labelBackground = FALSE,
                                labelFill = "white",
                                labelStroke = "black",
                                labelColor = "black",
                                labelOpacity = 0.9,
                                digits = 2,
                                sortTitlebyCount = TRUE) {
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
    , digits = digits
    , sortTitlebyCount = sortTitlebyCount
  ))
}

generate_css <- function(row, icon) {
  ## Get/Check Inputs ############
  label <- row["labels"]
  color <- row["colors"]
  stroke <- row["strokes"]
  if (is.null(stroke) || is.na(stroke)) stroke <- color

  ## Replace spaces with dots in the class name #######
  label_nospaces <- gsub(" ", ".", label, fixed = TRUE)

  ## Make Custom CSS-class with fill/stroke/background ################
  class_name <- paste0("category-", label_nospaces)
  css <- paste0(
    ".", class_name, " {\n",
    "  fill: ", color, ";\n",
    "  stroke: ", stroke, ";\n",
    "  background: ", color, ";\n",
    "  border-color: ", stroke, ";\n",
    "}\n"
  )

  ## Make Icon ################
  if (is.null(icon)) {
    icon <- row['icons']
    if (!is.null(icon) && !is.na(icon)) {
      css <- paste0(css,
                    ".icon-", label_nospaces, " {\n",
                    "  background-image: url('", icon, "');\n",
                    "  background-repeat: no-repeat;\n",
                    "  background-position: 0px 1px;\n",
                    "}"
                    )
      # css <- backgroundCSS(label_nospaces, icon,
      #                       additional_css = list(
      #                         c("background-blend-mode", "color-burn"),
      #                         c("opacity", "0.8"),
      #                         c("border-radius", "5px")
      #                       ))
    }
  } else {
    if (inherits(icon, "leaflet_icon_set")) {
      icon <- icon[[label]]
    }
    iconuse <- b64EncodePackedIcons(packStrings(icon$iconUrl))
    size = ""
    names_icon <- names(icon)
    if ("iconWidth" %in% names_icon) {
      if ("iconHeight" %in% names_icon) {
        size <- paste0("background-size: ", icon$iconWidth, "px ", icon$iconHeight, "px;\n")
      } else {
        size <- paste0("background-size: ", icon$iconWidth, "px ", icon$iconWidth, "px;\n")
      }
    }
    css <- paste0(css,
                  ".icon-", label_nospaces, " {\n",
                  "  background-image: url('", iconuse$data, "');\n",
                  "  background-repeat: no-repeat;\n",
                  "  background-position: 0px 1px;\n",
                  size,
                  "}"
    )
  }
  css
}

iconSetToIcons <- utils::getFromNamespace("iconSetToIcons", "leaflet")
b64EncodePackedIcons <- utils::getFromNamespace("b64EncodePackedIcons", "leaflet")
packStrings <- utils::getFromNamespace("packStrings", "leaflet")


# backgroundCSS <- function(label, icon,
#                           background_repeat = "no-repeat",
#                           background_position = "0px 1px",
#                           additional_css = list()) {
#   # Start the CSS string
#   css <- paste0(".icon-", label, " {\n",
#                 "  background-image: url('", icon, "');\n",
#                 "  background-repeat: ", background_repeat, ";\n",
#                 "  background-position: ", background_position, ";\n")
#
#   # Add each additional CSS property
#   for (css_property in additional_css) {
#     css <- paste0(css, "  ", css_property[1], ": ", css_property[2], ";\n")
#   }
#
#   # Close the CSS block
#   css <- paste0(css, "}")
#
#   return(css)
# }



