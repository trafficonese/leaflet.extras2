mapkeyIconDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-mapkeyicon", version = "1.0.0",
      src = system.file("htmlwidgets/lfx-mapkeyicon", package = "leaflet.extras2"),
      script = c("L.Icon.Mapkey.js",
                 "lfx-mapkeyicon-bindings.js"),
      stylesheet = c("L.Icon.Mapkey.css"),
      all_files = TRUE
    )
  )
}

#' Make Mapkey-icon set
#' @param ... icons created from \code{\link{makeMapkeyIcon}()}
#' @family Mapkey Functions
#' @references \url{https://github.com/mapshakers/leaflet-mapkey-icon}
#' @export
#' @return A list of class \code{"leaflet_mapkey_icon_set"}
#' @examples
#' iconSet = mapkeyIconList(
#'   red = makeMapkeyIcon(color = "#ff0000"),
#'   blue = makeMapkeyIcon(color = "#0000ff")
#' )
#' iconSet[c("red", "blue")]
mapkeyIconList = function(...) {
  res = structure(
    list(...),
    class = "leaflet_mapkey_icon_set"
  )
  cls = unlist(lapply(res, inherits, "leaflet_mapkey_icon"))
  if (any(!cls))
    stop("Arguments passed to mapkeyIconList() must be icon objects returned from makeMapkeyIcon()")
  res
}

#' leaflet_mapkey_icon_set
#' @param x icons
#' @param i offset
#' @export
#' @family Mapkey Functions
`[.leaflet_mapkey_icon_set` = function(x, i) {
  if (is.factor(i)) {
    i = as.character(i)
  }
  if (!is.character(i) && !is.numeric(i) && !is.integer(i)) {
    stop("Invalid subscript type '", typeof(i), "'")
  }
  structure(.subset(x, i), class = "leaflet_mapkey_icon_set")
}

mapkeyIconSetToMapkeyIcons = function(x) {
  cols = names(formals(makeMapkeyIcon))
  cols = structure(as.list(cols), names = cols)

  # Construct an equivalent output to mapkeyIcons().
  leaflet::filterNULL(lapply(cols, function(col) {
    # Pluck the `col` member off of each item in mapkeyIconObjs and put them in an
    # unnamed list (or vector if possible).
    colVals = unname(sapply(x, `[[`, col))

    # If this is the common case where there"s lots of values but they"re all
    # actually the same exact thing, then just return one value; this will be
    # much cheaper to send to the client, and we'll do recycling on the client
    # side anyway.
    if (length(unique(colVals)) == 1) {
      return(colVals[[1]])
    } else {
      return(colVals)
    }
  }))
}

#' Make Mapkey Icon
#' @inheritParams mapkeyIcons
#' @export
#' @family Mapkey Functions
#' @references \url{https://github.com/mapshakers/leaflet-mapkey-icon}
#' @return A list of mapkey-icon data that can be passed to the argument \code{icon}
#' @examples
#' makeMapkeyIcon(icon = "traffic_signal",
#'                color = "#0000ff",
#'                iconSize = 12,
#'                boxShadow = FALSE,
#'                background="transparent")
makeMapkeyIcon <- function(
  icon = 'mapkey',
  color = "#ff0000",
  iconSize = 12,
  background = '#1F7499',
  borderRadius = '100%',
  hoverScale = 1.4,
  hoverEffect = TRUE,
  additionalCSS = NULL,
  hoverCSS = NULL,
  htmlCode = NULL,
  boxShadow = TRUE
) {
  icon = leaflet::filterNULL(list(
    icon = icon,
    color = color,
    size = iconSize,
    background = background,
    borderRadius = borderRadius,
    hoverScale = hoverScale,
    hoverEffect = hoverEffect,
    additionalCSS = additionalCSS,
    hoverCSS = hoverCSS,
    htmlCode = htmlCode,
    boxShadow = boxShadow
  ))
  structure(icon, class = "leaflet_mapkey_icon")
}

#' Create a list of Mapkey icon data
#'
#' An icon can be represented as a list of the form \code{list(color, iconSize,
#' ...)}. This function is vectorized over its arguments to create a list of
#' icon data. Shorter argument values will be re-cycled. \code{NULL} values for
#' these arguments will be ignored.
#' @param icon ID of the mapkey Icon you want to use.
#' @param color Any CSS color (e.g. 'red','rgba(20,160,90,0.5)', '#686868', ...)
#' @param iconSize Size of Icon in Pixels. Default is 12
#' @param background Any CSS color or false for no background
#' @param borderRadius Any number (for circle size/2, for square 0.001)
#' @param hoverScale Any real number (best result in range 1 - 2, use 1 for no
#'   effect)
#' @param hoverEffect Switch on/off effect on hover
#' @param hoverCSS CSS code (e.g. \code{"background-color:#992b00 !important;
#'   color:#99defc !important;"})
#' @param additionalCSS CSS code (e.g. \code{"border:4px solid #aa3838;"})
#' @param htmlCode e.g. \code{'&#57347;&#xe003;'}.
#' @param boxShadow Should a shadow be visible
#' @export
#' @family Mapkey Functions
#' @references \url{https://github.com/mapshakers/leaflet-mapkey-icon}
#' @return A list of mapkey-icon data that can be passed to the argument \code{icon}
#' @examples
#' library(leaflet)
#' leaflet()  %>%
#'   addMapkeyMarkers(data = breweries91,
#'                    icon = mapkeyIcons(
#'                      color = "red",
#'                      borderRadius = 0,
#'                      iconSize = 25))
mapkeyIcons <- function(
  icon = 'mapkey',
  color = "#ff0000",
  iconSize = 12,
  background = '#1F7499',
  borderRadius = '100%',
  hoverScale = 1.4,
  hoverEffect = TRUE,
  hoverCSS = NULL,
  additionalCSS = NULL,
  htmlCode = NULL,
  boxShadow = TRUE
) {
  leaflet::filterNULL(list(
    icon = icon,
    color = color,
    size = iconSize,
    background = background,
    borderRadius = borderRadius,
    hoverScale = hoverScale,
    hoverEffect = hoverEffect,
    hoverCSS = hoverCSS,
    additionalCSS = additionalCSS,
    htmlCode = htmlCode,
    boxShadow = boxShadow
  ))
}

#' Add Mapkey Markers
#' @param map the map to add mapkey Markers to.
#' @inheritParams leaflet::addAwesomeMarkers
#' @param options a list of extra options for markers. See
#'   \code{\link[leaflet]{markerOptions}}
#' @family Mapkey Functions
#' @references \url{https://github.com/mapshakers/leaflet-mapkey-icon}
#' @inherit leaflet::addMarkers return
#' @export
#' @examples
#' library(leaflet)
#'
#' leaflet()  %>%
#'   addTiles() %>%
#'   addMapkeyMarkers(data = breweries91,
#'                 icon = makeMapkeyIcon(icon = "mapkey",
#'                                       iconSize = 30,
#'                                       boxShadow = FALSE,
#'                                       background = "transparent"),
#'                 group = "mapkey",
#'                 label = ~state, popup = ~village)
addMapkeyMarkers = function(
  map, lng = NULL, lat = NULL, layerId = NULL, group = NULL,
  icon = NULL,
  popup = NULL,
  popupOptions = NULL,
  label = NULL,
  labelOptions = NULL,
  options = leaflet::markerOptions(),
  clusterOptions = NULL,
  clusterId = NULL,
  data = leaflet::getMapData(map)
) {
  map$dependencies <- c(map$dependencies,
                        mapkeyIconDependency())

  if (!is.null(icon)) {
    # If formulas are present, they must be evaluated first so we can pack the
    # resulting values
    icon = leaflet::evalFormula(list(icon), data)[[1]]

    if (inherits(icon, "leaflet_mapkey_icon_set")) {
      icon = mapkeyIconSetToMapkeyIcons(icon)
    }
    icon = leaflet::filterNULL(icon)
  }

  if (!is.null(clusterOptions))
    map$dependencies = c(map$dependencies, leaflet::leafletDependencies$markerCluster())

  pts = leaflet::derivePoints(
    data, lng, lat, missing(lng), missing(lat), "addMapkeyMarkers")
  leaflet::invokeMethod(
    map, data, "addMapkeyMarkers", pts$lat, pts$lng, icon, layerId,
    group, options, popup, popupOptions,
    clusterOptions, clusterId, leaflet::safeLabel(label, data), labelOptions
  ) %>%
    expandLimits(pts$lat, pts$lng)
}
