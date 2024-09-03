diviconDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-divicon",
      version = "1.0.0",
      src = system.file("htmlwidgets/lfx-divicon", package = "leaflet.extras2"),
      script = "lfx-divicon-bindings.js",
      all_files = TRUE
    )
  )
}

#' Add DivIcon Markers to a Leaflet Map
#'
#' Adds customizable DivIcon markers to a Leaflet map. The function can accept either spatial
#' data (lines or points) in the form of a Simple Feature (sf) object or numeric vectors
#' for latitude and longitude coordinates. It allows for the application of custom HTML
#' content and CSS classes to each marker, providing high flexibility in marker design.
#'
#' @inheritParams leaflet::addAwesomeMarkers
#' @param className A single CSS class or a vector of CSS classes.
#' @param html A single HTML string or a vector of HTML strings.
#' @param divOptions A list of extra options for Leaflet DivIcon.
#'
#' @family DivIcon Functions
#' @return The modified Leaflet map object.
#' @export
#' @examples
#' library(sf)
#' library(leaflet)
#' library(leaflet.extras2)
#'
#' # Sample data
#' df <- sf::st_as_sf(atlStorms2005)
#' df <- suppressWarnings(st_cast(df, "POINT"))
#' df <- df[sample(1:nrow(df), 50, replace = FALSE), ]
#' df$classes <- sample(x = c("myclass1", "myclass2", "myclass3"), nrow(df), replace = TRUE)
#' df$ID <- paste0("ID_", 1:nrow(df))
#'
#' leaflet() %>%
#'   addTiles() %>%
#'   addDivicon(
#'     data = df,
#'     html = ~ paste0(
#'       '<div class="custom-html">',
#'       '<div class="title">', Name, "</div>",
#'       '<div class="subtitle">MaxWind: ', MaxWind, "</div>",
#'       "</div>"
#'     ),
#'     label = ~Name,
#'     layerId = ~ID,
#'     group = "Divicons",
#'     popup = ~ paste(
#'       "ID: ", ID, "<br>",
#'       "Name: ", Name, "<br>",
#'       "MaxWind:", MaxWind, "<br>",
#'       "MinPress:", MinPress
#'     ),
#'     options = markerOptions(draggable = TRUE)
#'   )
addDivicon <- function(map, lng = NULL, lat = NULL, layerId = NULL, group = NULL,
                       popup = NULL, popupOptions = NULL, label = NULL,
                       labelOptions = NULL,
                       className = NULL, html = NULL,
                       options = markerOptions(), clusterOptions = NULL,
                       clusterId = NULL, divOptions = list(), data = getMapData(map)) {
  if (missing(labelOptions)) {
    labelOptions <- labelOptions()
  }
  map$dependencies <- c(
    map$dependencies,
    diviconDependency()
  )
  if (!is.null(clusterOptions)) {
    map$dependencies <- c(map$dependencies, leafletDependencies$markerCluster())
  }

  pts <- derivePoints(
    data, lng, lat, missing(lng), missing(lat),
    "addDivicon"
  )
  invokeMethod(
    map, data, "addDivicon", pts$lat, pts$lng,
    layerId, group, options,
    className, html,
    popup, popupOptions,
    label, labelOptions,
    clusterId, clusterOptions,
    divOptions,
    getCrosstalkOptions(data)
  ) %>%
    expandLimits(pts$lat, pts$lng)
}


getCrosstalkOptions <- utils::getFromNamespace("getCrosstalkOptions", "leaflet")
