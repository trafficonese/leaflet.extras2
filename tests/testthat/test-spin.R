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
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$args[[2]],
    list("lines" = 7, "width" = 12)
  )
})

test_that("spin dependency ships minified scripts", {
  dep <- findDependencies(leaflet() %>% addSpinner())
  spin <- dep[[length(dep)]]
  expect_equal(spin$name, "lfx-spin")
  expect_true("spin.min.js" %in% spin$script)
  expect_true("leaflet.spin.min.js" %in% spin$script)
})

test_that("spinWhile needs a Shiny session", {
  expect_error(spinWhile("leaf", NULL), "Shiny session")
})
