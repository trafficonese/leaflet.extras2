test_that("sidebyside", {
  m <- leaflet(quakes) %>%
    addMapPane("left", zIndex = 0) %>%
    addMapPane("right", zIndex = 0) %>%
    addTiles(
      group = "base", layerId = "baseid",
      options = pathOptions(pane = "right")
    ) %>%
    addProviderTiles(providers$CartoDB.DarkMatter,
      group = "carto", layerId = "cartoid",
      options = pathOptions(pane = "left")
    ) %>%
    addCircleMarkers(
      data = breweries91[1:15, ], color = "blue", group = "blue",
      options = pathOptions(pane = "left")
    ) %>%
    addCircleMarkers(data = breweries91[15:20, ],
                     color = "yellow", group = "yellow") %>%
    addCircleMarkers(
      data = breweries91[15:30, ], color = "red", group = "red",
      options = pathOptions(pane = "right")
    ) %>%
    addLayersControl(overlayGroups = c("blue", "red", "yellow")) %>%
    addSidebyside(
      layerId = "sidecontrols",
      rightId = "baseid",
      leftId = "cartoid"
    )
  expect_is(m, "leaflet")

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-sidebyside")

  m <- leaflet() %>%
    removeSidebyside("sidecontrols")
  expect_is(m, "leaflet")
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "removeSidebyside"
  )
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$args[[1]],
    "sidecontrols"
  )
})
