library(shiny)
library(leaflet)
library(leaflet.extras2)

ui <- fluidPage(
  leafletOutput("map", height = "800px"),
  actionButton("show", "Show Contextmenu at given Coordinates"),
  actionButton("hide", "Hide Contextmenu"),
  actionButton("add", "Add Options to Contextmenu"),
  actionButton("ins", "Insert Options to Contextmenu"),
  actionButton("rm", "Remove Option 2"),
  actionButton("disable", "Disable Contextmenu Item 1"),
  actionButton("enable", "Enable Contextmenu Item 1"),
  actionButton("disable_all", "Disable Contextmenu"),
  actionButton("enable_all", "Enable Contextmenu"),
  actionButton("rmall", "Remove All Map Items"),
  splitLayout(
    div(
      h4("Contextmenu Selection:"),
      verbatimTextOutput("print"),
    ),
    div(
      h4("Custom Marker Selection:"),
      verbatimTextOutput("print1")
    )
  )
)

server <- function(input, output, session) {
  data <- reactiveVal()
  data1 <- reactiveVal()

  output$map <- renderLeaflet({
    ## Basemap ####################
    suppressWarnings(
    leaflet(options = leafletOptions(
      contextmenu=TRUE,
      contextmenuWidth = 200,
      contextmenuItems =
        context_mapmenuItems(
          context_menuItem("Zoom Out", "function(e) {this.zoomOut();}", disabled=TRUE),
          context_menuItem("Zoom In", "function(e) {this.zoomIn();}"),
          "-",
          context_menuItem("Disable index 0",
                   "function(e) {this.contextmenu.setDisabled(0, true)}",
                   hideOnSelect = TRUE),
          context_menuItem("Enable index 0",
                   "function(e) {this.contextmenu.setDisabled(0, false)}",
                   hideOnSelect = FALSE),
          "-",
          context_menuItem(text="Center Map",
               callback="function(e) {this.panTo(e.latlng);}",
               icon="https://cdn3.iconfinder.com/data/icons/web-15/128/RSSvgLink-2-512.png"),
          list(text="Console Log",
                   callback=JS("function(e) {console.log('e');console.log(e);}"))
        ))) %>%
      addTiles(group = "base") %>%
      addContextmenu() %>%

      ## Points ###############################
      addMarkers(data = sf::st_as_sf(leaflet::breweries91),
                 label=~brewery, layerId = ~founded, group="marker",
                 options = markerOptions(
                   contextmenu=TRUE,
                   contextmenuWidth = 200,
                   contextmenuItems =
                     context_markermenuItems(
                       context_menuItem(
                         text = "Show Marker Coords",
                         "function(e) {
                            Shiny.setInputValue(map.id + '_mymarkertrigger', {
                                    menuid: e.relatedTarget.options.contextmenuItems[0].id,
                                    layerId: e.relatedTarget.options.layerId,
                                    lat: e.relatedTarget.options.lat,
                                    lng: e.relatedTarget.options.lng,
                                    opacity: e.relatedTarget.options.opacity
                                  });
                            alert(e.latlng);}",
                         id = "somemarkerid",
                         icon="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/Person_icon_BLACK-01.svg/1200px-Person_icon_BLACK-01.svg.png",
                         index=0)
                     )
                 )) %>%
      ## Lines ###############################
      addPolylines(data = sf::st_as_sf(leaflet::atlStorms2005),
                   layerId = ~Name, group="lines",
                   label = ~Name,
                   options = pathOptions(
                     contextmenu=TRUE,
                     contextmenuWidth = 400,
                     contextmenuInheritItems = FALSE,
                     contextmenuItems =
                       context_markermenuItems(
                         context_menuItem(text = "Get Line Data",
                                  NULL,
                                  index=0),
                         context_menuItem(text = "Delete Line",
                                  "function(e) {e.relatedTarget.remove()}",
                                  icon="data:image/png;base64,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",
                                  index=1),
                         context_menuItem(text = "Change Color/Weight",
                                  "function(e) {e.relatedTarget.setStyle({color: '#'+(0x1000000+(Math.random())*0xffffff).toString(16).substr(1,6),
                                                                          weight: Math.round(Math.random()*10)});}",
                                  icon = "https://cdn3.iconfinder.com/data/icons/ui-glynh-blue-02-of-5/100/UI_Blue_2_of_3_30-512.png",
                                  index = 2),
                         context_menuItem(text = "Add Centroid",
                                  "function(e) {L.marker(Object.values(e.relatedTarget.getCenter())).addTo(this);}",
                                  icon = "https://bodylab.ch/wp-content/uploads/2015/11/map-marker-icon.png",
                                  index = 3),
                         context_menuItem(text = "Log GeoJSON",
                                  "function(e) {console.log(e.relatedTarget.toGeoJSON());}",
                                  icon = "https://cdn0.iconfinder.com/data/icons/outlinecons-filetypes/512/log-512.png",
                                  index = 4),
                         context_menuItem(text = "-", separator=TRUE,
                                  index = 5)
                       )
                   )) %>%
      ## Shapes ###############################
      addPolygons(data = sf::st_as_sf(leaflet::gadmCHE),
                  label=~NAME_1, layerId = ~OBJECTID, group="shapes",
                  options = pathOptions(
                    contextmenu=TRUE,
                    contextmenuWidth = 200,
                    contextmenuItems =
                      context_markermenuItems(
                        context_menuItem(text = "Get Polygon Coords",
                                 "function(e) {console.log(e.latlng);}",
                                 index = 0),
                        context_menuItem(text = "Delete Polygon",
                                 "function(e) {e.relatedTarget.remove()}",
                                 index = 1),
                        context_menuItem(text = "Change Color",
                                 "function(e) {e.relatedTarget.setStyle({color: '#4B1BDE',
                                                                         fillColor : '#'+(0x1000000+(Math.random())*0xffffff).toString(16).substr(1,6),
                                                                         fillOpacity: 1});}",
                                 index = 2),
                        context_menuItem(text = "Add Centroid",
                                 "function(e) {L.marker(Object.values(e.relatedTarget.getCenter())).addTo(this);}",
                                 index = 3),
                        context_menuItem(text = "Log GeoJSON",
                                 "function(e) {console.log(e.relatedTarget.toGeoJSON());}",
                                 index = 4),
                        context_menuItem(text = "-", NULL, separator=TRUE,
                                 index = 5)
                      )
                  ))
    )
  })

  observeEvent(input$map_contextmenu_select, {
    txt <- input$map_contextmenu_select
    data(txt)
    print(txt)
  })
  observeEvent(input$map_mymarkertrigger, {
    message("Return Value from 'Show Marker Coords' - callback")
    txt <- rbind(input$map_mymarkertrigger)
    data1(txt)
    print(txt)
  })
  observeEvent(input$show, {
    leafletProxy("map") %>%
      showContextmenu(data = leaflet::breweries91[sample(1:32, 1),])
  })
  observeEvent(input$hide, {
    leafletProxy("map") %>%
      hideContextmenu()
  })
  observeEvent(input$disable_all, {
    leafletProxy("map") %>%
      disableContextmenu()
  })
  observeEvent(input$enable_all, {
    leafletProxy("map") %>%
      enableContextmenu()
  })
  observeEvent(input$add, {
    ## Requires https://github.com/rstudio/leaflet/pull/696 to be merged!
    leafletProxy("map") %>%
      addItemContextmenu(
        context_menuItem(text = "Added Menu Item",
                 callback = ("function(e) {alert('I am a new menuItem!');
                                           console.log('e');console.log(e);}")))
  })
  observeEvent(input$ins, {
    ## Requires https://github.com/rstudio/leaflet/pull/696 to be merged!
    leafletProxy("map") %>%
      addItemContextmenu(
        context_menuItem(text = "Inserted Menu Item at Index 2",
                 callback = ("function(e) {alert('I am an inserted menuItem!');
                                           console.log('e');console.log(e);}")))
  })
  observeEvent(input$rm, {
    leafletProxy("map") %>%
      removeItemContextmenu(2)
  })
  observeEvent(input$disable, {
    leafletProxy("map") %>%
      setDisabledContextmenu(1, TRUE)
  })
  observeEvent(input$enable, {
    leafletProxy("map") %>%
      setDisabledContextmenu(1, FALSE)
  })
  observeEvent(input$rmall, {
    leafletProxy("map") %>%
      removeallItemsContextmenu()
  })

  output$print <- renderPrint({
    txt <- req(data())
    print(txt)
  })
  output$print1 <- renderPrint({
    txt <- req(data1())
    print(txt)
  })
}

shinyApp(ui, server)
