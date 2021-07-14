library(htmltools)
library(leaflet)

test_that("labelgun", {

  df <- breweries91
  df$weight <- 1:nrow(df)

  m <- leaflet() %>%
    addMarkers(data = df, label=~paste0(weight, " - ", brewery),
               group = "hidemarkers_1",
               labelOptions = labelOptions(permanent = TRUE)) %>%
    addLabelgun("hidemarkers_1")
  expect_is(m, "leaflet")

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-labelgun")
  expect_true(m$x$calls[[2]]$method == "addLabelgun")
  expect_true(m$x$calls[[2]]$args[[1]] == "hidemarkers_1")

  expect_error(leaflet() %>% addLabelgun())

})
