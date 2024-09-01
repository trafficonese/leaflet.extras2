test_that("Leaflet Sync works", {
  m <- leaflet() %>%
    addLeafletsyncDependency()
  expect_is(m, "leaflet")
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-leafletsync")
  expect_true(all(deps[[length(deps)]]$script %in% c("L.Map.Sync.js", "leafletsync-bindings.js")))


  m <- leaflet() %>%
    addLeafletsync(
      ids = NULL,
      synclist = list(map1 = c("map2", "map3"), map2 = c("map3")),
      options = leafletsyncOptions(
        noInitialSync = FALSE,
        syncCursor = TRUE
      )
    )
  expect_is(m, "leaflet")
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-leafletsync")

  expect_true(m$x$calls[[1]]$method == "addLeafletsync")
  expect_true(all(m$x$calls[[1]]$args[[1]] %in% c("map1", "map2", "map3")))
  expect_identical(
    m$x$calls[[1]]$args[[2]],
    list(map1 = c("map2", "map3"), map2 = c("map3"))
  )
  expect_true(length(m$x$calls[[1]]$args[[3]]) == 3)

  m <- leaflet() %>%
    addLeafletsync(
      synclist = "all",
      ids = c("map2", "map3", "map4")
    )
  expect_is(m, "leaflet")
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-leafletsync")
  expect_true(m$x$calls[[1]]$method == "addLeafletsync")
  expect_length(m$x$calls[[1]]$args[[2]], 3)

  m <- m %>%
    unsync("map1", "map2")
  len <- length(m$x$calls)
  expect_true(m$x$calls[[len]]$method == "unsyncLeaflet")
  expect_true(m$x$calls[[len]]$args[[1]] == "map1")
  expect_true(m$x$calls[[len]]$args[[2]] == "map2")


  m <- m %>%
    isSynced("map1")
  len <- length(m$x$calls)
  expect_true(m$x$calls[[len]]$method == "isSyncedLeaflet")
  expect_true(m$x$calls[[len]]$args[[1]] == "map1")
  expect_null(m$x$calls[[len]]$args[[2]])

  m <- m %>%
    isSynced("map1", syncwith = "map2")
  len <- length(m$x$calls)
  expect_true(m$x$calls[[len]]$method == "isSyncedLeaflet")
  expect_true(m$x$calls[[len]]$args[[1]] == "map1")
  expect_true(m$x$calls[[len]]$args[[2]] == "map2")


  expect_warning(
    leaflet() %>%
      addLeafletsync(
        ids = c("map2", "map3", "map4"),
        synclist = list(map1 = c("map2", "map3"), map2 = c("map3")),
        options = leafletsyncOptions(
          noInitialSync = FALSE,
          syncCursor = TRUE
        )
      )
  )
  expect_error(
    leaflet() %>%
      addLeafletsync(synclist = "all")
  )
  expect_error(
    m %>% unsync()
  )
  expect_error(
    m %>% unsync(unsyncids = "map2")
  )
  expect_error(
    m %>% unsync(id = "map1")
  )
  expect_error(
    m %>% isSynced()
  )
})
