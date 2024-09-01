layergroupCollisionDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-layergroupcollision", version = "1.0.0",
      src = system.file("htmlwidgets/lfx-layergroupcollision", package = "leaflet.extras2"),
      script = c("rbush.min.js",
                 "Leaflet.LayerGroup.Collision.js",
                 "layergroup-binding.js"),
      all_files = TRUE
    )
  )
}

#' Add LayerroupCollision Plugin
#' @return A leaflet map object
#' @export
#'
#' @references \url{https://github.com/Geovation/labelgun}
#'
#' @name LayerroupCollision
addLayerGroupCollision <- function(map, group=NULL, margin=5) {
  # stopifnot("The group argument is NULL. Please define a valid group." = !is.null(group))

  map$dependencies <- c(map$dependencies, layergroupCollisionDependency())

  invokeMethod(map, NULL, "addLayerGroupCollision", group, margin)
}
