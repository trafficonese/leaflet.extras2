library(sf)

breweries91 <- st_as_sf(breweries91)
lines <- st_as_sf(atlStorms2005)
polys <- st_as_sf(leaflet::gadmCHE)
groups <- c("atlStorms","breweries","gadmCHE")

test_that("layergroupconditional", {
  m <- leaflet() %>%
    addTiles() %>%
    addPolylines(data = lines, label = ~Name, group = groups[1]) %>%
    addCircleMarkers(data = breweries91, label = ~brewery, group = groups[2]) %>%
    addPolygons(data = polys, label = ~NAME_1, group = groups[3]) %>%
    addLayerGroupConditional(groups = groups,
                             conditions = list(
                               "(zoomLevel) => zoomLevel < 4" = groups[1],
                               "(zoomLevel) => zoomLevel >= 4 & zoomLevel < 6 " = groups[2],
                               "(zoomLevel) => zoomLevel >= 6" = c(groups[3])
                             ))

  expect_is(m, "leaflet")
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-conditional")

  m <- m %>%
    clearConditionalLayers()
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "clearConditionalLayers"
  )
  expect_silent(clearConditionalLayers(m))

  m <- m %>%
    removeConditionalLayer(groups[1])
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "removeConditionalLayer"
  )
  expect_silent(removeConditionalLayer(m, groups[1]))

})
