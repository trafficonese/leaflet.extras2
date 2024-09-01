
test_that("arrowhead", {
  m <- leaflet() %>%
    addArrowhead(data = atlStorms2005, group = "groupname")
  expect_is(m, "leaflet")

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-arrowhead")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method,
               "addArrowhead")
  expect_true(all(names(m$x$calls[[1]]$args[[10]]) %in%
                    c("yawn","size","frequency","proportionalToTotal")))

  m <- leaflet() %>% clearArrowhead("groupname")
  m$x$calls[[length(m$x$calls)]]$method == "clearArrowhead"
  m$x$calls[[length(m$x$calls)]]$args[[1]] == "groupname"

  m <- leaflet() %>% removeArrowhead(layerId = "layerid")
  m$x$calls[[length(m$x$calls)]]$method == "removeArrowhead"
  m$x$calls[[length(m$x$calls)]]$args[[1]] == "layerid"

  expect_error(leaflet() %>% clearArrowhead())
  expect_error(leaflet() %>% removeArrowhead())

})
