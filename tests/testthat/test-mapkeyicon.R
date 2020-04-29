
test_that("mapkey", {

  m <- leaflet()  %>%
    addMapkeyMarkers(data = breweries91,
                     icon = makeMapkeyIcon(icon = "mapkey",
                                           iconSize = 30,
                                           boxShadow = FALSE,
                                           background = "transparent"),
                     group = "mapkey",
                     label = ~state, popup = ~village)
  expect_is(m, "leaflet")

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-mapkeyicon")

  iconSet = mapkeyIconList(
    red = makeMapkeyIcon(icon = "boundary_stone",
                         color = "#725139",
                         background = '#f2c357',
                         iconSize = 30,
                         boxShadow = FALSE),
    blue = makeMapkeyIcon(icon = "traffic_signal",
                          color = "#0000ff",
                          iconSize = 12,
                          boxShadow = FALSE,
                          background = "transparent"),
    buddha = makeMapkeyIcon(icon = "buddhism",
                            color = "red",
                            iconSize = 12,
                            boxShadow = FALSE,
                            background = "transparent"))
  expect_is(iconSet, "leaflet_mapkey_icon_set")

  m <- leaflet()  %>%
    addMapkeyMarkers(data = breweries91, icon = iconSet,
                     group = "mapkey",
                     label = ~state, popup = ~village)
  expect_is(m, "leaflet")

  m <- leaflet()  %>%
    addMapkeyMarkers(data = breweries91, icon = iconSet,
                     group = "mapkey",
                     clusterOptions = markerClusterOptions(),
                     label = ~state, popup = ~village)
  expect_is(m, "leaflet")
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps) - 1]]$name, "lfx-mapkeyicon")
  expect_equal(deps[[length(deps)]]$name, "leaflet-markercluster")

  m <- mapkeyIcons()
  expect_is(m, "list")

  m <- leaflet()  %>%
    addMapkeyMarkers(data = breweries91,
                     icon = m)
  expect_is(m, "leaflet")

})

test_that("mapkey-error", {

  expect_error(mapkeyIconList(
    red = list(icon = "boundary_stone",
               color = "#725139",
               background = '#f2c357',
               iconSize = 30,
               boxShadow = FALSE))
  )

})


