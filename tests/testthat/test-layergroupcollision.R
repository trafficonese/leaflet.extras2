library(testthat)
library(sf)
library(leaflet)

# Sample data for testing
df <- sf::st_as_sf(atlStorms2005)
df <- suppressWarnings(st_cast(df, "POINT"))
df <- df[sample(1:nrow(df), 50, replace = FALSE), ]
df$classes <- sample(
  x = c("myclass1", "myclass2", "myclass3"),
  nrow(df), replace = TRUE
)
df$ID <- paste0("ID_", 1:nrow(df))
df$lon <- st_coordinates(df)[, 1]
df$lat <- st_coordinates(df)[, 2]

# Function to generate map object for reuse in tests
generate_test_map <- function() {
  leaflet() %>%
    addTiles()
}

# Test 1: Basic functionality of addLayerGroupCollision
test_that("addLayerGroupCollision works", {
  map <- generate_test_map() %>%
    addLayerGroupCollision(
      data = df,
      group = "Myclass",
      className = ~ paste("class", classes),
      html = ~ paste0("<div>", ID, "</div>")
    )

  expect_is(map, "leaflet")
  expect_true(any(sapply(
    map$dependencies,
    function(dep) dep$name == "lfx-layergroupcollision"
  )))
  expect_length(map$dependencies[[length(map$dependencies)]]$script, 3)
  expect_identical(map$x$calls[[2]]$method, "addLayerGroupCollision")
  expect_is(map$x$calls[[2]]$args[[1]], "geojson")
  expect_identical(map$x$calls[[2]]$args[[2]], "Myclass")
  expect_identical(map$x$calls[[2]]$args[[3]], 5) # Default margin
})

# Test 2: Handling of custom margin
test_that("addLayerGroupCollision handles custom margin", {
  map <- generate_test_map() %>%
    addLayerGroupCollision(
      data = df,
      margin = 10
    )

  expect_is(map, "leaflet")
  expect_identical(map$x$calls[[2]]$method, "addLayerGroupCollision")
  expect_identical(map$x$calls[[2]]$args[[3]], 10) # Custom margin
})

# Test 3: Adding HTML and className with custom values
test_that("addLayerGroupCollision assigns HTML and className correctly", {
  map <- generate_test_map() %>%
    addLayerGroupCollision(
      data = df,
      className = ~ paste("myclass", classes),
      html = ~ paste0("<div>", ID, "</div>")
    )

  expect_is(map, "leaflet")
  expect_identical(map$x$calls[[2]]$method, "addLayerGroupCollision")
  expect_null(map$x$calls[[2]]$args[[2]])
  expect_identical(map$x$calls[[2]]$args[[3]], 5)
})

# Test 4: Verifying map data transformation to GeoJSON
test_that("addLayerGroupCollision transforms spatial data to GeoJSON", {
  map <- generate_test_map() %>%
    addLayerGroupCollision(
      data = df
    )

  geojson <- map$x$calls[[2]]$args[[1]]
  expect_true(inherits(geojson, "geojson"))
})

# Test 5: Error handling for invalid data
test_that("addLayerGroupCollision handles invalid data gracefully", {
  expect_error({
    map <- generate_test_map() %>%
      addLayerGroupCollision(
        data = NULL
      )
  })

  expect_error({
    map <- generate_test_map() %>%
      addLayerGroupCollision(
        data = data.frame()
      )
  })
})
