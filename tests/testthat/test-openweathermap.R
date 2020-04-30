
test_that("openweather", {

  Sys.setenv("OPENWEATHERMAP" = 'Your_API_Key')

  m <- leaflet()  %>%
    addTiles() %>% setView(9, 50, 6) %>%
    addOpenweatherTiles(layers = "wind")
  expect_is(m, "leaflet")

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-openweather")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method,
               "addOpenweather")

  m <- leaflet()  %>%
    addTiles() %>% setView(9, 50, 6) %>%
    addOpenweatherTiles(layers = "wind",
                        group = "owm")
  expect_is(m, "leaflet")

  m <- leaflet()  %>%
    addTiles() %>% setView(9, 50, 6) %>%
    addOpenweatherTiles(layers = c("wind","precipitation"),
                        group = "owm")
  expect_is(m, "leaflet")

  ## Current Weather Marker/Popups
  m <- leaflet()  %>%
    addOpenweatherCurrent(options = openweatherCurrentOptions(
      lang = "en", popup = TRUE))
  expect_is(m, "leaflet")
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-openweather")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method,
               "addOpenweatherCurrent")


})

test_that("openweather-error-warnings", {
  Sys.unsetenv("OPENWEATHERMAP")

  expect_error(
    leaflet()  %>%
      addOpenweatherTiles(layers = "wind")
  )

  expect_error(
    leaflet()  %>%
      addOpenweatherCurrent(options = openweatherCurrentOptions(
        lang = "en", popup = TRUE))
  )

  expect_warning(
    leaflet()  %>%
      addOpenweatherTiles(apikey = "somekey",
                          layers = "wronglayer")
  )

  expect_warning(
    leaflet()  %>%
      addOpenweatherTiles(apikey = "somekey",
                          layers = c("wronglayer1",
                                     "wronglayer2"))
  )

  expect_warning(
    leaflet()  %>%
      addOpenweatherTiles(apikey = "somekey",
                          layers = c("wind",
                                     "clouds"),
                          layerId = "id1")
  )

})

