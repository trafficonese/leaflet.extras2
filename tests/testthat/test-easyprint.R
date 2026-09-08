test_that("addEasyprint / removeEasyprint / easyprintMap", {
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

  m <- m %>% easyprintMap(sizeModes = "custom-scale-3", filename = "hires")
  last <- m$x$calls[[length(m$x$calls)]]
  expect_equal(last$method, "easyprintMap")
  expect_equal(last$args[[1]], "custom-scale-3")
  expect_equal(last$args[[2]], "hires")
})

test_that("easyprintOptions hideClasses and empty sizeModes", {
  cl <- c("class1", "class2")
  opts <- easyprintOptions(hideClasses = cl)
  expect_is(opts$hideClasses, "list")
  expect_equal(unlist(opts$hideClasses), cl)
  opts <- easyprintOptions(hideClasses = as.list(cl))
  expect_is(opts$hideClasses, "list")
  expect_equal(unlist(opts$hideClasses), cl)
  expect_false("hideClasses" %in% names(easyprintOptions(hideClasses = NULL)))

  expect_error(easyprintOptions(sizeModes = NULL))
  expect_error(easyprintOptions(sizeModes = NA))
  expect_error(easyprintOptions(sizeModes = ""))
})

test_that("custom width/height sizeModes get defaults", {
  custom <- easyprintOptions(sizeModes = list(width = 3000, height = 1800))
  mode <- custom$sizeModes[[1]]
  expect_equal(mode$width, 3000)
  expect_equal(mode$height, 1800)
  expect_equal(mode$className, "custom-3000x1800")
  expect_equal(mode$name, "Custom (3000x1800)")
  expect_true(mode$keepView)

  named <- easyprintOptions(sizeModes = list(
    width = 800,
    height = 600,
    name = "High res",
    className = "my custom size!"
  ))
  expect_equal(named$sizeModes[[1]]$name, "High res")
  expect_equal(named$sizeModes[[1]]$className, "my-custom-size-")
  expect_true(named$sizeModes[[1]]$keepView)
})

test_that("keepView can be disabled", {
  opts <- easyprintOptions(sizeModes = list(
    width = 3000,
    height = 1800,
    keepView = FALSE
  ))
  expect_false(opts$sizeModes[[1]]$keepView)
})

test_that("tooltip is used as custom size name", {
  opts <- easyprintOptions(sizeModes = list(
    width = 100,
    height = 50,
    tooltip = "From tooltip"
  ))
  expect_equal(opts$sizeModes[[1]]$name, "From tooltip")
})

test_that("scale sizeModes keep the current view", {
  scaled <- easyprintOptions(sizeModes = list(scale = 3))
  mode <- scaled$sizeModes[[1]]
  expect_equal(mode$scale, 3)
  expect_true(mode$keepView)
  expect_equal(mode$name, "Current view x3")
  expect_equal(mode$className, "custom-scale-3")

  named <- easyprintOptions(sizeModes = list(scale = 2.5, name = "2.5x"))
  expect_equal(named$sizeModes[[1]]$name, "2.5x")
  expect_equal(named$sizeModes[[1]]$className, "custom-scale-2-5")
})

test_that("scale with explicit width/height keeps className from pixels", {
  opts <- easyprintOptions(sizeModes = list(
    scale = 3,
    width = 3000,
    height = 1800,
    name = "Both"
  ))
  expect_equal(opts$sizeModes[[1]]$scale, 3)
  expect_equal(opts$sizeModes[[1]]$width, 3000)
  expect_equal(opts$sizeModes[[1]]$className, "custom-3000x1800")
})

test_that("mixed sizeModes stay in order and unname lists", {
  mixed <- easyprintOptions(sizeModes = list(
    "CurrentSize",
    list(scale = 3, name = "3x current view"),
    list(width = 3000, height = 1800, name = "High res")
  ))
  expect_null(names(mixed$sizeModes))
  expect_equal(mixed$sizeModes[[1]], "CurrentSize")
  expect_equal(mixed$sizeModes[[2]]$scale, 3)
  expect_equal(mixed$sizeModes[[2]]$className, "custom-scale-3")
  expect_true(mixed$sizeModes[[2]]$keepView)
  expect_equal(mixed$sizeModes[[3]]$name, "High res")
  expect_equal(mixed$sizeModes[[3]]$className, "custom-3000x1800")
  expect_true(mixed$sizeModes[[3]]$keepView)

  chars <- easyprintOptions(sizeModes = c("CurrentSize", "A4Landscape"))
  expect_equal(unlist(chars$sizeModes), c("CurrentSize", "A4Landscape"))
})

test_that("addEasyprint forwards custom sizeModes to the widget", {
  opts <- easyprintOptions(
    exportOnly = TRUE,
    sizeModes = list(
      "CurrentSize",
      list(scale = 3, name = "3x current view"),
      list(width = 3000, height = 1800, name = "High res", keepView = FALSE)
    )
  )
  m <- leaflet() %>%
    addTiles() %>%
    addEasyprint(options = opts)

  call <- m$x$calls[[length(m$x$calls)]]
  expect_equal(call$method, "addEasyprint")
  modes <- call$args[[1]]$sizeModes
  expect_equal(modes[[1]], "CurrentSize")
  expect_equal(modes[[2]]$scale, 3)
  expect_true(modes[[2]]$keepView)
  expect_equal(modes[[3]]$width, 3000)
  expect_equal(modes[[3]]$height, 1800)
  expect_false(modes[[3]]$keepView)
})

test_that("custom sizeModes survive JSON serialization", {
  opts <- easyprintOptions(sizeModes = list(
    list(scale = 3, name = "3x"),
    list(width = 3000, height = 1800, keepView = FALSE)
  ))
  parsed <- jsonlite::fromJSON(
    jsonlite::toJSON(opts$sizeModes, auto_unbox = TRUE),
    simplifyVector = FALSE
  )
  expect_equal(parsed[[1]]$scale, 3)
  expect_true(parsed[[1]]$keepView)
  expect_equal(parsed[[1]]$className, "custom-scale-3")
  expect_equal(parsed[[2]]$width, 3000)
  expect_false(parsed[[2]]$keepView)
})

test_that("easyprint JS keeps the current view when resizing", {
  js <- paste(
    readLines(
      system.file("htmlwidgets/lfx-easyprint/lfx-easyprint_full.js",
        package = "leaflet.extras2"
      ),
      warn = FALSE
    ),
    collapse = "\n"
  )
  expect_match(js, "keepView")
  expect_match(js, "viewScale")
  expect_match(js, "pixelWidth")
  expect_match(js, "Math\\.log\\(viewScale\\)")
  expect_match(js, "CustomSize")
})
