test_that("easyprint", {
  m <- leaflet() %>%
    addTiles() %>%
    addEasyprint(options = easyprintOptions(
      title = "Print map",
      position = "bottomleft",
      exportOnly = TRUE
    ))
  expect_is(m, "leaflet")

  m <- leaflet() %>%
    addTiles() %>%
    addEasyprint(options = easyprintOptions(
      sizeModes = "A4Landscape",
      title = "Print map",
      position = "bottomleft",
      exportOnly = TRUE
    ))
  expect_is(m, "leaflet")

  cl <- c("class1", "class2")
  opts <- easyprintOptions(hideClasses = cl)
  expect_is(opts$hideClasses, "list")
  expect_equal(unlist(opts$hideClasses), cl)
  opts <- easyprintOptions(hideClasses = as.list(cl))
  expect_is(opts$hideClasses, "list")
  expect_equal(unlist(opts$hideClasses), cl)
  expect_false("hideClasses" %in% names(easyprintOptions(hideClasses = NULL)))

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-easyprint")

  m <- m %>% removeEasyprint()
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "removeEasyprint"
  )

  m <- m %>% easyprintMap()
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "easyprintMap"
  )

  expect_error(easyprintOptions(sizeModes = NULL))
  expect_error(easyprintOptions(sizeModes = NA))
  expect_error(easyprintOptions(sizeModes = ""))
})
