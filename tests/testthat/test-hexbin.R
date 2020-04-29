
test_that("hexbin", {
  n <- 1000
  df <- data.frame(lat = rnorm(n, 42.0285, .01),
                   lng = rnorm(n, -93.65, .01))

  m <- leaflet()  %>%
    addTiles() %>%
    addHexbin(lng = df$lng, lat = df$lat,
              options = hexbinOptions(
                tooltip = FALSE,
                colorRange = c("red", "yellow", "blue"),
                radiusRange = c(10, 20)
              ))

  expect_is(m, "leaflet")

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-hexbin")

  m <- m %>% clearHexbin()
  expect_equal(m$x$calls[[length(m$x$calls)]]$method,
               "clearHexbin")

  ## Show/Hide ###################
  m <- m %>% showHexbin()
  expect_equal(m$x$calls[[length(m$x$calls)]]$method,
               "showHexbin")
  m <- m %>% hideHexbin()
  expect_equal(m$x$calls[[length(m$x$calls)]]$method,
               "hideHexbin")

  ## Update Hexbin ###################
  df1 <- data.frame(lat = rnorm(n, 42.0285, .01),
                   lng = rnorm(n, -93.65, .01))
  m <- m %>% updateHexbin(data = df1,
                          lng = ~lng, lat = ~lat)
  expect_equal(m$x$calls[[length(m$x$calls)]]$method,
               "updateHexbin")
  expect_identical(m$x$calls[[length(m$x$calls)]]$args[[1]][,"lng"],
                   df1$lng)
  expect_identical(m$x$calls[[length(m$x$calls)]]$args[[1]][,"lat"],
                   df1$lat)

  m <- m %>% updateHexbin(colorRange = c("red", "yellow", "blue"))
  expect_equal(m$x$calls[[length(m$x$calls)]]$method,
               "updateHexbin")
  expect_identical(m$x$calls[[length(m$x$calls)]]$args[[2]],
                   c("red", "yellow", "blue"))

})
