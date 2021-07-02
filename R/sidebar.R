sidebar_deps <- function(mini = FALSE) {
  list(
    htmlDependency(
      "lfx-sidebar", "1.0.0",
      src = system.file("htmlwidgets/lfx-sidebar", package = "leaflet.extras2"),
      script = c("leaflet-sidebar.js",
                 "leaflet-sidebar-binding.js"),
      stylesheet = "leaflet-sidebar.css"
      )
  )
}

#' Add a Sidebar Leaflet Control
#'
#' The sidebar plugin only works in a reactive environment (e.g Shiny), as the
#' HTML must be created with \code{\link{sidebar_tabs}} and
#' \code{\link{sidebar_pane}} before
#' \code{\link[leaflet]{leafletOutput}} is called.
#'
#' @param map A leaflet map widget
#' @param id Id of the sidebar-div. Must match with the \code{id} of
#'   \code{\link{sidebar_tabs}}
#' @param options A named list with \code{position} and \code{fit} elements.
#' @family Sidebar Functions
#' @references \url{https://github.com/Turbo87/sidebar-v2}
#' @export
#' @inherit leaflet::addControl return
#' @examples \dontrun{
#' library(shiny)
#' runApp(paste0(system.file("examples", package = "leaflet.extras2"),
#'               "/sidebar_app.R"))
#' }
addSidebar <- function(map, id = "sidebar",
                       options = list(position = "left",
                                      fit = TRUE)) {
  map$dependencies <- c(map$dependencies, sidebar_deps())
  invokeMethod(map, NULL, "addSidebar", id, options)
}

#' Remove the Sidebar
#' @param map A leaflet map widget
#' @param tab_id The id of the sidebar defined in \code{\link{sidebar_tabs}}.
#'  Defaults to \code{NULL} such that the first sidebar is opened.
#' @family Sidebar Functions
#' @inherit leaflet::addControl return
#' @export
removeSidebar <- function(map, tab_id = NULL) {
  invokeMethod(map, NULL, "removeSidebar", tab_id)
}

#' Close the Sidebar
#' @param map A leaflet map widget
#' @param tab_id The id of the sidebar defined in \code{\link{sidebar_tabs}}.
#'  Defaults to \code{NULL} such that the first sidebar is opened.
#' @family Sidebar Functions
#' @inherit leaflet::addControl return
#' @export
closeSidebar <- function(map, tab_id = NULL) {
  invokeMethod(map, NULL, "closeSidebar", tab_id)
}

#' Open the Sidebar by ID
#' @param map A leaflet map widget
#' @param id The id of the \code{\link{sidebar_pane}} to open.
#' @param tab_id The id of the sidebar defined in \code{\link{sidebar_tabs}}.
#'  Defaults to \code{NULL} such that the first sidebar is opened.
#' @family Sidebar Functions
#' @inherit leaflet::addControl return
#' @export
openSidebar <- function(map, id, tab_id = NULL) {
  invokeMethod(map, NULL, "openSidebar", list(id = id, tab_id = tab_id))
}

#' Create a Sidebar Pane
#' @param title A title for the sidebar panel
#' @param id An id for the sidebar panel
#' @param icon An icon for the sidebar panel
#' @param ... List of elements to include in the panel
#' @family Sidebar Functions
#' @references \url{https://github.com/Turbo87/sidebar-v2},
#'          \url{https://github.com/Turbo87/sidebar-v2/blob/master/doc/usage.md}
#' @return A \code{shiny.tag} with sidebar-specific HTML classes
#' @export
#' @examples \dontrun{
#' library(shiny)
#' sidebar_pane(id = "id", icon = icon("cars"), tags$div())
#' }
sidebar_pane <- function(title = "Sidebar Title",
                         id = NULL,
                         icon = icon("caret-right"), ...) {
  if (is.null(id))
    stop("The sidebar pane needs an `id`.")
  tags$div(class = "sidebar-pane", id = id,
           tags$h3(class = "sidebar-header", title,
                   tags$span(class = "sidebar-close", icon)),
           ...)
}

#' Create a Sidebar
#' @param id The id of the sidebar, which must match the \code{id} of
#'   \code{\link{addSidebar}}. Default is \code{"sidebar"}
#' @param iconList A list of icons to be shown, when the sidebar is collapsed.
#'   The list is required and must match the amount of \code{\link{sidebar_pane}}.
#' @param ... The individual \code{\link{sidebar_pane}}'s.
#' @family Sidebar Functions
#' @references \url{https://github.com/Turbo87/sidebar-v2},
#'          \url{https://github.com/Turbo87/sidebar-v2/blob/master/doc/usage.md}
#' @return A \code{shiny.tag} with individual sidebar panes
#' @export
#' @examples \dontrun{
#' library(shiny)
#' runApp(paste0(system.file("examples", package = "leaflet.extras2"),
#'               "/sidebar_app.R"))
#' }
sidebar_tabs <- function(id = "sidebar", iconList = NULL, ...){
  arg <- list(...)
  ids <- lapply(arg, function(x) tagGetAttribute(x, "id"))
  if (length(ids) != length(iconList))
    stop("The number of icons needs to match the number of sidebar panes.")
  tags$div(id = id, class = "sidebar collapsed",
           tags$div(class = "sidebar-tabs",
                    tags$ul(role = "tablist",
                            tagList(lapply(1:length(ids), function(x) {
                              tags$li(tags$a(href = paste0("#", ids[[x]]), role = "tab", iconList[[x]]))
                            }))
                            )
           ),
           tags$div(class = "sidebar-content",
                    tagList(arg))
  )
}
