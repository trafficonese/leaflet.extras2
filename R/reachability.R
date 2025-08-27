reachabilityDependencies <- function() {
  list(
    htmlDependency(
      "lfx-reachability", "1.0.0",
      src = system.file("htmlwidgets/lfx-reachability", package = "leaflet.extras2"),
      script = c(
        "leaflet.reachability.js",
        "leaflet.reachability-bindings.js"
      ),
      stylesheet = "leaflet.reachability.css"
    )
  )
}

#' Add Isochrones to Leaflet
#'
#' A leaflet plugin which shows areas of reachability based on time or distance
#' for different modes of travel using the openrouteservice isochrones API.
#' Based on the
#' \href{https://github.com/traffordDataLab/leaflet.reachability}{leaflet.reachability
#' plugin}
#' @param map a map widget
#' @param apikey a valid Openrouteservice API-key. Can be obtained from
#'   \href{https://openrouteservice.org/dev/#/signup}{Openrouteservice}
#' @param options A list of further options. See \code{\link{reachabilityOptions}}
#' @note When used in Shiny, 3 events update a certain shiny Input:
#' \enumerate{
#'   \item reachability:displayed updates \code{input$MAPID_reachability_displayed}
#'   \item reachability:delete updates \code{input$MAPID_reachability_delete}
#'   \item reachability:error updates \code{input$MAPID_reachability_error}
#' }
#' @family Reachability Functions
#' @references \url{https://github.com/traffordDataLab/leaflet.reachability}
#' @inherit leaflet::addControl return
#' @export
#' @examples \dontrun{
#' library(leaflet)
#' library(leaflet.extras2)
#'
#' Sys.setenv("OPRS" = "Your_API_Key")
#'
#' leaflet() %>%
#'   addTiles() %>%
#'   setView(8, 50, 10) %>%
#'   addReachability()
#' }
addReachability <- function(map, apikey = NULL,
                            options = reachabilityOptions()) {
  if (is.null(apikey)) {
    apikey <- Sys.getenv("OPRS")
    if (apikey == "") {
      stop(
        "You must either pass an Openrouteservice-`apikey` directly or save it as ",
        "system variable under `OPRS`."
      )
    }
  }

  deps <- unique(htmltools::findDependencies(options))
  options <- lapply(options, function(x) {
    if (inherits(x, "shiny.tag")) as.character(x) else x
  })
  map$dependencies <- c(map$dependencies, reachabilityDependencies(), deps)
  options <- leaflet::filterNULL(c(apiKey = apikey, options))
  invokeMethod(map, NULL, "addReachability", options)
}

#' reachabilityOptions
#'
#' Add extra options. For a full list please visit the
#' \href{https://github.com/traffordDataLab/leaflet.reachability}{plugin repository}.
#' @param collapsed Should the control widget start in a collapsed mode.
#'   Default is \code{TRUE}
#' @param pane Leaflet pane to add the isolines GeoJSON to.
#'   Default is \code{overlayPane}
#' @param position Leaflet control pane position. Default is \code{topleft}
#' @param ... Further arguments passed to `L.Control.Reachability`
#' @family Reachability Functions
#' @references \url{https://github.com/traffordDataLab/leaflet.reachability}
#' @return A list of options for \code{addReachability}
#' @export
reachabilityOptions <- function(collapsed = TRUE,
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
#'
#' Remove the reachability controls.
#' @param map the map widget.
#' @inherit leaflet::addControl return
#' @export
#' @family Reachability Functions
removeReachability <- function(map) {
  invokeMethod(map, NULL, "removeReachability")
}
