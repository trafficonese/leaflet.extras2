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

wms_js <- function() {
  paste(
    readLines(system.file("htmlwidgets/lfx-wms/leaflet.wms.js", package = "leaflet.extras2")),
    collapse = "\n"
  )
}

test_that("wms layer owns attribution in JS", {
  js <- wms_js()
  expect_match(js, "getAttribution")
  expect_match(js, "this\\._source.options.attribution")
})

test_that("wms GetFeatureInfo accepts redirects and HTTPS upgrade", {
  js <- wms_js()
  expect_match(js, "upgradeInsecureUrl")
  expect_match(js, "status >= 200 && status < 300")
  expect_match(js, "status >= 300 && status < 400")
  expect_match(js, "getResponseHeader\\('Location'\\)")
  expect_match(js, "isSameHostRedirect")
})


test_that("wms-error", {
  expect_error(leaflet() %>%
    addWMS(baseUrl = "https://maps.dwd.de/geoserver/dwd/wms"))
})

test_that("setWMSParams", {
  expect_error(leaflet() %>% setWMSParams(), "requires at least one")

  m <- leaflet() %>%
    addWMS(
      baseUrl = "https://gibs.earthdata.nasa.gov/wms/epsg3857/best/wms.cgi",
      layers = "MODIS_Terra_CorrectedReflectance_TrueColor",
      layerId = "modis",
      group = "MODIS",
      options = WMSTileOptions(format = "image/jpeg", time = "2022-11-10")
    ) %>%
    setWMSParams(layerId = "modis", time = "2022-11-11")

  last <- m$x$calls[[length(m$x$calls)]]
  expect_equal(last$method, "setWMSParams")
  expect_equal(last$args[[1]], "modis")
  expect_equal(last$args[[3]]$time, "2022-11-11")

  bindings <- paste(
    readLines(system.file("htmlwidgets/lfx-wms/leaflet.wms-bindings.js", package = "leaflet.extras2")),
    collapse = "\n"
  )
  expect_match(bindings, "LeafletWidget.methods.setWMSParams")
})
