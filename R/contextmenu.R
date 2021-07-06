contextmenuDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-contextmenu", version = "1.0.0",
      src = system.file("htmlwidgets/lfx-contextmenu", package = "leaflet.extras2"),
      script = c("leaflet.contextmenu.js",
                 "leaflet.contextmenu-bindings.js"),
      stylesheet = "leaflet.contextmenu.css"
    )
  )
}

#' Add contextmenu Plugin
#'
#' Add a contextmenu to the map or markers/vector layers.
#' @param map a map widget object created from \code{\link[leaflet]{leaflet}}
#' @family Contextmenu Functions
#' @references \url{https://github.com/aratcliffe/Leaflet.contextmenu}
#' @export
#' @return A leaflet map object
#'
#' @details
#' This function is only used to include the required JavaScript and CSS
#' bindings and to set up some Shiny event handlers.
#'
#' \subsection{Contextmenu initialization}{
#' The contextmenu for
#' \itemize{
#'  \item {the \strong{map} must be defined in \code{\link[leaflet]{leafletOptions}}.}
#'  \item {the \strong{markers/vector layers} must be defined in \code{\link[leaflet]{markerOptions}}
#'         or \code{\link[leaflet]{pathOptions}}.}
#' }
#' }
#'
#' \subsection{Contextmenu selection}{
#' When a contextmenu is selected, a Shiny input with the ID \code{"MAPID_contextmenu_select"}
#' is set (`MAPID` refers to the map's id).
#'
#' If the selected contextmenu item is triggered from:
#' \itemize{
#'   \item {the \strong{map}, the returned list containts the \code{text} of the item.}
#'   \item {the \strong{markers}, the returned list also contains the
#'          \code{layerId}, \code{group}, \code{lat}, \code{lng} and \code{label}.}
#'   \item {the \strong{vector layers}, the returned list also contains the
#'          \code{layerId}, \code{group} and \code{label}.}
#' }
#' }
#'
#' @examples
#' library(leaflet)
#' leaflet(options = leafletOptions(
#'     contextmenu = TRUE,
#'     contextmenuWidth = 200,
#'     contextmenuItems =
#'      mapmenuItems(
#'        menuItem("Zoom Out", "function(e) {this.zoomOut()}", disabled=FALSE),
#'        "-",
#'        menuItem("Zoom In", "function(e) {this.zoomIn()}")))) %>%
#'   addTiles(group = "base") %>%
#'   addContextmenu() %>%
#'   addMarkers(data = breweries91, label = ~brewery,
#'           layerId = ~founded, group = "marker",
#'           options = markerOptions(
#'             contextmenu = TRUE,
#'             contextmenuWidth = 200,
#'             contextmenuItems =
#'               markermenuItems(
#'                 menuItem(text = "Show Marker Coords",
#'                          callback = "function(e) {alert(e.latlng);}",
#'                          index = 1)
#'               )
#'           ))
#'
addContextmenu <- function(map) {
  map$dependencies <- c(map$dependencies, contextmenuDependency())
  leaflet::invokeMethod(map, NULL, "addContextmenu")
}

#' showContextmenu
#'
#' Open the contextmenu at certain lat/lng-coordinates
#' @family Contextmenu Functions
#' @inheritParams leaflet::addMarkers
#' @return A leaflet map object
#' @export
showContextmenu <- function(map, lat=NULL, lng=NULL, data=leaflet::getMapData(map)) {
  pts <- leaflet::derivePoints(data, lng, lat, missing(lng), missing(lat), "showContextmenu")
  leaflet::invokeMethod(map, NULL, "showContextmenu", pts)
}

#' hideContextmenu
#'
#' Hide the contextmenu
#' @family Contextmenu Functions
#' @inheritParams addContextmenu
#' @return A leaflet map object
#' @export
hideContextmenu <- function(map) {
  leaflet::invokeMethod(map, NULL, "hideContextmenu")
}

#' addItemContextmenu
#'
#' Add a new contextmenu menu item
#' @family Contextmenu Functions
#' @inheritParams addContextmenu
#' @param option new menu item to add
#' @return A leaflet map object
#' @export
addItemContextmenu <- function(map, option) {
  if (utils::packageVersion("leaflet") < "2.0.4") {
    warning("The `addItemContextmenu` function requires leaflet `2.0.4` to correctly register callbacks.")
  }
  leaflet::invokeMethod(map, NULL, "addItemContextmenu", option)
}
# remotes::install_github("rstudio/leaflet#696")

#' insertItemContextmenu
#'
#' Insert a new contextmenu menu item at a specific index
#' @family Contextmenu Functions
#' @inheritParams addItemContextmenu
#' @inheritParams removeItemContextmenu
#' @return A leaflet map object
#' @export
insertItemContextmenu <- function(map, option, index) {
  if (utils::packageVersion("leaflet") < "2.0.4") {
    warning("The `insertItemContextmenu` function requires leaflet `2.0.4` to correctly register callbacks.")
  }
  leaflet::invokeMethod(map, NULL, "insertItemContextmenu", option, index)
}
# remotes::install_github("rstudio/leaflet#696")

#' removeItemContextmenu
#'
#' Remove a contextmenu item by index.
#' @family Contextmenu Functions
#' @inheritParams addContextmenu
#' @param index Index of the contextmenu. (NOTE: Since the index is passed to JavaScript,
#' it is zero-based)
#' @return A leaflet map object
#' @export
removeItemContextmenu <- function(map, index) {
  leaflet::invokeMethod(map, NULL, "removeItemContextmenu", index)
}

#' setDisabledContextmenu
#'
#' Enable/Disable a contextmenu item by index.
#' @family Contextmenu Functions
#' @inheritParams removeItemContextmenu
#' @param disabled Set to \code{TRUE} to disable the element and \code{FALSE}
#'   to enable it. Default is \code{TRUE}
#' @return A leaflet map object
#' @export
setDisabledContextmenu <- function(map, index, disabled=TRUE) {
  leaflet::invokeMethod(map, NULL, "setDisabledContextmenu", index, disabled)
}

#' removeallItemsContextmenu
#'
#' Remove all contextmenu items from the map.
#' @family Contextmenu Functions
#' @inheritParams removeItemContextmenu
#' @return A leaflet map object
#' @export
removeallItemsContextmenu <- function(map) {
  leaflet::invokeMethod(map, NULL, "removeallItemsContextmenu")
}



#' context_menuItem
#' @param text The label to use for the menu item
#' @param callback A callback function to be invoked when the menu item is
#' clicked. The callback is passed an object with properties identifying the
#' location the menu was opened at: \code{latlng}, \code{layerPoint} and \code{containerPoint}.
#' The callback-function must be valid JavaScript and will be wrapped in
#' \code{\link[leaflet]{JS}}.
#' @param ... For further options please visit \url{https://github.com/aratcliffe/Leaflet.contextmenu}
#' @family Contextmenu Functions
#' @return A contextmenu item list
#' @export
context_menuItem <- function(text, callback=NULL, ...) {
  list(text=text,
       callback=leaflet::JS(callback),
       ...)
}

#' mapmenuItems
#' @param ... contextmenu item/s
#' @family Contextmenu Functions
#' @return A list of \code{context_menuItem} for the map
#' @export
context_mapmenuItems <- function(...) {
  list(...)
}

#' markermenuItems
#' @param ... contextmenu item/s
#' @family Contextmenu Functions
#' @return A list of \code{context_menuItem} for markers
#' @export
context_markermenuItems <- function(...) {
  list(list(...))
}


## Deprecated ###########
#' menuItem
#' @param text The label to use for the menu item
#' @param callback A callback function to be invoked when the menu item is
#' clicked. The callback is passed an object with properties identifying the
#' location the menu was opened at: \code{latlng}, \code{layerPoint} and \code{containerPoint}.
#' The callback-function must be valid JavaScript and will be wrapped in
#' \code{\link[leaflet]{JS}}.
#' @param ... For further options please visit \url{https://github.com/aratcliffe/Leaflet.contextmenu}
#' @family Contextmenu Functions
#' @return A contextmenu item list
#' @export
menuItem <- function(text, callback=NULL, ...) {
  .Deprecated("context_menuItem")
  list(text=text,
       callback=leaflet::JS(callback),
       ...)
}

#' mapmenuItems
#' @param ... contextmenu item/s
#' @family Contextmenu Functions
#' @return A list of \code{menuItem} for the map
#' @export
mapmenuItems <- function(...) {
  .Deprecated("context_mapmenuItems")
  list(...)
}

#' markermenuItems
#' @param ... contextmenu item/s
#' @family Contextmenu Functions
#' @return A list of \code{menuItem} for markers
#' @export
markermenuItems <- function(...) {
  .Deprecated("context_markermenuItems")
  list(list(...))
}
