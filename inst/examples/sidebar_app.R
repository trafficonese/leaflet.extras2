library(sf)
library(shiny)
library(leaflet)
library(leaflet.extras2)

data(breweries91, package = "leaflet")

ui <- fluidPage(
  h4("Leaflet Sidebar Plugin"),
  splitLayout(
    cellWidths = c("20%", "80%"),
    tagList(
      actionButton("open", "Open Sidebar"),
      actionButton("close", "Close Sidebar"),
      actionButton("clear", "Clear Sidebar")
   ),
    tagList(
      leafletOutput("map", height = "700px", width = "100%"),
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
            selectInput("label", "Label", choices = c("brewery", "address", "zipcode", "village")),
            passwordInput("password", "Password:"),
            actionButton("go", "Go"),
            verbatimTextOutput("value")
          )
        ),
        sidebar_pane(
          title = "messages", id = "messages_id", icon = icon("person"),
          tagList(
            checkboxGroupInput("variable", "Variables to show:",
              c("Cylinders" = "cyl",
                "Transmission" = "am",
                "Gears" = "gear")),
            tableOutput("data")
          )
        )
      ),
      sidebar_tabs(id = "animalsidebar",
        list(icon("kiwi-bird"), icon("frog")),
        sidebar_pane(
          title = "kwi", id = "kiwi_id", icon = icon("kiwi-bird"),
          tagList(
            p("Kiwi birds are awesome.")
          )
        ),
        sidebar_pane(
          title = "frog", id = "frog_id", icon = icon("frog"),
          tagList(
            p("No frogs are better.")
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addSidebar(
        id = "mysidebarid",
        options = list(position = "left", fit = TRUE)
      ) %>%
      addSidebar(
        id = "animalsidebar",
        options = list(position = "right", fit = TRUE)
      )
  })
  observe({
    req(input$obs)
    df <- breweries91[sample.int(nrow(breweries91), input$obs), ]
    bbox <- st_bbox(df)
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
    tab_ids <- c(rep("mysidebarid", 3), rep("animalsidebar", 2))
    pane_ids <- c("home_id", "profile_id", "messages_id", "kiwi_id", "frog_id")
    idx <- sample.int(length(pane_ids), 1)
    leafletProxy("map", session) %>%
      openSidebar(pane_ids[idx], tab_ids[idx])
  })

  observeEvent(input$close, {
    leafletProxy("map", session) %>%
      closeSidebar(
        sample(c("mysidebarid", "animalsidebar"), 1))
  })

  observeEvent(input$clear, {
    leafletProxy("map", session) %>%
      removeSidebar(
        sample(c("mysidebarid", "animalsidebar"), 1))
  })
}
shinyApp(ui, server)
