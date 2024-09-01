leafletsyncDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-leafletsync",
      version = "1.0.0",
      src = system.file("htmlwidgets/lfx-leafletsync", package = "leaflet.extras2"),
      script = c(
        "L.Map.Sync.js",
        "leafletsync-bindings.js"
      )
    )
  )
}

#' Add the Leaflet Sync JS dependencies
#'
#' Sometimes it makes sense to include the Leaflet Sync dependencies already
#' before synchronizing maps. For example, if you want to use the
#' `L.Sync.offsetHelper`. See the example in
#' \code{./inst/examples/offsetHelper.R}
#'
#' @param map the map
#'
#' @family leafletsync Functions
#' @return A modified leaflet map
#' @export
addLeafletsyncDependency <- function(map) {
  map$dependencies <- c(map$dependencies, leafletsyncDependency())
  map
}

#' Synchronize multiple Leaflet map
#'
#' The plugin allows you to synchronize and unsynchronize multiple leaflet maps
#' in a Shiny application. You can pass additional options
#' to \code{\link{leafletsyncOptions}}. For more information see
#' \href{https://github.com/jieter/Leaflet.Sync}{Leaflet.Sync}
#'
#' @param map the map
#' @param ids the map ids to be synced. If you use a \code{synclist}, you may
#'   leave it \code{NULL.} The unique names and values of \code{synclist} will
#'   be used.
#' @param synclist The synchronization list. The default is \code{'all'}, which
#'   creates a list of all possible combinations of \code{ids}. For a more
#'   detailed control, a named list can be passed in this form
#'   \code{list(m1 = c("m2", "m3"), m2 = c("m1", "m3"), m3 = c("m1", "m2"))},
#'   where the names and values represent map-ids. The names of the lists serve
#'   as a basis and the list values are the maps to be kept in sync with the
#'   basemap.
#' @param options A named list of options. See \code{\link{leafletsyncOptions}}.
#'   If you want to add different options to multiple maps, you can wrap the
#'   options in a named list, with the names being the map-ids. See the example
#'   in \code{./inst/examples/offset_continuous.R}
#'
#' @note If you synchronize multiple maps, a map may not yet be
#'   initialized and therefore cannot be used. Make sure to use
#'   \code{addLeafletsync} after all maps have been rendered.
#'
#' @family leafletsync Functions
#' @references \url{https://github.com/jieter/Leaflet.Sync}
#' @return A modified leaflet map
#' @export
addLeafletsync <- function(map,
                           ids = NULL,
                           synclist = "all",
                           options = leafletsyncOptions()) {
  ## Stop If Synclist is NULL or 'all' and 'ids' is also NULL
  if (((length(synclist) == 1 && synclist == "all") || is.null(synclist)) && is.null(ids)) {
    stop(
      "You must pass a character vector to 'ids' ",
      "if you use synclist = 'all' or if it is unset."
    )
  }
  ## If 'ids' is NULL and a 'synclist' is passed, take the unique values/names
  if (is.null(ids) && is.list(synclist)) {
    ids <- unique(c(unlist(synclist), names(synclist)))
  }
  ## Create all possible combinations of the given 'ids'
  if (length(synclist) == 1 && synclist == "all") {
    synclist <- vector(mode = "list", length = length(ids))
    names(synclist) <- ids
    for (i in ids) {
      rest <- ids[ids != i]
      for (j in seq.int(length(rest))) {
        synclist[[i]][j] <- rest[j]
      }
    }
  } else {
    ## Warn if some names of the 'synclist' to not correspond to the 'ids'
    if (is.list(synclist)) {
      if (any(!names(synclist) %in% ids)) {
        warning(sprintf(
          "The map-ids %s in 'synclist' do not correspond to the given ids.\n",
          paste(names(synclist)[!names(synclist) %in% ids], collapse = ", ")
        ))
      }
    }
  }
  ## Repeat options for all maps
  if (!all(ids %in% names(options))) {
    options <- rep(list(options), length(ids))
    names(options) <- ids
  }

  map$dependencies <- c(map$dependencies, leafletsyncDependency())
  invokeMethod(map, NULL, "addLeafletsync", ids, synclist, options)
}

#' Removes synchronization.
#'
#' Removes the synchronization of multiple maps from a specific map.
#'
#' @param map the map
#' @param id The map id from which to unsynchronize the maps in \code{unsyncids}
#' @param unsyncids Unsynchronize the maps with the following IDs
#'
#' @family leafletsync Functions
#' @return A map
#' @export
unsync <- function(map, id = NULL, unsyncids = NULL) {
  if (is.null(id)) stop("You need to pass an `id` argument as character")
  if (is.null(unsyncids)) stop("You need to pass an `unsyncids` argument as character vector")
  invokeMethod(map, NULL, "unsyncLeaflet", id, unsyncids)
}

#' Is a map synchronized?
#'
#' Is a map snychronized with any or a specific map?
#' Invoking this method sets a Shiny input that returns \code{TRUE} when
#' the map is synchronized with another map. If \code{syncwith} is
#' set, \code{TRUE} is returned if the map is synchronized exactly
#' with that other map.
#'
#' @param map the map
#' @param id The map id
#' @param syncwith Is the map synchronized with one of these maps?
#'
#' @details The Siny input name is combined of the map-id and \code{"_synced"}.
#' For a map with id \code{map1} the input can be retrieved with
#' \code{input$map1_synced}.
#'
#' @family leafletsync Functions
#' @return A map
#' @export
isSynced <- function(map, id = NULL, syncwith = NULL) {
  if (is.null(id)) stop("You need to pass an `id` argument as character")
  invokeMethod(map, NULL, "isSyncedLeaflet", id, syncwith)
}

#' leafletsync Options
#'
#' Additional list of options.
#'
#' @param noInitialSync Setting to \code{TRUE} disables initial synchronization
#'   of the maps. The default is \code{FALSE}.
#' @param syncCursor The default \code{TRUE} adds a circle marker on the
#'   synced map.
#' @param offsetFn A JavaScript-function to compute an offset for the center.
#' @family leafletsync Functions
#' @return A list of options for \code{addLeafletsync}
#' @export
leafletsyncOptions <- function(
    noInitialSync = FALSE,
    syncCursor = TRUE,
    offsetFn = JS("function (center, zoom, refMap, tgtMap) { return center; }")) {
  filterNULL(list(
    noInitialSync = noInitialSync,
    syncCursor = syncCursor,
    offsetFn = offsetFn
  ))
}
