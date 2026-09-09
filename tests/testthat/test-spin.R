test_that("spin", {
  m <- leaflet() %>%
    addSpinner()
  expect_is(m, "leaflet")

  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-spin")

  m <- m %>% startSpinner()
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "spinner")
  expect_true(m$x$calls[[length(m$x$calls)]]$args[[1]])

  m <- m %>% stopSpinner()
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "spinner")
  expect_false(m$x$calls[[length(m$x$calls)]]$args[[1]])

  m <- m %>% startSpinner(options = list("lines" = 7, "width" = 12))
  expect_equal(
    m$x$calls[[length(m$x$calls)]]$args[[2]],
    list("lines" = 7, "width" = 12)
  )
})

test_that("spin dependency ships minified scripts", {
  dep <- findDependencies(leaflet() %>% addSpinner())
  spin <- dep[[length(dep)]]
  expect_equal(spin$name, "lfx-spin")
  expect_true("spin.min.js" %in% spin$script)
  expect_true("leaflet.spin.min.js" %in% spin$script)
})

test_that("spinWhile needs a Shiny session", {
  expect_error(spinWhile("leaf", NULL), "Shiny session")
})

if (requireNamespace("shiny", quietly = TRUE) && !"package:shiny" %in% search()) {
  suppressWarnings(suppressPackageStartupMessages(
    library(shiny, quietly = TRUE, warn.conflicts = FALSE)
  ))
}

leaflet_call_recorder <- function() {
  rec <- new.env(parent = emptyenv())
  rec$calls <- list()
  rec$invoke <- function(map, method, args = list()) {
    rec$calls[[length(rec$calls) + 1]] <- list(
      id = map$id,
      method = method,
      args = args
    )
    map
  }
  rec$states <- function() {
    vapply(rec$calls, function(x) isTRUE(x$args[[1]]), logical(1))
  }
  rec
}

test_that("spinWhile starts spinner, waits for shown, then runs expr and stops", {
  skip_if_not_installed("shiny")
  rec <- leaflet_call_recorder()
  ran <- FALSE

  with_mocked_bindings(
    {
      shiny::testServer(
        function(input, output, session) {
          shiny::observeEvent(input$go, {
            spinWhile("leaf",
              {
                ran <<- TRUE
              },
              options = list(lines = 7)
            )
          })
        },
        {
          session$setInputs(go = 1)
          expect_false(ran)
          expect_equal(length(rec$calls), 1L)
          expect_equal(rec$calls[[1]]$method, "spinner")
          expect_true(rec$calls[[1]]$args[[1]])
          expect_equal(rec$calls[[1]]$args[[2]], list(lines = 7))
          expect_true(grepl("leaf$", rec$calls[[1]]$id))

          session$setInputs(leaf_spinner_shown = 1)
          expect_true(ran)
          expect_equal(length(rec$calls), 2L)
          expect_equal(rec$calls[[2]]$method, "spinner")
          expect_false(rec$calls[[2]]$args[[1]])
        }
      )
    },
    invokeRemote = rec$invoke,
    .package = "leaflet"
  )
})

test_that("spinWhile stops the spinner if expr errors", {
  skip_if_not_installed("shiny")
  rec <- leaflet_call_recorder()

  with_mocked_bindings(
    {
      shiny::testServer(
        function(input, output, session) {
          shiny::observeEvent(input$go, {
            spinWhile("leaf", {
              stop("boom")
            })
          })
        },
        {
          session$setInputs(go = 1)
          invisible(capture.output(
            suppressWarnings(session$setInputs(leaf_spinner_shown = 1)),
            type = "message"
          ))
          expect_equal(rec$states(), c(TRUE, FALSE))
        }
      )
    },
    invokeRemote = rec$invoke,
    .package = "leaflet"
  )
})

test_that("spinWhile runs expr only once per call", {
  skip_if_not_installed("shiny")
  rec <- leaflet_call_recorder()
  n <- 0

  with_mocked_bindings(
    {
      shiny::testServer(
        function(input, output, session) {
          shiny::observeEvent(input$go, {
            spinWhile("leaf", {
              n <<- n + 1
            })
          })
        },
        {
          session$setInputs(go = 1)
          session$setInputs(leaf_spinner_shown = 1)
          session$setInputs(leaf_spinner_shown = 2)
          expect_equal(n, 1)
          expect_equal(rec$states(), c(TRUE, FALSE))
        }
      )
    },
    invokeRemote = rec$invoke,
    .package = "leaflet"
  )
})

test_that("spinWhile returns the session", {
  skip_if_not_installed("shiny")

  with_mocked_bindings(
    {
      ret <- NULL
      shiny::testServer(
        function(input, output, session) {
          shiny::observeEvent(input$go, {
            ret <<- spinWhile("leaf", NULL)
          })
        },
        {
          session$setInputs(go = 1)
          expect_identical(ret, session)
        }
      )
    },
    invokeRemote = function(map, method, args = list()) map,
    .package = "leaflet"
  )
})

test_that("spinner binding notifies Shiny after paint", {
  js <- paste(
    readLines(system.file(
      "htmlwidgets/lfx-spin/leaflet.spin-binding.js",
      package = "leaflet.extras2"
    )),
    collapse = "\n"
  )
  expect_match(js, "_spinner_shown")
  expect_match(js, "requestAnimationFrame")
  expect_match(js, "Shiny.setInputValue")
})
