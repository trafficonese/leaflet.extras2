/* global LeafletWidget, $, L */
LeafletWidget.methods.addTimeslider = function(data, options, popupOptions) {
  var map = this;
  if (map.sliderCntr) {
    map.sliderCntr.remove();
    delete map.sliderCntr;
  }

  // Add popups
  function onEachFeature(feature, layer) {
    var content = feature.properties.popup;
    layer.bindPopup(content, popupOptions);
  };

  //Create a marker layer
  var layer = L.geoJson(data, {
    pointToLayer: function (feature, latlng) {
        var geojsonMarkerOptions = {
            radius: feature.properties.radius,
            fillColor: feature.properties.fillColor,
            color: feature.properties.color,
            opacity: feature.properties.opacity,
            weight: feature.properties.weight,
            stroke: feature.properties.stroke,
            fill: feature.properties.fill,
            dashArray: feature.properties.dashArray,
            fillOpacity: feature.properties.fillOpacity
        };
        return L.circleMarker(latlng, geojsonMarkerOptions);
    },
    onEachFeature: onEachFeature
  });
  options.layer = layer;

  // Init the slider
  //debugger;
  map.sliderCntr = L.control.sliderControl(options);
  // Add the slider to the map
  map.addControl(map.sliderCntr);
  // Initialize the slider
  map.sliderCntr.startSlider();
};


LeafletWidget.methods.removeTimeslider = function() {
  var map = this;
  if (map.sliderCntr) {
    map.sliderCntr.remove();
    delete map.sliderCntr;
  }
};

