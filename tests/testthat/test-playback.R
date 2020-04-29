
test_that("playback", {

  data <- '{
    "type": "Feature",
    "geometry": {
      "type": "MultiPoint",
      "coordinates": [
        [-123.2653968, 44.54962188],
        [-123.2653999, 44.54961188],
        [-123.2654000, 44.54960188],
        [-123.2654259, 44.54951009]
      ]
  },
    "properties": {
      "time": [1366067072000, 1366067074000, 1366067076000, 1366067078000]
    }
  }'

  m <- leaflet() %>%
    addTiles() %>%
    addPlayback(data = data,
                options = playbackOptions(radius = 3),
                pathOpts = pathOptions(weight = 5))
  expect_is(m, "leaflet")
  expect_identical(m$x$calls[[2]]$method, "addPlayback")
  expect_identical(m$x$calls[[2]]$args[[1]], data)

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-playback")

  m <- m %>%
    removePlayback()
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method,
               "removePlayback")

  # data = "https://raw.githubusercontent.com/hallahan/LeafletPlayback/master/data/demo/drive.json"
  # if (requireNamespace("jsonlite", quietly = TRUE)) {
  #   m <- leaflet() %>%
  #     addTiles() %>%
  #     addPlayback(data = data,
  #                 options = playbackOptions(radius = 3),
  #                 pathOpts = pathOptions(weight = 5))
  #   expect_is(m, "leaflet")
  #   expect_identical(m$x$calls[[2]]$method, "addPlayback")
  # } else {
  #   expect_error(
  #     leaflet() %>%
  #       addTiles() %>%
  #       addPlayback(data = data)
  #   )
  # }

})

test_that("playback-error", {

  expect_error(
    leaflet() %>%
      addPlayback(data = breweries91,
                  options = playbackOptions(radius = 3),
                  pathOpts = pathOptions(weight = 5)))

})


