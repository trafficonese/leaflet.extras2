test_that("spin", {
  m <- leaflet() %>%
    addSpinner()
  expect_is(m, "leaflet")

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-spin")

  m <- m %>% startSpinner()
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "spinner")
  expect_true(m$x$calls[[length(m$x$calls)]]$args[[1]])

  m <- m %>% stopSpinner()
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "spinner")
  expect_false(m$x$calls[[length(m$x$calls)]]$args[[1]])

  m <- m %>% startSpinner(options = list("lines" = 7, "width" = 12))
  expect_equal(m$x$calls[[length(m$x$calls)]]$args[[2]], list("lines" = 7, "width" = 12))
})
