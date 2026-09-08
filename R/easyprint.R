easyprintDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-easyprint",
      version = "1.0.0",
      src = system.file("htmlwidgets/lfx-easyprint",
        package = "leaflet.extras2"
      ),
      script = c(
        "dom-to-image.js",
        "FileSaver.js",
        # "lfx-easyprint.js",
        "lfx-easyprint_full.js",
        "lfx-easyprint-bindings.js"
      )
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
#' leaflet() %>%
#'   addTiles() %>%
#'   addEasyprint(options = easyprintOptions(
#'     title = "Print map",
#'     position = "bottomleft",
#'     exportOnly = TRUE
#'   ))
#'
#' ## Custom pixel size (e.g. high-res PNG in a Quarto/HTML document):
#' leaflet() %>%
#'   addTiles() %>%
#'   addEasyprint(options = easyprintOptions(
#'     title = "Save map to PNG",
#'     exportOnly = TRUE,
#'     filename = "map",
#'     tileWait = 1000,
#'     sizeModes = list(
#'       "CurrentSize",
#'       list(scale = 3, name = "3x current view")
#'     )
#'   ))
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
#' @family EasyPrint Functions
#' @inherit addEasyprint return
#' @export
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'   library(shiny)
#'   library(leaflet)
#'   library(leaflet.extras2)
#'
#'   ui <- fluidPage(
#'     leafletOutput("map"),
#'     selectInput("scene", "Select Scene", choices = c("CurrentSize", "A4Landscape", "A4Portrait")),
#'     actionButton("print", "Print Map")
#'   )
#'
#'   server <- function(input, output, session) {
#'     output$map <- renderLeaflet({
#'       input$print
#'       leaflet() %>%
#'         addTiles() %>%
#'         setView(10, 50, 9) %>%
#'         addEasyprint(options = easyprintOptions(
#'           exportOnly = TRUE
#'         ))
#'     })
#'     observeEvent(input$print, {
#'       leafletProxy("map") %>%
#'         easyprintMap(sizeModes = input$scene)
#'     })
#'   }
#'
#'   shinyApp(ui, server)
#' }
easyprintMap <- function(map, sizeModes = "A4Portrait", filename = "map") {
  leaflet::invokeMethod(map, NULL, "easyprintMap", sizeModes, filename)
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
#'   \code{CurrentSize}, \code{A4Portrait}, \code{A4Landscape}. Custom pixel
#'   sizes can be mixed in as lists with \code{width} and \code{height} (and
#'   optionally \code{name} / \code{className}):
#'   \code{list("CurrentSize", list(width = 3000, height = 1800, name = "High res"))}.
#'   \code{CurrentSize} exports at the current map widget size (often low
#'   resolution in Quarto/HTML documents). A custom size resizes the map before
#'   export. By default \code{keepView = TRUE}: the current view is kept (zoom
#'   in, same aspect ratio; the PNG may be smaller than \code{width}/\code{height}
#'   on one side). Use \code{keepView = FALSE} to keep the zoom level and show a
#'   larger area, like A4. \code{list(scale = 3, name = "3x current view")}
#'   multiplies the current widget size and keeps the exact view.
#'   A custom \code{className} and CSS background-image are optional;
#'   see \code{./inst/examples/easyprint.R} and
#'   \code{./inst/examples/easyprint_app.R}.
#' @param defaultSizeTitles Button tooltips for the default page sizes
#' @param exportOnly 	If set to \code{TRUE} the map is exported to a .png file
#' @param tileLayer The group name of one tile layer that you can wait for to draw
#'   (helpful when resizing to a custom size)
#' @param tileWait How long to wait for the tiles to draw (helpful when resizing).
#'   Custom sizes always wait at least this long so tiles can reload.
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
#' @family EasyPrint Functions
#' @return A list of options for the 'easyprint' control
#' @references \url{https://github.com/rowanwins/leaflet-easyPrint}
#' @export
easyprintOptions <- function(title = "Print map",
                             position = "topleft",
                             sizeModes = list("A4Portrait", "A4Landscape", "CurrentSize"),
                             defaultSizeTitles = NULL,
                             exportOnly = FALSE,
                             tileLayer = NULL,
                             tileWait = 500,
                             filename = "map",
                             hidden = FALSE,
                             hideControlContainer = TRUE,
                             hideClasses = NULL,
                             customWindowTitle = NULL,
                             spinnerBgColor = "#0DC5C1",
                             customSpinnerClass = "epLoader") {
  if (inherits(hideClasses, "character")) hideClasses <- as.list(hideClasses)
  sizeModes <- unname(normalize_size_modes(sizeModes))
  if (length(sizeModes) == 0) {
    stop(
      "The 'sizeModes' argument cannot be empty.\nUse one of the following ",
      "options: 'A4Portrait', 'A4Landscape', 'CurrentSize' or define a 'Custom' sizeMode."
    )
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
    customSpinnerClass = customSpinnerClass
  ))
}

is_custom_size_mode <- function(mode) {
  is.list(mode) && (
    (!is.null(mode$width) && !is.null(mode$height)) || !is.null(mode$scale)
  )
}

normalize_size_modes <- function(sizeModes) {
  if (is.null(sizeModes) || length(sizeModes) == 0) {
    return(list())
  }
  if (is.atomic(sizeModes) && all(is.na(sizeModes) | sizeModes == "")) {
    return(list())
  }
  if (inherits(sizeModes, "character")) {
    sizeModes <- as.list(sizeModes)
  }
  if (is_custom_size_mode(sizeModes)) {
    sizeModes <- list(sizeModes)
  }

  Filter(function(mode) {
    if (is.character(mode)) {
      return(length(mode) == 1L && !is.na(mode) && nzchar(mode))
    }
    TRUE
  }, lapply(sizeModes, function(mode) {
    if (!is_custom_size_mode(mode)) {
      return(mode)
    }
    if (is.null(mode$name)) {
      mode$name <- if (!is.null(mode$tooltip)) {
        mode$tooltip
      } else if (!is.null(mode$scale)) {
        paste0("Current view x", mode$scale)
      } else {
        paste0("Custom (", mode$width, "x", mode$height, ")")
      }
    }
    if (is.null(mode$className) || !nzchar(mode$className)) {
      mode$className <- if (!is.null(mode$scale) && (is.null(mode$width) || is.null(mode$height))) {
        paste0("custom-scale-", gsub("[^0-9]+", "-", as.character(mode$scale)))
      } else {
        paste0("custom-", mode$width, "x", mode$height)
      }
    }
    mode$className <- gsub("[^A-Za-z0-9_-]", "-", mode$className)
    if (is.null(mode$keepView)) {
      mode$keepView <- TRUE
    }
    mode
  }))
}
