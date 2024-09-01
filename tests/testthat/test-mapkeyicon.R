test_that("mapkey", {
  m <- leaflet() %>%
    addMapkeyMarkers(
      data = breweries91,
      icon = makeMapkeyIcon(
        icon = "mapkey",
        iconSize = 30,
        boxShadow = FALSE,
        background = "transparent"
      ),
      group = "mapkey",
      label = ~state, popup = ~village
    )
  expect_is(m, "leaflet")

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-mapkeyicon")

  iconSet <- mapkeyIconList(
    red = makeMapkeyIcon(
      icon = "boundary_stone",
      color = "#725139",
      background = "#f2c357",
      iconSize = 30,
      boxShadow = FALSE
    ),
    blue = makeMapkeyIcon(
      icon = "traffic_signal",
      color = "#0000ff",
      iconSize = 12,
      boxShadow = FALSE,
      background = "transparent"
    ),
    buddha = makeMapkeyIcon(
      icon = "buddhism",
      color = "red",
      iconSize = 12,
      boxShadow = FALSE,
      background = "transparent"
    )
  )
  expect_is(iconSet, "leaflet_mapkey_icon_set")

  m <- leaflet() %>%
    addMapkeyMarkers(
      data = breweries91, icon = iconSet,
      group = "mapkey",
      label = ~state, popup = ~village
    )
  expect_is(m, "leaflet")

  m <- leaflet() %>%
    addMapkeyMarkers(
      data = breweries91, icon = iconSet,
      group = "mapkey",
      clusterOptions = markerClusterOptions(),
      label = ~state, popup = ~village
    )
  expect_is(m, "leaflet")
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps) - 1]]$name, "lfx-mapkeyicon")
  expect_equal(deps[[length(deps)]]$name, "leaflet-markercluster")

  m <- mapkeyIcons()
  expect_is(m, "list")

  m <- leaflet() %>%
    addMapkeyMarkers(
      data = breweries91,
      icon = m
    )
  expect_is(m, "leaflet")


  cities <- structure(
    list(
      City = structure(1:6, .Label = c(
        "Boston", "Hartford", "New York City",
        "Philadelphia", "Pittsburgh",
        "Providence"
      ), class = "factor"),
      Lat = c(42.3601, 41.7627, 40.7127, 39.95, 40.4397, 41.8236),
      Long = c(-71.0589, -72.6743, -74.0059, -75.1667, -79.9764, -71.4222),
      Pop = c(645966L, 125017L, 8406000L, 1553000L, 305841L, 177994L)
    ),
    class = "data.frame", row.names = c(NA, -6L)
  )

  icon.pop <- mapkeyIcons(
    color = ifelse(cities$Pop < 500000, "blue", "red"),
    iconSize = ifelse(cities$Pop < 500000, 20, 50)
  )
  m <- leaflet(cities) %>%
    addTiles() %>%
    addMapkeyMarkers(
      lng = ~Long, lat = ~Lat,
      label = ~City,
      icon = icon.pop
    )
  expect_is(m, "leaflet")

  cities$PopCat <- "blue"
  cities[cities$Pop > 500000, ]$PopCat <- "red"
  iconSet <- mapkeyIconList(
    blue = makeMapkeyIcon(
      icon = "traffic_signal",
      color = "#0000ff",
      iconSize = 12,
      boxShadow = FALSE,
      background = "transparent"
    ),
    red = makeMapkeyIcon(
      icon = "buddhism",
      color = "red",
      iconSize = 12,
      boxShadow = FALSE,
      background = "transparent"
    )
  )
  m <- leaflet(cities) %>%
    addTiles() %>%
    addMapkeyMarkers(
      lng = ~Long, lat = ~Lat,
      label = ~City,
      labelOptions = rep(labelOptions(noHide = T), nrow(cities)),
      icon = ~ iconSet[PopCat]
    )
  expect_is(m, "leaflet")

  m <- leaflet(cities) %>%
    addTiles() %>%
    addMapkeyMarkers(
      lng = ~Long, lat = ~Lat,
      label = ~City,
      labelOptions = rep(labelOptions(noHide = T), nrow(cities)),
      icon = ~ iconSet[as.factor(PopCat)]
    )


  m <- leaflet(cities) %>%
    addTiles() %>%
    addMapkeyMarkers(
      lng = ~Long, lat = ~Lat,
      label = ~City,
      clusterOptions = markerClusterOptions(),
      icon = ~ iconSet[PopCat]
    )
  expect_is(m, "leaflet")

  expect_error(
    leaflet(cities) %>% addTiles() %>%
      addMapkeyMarkers(
        lng = ~Long, lat = ~Lat, label = ~City,
        icon = ~ iconSet[list()]
      )
  )
})

test_that("mapkey-error", {
  expect_error(
    mapkeyIconList(
      red = list(
        icon = "boundary_stone",
        color = "#725139",
        background = "#f2c357",
        iconSize = 30,
        boxShadow = FALSE
      )
    )
  )
})
