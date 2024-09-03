test_that("wms", {
  m <- leaflet() %>%
    addTiles(group = "base") %>%
    setView(9, 50, 5) %>%
    addWMS(
      baseUrl = "https://maps.dwd.de/geoserver/dwd/wms",
      layers = "dwd:BRD_1km_winddaten_10m",
      popupOptions = popupOptions(maxWidth = 600),
      options = WMSTileOptions(
        transparent = TRUE,
        format = "image/png",
        info_format = "text/html"
      )
    )

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-wms")
})


test_that("wms-error", {
  expect_error(leaflet() %>%
    addWMS(baseUrl = "https://maps.dwd.de/geoserver/dwd/wms"))
})
