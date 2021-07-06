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
                       context_menuItem(text = "Show Marker Coords",
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
                                  icon="https://image.flaticon.com/icons/png/512/1175/1175343.png",
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
