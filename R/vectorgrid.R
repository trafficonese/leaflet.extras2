vectorgridDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-vectorgrid", version = "1.0.0",
      src = system.file("htmlwidgets/lfx-vectorgrid", package = "leaflet.extras2"),
      script = c("Leaflet.VectorGrid.bundled.js",
                 "Leaflet.VectorGrid-bindings.js")
    )
  )
}

#' Add a Vectorgrid
#'
#' A Leaflet plugin for working with Web Map services, providing:
#' @inheritParams leaflet::addGeoJSON
#' @inherit leaflet::addGeoJSON return
#' @references \url{https://github.com/Leaflet/Leaflet.VectorGrid}
#' @family Vectorgrid Functions
#' @export
addVectorgrid <- function(map, data, layerId = NULL, group = NULL, label = NULL,
                          stroke = TRUE,
                          color = "#03F", weight = 5, opacity = 0.5, fill = TRUE,
                          fillColor = color, fillOpacity = 0.2, dashArray = NULL,
                          smoothFactor = 1, noClip = FALSE, options = pathOptions()) {

  options <- c(options, filterNULL(list(stroke = stroke, color = color,
                                        weight = weight, opacity = opacity, fill = fill,
                                        fillColor = fillColor,
                                        fillOpacity = fillOpacity,
                                        dashArray = dashArray, smoothFactor = smoothFactor,
                                        noClip = noClip)))

  # browser()
  if (inherits(data, "sf")) {
    bbox <- sf::st_bbox(data)
    data$vg_label <- evalFormula(label, data)
    data$vg_layerId <- evalFormula(layerId, data)
    geojson <- geojsonsf::sf_geojson(data)
  } else {
    bbox <- c(-90,-180,90,180)
    geojson <- data
  }


  map$dependencies <- c(map$dependencies, vectorgridDependency())
  invokeMethod(map, data, "addVectorgrid", geojson, group, options, layerId) %>%
    expandLimits(lat = c(bbox[[1]], bbox[[3]]), lng = c(bbox[[2]], bbox[[4]]))
}

#' Remove a Vectorgrid by layerId
#' @inheritParams leaflet::removeGeoJSON
#' @inherit leaflet::removeGeoJSON return
#' @family Vectorgrid Functions
#' @export
removeVectorgrid <- function(map, layerId) {
  invokeMethod(map, getMapData(map), "removeVectorgrid",
               layerId)
}

#' Clear all Vectorgrids
#' @inheritParams leaflet::clearGeoJSON
#' @inherit leaflet::removeGeoJSON return
#' @family Vectorgrid Functions
#' @export
clearVectorgrid <- function(map) {
  invokeMethod(map, NULL, "clearVectorgrid")
}





#' Add Vector Tiles through Protobuf
#'
#' A Leaflet plugin for working with Web Map services, providing:
#' @inheritParams leaflet::addTiles
#' @param key a valid API key
#' @param interactive Should the layer fire mouse/pointer events. Default is TRUE
#' @param popup TODO
#' @param styling TODO
#' @inherit leaflet::addTiles return
#' @references \url{https://github.com/Leaflet/Leaflet.VectorGrid}
#' @family Vectorgrid Functions
#' @export
addProtobuf <- function(map,
                        urlTemplate = "//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        key = NULL, attribution = NULL,
                        layerId = NULL, group = NULL,
                        interactive = TRUE,
                        options = leaflet::tileOptions(),
                        popup = NULL,
                        styling = vectorStyling(),
                        data = getMapData(map)) {

  options$attribution <- attribution
  options$interactive <- interactive
  options$key <- key
  options$popup <- popup
  map$dependencies <- c(map$dependencies, vectorgridDependency())
  invokeMethod(map, data, "addProtobuf", urlTemplate, layerId, group, options, styling)
}


#' vectorStyling
#'
#' Styling template for Mapbox/Nextzen/Maptiler and any OSM based vector ziles
#' @references \url{https://github.com/Leaflet/Leaflet.VectorGrid}
#' @family Vectorgrid Functions
#' @return a list width different styles
#' @export
vectorStyling <- function() {
  list(
    water = list(
      fill= TRUE,
      weight= 1,
      fillColor= '#06cccc',
      color= '#06cccc',
      fillOpacity= 0.2,
      opacity= 0.4)
    ,
    admin= list(
      weight= 1,
      fillColor= 'pink',
      color= 'pink',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    waterway= list(
      weight= 1,
      fillColor= '#2375e0',
      color= '#2375e0',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    landcover= list(
      fill= TRUE,
      weight= 1,
      fillColor= '#53e033',
      color= '#53e033',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    landuse= list(
      fill= TRUE,
      weight= 1,
      fillColor= '#e5b404',
      color= '#e5b404',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    park= list(
      fill= TRUE,
      weight= 1,
      fillColor= '#84ea5b',
      color= '#84ea5b',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    boundary= list(
      weight= 1,
      fillColor= '#c545d3',
      color= '#c545d3',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    boundaries= list(
      weight= 1,
      fillColor= '#c545d3',
      color= '#c545d3',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    aeroway= list(
      weight= 1,
      fillColor= '#51aeb5',
      color= '#51aeb5',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    ## mapbox & nextzen only
    road= list(
      weight= 1,
      fillColor= '#f2b648',
      color= '#f2b648',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    roads= list(
      weight= 1,
      fillColor= '#f2b648',
      color= '#f2b648',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    ## mapbox only
    tunnel= list(
      weight= 0.5,
      fillColor= '#f2b648',
      color= '#f2b648',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    ## mapbox only
    bridge= list(
      weight= 0.5,
      fillColor= '#f2b648',
      color= '#f2b648',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    ## openmaptiles only
    transportation= list(
      weight= 0.5,
      fillColor= '#f2b648',
      color= '#f2b648',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    ## nextzen only
    transit= list(
      weight= 0.5,
      fillColor= '#f2b648',
      color= '#f2b648',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    building= list(
      fill= TRUE,
      weight= 1,
      fillColor= '#2b2b2b',
      color= '#2b2b2b',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    buildings= list(
      fill= TRUE,
      weight= 1,
      fillColor= '#2b2b2b',
      color= '#2b2b2b',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    water_name= list(
      weight= 1,
      fillColor= '#022c5b',
      color= '#022c5b',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    transportation_name= list(
      weight= 1,
      fillColor= '#bc6b38',
      color= '#bc6b38',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    place= list(
      weight= 1,
      fillColor= '#f20e93',
      color= '#f20e93',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    places= list(
      weight= 1,
      fillColor= '#f20e93',
      color= '#f20e93',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    housenumber= list(
      weight= 1,
      fillColor= '#ef4c8b',
      color= '#ef4c8b',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    poi= list(
      weight= 1,
      fillColor= '#3bb50a',
      color= '#3bb50a',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    pois= list(
      weight= 1,
      fillColor= '#3bb50a',
      color= '#3bb50a',
      fillOpacity= 0.2,
      opacity= 0.4
    ),
    earth= list(
      fill= TRUE,
      weight= 1,
      fillColor= '#c0c0c0',
      color= '#c0c0c0',
      fillOpacity= 0.2,
      opacity= 0.4
    )
  )
}
