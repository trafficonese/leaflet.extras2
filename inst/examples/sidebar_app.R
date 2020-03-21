library(sf)
library(shiny)
library(leaflet)
library(leaflet.extras2)

data(breweries91, package = "leaflet")

ui <- fluidPage(
  h4("Leaflet Sidebar Plugin"),
  sidebar_tabs(
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
  ),
  splitLayout(cellWidths = c("70%", "30%"),
              leafletOutput("map"),
              tagList(
                actionButton("open", "Open Sidebar"),
                actionButton("close", "Close Sidebar"),
                actionButton("clear", "Clear Sidebar")
              )
  )
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addSidebar(
        id = "sidebar", layerId = "sidebar",
        options = list(position = "right", fit = TRUE)
      )
  })
  observe({
    req(input$obs)
    df <- breweries91[sample.int(nrow(breweries91), input$obs), ]
    bbox <- st_bbox(df)
    leafletProxy("map", session) %>%
      clearGroup("pts") %>%
      addCircleMarkers(data = df, label = df[[input$label]], group = "pts") %>%
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
      openSidebar(sample(c("home_id","profile_id","messages_id"), 1))
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
