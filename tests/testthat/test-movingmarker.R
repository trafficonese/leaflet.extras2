library(sf)
## DATA #######################
df <- new("SpatialLinesDataFrame",
  data = structure(list(Name = structure(1L, levels = c(
    "ALPHA",
    "ARLENE", "BRET", "CINDY", "DELTA", "DENNIS", "EMILY", "EPSILON",
    "FRANKLIN", "GAMMA", "GERT", "HARVEY", "IRENE", "JOSE", "KATRINA",
    "LEE", "MARIA", "NATE", "OPHELIA", "PHILIPPE", "RITA", "TEN",
    "TWENTY-TWO", "WILMA"
  ), class = "factor"), MaxWind = 45, MinPress = 998),
  row.names = 1L, class = "data.frame"),
  lines = list(new("Lines", Lines = list(new("Line", coords = structure(c(
    -67.5,
    -68.5, -69.6, -70.5, -71.3, -72.2, -72.7, -72.9, -73, -72.4,
    -70.8, 15.8, 16.5, 17.3, 17.8, 18.3, 18.6, 19.8, 21.6, 23.5,
    25.1, 27.9
  ), dim = c(11L, 2L)))), ID = "1")), bbox = structure(c(
    -73,
    15.8, -67.5, 27.9
  ), dim = c(2L, 2L), dimnames = list(c(
    "x",
    "y"
  ), c("min", "max"))), proj4string = new(
    "CRS",
    projargs = "+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +no_defs")
)

## TESTS #######################

test_that("movingmarker", {
  m <- expect_warning(
    leaflet() %>%
      addMovingMarker(
        data = df,
        movingOptions = movingMarkerOptions(autostart = TRUE, loop = TRUE),
        label = "I am a pirate!",
        popup = "Arrr"
      )
  )
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[1]]$method, "addMovingMarker")

  ## Data as coordinates
  df1 <- sf::st_as_sf(df)
  df1 <- st_coordinates(df1)
  m <- leaflet() %>%
    addMovingMarker(
      lng = df1[, 1], lat = df1[, 2],
      movingOptions = movingMarkerOptions(autostart = TRUE, loop = TRUE),
      label = "I am a pirate!",
      popup = "Arrr"
    )
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[1]]$method, "addMovingMarker")

  ## Use awesomeIcon
  shipIcon2 <- makeAwesomeIcon(icon = "arrow-up", markerColor = "black")
  m <- leaflet() %>%
    addMovingMarker(
      lng = df1[, 1], lat = df1[, 2], icon = shipIcon2,
      movingOptions = movingMarkerOptions(autostart = TRUE, loop = TRUE),
      label = "I am a pirate!",
      popup = "Arrr"
    )
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[1]]$method, "addMovingMarker")
  expect_contains(
    vapply(m$dependencies, function(x) x$name, character(1)),
    c("lfx-movingmarker", "leaflet-awesomemarkers")
  )

  ## Data is Simple Feature LINESTRING
  df1 <- sf::st_as_sf(df)
  m <- expect_warning(
    leaflet() %>%
      addMovingMarker(
        data = df1,
        movingOptions = movingMarkerOptions(autostart = TRUE, loop = TRUE),
        label = "I am a pirate!",
        popup = "Arrr"
      )
  )
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[1]]$method, "addMovingMarker")
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-movingmarker")

  ## Data is Simple Feature POINT
  df1 <- sf::st_as_sf(df)[1, ]
  df1 <- expect_warning(sf::st_cast(df1, "POINT"))
  m <- expect_warning(
    leaflet() %>%
      addMovingMarker(
        data = df1,
        movingOptions = movingMarkerOptions(autostart = TRUE, loop = TRUE),
        label = "I am a pirate!",
        popup = "Arrr"
      )
  )
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[1]]$method, "addMovingMarker")

  dfsf <- sf::st_as_sf(df)
  dfsf <- expect_warning(st_cast(dfsf, "POINT"))
  dfsf <- st_transform(dfsf, 4326)
  m <- leaflet() %>%
    addMovingMarker(data = dfsf) %>%
    startMoving()
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "startMoving")

  m <- leaflet() %>%
    addMovingMarker(data = dfsf) %>%
    startMoving()
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "startMoving")

  m <- leaflet() %>%
    addMovingMarker(data = dfsf) %>%
    stopMoving()
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "stopMoving")

  m <- leaflet() %>%
    addMovingMarker(data = dfsf) %>%
    pauseMoving()
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "pauseMoving")

  m <- leaflet() %>%
    addMovingMarker(data = dfsf) %>%
    resumeMoving()
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "resumeMoving")

  m <- leaflet() %>%
    addMovingMarker(data = dfsf) %>%
    addLatLngMoving(latlng = list(33, -67), duration = 2000)
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "addLatLngMoving")
  expect_length(m$x$calls[[length(m$x$calls)]]$args[[2]], 2)
  expect_equal(m$x$calls[[length(m$x$calls)]]$args[[3]], 2000)

  m <- leaflet() %>%
    addMovingMarker(data = dfsf) %>%
    moveToMoving(latlng = list(33, -67), duration = 2000)
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "moveToMoving")
  expect_length(m$x$calls[[length(m$x$calls)]]$args[[2]], 2)
  expect_equal(m$x$calls[[length(m$x$calls)]]$args[[3]], 2000)

  m <- leaflet() %>%
    addMovingMarker(data = dfsf) %>%
    addStationMoving(pointIndex = 2, duration = 5000)
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "addStationMoving")
  expect_equal(m$x$calls[[length(m$x$calls)]]$args[[2]], 2)
  expect_equal(m$x$calls[[length(m$x$calls)]]$args[[3]], 5000)
})
