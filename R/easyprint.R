easyprintDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-easyprint", version = "1.0.0",
      src = system.file("htmlwidgets/lfx-easyprint",
                        package = "leaflet.extras2"),
      script = c(
        "dom-to-image.js",
        "FileSaver.js",
        # "lfx-easyprint.js",
        "lfx-easyprint_full.js",
        "lfx-easyprint-bindings.js")
    )
  )
}

#' Add easyPrint Plugin
#'
#' Add a control, which allows to print or export a map as .PNG.
#' @param map a map widget object created from \code{\link[leaflet]{leaflet}}
#' @param options A named list of options. See \code{\link{easyprintOptions}}
#' @family EasyPrint Functions
#' @references \url{https://github.com/rowanwins/leaflet-easyPrint}
#' @export
#' @return A leaflet map object
#' @examples
#' library(leaflet)
#' leaflet()  %>%
#'   addTiles() %>%
#'   addEasyprint(options = easyprintOptions(
#'     title = 'Print map',
#'     position = 'bottomleft',
#'     exportOnly = TRUE))
addEasyprint <- function(map, options = easyprintOptions()) {
  map$dependencies <- c(map$dependencies, easyprintDependency())
  leaflet::invokeMethod(map, NULL, "addEasyprint", options)
}

#' easyprintMap
#'
#' Print or export a map programmatically (e.g. in a Shiny environment).
#' @param map the map widget
#' @param sizeModes Must match one of the given \code{sizeMode} names in
#'   \code{\link{easyprintOptions}}. The options are:
#'   \code{CurrentSize}, \code{A4Portrait} or \code{A4Landscape}. If you want to
#'   print the map with a \code{Custom} sizeMode you need to pass the Custom className.
#'   Default is \code{A4Portrait}
#' @param filename Name of the file if \code{exportOnly} option is \code{TRUE}.
#' @param dpi Integer value indicating the dpi for the resulting image.
#'   Default is \code{96}
#' @family EasyPrint Functions
#' @inherit addEasyprint return
#' @export
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#' library(shiny)
#' library(leaflet)
#' library(leaflet.extras2)
#'
#' ui <- fluidPage(
#'   leafletOutput("map"),
#'   selectInput("scene", "Select Scene", choices = c("CurrentSize", "A4Landscape", "A4Portrait")),
#'   actionButton("print", "Print Map")
#' )
#'
#' server <- function(input, output, session) {
#'   output$map <- renderLeaflet({
#'     input$print
#'     leaflet()  %>%
#'       addTiles() %>%
#'       setView(10, 50, 9) %>%
#'       addEasyprint(options = easyprintOptions(
#'         exportOnly = TRUE
#'       ))
#' })
#'   observeEvent(input$print, {
#'     leafletProxy("map") %>%
#'       easyprintMap(sizeModes = input$scene)
#' })
#' }
#'
#' shinyApp(ui, server)
#' }
easyprintMap <- function(map, sizeModes = "A4Portrait", filename = "map", dpi=96) {
  leaflet::invokeMethod(map, NULL, "easyprintMap", sizeModes, filename, dpi)
}

#' removeEasyprint
#'
#' Removes the easyprint control from the map.
#' @param map the map widget
#' @family EasyPrint Functions
#' @inherit addEasyprint return
#' @export
removeEasyprint <- function(map) {
  leaflet::invokeMethod(map, NULL, "removeEasyprint")
}

#' easyprintOptions
#'
#' Create a list of further options for the easyprint plugin.
#' @param title Sets the text which appears as the tooltip of the print/export button
#' @param position Positions the print button
#' @param sizeModes Either a character vector with one of the following options:
#'   \code{CurrentSize}, \code{A4Portrait}, \code{A4Landscape}. If you want to
#'   include a \code{Custom} size mode you need to pass a named list, with
#'   \code{width}, \code{height}, \code{name} and \code{className} and assign a
#'   background-image in CSS.
#'   See the example in \code{./inst/examples/easyprint_app.R}.
#' @param defaultSizeTitles Button tooltips for the default page sizes
#' @param exportOnly 	If set to \code{TRUE} the map is exported to a .png file
#' @param tileLayer The group name of one tile layer that you can wait for to draw
#'   (helpful when resizing)
#' @param tileWait How long to wait for the tiles to draw (helpful when resizing)
#' @param filename Name of the file if \code{exportOnly} option is \code{TRUE}
#' @param hidden Set to \code{TRUE} if you don't want to display the toolbar.
#'   Instead you can create your own buttons or fire print events programmatically.
#' @param hideControlContainer Hides the leaflet controls like the zoom buttons
#'   and the attribution on the print out
#' @param hideClasses Use a character vector or list of CSS-classes to hide on
#'   the output image.
#' @param customWindowTitle A title for the print window which will get
#'   added to the printed paper
#' @param spinnerBgColor A valid css colour for the spinner background color
#' @param customSpinnerClass A class for a custom css spinner to use while
#'   waiting for the print.
#' @param dpi Integer value indicating the dpi for the resulting image.
#'   Default is \code{96}
#' @family EasyPrint Functions
#' @return A list of options for the 'easyprint' control
#' @references \url{https://github.com/rowanwins/leaflet-easyPrint}
#' @export
easyprintOptions <- function(title = 'Print map',
                             position = 'topleft',
                             sizeModes = list("A4Portrait", "A4Landscape", "CurrentSize"),
                             defaultSizeTitles = NULL,
                             exportOnly = FALSE,
                             tileLayer = NULL,
                             tileWait = 500,
                             filename = 'map',
                             hidden = FALSE,
                             hideControlContainer = TRUE,
                             hideClasses = NULL,
                             customWindowTitle = NULL,
                             spinnerBgColor = '#0DC5C1',
                             customSpinnerClass = 'epLoader',
                             dpi = 96) {
  if (inherits(sizeModes, "character")) sizeModes <- as.list(sizeModes)
  if (inherits(hideClasses, "character")) hideClasses <- as.list(hideClasses)
  if (length(sizeModes) == 0 || (is.null(sizeModes) || all(is.na(sizeModes)) || all(sizeModes == ""))) {
    stop("The 'sizeModes' argument cannot be empty.\nUse one of the following ",
         "options: 'A4Portrait', 'A4Landscape', 'CurrentSize' or define a 'Custom' sizeMode.")
  }
  leaflet::filterNULL(list(
    title = title,
    position = position,
    sizeModes = sizeModes,
    defaultSizeTitles = defaultSizeTitles,
    exportOnly = exportOnly,
    tileLayer = tileLayer,
    tileWait = tileWait,
    filename = filename,
    hidden = hidden,
    hideControlContainer = hideControlContainer,
    hideClasses = hideClasses,
    customWindowTitle = customWindowTitle,
    spinnerBgColor = spinnerBgColor,
    customSpinnerClass = customSpinnerClass,
    dpi = dpi
  ))
}
