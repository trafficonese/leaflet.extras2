
test_that("timeslider", {
  ## Test Single Trail ######################
  data <- suppressWarnings(sf::st_as_sf(leaflet::atlStorms2005[1,]))
  data <- suppressWarnings(st_cast(data, "POINT"))
  data$time = as.POSIXct(
    seq.POSIXt(Sys.time() - 1000, Sys.time(), length.out = nrow(data)))

  m <- leaflet() %>%
    addTimeslider(data = data,
                  options = timesliderOptions(
                    position = "topright",
                    timeAttribute = "time",
                    range = TRUE))
  expect_is(m, "leaflet")
  expect_identical(m$x$calls[[1]]$method, "addTimeslider")
  expect_is(m$x$calls[[1]]$args[[1]], "geojson")
  expect_true(inherits(m$x$calls[[1]]$args[[1]], "geojson"))

  m <- leaflet() %>%
    addTimeslider(data = data,
                  popup = ~sprintf("Name: %s", Name),
                  options = timesliderOptions(
                    position = "topright",
                    timeAttribute = "time",
                    range = TRUE))

  expect_is(m, "leaflet")
  expect_identical(m$x$calls[[1]]$method, "addTimeslider")
  expect_is(m$x$calls[[1]]$args[[1]], "geojson")
  expect_true(inherits(m$x$calls[[1]]$args[[1]], "geojson"))


  data <- suppressWarnings(sf::st_as_sf(leaflet::atlStorms2005))
  data$time = as.POSIXct(
    seq.POSIXt(Sys.time() - 1000, Sys.time(), length.out = nrow(data)))
  m <- leaflet() %>%
    addTimeslider(data = data, fill = FALSE,
                  options = timesliderOptions(
                    position = "topright",
                    timeAttribute = "time",
                    range = FALSE))
  expect_is(m, "leaflet")
  expect_identical(m$x$calls[[1]]$method, "addTimeslider")
  expect_is(m$x$calls[[1]]$args[[1]], "geojson")
  expect_true(inherits(m$x$calls[[1]]$args[[1]], "geojson"))

  m <- m %>%
    removeTimeslider()
  expect_identical(m$x$calls[[length(m$x$calls)]]$method, "removeTimeslider")

  m <- leaflet() %>%
    addTimeslider(data = data, fill = FALSE,
                  label = ~Name,
                  options = timesliderOptions(
                    position = "topright",
                    timeAttribute = "time",
                    range = FALSE))
  expect_is(m, "leaflet")
  expect_identical(m$x$calls[[1]]$method, "addTimeslider")
  expect_is(m$x$calls[[1]]$args[[1]], "geojson")
  expect_true(inherits(m$x$calls[[1]]$args[[1]], "geojson"))

  m <- leaflet() %>%
    addTimeslider(data = data, fill = FALSE,
                  label = data$Name,
                  options = timesliderOptions(
                    position = "topright",
                    timeAttribute = "time",
                    range = FALSE))
  expect_is(m, "leaflet")
  expect_identical(m$x$calls[[1]]$method, "addTimeslider")
  expect_is(m$x$calls[[1]]$args[[1]], "geojson")
  expect_true(inherits(m$x$calls[[1]]$args[[1]], "geojson"))

})
