library(sf)
library(shiny)
library(shinyWidgets)
library(leaflet)
library(leaflet.extras2)

data(breweries91, package = "leaflet")

breweries_data <- breweries91 |>
  st_as_sf()

sample_brewery_data <- function(data, n_obs) {
  ii <- sample.int(nrow(data), n_obs, replace = TRUE)
  data[ii, ]
}

ui <- fluidPage(
  tags$head(tags$style(".btn-default {display: block;}")),
  h4("Leaflet Sidebar Plugin"),
  splitLayout(cellWidths = c("20%", "80%"),
              tagList(
                actionButton("open", "Open Sidebar"),
                actionButton("close", "Close Sidebar"),
                actionButton("clear", "Clear Sidebar"),
                verbatimTextOutput("whichtab")
              ),
              tagList(
                sidebar_tabs(id = "mysidebarid",
                             list(icon("car"), icon("user"), icon("envelope")),
                             sidebar_pane(
                               title = "home", id = "home_id", icon = icon("home"),
                               tagList(
                                 sliderInput("obs", "Number of observations:",
                                             min = 1, max = 32, value = 10),
                                 sliderInput("opa", "Point Opacity:",
                                             min = 0, max = 1, value = 0.5),
                                 sliderInput("fillopa", "Fill Opacity:",
                                             min = 0, max = 1, value = 0.2),
                                 dateRangeInput("daterange4", "Date range:",
                                                start = Sys.Date() - 10,
                                                end = Sys.Date() + 10),
                                 verbatimTextOutput("tab1")
                               )
                             ),
                             sidebar_pane(
                               title = "profile", id = "profile_id", icon = icon("wrench"),
                               tagList(
                                 textInput("caption", "Caption", "Data Summary"),
                                 selectInput("label", "selectInput", selectize = FALSE,
                                             choices = LETTERS[1:26]),
                                 selectInput("label1", "selectInput with selectize", selectize = TRUE,
                                             choices = LETTERS[1:26]),
                                 virtualSelectInput("label2", "virtualSelectInput",
                                             choices = LETTERS[1:26]),
                                 passwordInput("password", "Password:"),
                                 actionButton("go", "Go"),
                                 verbatimTextOutput("value")
                               )
                             ),
                             sidebar_pane(
                               title = "messages", id = "messages_id",
                               icon = icon("person", verify_fa = FALSE),
                               tagList(
                                 checkboxGroupInput("variable", "Variables to show:",
                                                    c("Cylinders" = "cyl",
                                                      "Transmission" = "am",
                                                      "Gears" = "gear")),
                                 tableOutput("data")
                               )
                             )
                ),
                leafletOutput("map", height = "700px")
              )
  )
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addSidebar(
        id = "mysidebarid",
        options = list(position = "left")
      )
  })
  output$whichtab <- renderPrint({
    paste0(req(input$mysidebarid), " is open")
  })

  observe({
    req(input$obs)

    df <- breweries_data |>
      sample_brewery_data(n_obs = input$obs)

    bbox <- suppressWarnings(st_bbox(df))
    leafletProxy("map", session) %>%
      clearGroup("pts") %>%
      addCircleMarkers(data = df,
                       label = df[[input$label]],
                       opacity = input$opa,
                       fillOpacity = input$fillopa,
                       group = "pts") %>%
      fitBounds(bbox[[1]], bbox[[2]], bbox[[3]], bbox[[4]])
  })

  output$tab1 <- renderText({
    input$obs
  })
  output$value <- renderText({
    req(input$go)
    isolate(input$password)
  })
  output$data <- renderTable(rownames = FALSE, {
    mtcars[, c("mpg", input$variable), drop = FALSE]
  })

  observeEvent(input$open, {
    leafletProxy("map", session) %>%
      openSidebar(sample(c("home_id", "profile_id", "messages_id"), 1))
  })
  observeEvent(input$close, {
    leafletProxy("map", session) %>%
      closeSidebar()
  })
  observeEvent(input$clear, {
    leafletProxy("map", session) %>%
      removeSidebar()
  })
}
shinyApp(ui, server)
