library(sf)

test_that("movingmarker", {

  ## Data is a SpatialLinesDataFrame
  df <- atlStorms2005[1,]
  m <- leaflet()  %>%
    addMovingMarker(data = df,
                    movingOptions = movingMarkerOptions(autostart = TRUE, loop = TRUE),
                    label="I am a pirate!",
                    popup="Arrr")
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[1]]$method, "addMovingMarker")

  ## Data as coordinates
  df <- sf::st_as_sf(atlStorms2005)[1,]
  df <- st_coordinates(df)
  m <- leaflet()  %>%
    addMovingMarker(lng = df[,1], lat = df[,2],
                    movingOptions = movingMarkerOptions(autostart = TRUE, loop = TRUE),
                    label="I am a pirate!",
                    popup="Arrr")
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[1]]$method, "addMovingMarker")

  ## Use awesomeIcon
  shipIcon2 <- makeAwesomeIcon(icon = "arrow-up", markerColor = "black")
  m <- leaflet()  %>%
    addMovingMarker(lng = df[,1], lat = df[,2], icon = shipIcon2,
                    movingOptions = movingMarkerOptions(autostart = TRUE, loop = TRUE),
                    label="I am a pirate!",
                    popup="Arrr")
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[1]]$method, "addMovingMarker")
  expect_equal(m$dependencies[[1]]$name, "lfx-movingmarker")
  expect_equal(m$dependencies[[2]]$name, "leaflet-awesomemarkers")

  ## Data is Simple Feature LINESTRING
  df <- sf::st_as_sf(atlStorms2005)[1,]
  m <- leaflet()  %>%
      addMovingMarker(data = df,
                      movingOptions = movingMarkerOptions(autostart = TRUE, loop = TRUE),
                      label="I am a pirate!",
                      popup="Arrr")
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[1]]$method, "addMovingMarker")
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-movingmarker")

  ## Data is Simple Feature POINT
  df <- sf::st_as_sf(atlStorms2005)[1,]
  df <- sf::st_cast(df, "POINT")
  m <- leaflet() %>%
      addMovingMarker(data = df,
                      movingOptions = movingMarkerOptions(autostart = TRUE, loop = TRUE),
                      label="I am a pirate!",
                      popup="Arrr")
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[1]]$method, "addMovingMarker")


  m <- leaflet()  %>%
      addMovingMarker(data = df) %>%
      startMoving()
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "startMoving")

  m <- leaflet()  %>%
      addMovingMarker(data = df) %>%
      startMoving()
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "startMoving")

  m <- leaflet()  %>%
      addMovingMarker(data = df) %>%
      stopMoving()
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "stopMoving")

  m <- leaflet()  %>%
      addMovingMarker(data = df) %>%
      pauseMoving()
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "pauseMoving")

  m <- leaflet()  %>%
      addMovingMarker(data = df) %>%
      resumeMoving()
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "resumeMoving")


  m <- leaflet()  %>%
      addMovingMarker(data = df) %>%
      addLatLngMoving(latlng = list(33, -67), duration = 2000)
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "addLatLngMoving")
  expect_length(m$x$calls[[length(m$x$calls)]]$args[[2]], 2)
  expect_equal(m$x$calls[[length(m$x$calls)]]$args[[3]], 2000)

  m <- leaflet()  %>%
      addMovingMarker(data = df) %>%
      moveToMoving(latlng = list(33, -67), duration = 2000)
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "moveToMoving")
  expect_length(m$x$calls[[length(m$x$calls)]]$args[[2]], 2)
  expect_equal(m$x$calls[[length(m$x$calls)]]$args[[3]], 2000)

  m <- leaflet()  %>%
      addMovingMarker(data = df) %>%
      addStationMoving(pointIndex = 2, duration = 5000)
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "addStationMoving")
  expect_equal(m$x$calls[[length(m$x$calls)]]$args[[2]], 2)
  expect_equal(m$x$calls[[length(m$x$calls)]]$args[[3]], 5000)

})


