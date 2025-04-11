library(testthat)
library(htmltools)
library(leaflet)
library(leaflet.extras2)

test_that("geosearch", {
  m <- leaflet() %>%
    addTiles() %>%
    addGeosearch()
  expect_is(m, "leaflet")
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-geosearch")

  m <- m %>%
    removeGeosearch()
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "removeGeosearch"
  )
  expect_silent(removeGeosearch(m))

  opts <- geosearchOptions(style = "bar", maxMarkers = 3, searchLabel = "Suche")
  expect_type(opts, "list")
  expect_equal(opts$style, "bar")
  expect_equal(opts$maxMarkers, 3)
  expect_equal(opts$searchLabel, "Suche")

  prov <- geosearchProvider("Google", options = list(apiKey = "abc123"))
  expect_type(prov, "list")
  expect_equal(prov$type, "Google")
  expect_true("apiKey" %in% names(prov$options))

  prov <- geosearchProvider("OSM")
  expect_equal(prov$type, "OSM")
})
