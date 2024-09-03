test_that("contextmenu", {
  m <- leaflet(options = leafletOptions(
    contextmenu = TRUE,
    contextmenuWidth = 200,
    contextmenuItems =
      context_mapmenuItems(
        context_menuItem("Zoom Out", "function(e) {this.zoomOut()}",
          disabled = FALSE
        ),
        "-",
        context_menuItem("Zoom In", "function(e) {this.zoomIn()}")
      )
  )) %>%
    addTiles(group = "base") %>%
    addContextmenu() %>%
    addMarkers(
      data = breweries91, label = ~brewery,
      layerId = ~founded, group = "marker",
      options = markerOptions(
        contextmenu = TRUE,
        contextmenuWidth = 200,
        contextmenuItems =
          context_markermenuItems(
            context_menuItem(
              text = "Show Marker Coords",
              callback = "function(e) {alert(e.latlng);}",
              index = 1
            )
          )
      )
    )

  expect_is(m, "leaflet")
  expect_true(m$x$options$contextmenu)
  expect_is(m$x$options$contextmenuWidth, "numeric")
  expect_is(m$x$options$contextmenuItems, "list")
  expect_is(m$x$options$contextmenuItems[[1]]$callback, "JS_EVAL")

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-contextmenu")

  m <- m %>% showContextmenu(data = leaflet::breweries91[sample(1:32, 1), ])
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "showContextmenu"
  )
  expect_true(all(
    colnames(m$x$calls[[length(m$x$calls)]]$args[[1]]) %in% c("lng", "lat")
  ))

  m <- m %>% showContextmenu(lat = 49.79433, lng = 11.50941)
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "showContextmenu"
  )
  expect_true(all(
    colnames(m$x$calls[[length(m$x$calls)]]$args[[1]]) %in% c("lng", "lat")
  ))

  m <- m %>% hideContextmenu()
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "hideContextmenu"
  )

  m <- m %>% enableContextmenu()
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "enableContextmenu"
  )

  m <- m %>% disableContextmenu()
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "disableContextmenu"
  )

  if (packageVersion("leaflet") < "2.0.4") {
    m <- expect_warning(
      m %>% addItemContextmenu(
        context_menuItem(
          text = "Added Menu Item",
          callback = ("function(e) {alert('I am a new menuItem!');
                                             console.log('e');console.log(e);}")
        )
      )
    )
    expect_equal(
      m$x$calls[[length(m$x$calls)]]$method,
      "addItemContextmenu"
    )

    m <- expect_warning(
      m %>% insertItemContextmenu(
        index = 1,
        context_menuItem(
          text = "Inserted Menu Item",
          callback = ("function(e) {alert('I am an inserted menuItem!');}")
        )
      )
    )
    expect_equal(
      m$x$calls[[length(m$x$calls)]]$method,
      "insertItemContextmenu"
    )
  } else {
    m <- m %>% addItemContextmenu(
      context_menuItem(
        text = "Added Menu Item",
        callback = ("function(e) {alert('I am a new menuItem!');
                                             console.log('e');console.log(e);}")
      )
    )
    expect_equal(
      m$x$calls[[length(m$x$calls)]]$method,
      "addItemContextmenu"
    )

    m <- m %>% insertItemContextmenu(
      index = 2,
      context_menuItem(
        text = "Added Menu Item",
        callback = ("function(e) {alert('I am an inserted menuItem!');}")
      )
    )
    expect_equal(
      m$x$calls[[length(m$x$calls)]]$method,
      "insertItemContextmenu"
    )
  }

  m <- m %>% removeItemContextmenu(index = 1)
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "removeItemContextmenu"
  )
  expect_true(m$x$calls[[length(m$x$calls)]]$args[[1]] == 1)

  m <- m %>% setDisabledContextmenu(index = 1, disabled = TRUE)
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "setDisabledContextmenu"
  )
  expect_true(m$x$calls[[length(m$x$calls)]]$args[[1]] == 1)
  expect_true(m$x$calls[[length(m$x$calls)]]$args[[2]] == TRUE)

  m <- m %>% setDisabledContextmenu(index = 2, disabled = FALSE)
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "setDisabledContextmenu"
  )
  expect_true(m$x$calls[[length(m$x$calls)]]$args[[1]] == 2)
  expect_true(m$x$calls[[length(m$x$calls)]]$args[[2]] == FALSE)

  m <- m %>% removeallItemsContextmenu()
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "removeallItemsContextmenu"
  )


  mn <- context_menuItem("some text", "my callback", id = "myid")
  expect_is(mn, "list")
  expect_is(mn$callback, "JS_EVAL")

  mn1 <- context_menuItem(id = "myid", "some text", "my callback")
  expect_identical(mn1, mn)

  mn <- context_mapmenuItems(
    context_menuItem("some text", "my callback", id = "myid"),
    context_menuItem("some other text", "my callback", id = "myid2")
  )
  expect_is(mn, "list")
  expect_length(mn, 2)

  mn <- context_markermenuItems(
    context_menuItem("some text", "my callback", id = "myid"),
    context_menuItem("some other text", "my callback", id = "myid2")
  )
  expect_is(mn, "list")
  expect_length(mn, 1)
})



test_that("contextmenu-deprecation", {
  mn <- expect_warning(menuItem("some text", "my callback", id = "myid"))
  expect_is(mn, "list")
  expect_is(mn$callback, "JS_EVAL")

  mn1 <- expect_warning(menuItem(id = "myid", "some text", "my callback"))
  expect_identical(mn1, mn)

  mn <- expect_warning(markermenuItems(
    menuItem("some text", "my callback", id = "myid"),
    menuItem("some other text", "my callback", id = "myid2")
  ))
  expect_is(mn, "list")
  expect_length(mn, 1)

  cnt <- expect_warning(mapmenuItems(
    context_menuItem("Zoom In", "function(e) {this.zoomIn()}")
  ))
  expect_is(cnt, "list")
  expect_length(cnt, 1)
  expect_identical(cnt[[1]]$text, "Zoom In")
  expect_is(cnt[[1]]$callback, "JS_EVAL")
})
