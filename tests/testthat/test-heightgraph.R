library(sf)
library(geojsonsf)

test_that("heightgraph", {

  data <- st_cast(st_as_sf(leaflet::atlStorms2005[4,]), "LINESTRING")
  data <- st_transform(data, 4326)
  data <- data.frame(st_coordinates(data))
  data$elev <-  runif(nrow(data), 10, 500)
  data$L1 <- NULL
  L1 <- round(seq.int(1, 4, length.out = nrow(data)))
  data <- st_as_sf(st_sfc(lapply(split(data, L1), function(x) {
    st_linestring(as.matrix(x))
  })))
  data$steepness <- 1:nrow(data)
  data$suitability <- nrow(data):1
  data$popup <- apply(data, 1, function(x) {
    sprintf("Steepness: %s<br>Suitability: %s", x$steepness, x$suitability)
  })

  m <- leaflet() %>%
    addTiles(group = "base") %>%
    addHeightgraph(color = "red", columns = c("steepness", "suitability"),
                   opacity = 1, data = data, group = "heightgraph",
                   options = heightgraphOptions(width = 400))
  expect_is(m, "leaflet")

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-heightgraph")

  expect_true(m$x$calls[[2]]$method == "addHeightgraph")
  expect_is(m$x$calls[[2]]$args[[1]][[1]], "geojson")
  expect_is(m$x$calls[[2]]$args[[1]][[2]], "geojson")
  expect_identical(m$x$calls[[2]]$args[[2]]$steepness, data$steepness)
  expect_identical(m$x$calls[[2]]$args[[2]]$suitability, data$suitability)


  expect_error(
    leaflet() %>%
    addTiles(group = "base") %>%
    addHeightgraph(data = data)
  )

})
