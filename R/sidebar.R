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

#' Adds a Sidebar Leaflet Control
#' @param map A leaflet map widget
#' @param id Id of the sidebar-div
#' @param options A named list with \code{position} and \code{fit} elements.
#' @seealso \url{https://github.com/Turbo87/sidebar-v2}
#' @family Sidebar Functions
#' @export
#' @examples \dontrun{
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
#' @family Sidebar Functions
#' @export
removeSidebar <- function(map) {
  invokeMethod(map, NULL, "removeSidebar")
}

#' Close the Sidebar
#' @param map A leaflet map widget
#' @family Sidebar Functions
#' @export
closeSidebar <- function(map) {
  invokeMethod(map, NULL, "closeSidebar")
}

#' Open the Sidebar
#' @param map A leaflet map widget
#' @param id The id of the \code{\link{sidebar_pane}} to open.
#' @family Sidebar Functions
#' @export
openSidebar <- function(map, id) {
  invokeMethod(map, NULL, "openSidebar", id)
}

#' Create a Sidebar Panel
#' @param title A title for the sidebar panel
#' @param id An id for the sidebar panel
#' @param icon An icon for the sidebar panel.
#' @param ... List of elements to include in the panel
#' @family Sidebar Functions
#' @export
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
#' @param iconList A list of icons to be shown, when the sidebar is collapsed.
#'   The list is required and must match the amount of \code{\link{sidebar_pane}}.
#' @param ... The individual \code{\link{sidebar_pane}}.
#' @family Sidebar Functions
#' @export
sidebar_tabs <- function(iconList = NULL, ...){
  arg <- list(...)
  ids <- lapply(arg, function(x) tagGetAttribute(x, "id"))
  if (length(ids) != length(iconList))
    stop("The number of icons needs to match the number of sidebar panes.")
  tags$div(id = "sidebar", class = "sidebar collapsed",
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
