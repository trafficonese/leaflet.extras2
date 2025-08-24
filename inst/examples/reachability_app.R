library(shiny)
library(leaflet)
library(leaflet.extras2)

## Include your API-Key
# Sys.setenv("OPRS" = 'Your_API_Key')
apikey <- Sys.getenv("OPRS")

ui <- fluidPage(
  icon("cars"), ## needed to load FontAwesome Lib
  leafletOutput("map")
  ,actionButton("removeReachability", "removeReachability")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(group = "base") %>%
      setView(8, 50, 11) %>%
      addLayersControl(baseGroups = "base") %>%
      addReachability(apikey = apikey,
                      options = reachabilityOptions(
                        collapsed = FALSE,
                        drawButtonContent        = icon("pen"),
                        deleteButtonContent      = icon("x"),
                        distanceButtonContent    = icon("map-marked"),
                        timeButtonContent        = icon("clock"),
                        travelModeButton1Content = icon("car"),
                        travelModeButton2Content = icon("bicycle"),
                        travelModeButton3Content = icon("walking"),
                        travelModeButton4Content = icon("wheelchair"),
                        clickFn = JS("function(e) {
                          //console.log('clickFn');console.log(e);
                          var layer = e.target;
                          var props = layer.feature.properties;
                          var popupContent = 'Mode of travel: ' + props['Travel mode'] +
                                              '<br />Range: 0 - ' + props['Range'] + ' ' + props['Range units'] +
                                              '<br />Area: ' + props['Area'] + ' ' + props['Area units'] +
                                              '<br />Population: ' + props['Population'];
                          if (props.hasOwnProperty('Reach factor')) popupContent += '<br />Reach factor: ' + props['Reach factor'];
                          layer.bindPopup(popupContent).openPopup();
                        }"),
                        mouseOutFn = JS("function(e) {
                          //console.log('mouseOutFn');console.log(e);
                          var layer = e.target;
                          e.target._map.reachabilityControl.isolinesGroup.resetStyle(layer);
                        }"),
                        mouseOverFn = JS("function(e) {
                          //console.log('mouseOverFn');console.log(e);
                          var layer = e.target;
                          layer.setStyle({
                              fillColor: '#E16462',
                              dashArray: '1,13',
                              weight: 4,
                              fillOpacity: '0.5',
                              opacity: '1'
                          });
                          // add tooltip/label dynamically
                          if (layer.feature && layer.feature.properties) {
                            var props = layer.feature.properties;
                            var label = 'Range: ' + props['Range'] + ' ' + props['Range units'];
                            layer.bindTooltip(label, {permanent: false, sticky: true, direction: 'top'});
                            layer.openTooltip();
                          }
                         }"),
                        styleFn = JS("function(feature) {
                            //console.log('styleFn');console.log(feature);
                            var rangeVal = feature.properties['Range'];
                            if (feature.properties['Measure'] == 'distance') rangeVal = rangeVal * 10;
                            return {
                                color: getColourByRange(rangeVal),
                                opacity: 0.5,
                                fillOpacity: 0.2
                            };
                        }"),
                        showOriginMarker = TRUE,
                        markerFn = JS("function(latLng, travelMode, rangeType) {
                          //console.log('markerFn');console.log(latLng);
                          return L.circleMarker(latLng, { radius: 5, weight: 2, color: '#0073d4',
                                                          fillColor: '#fff', fillOpacity: 1 });
                        }"),
                        markerClickFn = JS("function(e) {console.log('markerClickFn');console.log(e);}"),
                        markerOutFn = JS("function(e) {console.log('markerOutFn');console.log(e);}"),
                        markerOverFn = JS("function(e) {console.log('markerOverFn');console.log(e);}")
                      ))
  })
  observeEvent(input$removeReachability, {
    leafletProxy("map") %>%
      removeReachability()
  })
  observeEvent(input$map_reachability_displayed, {
    print("input$map_reachability_displayed")
  })
  observeEvent(input$map_reachability_delete, {
    print("input$map_reachability_delete")
  })
  observeEvent(input$map_reachability_error, {
    print("input$map_reachability_error")
  })
}

shinyApp(ui, server)
