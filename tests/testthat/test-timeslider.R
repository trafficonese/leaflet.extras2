
test_that("timeslider", {
  ## Test Single Trail ######################
  data <- sf::st_as_sf(leaflet::atlStorms2005[1,])
  data <- st_cast(data, "POINT")
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
  expect_identical(m$x$calls[[1]]$args[[1]], sf_geojson(data))
})
