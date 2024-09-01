historyDependency <- function() {
  list(
    htmltools::htmlDependency(
      name = "font-awesome",
      version = fontawesome::fa_metadata()$version,
      src = "fontawesome",
      package = "fontawesome",
      stylesheet = c("css/all.min.css", "css/v4-shims.min.css")
    ),
    htmlDependency(
      "lfx-history", version = "1.0.0",
      src = system.file("htmlwidgets/lfx-history", package = "leaflet.extras2"),
      script = c("zoomCenter.js",
                 "lfx-history.js",
                 "lfx-history-bindings.js"),
      stylesheet =  "lfx-history.css"
    )
  )
}

#' Add History Plugin
#'
#' The plugin enables tracking of map movements in a history similar to a web
#' browser. By default, it is a simple pair of buttons -- back and forward.
#' @param map a map widget object created from \code{\link[leaflet]{leaflet}}
#' @param layerId the control id
#' @param options A named list of options. See \code{\link{historyOptions}}
#' @family History Functions
#' @references \url{https://github.com/cscott530/leaflet-history}
#' @inherit leaflet::addControl return
#' @export
#' @examples
#' library(leaflet)
#' leaflet()  %>%
#'   addTiles() %>%
#'   addHistory()
addHistory <- function(map, layerId = NULL, options = historyOptions()) {
  if (!requireNamespace("fontawesome")) {
    stop("The package `fontawesome` is needed for this plugin. ",
         "Please install it with:\ninstall.packages('fontawesome')")
  }
  ## Check Icon options. Is it character or shiny.tag. Adapt htmlDeps
  map$dependencies <- c(map$dependencies, historyDependency())
  leaflet::invokeMethod(map, NULL, "addHistory", layerId, options)
}

#' History Options
#' @param position Set the position of the History control. Default is
#'   \code{topright}.
#' @param maxMovesToSave Number of moves in the history to save before clearing
#'   out the oldest. Default value is 10, use 0 or a negative number to make
#'   unlimited.
#' @param backImage The class for the `back` button icon. Default is
#'   \code{"fa fa-caret-left"}.
#' @param forwardImage The class for the `forward` button icon. Default is
#'   \code{"fa fa-caret-right"}.
#' @param backText The text in the buttons. Default is ''.
#' @param forwardText The text in the buttons. Default is ''.
#' @param backTooltip Tooltip content. Default is \code{"Go to Previous Extent"}.
#' @param forwardTooltip Tooltip content. Default is \code{"Go to Next Extent"}.
#' @param backImageBeforeText When both text and image are present, whether to
#'   show the image first or the text first (left to right). Default is
#'   \code{TRUE}
#' @param forwardImageBeforeText When both text and image are present, whether
#'   to show the image first or the text first (left to right). Default is
#'   \code{FALSE}
#' @param orientation Whether to position the buttons on top of one another or
#'   side-by-side. Default is \code{horizontal}
#' @param shouldSaveMoveInHistory A JS callback you can provide that gets called
#'   with every move. return false to not save a move.
#' @family History Functions
#' @references \url{https://github.com/cscott530/leaflet-history}
#' @return A list of further options for \code{addHistory}
#' @export
#' @examples
#' library(leaflet)
#' leaflet()  %>%
#'   addTiles() %>%
#'     addHistory(options = historyOptions(position = "bottomright",
#'     maxMovesToSave = 20,
#'     backText =  "Go back",
#'     forwardText = "Go forward",
#'     orientation = "vertical"
#'     ))
historyOptions <- function(position = c("topright", "topleft", "bottomleft","bottomright"),
                           maxMovesToSave = 10,
                           backImage = "fa fa-caret-left",
                           forwardImage = "fa fa-caret-right",
                           backText = '',
                           forwardText = '',
                           backTooltip = 'Go to Previous Extent',
                           forwardTooltip = 'Go to Next Extent',
                           backImageBeforeText = TRUE,
                           forwardImageBeforeText = FALSE,
                           orientation = c("horizontal", "vertical"),
                           shouldSaveMoveInHistory = NULL) {
  position <- match.arg(position)
  orientation <- match.arg(orientation)
  leaflet::filterNULL(list(
    position = position,
    maxMovesToSave = maxMovesToSave,
    backImage = backImage,
    forwardImage = forwardImage,
    backText = backText,
    forwardText = forwardText,
    backTooltip = backTooltip,
    forwardTooltip = forwardTooltip,
    backImageBeforeText = backImageBeforeText,
    forwardImageBeforeText = forwardImageBeforeText,
    orientation = orientation,
    shouldSaveMoveInHistory = shouldSaveMoveInHistory
  ))
}

#' goBackHistory
#'
#' If possible, will go to previous map extent. Pushes current extent to the
#' "future" stack.
#' @param map a map widget object created from
#'   \code{\link[leaflet]{leafletProxy}}
#' @family History Functions
#' @references \url{https://github.com/cscott530/leaflet-history}
#' @inherit leaflet::addControl return
#' @export
goBackHistory <- function(map) {
  leaflet::invokeMethod(map, NULL, "goBackHistory")
}

#' goForwardHistory
#'
#' If possible, will go to next map extent. Pushes current extent to the "back"
#' stack.
#' @inheritParams goBackHistory
#' @family History Functions
#' @references \url{https://github.com/cscott530/leaflet-history}
#' @inherit leaflet::addControl return
#' @export
goForwardHistory <- function(map) {
  leaflet::invokeMethod(map, NULL, "goForwardHistory")
}

#' clearHistory
#'
#' Resets the stack of history items.
#' @inheritParams goBackHistory
#' @family History Functions
#' @references \url{https://github.com/cscott530/leaflet-history}
#' @inherit leaflet::addControl return
#' @export
clearHistory <- function(map) {
  leaflet::invokeMethod(map, NULL, "clearHistory")
}

#' clearFuture
#'
#' Resets the stack of future items.
#' @inheritParams goBackHistory
#' @family History Functions
#' @references \url{https://github.com/cscott530/leaflet-history}
#' @inherit leaflet::addControl return
#' @export
clearFuture <- function(map) {
  leaflet::invokeMethod(map, NULL, "clearFuture")
}

