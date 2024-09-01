test_that("sidebar", {
  ## Check HTML ####################
  m <- sidebar_pane(
    title = "messages", id = "messages_id", icon = tags$i(class = "person"),
    tagList(tags$div("Some Shiny Inputs"))
  )
  expect_is(m, "shiny.tag")

  m <- sidebar_tabs(
    id = "sidebar",
    list(tags$i(class = "car"), tags$i(class = "user"), tags$i(class = "car")),
    sidebar_pane(
      title = "home", id = "home_id", icon = tags$i(class = "home"),
      tagList(tags$div("Some Shiny Inputs"))
    ),
    sidebar_pane(
      title = "profile", id = "profile_id", icon = tags$i(class = "wrench"),
      tagList(tags$div("Some Shiny Inputs"))
    ),
    sidebar_pane(
      title = "messages", id = "messages_id", icon = tags$i(class = "person"),
      tagList(tags$div("Some Shiny Inputs"))
    )
  )
  expect_is(m, "shiny.tag")

  ## Leaflet ####################
  m <- leaflet() %>%
    addSidebar()
  expect_is(m, "leaflet")

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-sidebar")

  m <- m %>%
    removeSidebar()
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "removeSidebar"
  )

  m <- m %>%
    openSidebar("tab1")
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "openSidebar"
  )

  m <- m %>%
    closeSidebar()
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$method,
    "closeSidebar"
  )

  ## Check For Modules ##########
  m <- leaflet() %>%
    addSidebar(ns = shiny::NS("modul"))
  expect_is(m, "leaflet")
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$args[[1]],
    "modul-sidebar"
  )

  m <- leaflet() %>%
    addSidebar(ns = shiny::NS("modul")) %>%
    openSidebar(id = "sidebar", ns = shiny::NS("modul"))
  expect_is(m, "leaflet")
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$args[[1]]$id,
    "modul-sidebar"
  )
})

test_that("sidebar-error", {
  expect_error(
    sidebar_pane(
      icon = tags$i(class = "person"),
      tagList()
    )
  )

  expect_error(
    sidebar_tabs(
      list(tags$i(class = "person"), tags$i(class = "person")),
      sidebar_pane(
        id = "home_id",
        icon = tags$i(class = "person"), tagList()
      ),
      sidebar_pane(
        id = "profile_id",
        icon = tags$i(class = "person"), tagList()
      ),
      sidebar_pane(
        id = "messages_id",
        icon = tags$i(class = "person"), tagList()
      )
    )
  )
})
