library(sf)

# Sample data for testing
df <- sf::st_as_sf(atlStorms2005)
df <- suppressWarnings(st_cast(df, "POINT"))
df <- df[sample(seq_len(nrow(df)), 50, replace = FALSE), ]
df$classes <- sample(
  x = c("myclass1", "myclass2", "myclass3"),
  nrow(df), replace = TRUE
)
df$ID <- paste0("ID_", seq_len(nrow(df)))
df$lon <- st_coordinates(df)[, 1]
df$lat <- st_coordinates(df)[, 2]

# Function to generate map object for reuse in tests
generate_test_map <- function() {
  leaflet() %>%
    addTiles()
}

# Test 1: Basic functionality
test_that("addDivicon works", {
  map <- generate_test_map() %>%
    addDivicon(
      data = df,
      lng = ~lon,
      lat = ~lat,
      layerId = ~ID,
      className = ~ paste("globalclass", classes),
      html = ~ paste0("<div>", Name, "</div>")
    )
  expect_true(any(sapply(
    map$dependencies,
    function(dep) dep$name == "lfx-divicon"
  )))
  expect_is(map, "leaflet")
  expect_identical(map$x$calls[[2]]$method, "addDivicon")
  expect_identical(map$x$calls[[2]]$args[[3]], df$ID)
  expect_identical(map$x$calls[[2]]$args[[4]], NULL)
  expect_identical(map$x$calls[[2]]$args[[5]], leaflet::markerOptions())
  expect_identical(map$x$calls[[2]]$args[[6]], paste("globalclass", df$classes))
  expect_identical(
    map$x$calls[[2]]$args[[7]],
    paste0("<div>", df$Name, "</div>")
  )
  expect_identical(map$x$calls[[2]]$args[[8]], NULL)
  expect_identical(map$x$calls[[2]]$args[[9]], NULL)
  expect_identical(map$x$calls[[2]]$args[[10]], NULL)
  expect_identical(map$x$calls[[2]]$args[[11]], leaflet::labelOptions())
  expect_identical(map$x$calls[[2]]$args[[12]], NULL)
  expect_identical(map$x$calls[[2]]$args[[13]], NULL)

  # Test 2: Passing a group
  df$groups <- sample(
    x = c("myclass1", "myclass2", "myclass3"),
    nrow(df), replace = TRUE
  )
  map <- generate_test_map() %>%
    addDivicon(
      data = df,
      layerId = ~ID,
      className = ~ paste("globalclass", classes),
      group = ~groups,
      html = ~ paste0("<div>", Name, "</div>")
    )
  expect_is(map, "leaflet")
  expect_identical(map$x$calls[[2]]$method, "addDivicon")
  expect_identical(map$x$calls[[2]]$args[[3]], df$ID)
  expect_identical(map$x$calls[[2]]$args[[4]], df$groups)
  expect_identical(map$x$calls[[2]]$args[[5]], leaflet::markerOptions())
  expect_identical(map$x$calls[[2]]$args[[6]], paste("globalclass", df$classes))
  expect_identical(
    map$x$calls[[2]]$args[[7]],
    paste0("<div>", df$Name, "</div>")
  )
  expect_identical(map$x$calls[[2]]$args[[8]], NULL)
  expect_identical(map$x$calls[[2]]$args[[9]], NULL)
  expect_identical(map$x$calls[[2]]$args[[10]], NULL)
  expect_identical(map$x$calls[[2]]$args[[11]], leaflet::labelOptions())
  expect_identical(map$x$calls[[2]]$args[[12]], NULL)
  expect_identical(map$x$calls[[2]]$args[[13]], NULL)

  # Test 3: Adding labels and popups
  map <- generate_test_map() %>%
    addDivicon(
      data = df,
      layerId = ~ID,
      className = ~ paste("globalclass", classes),
      label = ~groups,
      labelOptions = labelOptions(textsize = 17),
      popup = ~ paste0(ID, ": ", Name),
      popupOptions = popupOptions(minWidth = 400),
      group = ~groups,
      html = ~ paste0("<div>", Name, "</div>")
    )
  expect_is(map, "leaflet")
  expect_identical(map$x$calls[[2]]$method, "addDivicon")
  expect_identical(map$x$calls[[2]]$args[[3]], df$ID)
  expect_identical(map$x$calls[[2]]$args[[4]], df$groups)
  expect_identical(map$x$calls[[2]]$args[[5]], leaflet::markerOptions())
  expect_identical(map$x$calls[[2]]$args[[6]], paste("globalclass", df$classes))
  expect_identical(
    map$x$calls[[2]]$args[[7]],
    paste0("<div>", df$Name, "</div>")
  )
  expect_identical(map$x$calls[[2]]$args[[8]], paste0(df$ID, ": ", df$Name))
  expect_identical(map$x$calls[[2]]$args[[9]], popupOptions(minWidth = 400))
  expect_identical(map$x$calls[[2]]$args[[10]], df$groups)
  expect_identical(map$x$calls[[2]]$args[[11]], labelOptions(textsize = 17))
  expect_identical(map$x$calls[[2]]$args[[12]], NULL)
  expect_identical(map$x$calls[[2]]$args[[13]], NULL)

  # Test 4: Adding clustering options
  map <- generate_test_map() %>%
    addDivicon(
      data = df,
      layerId = ~ID,
      className = ~ paste("globalclass", classes),
      label = ~groups,
      labelOptions = labelOptions(textsize = 17),
      popup = ~ paste0(ID, ": ", Name),
      popupOptions = popupOptions(minWidth = 400),
      group = ~groups,
      html = ~ paste0("<div>", Name, "</div>"),
      clusterOptions = markerClusterOptions(),
      clusterId = "someclusterid"
    )
  expect_is(map, "leaflet")
  expect_identical(map$x$calls[[2]]$method, "addDivicon")
  expect_identical(map$x$calls[[2]]$args[[3]], df$ID)
  expect_identical(map$x$calls[[2]]$args[[4]], df$groups)
  expect_identical(map$x$calls[[2]]$args[[5]], leaflet::markerOptions())
  expect_identical(map$x$calls[[2]]$args[[6]], paste("globalclass", df$classes))
  expect_identical(
    map$x$calls[[2]]$args[[7]],
    paste0("<div>", df$Name, "</div>")
  )
  expect_identical(map$x$calls[[2]]$args[[8]], paste0(df$ID, ": ", df$Name))
  expect_identical(map$x$calls[[2]]$args[[9]], popupOptions(minWidth = 400))
  expect_identical(map$x$calls[[2]]$args[[10]], df$groups)
  expect_identical(map$x$calls[[2]]$args[[11]], labelOptions(textsize = 17))
  expect_identical(map$x$calls[[2]]$args[[12]], "someclusterid")
  expect_identical(map$x$calls[[2]]$args[[13]], markerClusterOptions())

  expect_error({
    map <- generate_test_map() %>%
      addDivicon(
        data = NULL,
        lng = ~lon,
        lat = ~lat,
        layerId = ~ID,
        className = ~ paste("globalclass", classes),
        html = ~ paste0("<div>", Name, "</div>")
      )
  })

  expect_error({
    map <- generate_test_map() %>%
      addDivicon(
        data = data.frame(),
        lng = ~lon,
        lat = ~lat,
        layerId = ~ID,
        className = ~ paste("globalclass", classes),
        html = ~ paste0("<div>", Name, "</div>")
      )
  })
})
