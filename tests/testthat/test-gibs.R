
test_that("gibs", {
  layers <- gibs_layers$title[c(35, 128, 185)]

  m <- leaflet()  %>%
    addGIBS(layers, dates = Sys.Date(), group = "singlegroup")
  expect_is(m, "leaflet")

  m <- leaflet()  %>%
    addTiles() %>%
    setView(9, 50, 4) %>%
    addGIBS(layers = layers,
            dates = Sys.Date() - 1,
            group = layers) %>%
    addLayersControl(overlayGroups = layers)
  expect_is(m, "leaflet")

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-gibs")

  m <- m %>% setDate(dates = Sys.Date() - 5, layers = layers)
  expect_equal(m$x$calls[[length(m$x$calls)]]$method,
               "setDate")
  expect_equal(m$x$calls[[length(m$x$calls)]]$args[[2]],
               Sys.Date() - 5)

  m <- m %>% setTransparent(layers, transparent = F)
  expect_equal(m$x$calls[[length(m$x$calls)]]$method,
               "setTransparent")
  expect_equal(m$x$calls[[length(m$x$calls)]]$args[[2]],
               FALSE)

})

test_that("gibs-error", {
  layers <- gibs_layers$title[c(35, 128, 185)]

  expect_error(
    leaflet()  %>%
      addGIBS(layers = NULL, dates = Sys.Date() - 1,group = layers)
  )

  expect_error(
    leaflet()  %>%
      addGIBS("nonexistent", dates = Sys.Date())
  )

  expect_error(
    leaflet()  %>%
      addGIBS(layers, dates = NULL, group = layers)
  )

  expect_error(
    leaflet()  %>%
      addGIBS(layers, dates = Sys.Date()) %>%
      setDate()
  )
  expect_error(
    leaflet()  %>%
      addGIBS(layers, dates = Sys.Date()) %>%
      setDate(dates = Sys.Date())
  )
  expect_error(
    leaflet()  %>%
      addGIBS(layers, dates = Sys.Date()) %>%
      setDate(layers)
  )

  expect_error(
    leaflet()  %>%
      addGIBS(layers,dates = Sys.Date()) %>%
      setTransparent()
  )

})

