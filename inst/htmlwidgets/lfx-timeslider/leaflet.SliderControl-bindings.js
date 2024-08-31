/* global LeafletWidget, $, L */
LeafletWidget.methods.addTimeslider = function(data, options, popupOptions, labelOptions) {
  var map = this;
  if (map.sliderCntr) {
    map.sliderCntr.remove();
    delete map.sliderCntr;
  }

  // Add popups
  function onEachFeature(feature, layer) {
    var popup = feature.properties.popup;
    if (popup) layer.bindPopup(popup, popupOptions);

    var label = feature.properties.label;
    if (label) layer.bindTooltip(label, labelOptions);
  };

  //Create a marker layer
  var layer = L.geoJson(data, {
    style: function(feature) {
      return {
        radius: feature.properties.radius,
        fillColor: feature.properties.fillColor,
        color: feature.properties.color,
        opacity: feature.properties.opacity,
        weight: feature.properties.weight,
        stroke: feature.properties.stroke,
        fill: feature.properties.fill,
        dashArray: feature.properties.dashArray,
        fillOpacity: feature.properties.fillOpacity
      }
    },
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

  /*
  // Multi Layer in layerGroup
  var layer1 = L.geoJson(data, {
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
  var times = []
  data.features.forEach(e=> times.push(e.properties.time))
  layer.options.time = "1992";
  layer1.options.time = "1993";
  layer = L.layerGroup([layer, layer1]);
  */
  options.layer = layer;

  // Init the slider
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

