## DATA #######################
# data <- st_cast(st_as_sf(leaflet::atlStorms2005[4,]), "LINESTRING")
data <- structure(
  list(
    Name = structure(4L, levels = c(
      "ALPHA", "ARLENE",
      "BRET", "CINDY", "DELTA", "DENNIS", "EMILY", "EPSILON", "FRANKLIN",
      "GAMMA", "GERT", "HARVEY", "IRENE", "JOSE", "KATRINA", "LEE",
      "MARIA", "NATE", "OPHELIA", "PHILIPPE", "RITA", "TEN", "TWENTY-TWO",
      "WILMA"
    ), class = "factor"),
    MaxWind = 65, MinPress = 991,
    geometry = structure(
      list(
        structure(c(
          -86.7, -87.2, -87.6, -87.9, -88.5, -89, -89.7,
          -90.2, -90.4, -90.5, -90.3, -90.1, -90, -89.5, -88.9, -88.1,
          -87.2, -86.2, -84.1, -81.8, -80, -78.3, -76.7, -74.8, -72,
          -70.7, -69.8, -69.6, -69.8, -70, -67.6, -66.4, -64.5, -62.5,
          18.3, 18.6, 19, 19.3, 20.9, 22.3, 23.9, 25.1, 26.4, 27.6,
          28.5, 29.2, 29.6, 30.2, 30.8, 31.6, 32.4, 33.2, 34.6, 35.6,
          37.1, 37.8, 38.4, 39.1, 39.5, 40.8, 41.6, 43.5, 44.9, 45.5,
          46.5, 48, 48.5, 48.5
        ), dim = c(34L, 2L), class = c("XY", "LINESTRING", "sfg"))
      ),
      class = c("sfc_LINESTRING", "sfc"),
      precision = 0, bbox = structure(c(
        xmin = -90.5, ymin = 18.3,
        xmax = -62.5, ymax = 48.5
      ), class = "bbox"), crs = structure(list(
        input = "+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +no_defs",
        wkt = "GEOGCRS[\"unknown\",\n    DATUM[\"World Geodetic System 1984\",\n        ELLIPSOID[\"WGS 84\",6378137,298.257223563,\n            LENGTHUNIT[\"metre\",1]],\n        ID[\"EPSG\",6326]],\n    PRIMEM[\"Greenwich\",0,\n        ANGLEUNIT[\"degree\",0.0174532925199433],\n        ID[\"EPSG\",8901]],\n    CS[ellipsoidal,2],\n        AXIS[\"longitude\",east,\n            ORDER[1],\n            ANGLEUNIT[\"degree\",0.0174532925199433,\n                ID[\"EPSG\",9122]]],\n        AXIS[\"latitude\",north,\n            ORDER[2],\n            ANGLEUNIT[\"degree\",0.0174532925199433,\n                ID[\"EPSG\",9122]]]]"
      ), class = "crs"), n_empty = 0L
    )
  ),
  row.names = 4L, class = c("sf", "data.frame"), sf_column = "geometry",
  agr = structure(c(Name = NA_integer_,
                    MaxWind = NA_integer_, MinPress = NA_integer_),
    levels = c("constant", "aggregate", "identity"), class = "factor"
  )
)

## TESTS #######################
test_that("heightgraph", {
  library(sf)

  data <- st_transform(data, 4326)
  data <- data.frame(st_coordinates(data))
  data$elev <- runif(nrow(data), 10, 500)
  data$L1 <- NULL
  L1 <- round(seq.int(1, 4, length.out = nrow(data)))
  data <- st_as_sf(st_sfc(lapply(split(data, L1), function(x) {
    st_linestring(as.matrix(x))
  })))
  data$steepness <- 1:nrow(data)
  data$suitability <- nrow(data):1
  data$popup <- apply(data, 1, function(x) {
    sprintf("Steepness: %s<br>Suitability: %s", x$steepness, x$suitability)
  })

  m <- leaflet() %>%
    addTiles(group = "base") %>%
    addHeightgraph(
      color = "red", columns = c("steepness", "suitability"),
      opacity = 1, data = data, group = "heightgraph",
      options = heightgraphOptions(width = 400)
    )
  expect_is(m, "leaflet")

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-heightgraph")

  expect_true(m$x$calls[[2]]$method == "addHeightgraph")
  expect_is(m$x$calls[[2]]$args[[1]][[1]], "geojson")
  expect_is(m$x$calls[[2]]$args[[1]][[2]], "geojson")
  expect_identical(m$x$calls[[2]]$args[[2]]$steepness, data$steepness)
  expect_identical(m$x$calls[[2]]$args[[2]]$suitability, data$suitability)


  expect_error(
    leaflet() %>%
      addTiles(group = "base") %>%
      addHeightgraph(data = data)
  )
})
