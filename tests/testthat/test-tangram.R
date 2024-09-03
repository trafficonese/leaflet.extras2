test_that("tangram", {
  scene <- system.file("examples/tangram/www/scene.yaml",
    package = "leaflet.extras2"
  )

  m <- leaflet() %>%
    addTangram(scene = scene, group = "tangram") %>%
    setView(11, 49.4, 14)
  expect_is(m, "leaflet")

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-tangram")
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "addTangram"
  )
})

test_that("tangram-error", {
  expect_error(
    leaflet() %>%
      addTangram()
  )
  expect_error(
    leaflet() %>%
      addTangram(scene = NULL)
  )

  expect_error(
    leaflet() %>%
      addTangram(scene = "scene")
  )
})
