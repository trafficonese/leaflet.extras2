library(shiny)
library(leaflet)
pkgload::load_all("C:/Users/kona1/Documents/Github_Forks/leaflet.extras2")

# Docker (CORS already on):
# docker run -d --name geoserver -p 8080:8080 `
#   -e GEOSERVER_ADMIN_USER=admin `
#   -e GEOSERVER_ADMIN_PASSWORD=geoserver `
#   -e CORS_ENABLED=true `
#   -e SAMPLE_DATA=true `
#   kartoza/geoserver:2.24.2
#
# Services: wms.GetMap / wms.GetFeatureInfo = ROLE_AUTHENTICATED
# Test in a private window and close the GeoServer admin tab —
# otherwise the browser may reuse the admin session/Basic cache.

basic_auth <- function(user, password) {
  paste("Basic", jsonlite::base64_enc(charToRaw(paste0(user, ":", password))))
}

wms_opts <- function() {
  WMSTileOptions(
    tiled = TRUE,
    transparent = TRUE,
    format = "image/png",
    info_format = "text/html"
  )
}

add_demo_wms <- function(proxy, url, layer, headers = NULL) {
  proxy %>%
    clearGroup("WMS") %>%
    addWMS(
      baseUrl = url,
      layers = layer,
      layerId = "wms-auth",
      group = "WMS",
      headers = headers,
      options = wms_opts()
    )
}

ui <- fluidPage(
  tags$p("Click a button after each change. Use a private window and close the GeoServer admin UI."),
  fluidRow(
    column(4, textInput("url", "WMS URL", "http://127.0.0.1:8080/geoserver/wms", width = "100%")),
    column(3, textInput("layer", "Layer", "topp:states", width = "100%")),
    column(2, textInput("user", "User", "admin", width = "100%")),
    column(3, passwordInput("password", "Password", "geoserver", width = "100%"))
  ),
  actionButton("with_auth", "Apply credentials"),
  actionButton("wrong_auth", "Wrong credentials"),
  actionButton("no_auth", "No headers"),
  leafletOutput("map", height = "500px")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(group = "base") %>%
      setView(-100, 40, 4) %>%
      addLayersControl(baseGroups = "base", overlayGroups = "WMS")
  })

  observeEvent(input$with_auth, {
    add_demo_wms(
      leafletProxy("map"),
      input$url,
      input$layer,
      c(Authorization = basic_auth(input$user, input$password))
    )
  })

  observeEvent(input$wrong_auth, {
    add_demo_wms(
      leafletProxy("map"),
      input$url,
      input$layer,
      c(Authorization = basic_auth("not-a-user", "wrong-password"))
    )
  })

  observeEvent(input$no_auth, {
    add_demo_wms(leafletProxy("map"), input$url, input$layer, NULL)
  })
}

shinyApp(ui, server)
