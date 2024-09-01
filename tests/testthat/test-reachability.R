test_that("reachability", {
  Sys.setenv("OPRS" = "Your_API_Key")

  m <- leaflet() %>%
    addReachability()
  expect_is(m, "leaflet")

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-reachability")
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "addReachability"
  )

  m <- m %>%
    removeReachability()
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "removeReachability"
  )
})

test_that("reachability-error", {
  Sys.unsetenv("OPRS")

  expect_error(
    leaflet() %>%
      addReachability()
  )
})
