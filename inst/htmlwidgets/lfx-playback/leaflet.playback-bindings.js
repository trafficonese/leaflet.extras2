/* global LeafletWidget, $, L, toGeoJSON */
LeafletWidget.methods.addPlayback= function(data, options) {
  var map = this;

  // If data is a string, parse it first
  if (typeof data === "string") {
    data = JSON.parse(data);
  }
  // Make JSON object
  if (data.type === undefined) {
    var kys = Object.keys(data);
    // Single JSON
    if (kys.includes("time")) {
      data = {
          type: "Feature",
          geometry: {
            type: "MultiPoint",
            coordinates: data.geometry
          },
          properties: {
              time: data.time
          }
      };
      data.properties.path_options = options.pathOptions;
      data.properties.radius = options.radius ? options.radius: 5;
    }
    // Array of JSONs
    else {
      var dattmp = [];
      for (kys in data) {
        var tmp = {
          type: "Feature",
          geometry: {
            type: "MultiPoint",
            coordinates: data[kys].geometry
          },
          properties: {
              time: data[kys].time,
              path_options: Object.assign({}, options.pathOptions),
              radius: options.radius ? options.radius: 5
          }
        };
        dattmp.push(tmp);
      }

      if (options.color) {
        if (Array.isArray(options.color) && options.color.length > 1) {
          for (var i = 0; i < options.color.length; i++) {
            dattmp[i].properties.path_options.color = options.color[i];
          }
        }
      }
      data = dattmp;
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

  var playback = new L.Playback(map, data, null, options);
};


LeafletWidget.methods.removePlayback= function() {
  this.controls.clear();
};

