/* global LeafletWidget, $, L, toGeoJSON */
LeafletWidget.methods.addPlayback= function(data, options) {
  var map = this;
  if (map.playback) {
      map.playback.destroy();
      delete map.playback;
  }

  // If mutliple Features, transform the Object to an Array and add path_options+radius
  if (data.type !== "Feature" && Object.keys(data).length > 1) {
    data = Object.values(data);
    for (var i = 0; i < data.length; i++) {
      data[i].properties.path_options = Object.assign({}, options.pathOptions);
      data[i].properties.radius = options.radius ? options.radius: 5;
    }
  } else {
    // Add path_options+radius to single Feature
    data.properties.path_options = options.pathOptions;
    data.properties.radius = options.radius ? options.radius: 5;
  }

  // Add Color to path_options
  if (options.color) {
      if (Array.isArray(options.color) && options.color.length > 1) {
        for (var j = 0; j < options.color.length; j++) {
          if (data[j]) {
            data[j].properties.path_options.color = options.color[j];
          }
        }
      }
  }

  // Add Mouse Events (Mouseover + Click)
  if (HTMLWidgets.shinyMode === true) {
    options.mouseOverCallback = function(el) {
      var obj = {
        lat: el.latlng.lat,
        lng: el.latlng.lng,
        popup: el.popupContent
      };
      Shiny.onInputChange(map.id+"_pb_mouseover", obj);
    };
    options.clickCallback  = function(el) {
      var obj = {
        lat: el.latlng.lat,
        lng: el.latlng.lng,
        popup: el.popupContent
      };
      Shiny.onInputChange(map.id+"_pb_click", obj);
    };
  }

  // Add playbackoptions and Icon
  options.layer = {
    pointToLayer : function(featureData, latlng, options) {
        var result = {};
        if (featureData && featureData.properties && featureData.properties.path_options) {
            result = featureData.properties.path_options;
        }
        result.radius = featureData.properties.radius;
        return new L.CircleMarker(latlng, result);
    }
  };
  if (options && options.icon) {
    var icoli = options.icon;
    var madeIcon = L.icon({
            iconUrl: icoli.iconUrl,
            iconSize: [icoli.iconWidth, icoli.iconHeight],
            shadowSize: [icoli.shadowWidth, icoli.shadowHeight],
            iconAnchor: [icoli.iconAnchorX, icoli.iconAnchorY],
            shadowAnchor: [icoli.shadowAnchorX, icoli.shadowAnchorY],
            popupAnchor: [icoli.popupAnchorX, icoli.popupAnchorY]
    });
    options.marker = function(featureData) {
        return {icon: madeIcon};
    };
  }

  map.playback = new L.Playback(map, data, null, options);
};


LeafletWidget.methods.removePlayback= function() {
  var map = this;
  if (map.playback) {
    map.playback.destroy();
    delete map.playback;
  }
};

