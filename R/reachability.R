reachabilityDependencies <- function() {
  list(
    htmlDependency(
      "leaflet.reachability", "1.0.0",
      src = system.file("htmlwidgets/lfx-reachability", package = "leaflet.extras2"),
      script = c("leaflet.reachability.js",
                 "leaflet.reachability.bindings.js"),
      stylesheet = "leaflet.reachability.css"
    )
  )
}

#' Add Isochrones to Leaflet
#'
#' @param map a map widget
#' @param apikey a valid Openrouteservice API-key. Can be obtained from
#'   \href{https://openrouteservice.org/dev/#/signup}{Openrouteservice}
#' @param options see \code{\link{reachabilityOptions}}
#' @description Add Leaflet Reachability Plugin Control. Based on the
#'  \href{https://github.com/traffordDataLab/leaflet.reachability}{leaflet.reachability plugin}
#' @note When used in Shiny, 3 events update a certain shiny Input:
#' \enumerate{
#'   \item reachability:displayed updates \code{input$MAPID_reachability_displayed}
#'   \item reachability:delete updates \code{input$MAPID_reachability_delete}
#'   \item reachability:error updates \code{input$MAPID_reachability_error}
#' }
#' @family Reachability Functions
#' @seealso \url{https://github.com/traffordDataLab/leaflet.reachability}
#' @export
#' @examples \dontrun{
#' library(leaflet)
#' library(leaflet.extras2)
#'
#' Sys.setenv("OPRS" = 'Your_API_Key')
#'
#' leaflet() %>%
#'   addTiles() %>%
#'   setView(8, 50, 10) %>%
#'   addReachability()
#' }
addReachability <- function(map, apikey = NULL,
                            options = reachabilityOptions()){
  if (is.null(apikey)) {
    apikey <- Sys.getenv("OPRS")
    if (apikey == "") {
      stop("You must either pass an Openrouteservice-`apikey` directly or save it as ",
           "system variable under `OPRS`.")
    }
  }
  map$dependencies <- c(map$dependencies, reachabilityDependencies())
  options = leaflet::filterNULL(c(apiKey = apikey, options))
  invokeMethod(map, NULL, "addReachability", options)
}

#' reachabilityOptions
#'
#' @param collapsed Should the control widget start in a collapsed mode.
#'   Default is \code{TRUE}
#' @param pane Leaflet pane to add the isolines GeoJSON to.
#'   Default is \code{overlayPane}
#' @param position Leaflet control pane position. Default is \code{topleft}
#' @param ... Further arguments passed to `L.Control.Reachability`
#' @description Add extra options. For a full list please visit the
#' \href{https://github.com/traffordDataLab/leaflet.reachability}{plugin repository}
#' @family Reachability Functions
#' @seealso \url{https://github.com/traffordDataLab/leaflet.reachability}
#' @export
reachabilityOptions = function(collapsed = TRUE,
                               pane = "overlayPane",
                               position = "topleft",
                               ...) {
  filterNULL(list(
    collapsed = collapsed,
    pane = pane,
    position = position,
    ...
  ))
}

#' removeReachability
#' @param map the map widget.
#' @description Remove the reachability controls
#' @export
#' @family Reachability Functions
removeReachability <- function(map){
  invokeMethod(map, NULL, "removeReachability")
}
