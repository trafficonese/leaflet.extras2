library(shiny)

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

  m <- leaflet() %>%
    addReachability(options = reachabilityOptions(
      collapsed = FALSE,
      drawButtonContent = icon("pen"),
      deleteButtonContent = icon("x"),
      distanceButtonContent = icon("map-marked"),
      timeButtonContent = icon("clock")
    ))
  expect_is(m, "leaflet")
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "font-awesome")
  expect_equal(deps[[length(deps) - 1]]$name, "lfx-reachability")
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "addReachability"
  )
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$args[[1]]$drawButtonContent,
    as.character(icon("pen"))
  )

  m <- leaflet() %>%
    addReachability(options = reachabilityOptions(
      collapsed = FALSE,
      drawButtonContent = as.character(icon("pen")),
      timeButtonContent = as.character(icon("clock"))
    ))
  expect_is(m, "leaflet")
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-reachability")
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "addReachability"
  )
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$args[[1]]$drawButtonContent,
    as.character(icon("pen"))
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
