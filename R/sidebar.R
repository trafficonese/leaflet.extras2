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
#' The sidebar HTML must be created with \code{\link{sidebar_tabs}} and
#' \code{\link{sidebar_pane}} before
#' \code{\link[leaflet]{leafletOutput}} is called.
#'
#' @param map A leaflet map widget
#' @param id Id of the sidebar-div. Must match with the \code{id} of
#'   \code{\link{sidebar_tabs}}
#' @param options A named list with the only option \code{position}, which should
#'   be either \code{left} or \code{right}.
#' @param ns The namespace function, if used in Shiny modules.
#' @family Sidebar Functions
#' @references \url{https://github.com/Turbo87/sidebar-v2}
#' @export
#' @inherit leaflet::addControl return
#' @inherit sidebar_tabs examples
addSidebar <- function(map, id = "sidebar",
                       options = list(position = "left"),
                       ns = NULL) {
  map$dependencies <- c(map$dependencies, sidebar_deps())
  options$fit = TRUE
  if (!is.null(ns)) id <- ns(id)
  invokeMethod(map, NULL, "addSidebar", id, options)
}

#' Remove the Sidebar
#' @param map A leaflet map widget
#' @param sidebar_id The id of the sidebar (per \code{\link{sidebar_tabs}}).
#'  Defaults to \code{NULL} such that the first sidebar is removed.
#' @family Sidebar Functions
#' @inherit leaflet::addControl return
#' @export
removeSidebar <- function(map, sidebar_id = NULL) {
  invokeMethod(map, NULL, "removeSidebar", sidebar_id)
}

#' Close the Sidebar
#' @param map A leaflet map widget
#' @param sidebar_id The id of the sidebar (per \code{\link{sidebar_tabs}}).
#'  Defaults to \code{NULL} such that the first sidebar is used.
#' @family Sidebar Functions
#' @inherit leaflet::addControl return
#' @export
closeSidebar <- function(map, sidebar_id = NULL) {
  invokeMethod(map, NULL, "closeSidebar", sidebar_id)
}

#' Open the Sidebar by ID
#' @param id The id of the \code{\link{sidebar_pane}} to open.
#' @family Sidebar Functions
#' @param ns The namespace function, if used in Shiny modules.
#' @inheritParams closeSidebar
#' @inherit leaflet::addControl return
#' @export
openSidebar <- function(map, id, sidebar_id = NULL, ns = NULL) {
  if (!is.null(ns)) id <- ns(id)
  invokeMethod(map, NULL, "openSidebar", list(id = id, sidebar_id = sidebar_id))
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
  tags$div(class = "leafsidebar-pane", id = id,
           tags$h3(class = "leafsidebar-header", title,
                   tags$span(class = "leafsidebar-close", icon)),
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
#'
#' # run example app showing a single sidebar
#' runApp(paste0(system.file("examples", package = "leaflet.extras2"),
#'               "/sidebar_app.R"))
#'
#' # run example app showing two sidebars
#' runApp(paste0(system.file("examples", package = "leaflet.extras2"),
#'               "/multi_sidebar_app.R"))
#' }
sidebar_tabs <- function(id = "sidebar", iconList = NULL, ...){
  arg <- list(...)
  ids <- lapply(arg, function(x) tagGetAttribute(x, "id"))
  if (length(ids) != length(iconList))
    stop("The number of icons needs to match the number of sidebar panes.")
  tags$div(id = id, class = "leafsidebar collapsed",
           tags$div(class = "leafsidebar-tabs", style = "display: none",
                    tags$ul(role = "tablist",
                            tagList(lapply(1:length(ids), function(x) {
                              tags$li(tags$a(href = paste0("#", ids[[x]]), role = "tab", iconList[[x]]))
                            }))
                            )
           ),
           tags$div(class = "leafsidebar-content", style = "display: none",
                    tagList(arg))
  )
}
