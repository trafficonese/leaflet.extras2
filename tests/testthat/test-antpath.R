
test_that("antpath", {
  m <- leaflet() %>%
    addAntpath(data = atlStorms2005, layerId = "id")
  expect_is(m, "leaflet")

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-antpath")

  m <- m %>% removeAntpath(layerId = "id")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method,
               "removeAntpath")

  m <- m %>% clearAntpath()
  expect_equal(m$x$calls[[length(m$x$calls)]]$method,
               "clearAntpath")

})
