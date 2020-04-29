library(shiny)

test_that("sidebar", {

  ## Check HTML ####################
  m <- sidebar_pane(
    title = "messages", id = "messages_id", icon = icon("person"),
    tagList(
      checkboxGroupInput(
        "variable", "Variables to show:",
        c(
          "Cylinders" = "cyl",
          "Transmission" = "am",
          "Gears" = "gear"
        )
      )
    )
  )
  expect_is(m, "shiny.tag")

  m <- sidebar_tabs(
    list(icon("car"), icon("user"), icon("envelope")),
    sidebar_pane(
      title = "home", id = "home_id", icon = icon("home"),
      tagList(
        sliderInput("obs", "Number of observations:",
                    min = 1, max = 32, value = 10
        ),
        dateRangeInput("daterange4", "Date range:",
                       start = Sys.Date() - 10,
                       end = Sys.Date() + 10
        ),
        verbatimTextOutput("tab1")
      )
    ),
    sidebar_pane(
      title = "profile", id = "profile_id", icon = icon("wrench"),
      tagList(
        textInput("caption", "Caption", "Data Summary"),
        selectInput("label", "Label", choices = c("brewery", "address", "zipcode", "village")),
        passwordInput("password", "Password:"),
        actionButton("go", "Go"),
        verbatimTextOutput("value")
      )
    ),
    sidebar_pane(
      title = "messages", id = "messages_id", icon = icon("person"),
      tagList(
        checkboxGroupInput(
          "variable", "Variables to show:",
          c(
            "Cylinders" = "cyl",
            "Transmission" = "am",
            "Gears" = "gear"
          )
        ),
        tableOutput("data")
      )
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
  expect_equal(m$x$calls[[length(m$x$calls)]]$method,
               "removeSidebar")

  m <- m %>%
    openSidebar("tab1")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method,
               "openSidebar")

  m <- m %>%
    closeSidebar()
  expect_equal(m$x$calls[[length(m$x$calls)]]$method,
               "closeSidebar")

})

test_that("sidebar-error", {

  expect_error(sidebar_pane(icon = icon("person"),
                            tagList()))

  expect_error(sidebar_tabs(
    list(icon("car"), icon("user")),
    sidebar_pane(id = "home_id", icon = icon("caret-right"),tagList()),
    sidebar_pane(id = "profile_id", icon = icon("wrench"), tagList()),
    sidebar_pane(id = "messages_id", icon = icon("cars"), tagList())
  ))

})

