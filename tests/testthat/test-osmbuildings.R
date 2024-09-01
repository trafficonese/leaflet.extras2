
create_test_map <- function() {
  leaflet() %>% addTiles()
}

# Test suite for addBuildings
test_that("addBuildings adds dependencies and invokes method correctly", {
  map <- create_test_map()

  # Call addBuildings without additional arguments
  map <- addBuildings(map)

  # Check if the dependencies are added
  expect_true(any(sapply(map$dependencies,
                         function(dep) dep$name) == "lfx-building"))

  # Check if invokeMethod is called with correct arguments
  expect_equal(map$x$calls[[2]]$method, "addBuilding")
  expect_equal(
    map$x$calls[[2]]$args[[1]],
    "https://{s}.data.osmbuildings.org/0.2/59fcc2e8/tile/{z}/{x}/{y}.json")
})

test_that("addBuildings handles custom eachFn, clickFn, and data", {
  map <- create_test_map()

  # Define custom JavaScript functions using htmlwidgets::JS
  each_fn <- htmlwidgets::JS("function(e) { console.log('each:', e); }")
  click_fn <- htmlwidgets::JS("function(e) { console.log('click:', e); }")

  # Define custom GeoJSON data
  geojson_data <- list(
    type = "FeatureCollection",
    features = list(
      list(
        type = "Feature",
        properties = list(height = 100, color = "#ff0000"),
        geometry = list(
          type = "Polygon",
          coordinates = list(
            list(
              c(13.39631974697113, 52.52184840804295),
              c(13.39496523141861, 52.521166220963536),
              c(13.395150303840637, 52.52101770514734),
              c(13.396652340888977, 52.52174559105107),
              c(13.39631974697113, 52.52184840804295)
            )
          )
        )
      )
    )
  )

  map <- addBuildings(map, eachFn = each_fn,
                      clickFn = click_fn, data = geojson_data)

  # Check if the JavaScript functions and data are passed correctly
  expect_equal(map$x$calls[[2]]$args[[3]], each_fn)
  expect_equal(map$x$calls[[2]]$args[[4]], click_fn)
  expect_equal(map$x$calls[[2]]$args[[5]], geojson_data)
})

# Test suite for updateBuildingTime
test_that("updateBuildingTime updates the time correctly", {
  map <- create_test_map()
  time <- Sys.time()

  map <- addBuildings(map) %>%
    updateBuildingTime(time) %>%
    setView(13.40, 52.51836, 15)

  # Check if invokeMethod is called with the correct timestamp
  expect_equal(map$x$calls[[3]]$method, "updateBuildingTime")
  expect_equal(map$x$calls[[3]]$args[[1]], time)
})

# Test suite for setBuildingStyle
test_that("setBuildingStyle applies styles correctly", {
  map <- create_test_map()
  style <- list(color = "#0000ff", wallColor = "#0000ff",
                roofColor = "blue", shadows = FALSE)

  map <- addBuildings(map) %>%
    setBuildingStyle(style) %>%
    setView(13.40, 52.51836, 15)

  # Check if invokeMethod is called with the correct style
  expect_equal(map$x$calls[[3]]$method, "setBuildingStyle")
  expect_equal(map$x$calls[[3]]$args[[1]], style)
})

test_that("setBuildingStyle uses default styles if not provided", {
  map <- create_test_map()

  map <- addBuildings(map) %>%
    setBuildingStyle() %>%
    setView(13.40, 52.51836, 15)
  # map

  # Check if invokeMethod is called with the default styles
  default_style <- list(color = "#ffcc00", wallColor = "#ffcc00",
                        roofColor = "orange", shadows = TRUE)
  expect_equal(map$x$calls[[3]]$"method", "setBuildingStyle")
  expect_equal(map$x$calls[[3]]$args[[1]], default_style)
})

# Test suite for setBuildingData
test_that("setBuildingData updates the building data correctly", {
  map <- create_test_map()

  # Define custom GeoJSON data
  geojson_data <- list(
    type = "FeatureCollection",
    features = list(
      list(
        type = "Feature",
        properties = list(height = 100, color = "#ff0000"),
        geometry = list(
          type = "Polygon",
          coordinates = list(
            list(
              c(13.39631974697113, 52.52184840804295),
              c(13.39496523141861, 52.521166220963536),
              c(13.395150303840637, 52.52101770514734),
              c(13.396652340888977, 52.52174559105107),
              c(13.39631974697113, 52.52184840804295)
            )
          )
        )
      )
    )
  )

  map <- addBuildings(map,
    buildingURL = NULL,
    data = geojson_data
  ) %>%
    setView(13.40, 52.51836, 15)
  # map
  # Check if invokeMethod is called with the correct data
  expect_equal(map$x$calls[[2]]$method, "addBuilding")
  expect_equal(map$x$calls[[2]]$args[[5]], geojson_data)

  map <- addBuildings(create_test_map(), buildingURL = NULL) %>%
    setBuildingData(geojson_data) %>%
    setView(13.40, 52.51836, 15)
  # map
  # Check if invokeMethod is called with the correct data
  expect_equal(map$x$calls[[2]]$method, "addBuilding")
  expect_true(is.null(unlist(map$x$calls[[2]]$args)))
  expect_equal(map$x$calls[[3]]$method, "setBuildingData")
  expect_equal(map$x$calls[[3]]$args[[1]], geojson_data)
})
