tangram_deps <- function() {
  list(
    htmlDependency(
      "lfx-tangram", "1.0.0",
      src = system.file("htmlwidgets/lfx-tangram", package = "leaflet.extras2"),
      script = c(
        "tangram.min.js",
        "leaflet.tangram.binding.js"
      )
    )
  )
}

#' Adds a Tangram layer to a Leaflet map in a Shiny App.
#'
#' @param scene Path to a required \bold{.yaml} or \bold{.zip} file. If the file
#'   is within the \code{/www} folder of a Shiny-App, only the filename must be
#'   given, otherwise the full path is needed. See the
#'   \href{https://github.com/tangrams/tangram}{Tangram repository} or the
#'   \href{https://tangrams.readthedocs.io/en/latest/}{Tangram docs} for further
#'   information on how to edit such a .yaml file.
#' @param options A list of further options. See the app in the
#'   \code{examples/tangram} folder or the
#'   \href{https://tangrams.readthedocs.io/en/latest/Overviews/Tangram-Overview/#leaflet}{docs}
#'    for further information.
#' @note Only works correctly in a Shiny-App environment.
#' @references \url{https://github.com/tangrams/tangram}
#' @family Tangram Functions
#' @inheritParams leaflet::addPolygons
#' @inherit leaflet::addWMSTiles return
#' @export
#' @examples \dontrun{
#' library(shiny)
#' library(leaflet)
#' library(leaflet.extras2)
#'
#' ## In the /www folder of a ShinyApp. Must contain the Nextzen API-key
#' scene <- "scene.yaml"
#'
#' ui <- fluidPage(leafletOutput("map"))
#'
#' server <- function(input, output, session) {
#'   output$map <- renderLeaflet({
#'     leaflet() %>%
#'       addTiles(group = "base") %>%
#'       addTangram(scene = scene, group = "tangram") %>%
#'       addCircleMarkers(data = breweries91, group = "brews") %>%
#'       setView(11, 49.4, 14) %>%
#'       addLayersControl(
#'         baseGroups = c("tangram", "base"),
#'         overlayGroups = c("brews")
#'       )
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
addTangram <- function(map, scene = NULL, layerId = NULL, group = NULL,
                       options = NULL) {
  if ((is.null(scene) || !is.character(scene) ||
    (!gsub(".*\\.", "", scene) %in% c("yaml", "zip")))) {
    stop(
      "The scene must point to a valid .yaml or .zip file.\n",
      "See the documentation for further information."
    )
  }

  tngrscene <- list(
    htmltools::htmlDependency(
      name = "tangram_scene",
      version = 1,
      src = dirname(scene),
      attachment = basename(scene)
    )
  )

  map$dependencies <- c(map$dependencies, tngrscene, tangram_deps())

  options <- leaflet::filterNULL(c(list(scene = basename(scene)), options))

  invokeMethod(
    map, NULL, "addTangram",
    layerId, group, options
  )
}
