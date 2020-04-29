library(jsonlite)

test_that("velocity", {

  content <- "https://raw.githubusercontent.com/danwild/leaflet-velocity/master/demo/wind-gbr.json"

  contentdf <- jsonlite::fromJSON(content)
  m <- leaflet() %>%
    addVelocity(content = contentdf)
  expect_is(m, "leaflet")

  m <- leaflet() %>%
    addVelocity(content = content, options = velocityOptions(
      colorScale = matrix(1:99, ncol = 3)
    ))
  expect_is(m, "leaflet")

  m <- leaflet() %>%
    addTiles(group = "base") %>%
    addVelocity(content = content, group = "velo", layerId = "veloid") %>%
    addLayersControl(baseGroups = "base", overlayGroups = "velo")
  expect_is(m, "leaflet")

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-velocity")

  m <- m %>%
    setOptionsVelocity("veloid",
                       options = velocityOptions(
                         speedUnit = "kt",
                         colorScale = c("#F2A100", "#DC354B", "#272D37")))
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method,
               "setOptionsVelocity")
  expect_equal(m$x$calls[[length(m$x$calls)]]$args[[1]],
               "veloid")
  expect_equal(m$x$calls[[length(m$x$calls)]]$args[[2]]$colorScale,
               c("#F2A100", "#DC354B", "#272D37"))
  expect_equal(m$x$calls[[length(m$x$calls)]]$args[[2]]$speedUnit,
               "kt")

  m <- m %>%
    removeVelocity(group = "velo")
  expect_is(m, "leaflet")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method,
               "removeVelocity")
  expect_equal(m$x$calls[[length(m$x$calls)]]$args[[1]],
               "velo")

})

test_that("velocity-error", {

  expect_error(
    leaflet() %>%
      addVelocity(content = NULL, group = "velo", layerId = "veloid"))

  expect_error(
    leaflet() %>%
      addVelocity(content = list(), group = "velo", layerId = "veloid"))

})
