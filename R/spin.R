spinDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-spin",
      version = "1.0.2",
      src = system.file("htmlwidgets/lfx-spin", package = "leaflet.extras2"),
      script = c(
        "spin.min.js",
        "leaflet.spin.min.js",
        "leaflet.spin-binding.js"
      ),
      all_files = TRUE
    )
  )
}

#' Add Spin Plugin
#'
#' Adds an animated loading spinning over the map.
#' @param map A map widget object created from \code{\link[leaflet]{leaflet}}
#'
#' @param options Spin.js options. Named list. See \url{http://spin.js.org}
#'
#' @return A leaflet map object
#' @family Spinner Functions
#' @export
#'
#' @references \url{https://github.com/makinacorpus/Leaflet.Spin}
#' @references \url{https://github.com/fgnass/spin.js}
#'
#' @section Shiny:
#' \code{startSpinner()} and \code{stopSpinner()} in the same
#' \code{\link[leaflet]{leaflet}} or \code{\link[leaflet]{leafletProxy}}
#' chain are sent to the browser together. Use
#' \code{\link{spinWhile}} (or start the spinner, then run the work after
#' \code{session$onFlushed}).
#'
#' @name addSpinner
#'
#' @examples
#' library(leaflet)
#'
#' leaflet(data = quakes) %>%
#'   addTiles() %>%
#'   addSpinner() %>%
#'   startSpinner(options = list("lines" = 7, "length" = 20)) %>%
#'   addMarkers(~long, ~lat, popup = ~ as.character(mag), label = ~ as.character(mag)) %>%
#'   stopSpinner()
#'
#' \dontrun{
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(
#'     actionButton("go", "Load markers"),
#'     leafletOutput("leaf")
#'   ),
#'   server = function(input, output, session) {
#'     output$leaf <- renderLeaflet({
#'       leaflet() %>%
#'         addTiles() %>%
#'         addSpinner()
#'     })
#'     observeEvent(input$go, {
#'       spinWhile("leaf",
#'         {
#'           Sys.sleep(2)
#'           leafletProxy("leaf") %>%
#'             addMarkers(data = quakes, ~long, ~lat)
#'         },
#'         options = list(lines = 7, length = 20)
#'       )
#'     })
#'   }
#' )
#' }
addSpinner <- function(map) {
  map$dependencies <- c(map$dependencies, spinDependency())
  map
}

#' @export
#'
#' @rdname addSpinner
startSpinner <- function(map, options = NULL) {
  invokeMethod(map, NULL, "spinner", TRUE, options)
}

#' @export
#'
#' @rdname addSpinner
stopSpinner <- function(map) {
  invokeMethod(map, NULL, "spinner", FALSE)
}

#' Run work while a map spinner is visible (Shiny)
#'
#' Starts the spinner, waits until the browser has painted it (and Shiny
#' has flushed that update), then evaluates \code{expr} and always stops
#' the spinner.
#'
#' @param mapId The \code{outputId} of the \code{leafletOutput}.
#' @param expr Expression to evaluate after the spinner is shown.
#' @param options Passed to \code{\link{startSpinner}}.
#' @param session The Shiny session; default is the current domain.
#' @return The Shiny session (invisible).
#' @family Spinner Functions
#' @export
#' @examples
#' \dontrun{
#' observeEvent(input$go, {
#'   spinWhile("leaf", {
#'     Sys.sleep(2)
#'     leafletProxy("leaf") %>% addMarkers(data = quakes, ~long, ~lat)
#'   })
#' })
#' }
spinWhile <- function(mapId, expr, options = NULL,
                      session = shiny::getDefaultReactiveDomain()) {
  if (!requireNamespace("shiny", quietly = TRUE)) {
    stop("spinWhile() requires the shiny package.")
  }
  if (is.null(session)) {
    stop("spinWhile() must be called from a Shiny session.")
  }
  expr <- substitute(expr)
  parent <- parent.frame()
  shiny::observeEvent(
    session$input[[paste0(mapId, "_spinner_shown")]],
    {
      tryCatch(
        eval(expr, envir = parent),
        finally = stopSpinner(leaflet::leafletProxy(mapId, session))
      )
    },
    once = TRUE,
    ignoreInit = TRUE,
    domain = session
  )
  startSpinner(leaflet::leafletProxy(mapId, session), options)
  invisible(session)
}
