vectorgridDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-vectorgrid",
      version = "1.3.6",
      src = system.file("htmlwidgets/lfx-vectorgrid", package = "leaflet.extras2"),
      script = c(
        "Leaflet.VectorGrid.min.js",
        "Leaflet.VectorGrid-bindings.js"
      )
    )
  )
}

vectorgrid_as_sf <- function(data) {
  if (inherits(data, "Spatial")) {
    if (!requireNamespace("sf", quietly = TRUE)) {
      stop(
        "The package `sf` is needed to convert Spatial data. ",
        "Please install it with:\ninstall.packages('sf')"
      )
    }
    data <- sf::st_as_sf(data)
  }
  data
}

vectorgrid_geojson <- function(data) {
  if (!requireNamespace("yyjsonr", quietly = TRUE)) {
    stop(
      "The package `yyjsonr` is needed for addVectorgrid(). ",
      "Please install it with:\ninstall.packages('yyjsonr')"
    )
  }
  geojson <- yyjsonr::write_geojson_str(data)
  class(geojson) <- c("geojson", "json")
  geojson
}

#' Add sliced GeoJSON / TopoJSON as a VectorGrid
#'
#' Displays large polygon/line datasets as tiled vector features using
#' \href{https://github.com/Leaflet/Leaflet.VectorGrid}{Leaflet.VectorGrid}
#' (\code{L.vectorGrid.slicer}). This is more efficient than
#' \code{\link[leaflet]{addPolygons}} for big GeoJSON.
#'
#' In Shiny a click updates \code{input$MAPID_vectorgrid_click} with
#' \code{id}, \code{group}, \code{lat}, \code{lng} and \code{properties}.
#'
#' @inheritParams leaflet::addPolygons
#' @param data An \code{sf} / \code{Spatial} object, a GeoJSON object, or a
#'   URL returning GeoJSON / TopoJSON.
#' @param featureId Formula or vector of unique feature ids (used for highlight
#'   and the Shiny click \code{id}). A formula passed as \code{layerId} is
#'   treated as \code{featureId}.
#' @param popup Formula, column name or character vector with HTML for the
#'   click popup.
#' @param interactive Whether the layer fires mouse events. Default \code{TRUE}.
#' @family Vectorgrid Functions
#' @references \url{https://github.com/Leaflet/Leaflet.VectorGrid}
#' @inherit leaflet::addPolygons return
#' @export
#' @examples
#' \dontrun{
#' library(leaflet)
#' library(sf)
#'
#' nc <- st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#' leaflet() %>%
#'   addTiles() %>%
#'   addVectorgrid(
#'     data = nc,
#'     layerId = "nc",
#'     featureId = ~NAME,
#'     popup = ~NAME,
#'     color = "black",
#'     fillColor = "#4daf4a",
#'     weight = 1
#'   )
#' }
addVectorgrid <- function(map, data, layerId = NULL, group = NULL,
                          featureId = NULL, popup = NULL,
                          stroke = TRUE, color = "#03F", weight = 5,
                          opacity = 0.5, fill = TRUE, fillColor = color,
                          fillOpacity = 0.2, dashArray = NULL,
                          options = pathOptions(),
                          interactive = TRUE) {
  if (inherits(layerId, "formula")) {
    if (is.null(featureId)) {
      featureId <- layerId
    }
    layerId <- NULL
  }

  bbox <- NULL
  popup_prop <- if (is.character(popup) && length(popup) == 1) popup else NULL
  if (is.character(data) && length(data) == 1) {
    geojson <- data
    options <- c(options, filterNULL(list(
      stroke = stroke, color = color, weight = weight, opacity = opacity,
      fill = fill, fillColor = fillColor, fillOpacity = fillOpacity,
      dashArray = dashArray, interactive = interactive
    )))
  } else if (inherits(data, "geojson") || inherits(data, "json")) {
    geojson <- data
    options <- c(options, filterNULL(list(
      stroke = stroke, color = color, weight = weight, opacity = opacity,
      fill = fill, fillColor = fillColor, fillOpacity = fillOpacity,
      dashArray = dashArray, interactive = interactive
    )))
  } else {
    data <- vectorgrid_as_sf(data)
    if (!inherits(data, "sf")) {
      stop("`data` must be an sf/Spatial object, GeoJSON, or a URL.")
    }
    if (!requireNamespace("sf", quietly = TRUE)) {
      stop(
        "The package `sf` is needed for addVectorgrid(). ",
        "Please install it with:\ninstall.packages('sf')"
      )
    }
    n <- nrow(data)
    data$stroke <- leaflet::evalFormula(stroke, data)
    data$color <- leaflet::evalFormula(color, data)
    data$weight <- leaflet::evalFormula(weight, data)
    data$opacity <- leaflet::evalFormula(opacity, data)
    data$fill <- leaflet::evalFormula(fill, data)
    data$fillColor <- leaflet::evalFormula(fillColor, data)
    data$fillOpacity <- leaflet::evalFormula(fillOpacity, data)
    data$dashArray <- leaflet::evalFormula(dashArray, data)
    if (!is.null(popup) && !isFALSE(popup)) {
      data$vg_popup <- leaflet::evalFormula(popup, data)
    }
    if (!is.null(featureId)) {
      data$vg_id <- as.character(leaflet::evalFormula(featureId, data))
    } else {
      data$vg_id <- as.character(seq_len(n))
    }
    options <- c(options, filterNULL(list(
      stroke = data$stroke[[1]],
      color = data$color[[1]],
      weight = data$weight[[1]],
      opacity = data$opacity[[1]],
      fill = data$fill[[1]],
      fillColor = data$fillColor[[1]],
      fillOpacity = data$fillOpacity[[1]],
      dashArray = data$dashArray[[1]],
      interactive = interactive
    )))
    bbox <- as.numeric(sf::st_bbox(data))
    geojson <- vectorgrid_geojson(data)
  }

  map$dependencies <- c(map$dependencies, vectorgridDependency())
  out <- invokeMethod(
    map, NULL, "addVectorgrid", geojson, layerId, group, options, popup_prop
  )
  if (!is.null(bbox) && length(bbox) == 4 && !anyNA(bbox)) {
    out <- expandLimits(out, bbox[c(2, 4)], bbox[c(1, 3)])
  }
  out
}

#' Add protobuf vector tiles
#'
#' Loads remote Mapbox Vector Tiles (\code{.pbf} / \code{.mvt}) with
#' \code{L.vectorGrid.protobuf}. Style each vector-tile layer by name via
#' \code{\link{vectorStyling}} (OpenMapTiles / Mapbox / Nextzen names).
#'
#' In Shiny a click updates \code{input$MAPID_vectorgrid_pbf_click}.
#'
#' @inheritParams leaflet::addTiles
#' @param urlTemplate Tile URL with \code{\{z\}}, \code{\{x\}}, \code{\{y\}}.
#'   Use \code{\{key\}} together with \code{key} for API tokens.
#' @param key Optional API key substituted into \code{\{key\}} in the URL.
#' @param interactive Whether the layer fires mouse events. Default \code{TRUE}.
#' @param popup Name of a feature property shown in a popup on click.
#' @param label Name of a feature property shown as a tooltip on hover.
#' @param styling Named list of path styles, one per vector-tile layer name.
#'   See \code{\link{vectorStyling}}.
#' @family Vectorgrid Functions
#' @references \url{https://github.com/Leaflet/Leaflet.VectorGrid}
#' @inherit leaflet::addTiles return
#' @export
#' @examples
#' \dontrun{
#' leaflet() %>%
#'   addTiles() %>%
#'   addProtobuf(
#'     urlTemplate = "https://vector.openstreetmap.org/shortbread_v1/{z}/{x}/{y}.mvt",
#'     layerId = "osm",
#'     attribution = "OpenStreetMap"
#'   )
#' }
addProtobuf <- function(map,
                        urlTemplate,
                        attribution = NULL,
                        layerId = NULL,
                        group = NULL,
                        key = NULL,
                        interactive = TRUE,
                        options = leaflet::tileOptions(),
                        popup = NULL,
                        label = NULL,
                        styling = vectorStyling(),
                        data = getMapData(map)) {
  if (missing(urlTemplate) || !nzchar(urlTemplate)) {
    stop("`urlTemplate` is required (a .pbf / .mvt tile URL).")
  }
  options$attribution <- attribution
  options$interactive <- interactive
  options$key <- key
  options$popup <- popup
  options$label <- label
  map$dependencies <- c(map$dependencies, vectorgridDependency())
  invokeMethod(
    map, data, "addProtobuf", urlTemplate, layerId, group, options, styling
  )
}

#' Remove a VectorGrid layer
#' @inheritParams leaflet::removeTiles
#' @family Vectorgrid Functions
#' @inherit leaflet::removeTiles return
#' @export
removeVectorgrid <- function(map, layerId) {
  invokeMethod(map, NULL, "removeVectorgrid", layerId)
}

#' Clear all VectorGrid layers
#' @inheritParams leaflet::clearTiles
#' @family Vectorgrid Functions
#' @inherit leaflet::clearTiles return
#' @export
clearVectorgrid <- function(map) {
  invokeMethod(map, NULL, "clearVectorgrid")
}

#' Default styles for OSM-based vector tiles
#'
#' Layer-name styles for Mapbox, Nextzen, MapTiler / OpenMapTiles and similar
#' protobuf tiles. Override individual entries before passing to
#' \code{\link{addProtobuf}}.
#'
#' @return A named list of path options.
#' @family Vectorgrid Functions
#' @references \url{https://github.com/Leaflet/Leaflet.VectorGrid}
#' @export
vectorStyling <- function() {
  list(
    water = list(
      fill = TRUE, weight = 1, fillColor = "#06cccc", color = "#06cccc",
      fillOpacity = 0.2, opacity = 0.4
    ),
    admin = list(
      weight = 1, fillColor = "pink", color = "pink",
      fillOpacity = 0.2, opacity = 0.4
    ),
    waterway = list(
      weight = 1, fillColor = "#2375e0", color = "#2375e0",
      fillOpacity = 0.2, opacity = 0.4
    ),
    landcover = list(
      fill = TRUE, weight = 1, fillColor = "#53e033", color = "#53e033",
      fillOpacity = 0.2, opacity = 0.4
    ),
    landuse = list(
      fill = TRUE, weight = 1, fillColor = "#e5b404", color = "#e5b404",
      fillOpacity = 0.2, opacity = 0.4
    ),
    park = list(
      fill = TRUE, weight = 1, fillColor = "#84ea5b", color = "#84ea5b",
      fillOpacity = 0.2, opacity = 0.4
    ),
    boundary = list(
      weight = 1, fillColor = "#c545d3", color = "#c545d3",
      fillOpacity = 0.2, opacity = 0.4
    ),
    boundaries = list(
      weight = 1, fillColor = "#c545d3", color = "#c545d3",
      fillOpacity = 0.2, opacity = 0.4
    ),
    aeroway = list(
      weight = 1, fillColor = "#51aeb5", color = "#51aeb5",
      fillOpacity = 0.2, opacity = 0.4
    ),
    road = list(
      weight = 1, fillColor = "#f2b648", color = "#f2b648",
      fillOpacity = 0.2, opacity = 0.4
    ),
    roads = list(
      weight = 1, fillColor = "#f2b648", color = "#f2b648",
      fillOpacity = 0.2, opacity = 0.4
    ),
    tunnel = list(
      weight = 0.5, fillColor = "#f2b648", color = "#f2b648",
      fillOpacity = 0.2, opacity = 0.4
    ),
    bridge = list(
      weight = 0.5, fillColor = "#f2b648", color = "#f2b648",
      fillOpacity = 0.2, opacity = 0.4
    ),
    transportation = list(
      weight = 0.5, fillColor = "#f2b648", color = "#f2b648",
      fillOpacity = 0.2, opacity = 0.4
    ),
    transit = list(
      weight = 0.5, fillColor = "#f2b648", color = "#f2b648",
      fillOpacity = 0.2, opacity = 0.4
    ),
    building = list(
      fill = TRUE, weight = 1, fillColor = "#2b2b2b", color = "#2b2b2b",
      fillOpacity = 0.2, opacity = 0.4
    ),
    buildings = list(
      fill = TRUE, weight = 1, fillColor = "#2b2b2b", color = "#2b2b2b",
      fillOpacity = 0.2, opacity = 0.4
    ),
    water_name = list(
      weight = 1, fillColor = "#022c5b", color = "#022c5b",
      fillOpacity = 0.2, opacity = 0.4
    ),
    transportation_name = list(
      weight = 1, fillColor = "#bc6b38", color = "#bc6b38",
      fillOpacity = 0.2, opacity = 0.4
    ),
    place = list(
      weight = 1, fillColor = "#f20e93", color = "#f20e93",
      fillOpacity = 0.2, opacity = 0.4
    ),
    places = list(
      weight = 1, fillColor = "#f20e93", color = "#f20e93",
      fillOpacity = 0.2, opacity = 0.4
    ),
    housenumber = list(
      weight = 1, fillColor = "#ef4c8b", color = "#ef4c8b",
      fillOpacity = 0.2, opacity = 0.4
    ),
    poi = list(
      weight = 1, fillColor = "#3bb50a", color = "#3bb50a",
      fillOpacity = 0.2, opacity = 0.4
    ),
    pois = list(
      weight = 1, fillColor = "#3bb50a", color = "#3bb50a",
      fillOpacity = 0.2, opacity = 0.4
    ),
    earth = list(
      fill = TRUE, weight = 1, fillColor = "#c0c0c0", color = "#c0c0c0",
      fillOpacity = 0.2, opacity = 0.4
    ),
    land = list(
      fill = TRUE, weight = 1, fillColor = "#c0c0c0", color = "#c0c0c0",
      fillOpacity = 0.2, opacity = 0.4
    ),
    ocean = list(
      fill = TRUE, weight = 1, fillColor = "#06cccc", color = "#06cccc",
      fillOpacity = 0.25, opacity = 0.4
    ),
    water_polygons = list(
      fill = TRUE, weight = 1, fillColor = "#06cccc", color = "#06cccc",
      fillOpacity = 0.35, opacity = 0.5
    ),
    water_lines = list(
      weight = 1.5, fillColor = "#2375e0", color = "#2375e0",
      fillOpacity = 0.2, opacity = 0.8
    ),
    streets = list(
      weight = 1.5, fillColor = "#f2b648", color = "#f2b648",
      fillOpacity = 0.2, opacity = 0.9
    ),
    bridges = list(
      weight = 1.5, fillColor = "#f2b648", color = "#f2b648",
      fillOpacity = 0.2, opacity = 0.9
    ),
    railways = list(
      weight = 1, fillColor = "#888888", color = "#888888",
      fillOpacity = 0.2, opacity = 0.7
    ),
    street_labels = list(),
    street_labels_points = list(),
    water_lines_labels = list(),
    water_polygons_labels = list(),
    place_labels = list()
  )
}
