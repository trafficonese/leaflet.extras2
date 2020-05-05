heightgraphDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-heightgraph", version = "2.1.0",
      src = system.file("htmlwidgets/lfx-heightgraph", package = "leaflet.extras2"),
      script = c(
        "d3.js",
        "L.Control.Heightgraph.js",
        "L.Control.Heightgraph-bindings.js"),
      stylesheet = "L.Control.Heightgraph.css"
    )
  )
}

#' Add a Heightgraph layer
#'
#' The data must be a Simple Feature LINESTRING Z and is transformed to GeoJSON.
#' The function therefore inherits arguments from
#' \code{\link[leaflet]{addGeoJSON}}.
#'
#' @inheritParams leaflet::addGeoJSON
#' @param data A Simple Feature LINESTRING with Z dimension.
#' @param columns the columns you want to include in the heightgraph control.
#' @param pathOpts List of further options for the path. See
#'   \code{\link[leaflet]{pathOptions}}
#' @param options List of further plugin options. See
#'   \code{\link{heightgraphOptions}}
#'
#' @note When used in Shiny, 3 events update a certain shiny Input:
#' \enumerate{
#'   \item A click updates \code{input$MAPID_heightgraph_click}
#'   \item A mouseover updates \code{input$MAPID_heightgraph_mouseover}
#'   \item A mouseout updates \code{input$MAPID_heightgraph_mouseout}
#' }
#' If you want to explicitly remove the Heightgraph control, please use
#' \code{\link[leaflet]{removeControl}} with the \code{layerId = "hg_control"}.
#' @seealso \url{https://github.com/GIScience/Leaflet.Heightgraph}
#' @family Heightgraph Functions
#' @export
#' @examples \dontrun{
#' library(leaflet)
#' library(leaflet.extras2)
#' library(sf)
#'
#'data <- st_cast(st_as_sf(leaflet::atlStorms2005[4,]), "LINESTRING")
#'data <- st_transform(data, 4326)
#'data <- data.frame(st_coordinates(data))
#'data$elev <-  runif(nrow(data), 10, 500)
#'data$L1 <- NULL
#'L1 <- round(seq.int(1, 4, length.out = nrow(data)))
#'data <- st_as_sf(st_sfc(lapply(split(data, L1), sfg_linestring)))
#'data$steepness <- 1:nrow(data)
#'data$suitability <- nrow(data):1
#'data$popup <- apply(data, 1, function(x) {
#'  sprintf("Steepness: %s<br>Suitability: %s", x$steepness, x$suitability)
#'})
#'
#'leaflet() %>%
#'  addTiles(group = "base") %>%
#'  addHeightgraph(color = "red", columns = c("steepness", "suitability"),
#'                 opacity = 1, data = data, group = "heightgraph",
#'                 options = heightgraphOptions(width = 400))
#' }
addHeightgraph <- function(
  map, data = NULL, columns = NULL, layerId = NULL, group = NULL,
  color = "#03F", weight = 5, opacity = 0.5,
  dashArray = NULL, smoothFactor = 1, noClip = FALSE,
  pathOpts = leaflet::pathOptions(),
  options = heightgraphOptions()) {

  if (!requireNamespace("geojsonsf")) {
    stop("The package `geojsonsf` is needed for this plugin. ",
         "Please install it with:\ninstall.packages('geojsonsf')")
  }

  ## TODO - Use all columns if NULL ??
  if (is.null(columns)) stop("No `columns` given.")

  # if (inherits(data, "Spatial")) data <- sf::st_as_sf(data)
  stopifnot(inherits(sf::st_geometry(data), "sfc_LINESTRING"))
  stopifnot(!is.null(sf::st_z_range(data)))
  bounds <- as.numeric(sf::st_bbox(data))

  ## Create Property List
  props <- lapply(columns, function(x) {data[[x]]})
  names(props) <- columns

  ## Change columnnames to `attributeType` and transform to Geojson
  data <- lapply(columns, function(x) {
    names(data)[names(data) == x] <- 'attributeType'
    geojsonsf::sf_geojson(data)
  })

  # Check if Properties and Data have same length
  stopifnot(length(props) == length(data))

  geojson_opts <- c(pathOpts, filterNULL(
    list(color = color,
         weight = weight, opacity = opacity,
         dashArray = dashArray, smoothFactor = smoothFactor,
         noClip = noClip)))

  map$dependencies <- c(map$dependencies, heightgraphDependency())

  invokeMethod(map, data, "addHeightgraph", data, props, layerId,
               group, geojson_opts, options) %>%
    expandLimits(bounds[c(2,4)], bounds[c(1,3)])
}

#' heightgraphOptions
#' @param position position of control: "topleft", "topright", "bottomleft", or
#'   "bottomright". Default is \code{bottomright}.
#' @param width The width of the expanded heightgraph display in pixels. Default
#'   is \code{800}.
#' @param height The height of the expanded heightgraph display in pixels.
#'   Default is \code{200}.
#' @param margins The margins define the distance between the border of the
#'   heightgraph and the actual graph inside. You are able to specify margins
#'   for top, right, bottom and left in pixels. Default is \code{list(top = 10,
#'   right = 30, bottom = 55, left = 50)}.
#' @param expand Boolean value that defines if the heightgraph should be
#'   expanded on creation. Default is \code{200}.
#' @param expandCallback Function to be called if the heightgraph is expanded or
#'   reduced. The state of the heightgraph is passed as an argument. It is
#'   \code{TRUE} when expanded and \code{FALSE} when reduced. Default is
#'   \code{NULL}.
#' @param mappings You may add a mappings object to customize the colors and
#'   labels in the height graph. Without adding custom mappings the segments and
#'   labels within the graph will be displayed in random colors. Each key of the
#'   object must correspond to the \code{summary} key in \code{properties}
#'   within the \code{FeatureCollection}. Default is \code{NULL}.
#' @param highlightStyle You can customize the highlight style when using the
#'   horizontal line to find parts of the route above an elevation value. Use
#'   any Leaflet Path options as value of the highlightStyle parameter. Default
#'   is \code{list(color = "red")}.
#' @param translation You can change the labels of the heightgraph info field by
#'   passing translations for \code{distance}, \code{elevation},
#'   \code{segment_length}, \code{type} and \code{legend}. Default is
#'   \code{NULL}.
#' @param xTicks Specify the tick frequency in the x axis of the graph.
#'   Corresponds approximately to 2 to the power of value ticks. Default is
#'   \code{3}.
#' @param yTicks Specify the tick frequency in the y axis of the graph.
#'   Corresponds approximately to 2 to the power of value ticks. Default is
#'   \code{3}.
#' @family Heightgraph Functions
#' @export
heightgraphOptions = function(
  position = c("bottomright", "topleft", "topright", "bottomleft"),
  width = 800,
  height = 200,
  margins = list(top = 10, right = 30, bottom = 55, left = 50),
  expand = TRUE,
  expandCallback = NULL,
  mappings = NULL,
  highlightStyle = list(color = "red"),
  translation = NULL,
  xTicks = 3,
  yTicks = 3
) {
  position <- match.arg(position)
  filterNULL(list(
    position = position,
    width = width,
    height = height,
    margins = margins,
    expand = expand,
    expandCallback = expandCallback,
    mappings = mappings,
    highlightStyle = highlightStyle,
    translation = translation,
    xTicks = xTicks,
    yTicks = yTicks
  ))
}
