test_that("vectorgrid slicer", {
  skip_if_not_installed("sf")
  skip_if_not_installed("yyjsonr")

  nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
  nc <- nc[1:5, ]

  m <- leaflet() %>%
    addTiles() %>%
    addVectorgrid(
      data = nc,
      layerId = "nc",
      group = "counties",
      featureId = ~NAME,
      popup = ~NAME,
      color = "black",
      weight = 1,
      fillColor = "#4daf4a"
    )

  expect_is(m, "leaflet")
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-vectorgrid")
  expect_true("Leaflet.VectorGrid.min.js" %in% deps[[length(deps)]]$script)

  last <- m$x$calls[[length(m$x$calls)]]
  expect_equal(last$method, "addVectorgrid")
  expect_true(inherits(last$args[[1]], "geojson"))
  expect_equal(last$args[[2]], "nc")
  expect_equal(last$args[[3]], "counties")
  expect_equal(last$args[[4]]$weight, 1)
  expect_true(last$args[[4]]$interactive)

  m <- m %>% removeVectorgrid("nc")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "removeVectorgrid")
  expect_equal(m$x$calls[[length(m$x$calls)]]$args[[1]], "nc")

  m <- m %>% clearVectorgrid()
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "clearVectorgrid")
})

test_that("vectorgrid treats formula layerId as featureId", {
  skip_if_not_installed("sf")
  skip_if_not_installed("yyjsonr")

  p <- sf::st_sf(
    name = c("a", "b"),
    geometry = sf::st_sfc(
      sf::st_point(c(0, 0)),
      sf::st_point(c(1, 1))
    ),
    crs = 4326
  )

  m <- leaflet() %>%
    addVectorgrid(data = p, layerId = ~name, color = "red")
  last <- m$x$calls[[length(m$x$calls)]]
  expect_null(last$args[[2]])
})

test_that("vectorgrid accepts a GeoJSON URL", {
  url <- "https://example.com/data.geojson"
  m <- leaflet() %>%
    addVectorgrid(data = url, layerId = "url", color = "navy", weight = 3)

  last <- m$x$calls[[length(m$x$calls)]]
  expect_equal(last$method, "addVectorgrid")
  expect_equal(last$args[[1]], url)
  expect_equal(last$args[[2]], "url")
  expect_equal(last$args[[4]]$color, "navy")
  expect_equal(last$args[[4]]$weight, 3)
  expect_true(last$args[[4]]$interactive)
})

test_that("vectorgrid accepts geojson/json objects", {
  gj <- '{"type":"FeatureCollection","features":[]}'
  class(gj) <- c("geojson", "json")

  m <- leaflet() %>%
    addVectorgrid(data = gj, layerId = "gj", fillColor = "#abc", dashArray = "4")

  last <- m$x$calls[[length(m$x$calls)]]
  expect_equal(last$args[[1]], gj)
  expect_equal(last$args[[4]]$fillColor, "#abc")
  expect_equal(last$args[[4]]$dashArray, "4")

  raw <- '{"type":"FeatureCollection","features":[]}'
  class(raw) <- "json"
  m <- leaflet() %>% addVectorgrid(data = raw, opacity = 0.8)
  expect_equal(m$x$calls[[length(m$x$calls)]]$args[[1]], raw)
  expect_equal(m$x$calls[[length(m$x$calls)]]$args[[4]]$opacity, 0.8)
})

test_that("vectorgrid converts Spatial data", {
  skip_if_not_installed("sf")
  skip_if_not_installed("sp")
  skip_if_not_installed("yyjsonr")

  p <- sf::st_sf(
    name = c("a", "b"),
    geometry = sf::st_sfc(
      sf::st_point(c(0, 0)),
      sf::st_point(c(1, 1))
    ),
    crs = 4326
  )
  spatial <- as(p, "Spatial")
  expect_true(inherits(spatial, "Spatial"))

  m <- leaflet() %>%
    addVectorgrid(data = spatial, layerId = "sp", featureId = ~name, popup = ~name)

  last <- m$x$calls[[length(m$x$calls)]]
  expect_equal(last$method, "addVectorgrid")
  expect_true(inherits(last$args[[1]], "geojson"))
  expect_equal(last$args[[2]], "sp")
})

test_that("vectorgrid rejects unsupported data", {
  expect_error(
    addVectorgrid(leaflet(), data = data.frame(x = 1)),
    "must be an sf/Spatial object, GeoJSON, or a URL"
  )
})

test_that("vectorgrid errors when sf is missing for Spatial data", {
  skip_if_not_installed("sf")
  skip_if_not_installed("sp")

  spatial <- as(sf::st_sf(
    name = "a",
    geometry = sf::st_sfc(sf::st_point(c(0, 0))),
    crs = 4326
  ), "Spatial")

  with_mocked_bindings(
    {
      expect_error(
        addVectorgrid(leaflet(), data = spatial),
        "The package `sf` is needed to convert Spatial data"
      )
    },
    requireNamespace = function(package, ..., quietly = FALSE) FALSE,
    .package = "base"
  )
})

test_that("vectorgrid errors when sf is missing", {
  skip_if_not_installed("sf")

  p <- sf::st_sf(
    name = "a",
    geometry = sf::st_sfc(sf::st_point(c(0, 0))),
    crs = 4326
  )

  with_mocked_bindings(
    {
      expect_error(
        addVectorgrid(leaflet(), data = p),
        "The package `sf` is needed for addVectorgrid()"
      )
    },
    requireNamespace = function(package, ..., quietly = FALSE) {
      if (identical(package, "sf")) FALSE else TRUE
    },
    .package = "base"
  )
})

test_that("vectorgrid errors when yyjsonr is missing", {
  skip_if_not_installed("sf")

  p <- sf::st_sf(
    name = "a",
    geometry = sf::st_sfc(sf::st_point(c(0, 0))),
    crs = 4326
  )

  with_mocked_bindings(
    {
      expect_error(
        addVectorgrid(leaflet(), data = p),
        "The package `yyjsonr` is needed for addVectorgrid()"
      )
    },
    requireNamespace = function(package, ..., quietly = FALSE) {
      if (identical(package, "yyjsonr")) FALSE else TRUE
    },
    .package = "base"
  )
})

test_that("addProtobuf", {
  m <- leaflet() %>%
    addTiles() %>%
    addProtobuf(
      urlTemplate = "https://example.com/{z}/{x}/{y}.pbf",
      layerId = "pbf",
      group = "vector",
      key = "secret",
      popup = "name",
      label = "name",
      attribution = "OSM"
    )

  expect_is(m, "leaflet")
  last <- m$x$calls[[length(m$x$calls)]]
  expect_equal(last$method, "addProtobuf")
  expect_equal(last$args[[1]], "https://example.com/{z}/{x}/{y}.pbf")
  expect_equal(last$args[[2]], "pbf")
  expect_equal(last$args[[3]], "vector")
  expect_equal(last$args[[4]]$key, "secret")
  expect_equal(last$args[[4]]$popup, "name")
  expect_equal(last$args[[4]]$label, "name")
  expect_equal(last$args[[4]]$attribution, "OSM")
  expect_true(is.list(last$args[[5]]$water))

  expect_error(addProtobuf(leaflet()), "urlTemplate")
})

test_that("vectorStyling has OSM layer names", {
  st <- vectorStyling()
  expect_true(is.list(st))
  expect_true(all(c("water", "building", "transportation", "road", "streets", "water_polygons") %in% names(st)))
})

test_that("vectorgrid binding wires layerId and shiny click", {
  js <- paste(
    readLines(system.file(
      "htmlwidgets/lfx-vectorgrid/Leaflet.VectorGrid-bindings.js",
      package = "leaflet.extras2"
    )),
    collapse = "\n"
  )
  expect_match(js, "getFeatureId")
  expect_match(js, "layerManager.addLayer")
  expect_match(js, "_vectorgrid_click")
  expect_match(js, "_vectorgrid_pbf_click")
  expect_match(js, "_removeAllTiles")
  expect_match(js, "L.tooltip")
  expect_match(js, "lfxDefined")
  expect_match(js, "lfxPatchPointGetLatLng")
  expect_match(js, "getLatLng = null")
  expect_false(grepl("\\bdebugger\\b", js))
})
