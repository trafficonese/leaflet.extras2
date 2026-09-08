test_that("wms", {
  m <- leaflet() %>%
    addTiles(group = "base") %>%
    setView(9, 50, 5) %>%
    addWMS(
      baseUrl = "https://maps.dwd.de/geoserver/dwd/wms",
      layers = "dwd:BRD_1km_winddaten_10m",
      group = "wms",
      attribution = "WMS-ATTRIB-TEST",
      popupOptions = popupOptions(maxWidth = 600),
      options = WMSTileOptions(
        transparent = TRUE,
        format = "image/png",
        info_format = "text/html"
      )
    )

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-wms")

  last <- m$x$calls[[length(m$x$calls)]]
  expect_equal(last$method, "addWMS")
  expect_equal(last$args[[3]], "wms")
  expect_equal(last$args[[4]]$attribution, "WMS-ATTRIB-TEST")
})

test_that("wms layer owns attribution in JS", {
  js <- paste(
    readLines(system.file("htmlwidgets/lfx-wms/leaflet.wms.js", package = "leaflet.extras2")),
    collapse = "\n"
  )
  expect_match(js, "getAttribution")
  expect_match(js, "this\\._source.options.attribution")
})


test_that("wms-error", {
  expect_error(leaflet() %>%
    addWMS(baseUrl = "https://maps.dwd.de/geoserver/dwd/wms"))
})
