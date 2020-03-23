/* global LeafletWidget, $, L, topojson, csv2geojson, toGeoJSON */
LeafletWidget.methods.addPlayback= function(data, options) {
  var map = this;

  // If data is a string, parse it first
  if (typeof(data) === "string") {
    data = JSON.parse(data);
  }
  // If JSON has wrong format, try to fix it (part1)
  if (data.features !== undefined && data.features.length) {
    // TODO - change that part here
    console.log("change this part. When am i coming here???");
    var data1 = L.Playback.Util.ParseGPX();
    data1.geometry = data.features[0].geometry;
    data1.properties.time = data.features[0].properties.time;
    data1.properties.speed = data.features[0].properties.speed;
    data1.properties.altitude = data.features[0].properties.altitude;
    data = data1;
  }
  // If JSON has wrong format, try to fix it (part2)
  if (data.type === undefined) {
    data = {
        type: "Feature",
        geometry: {
          type: "MultiPoint",
          coordinates: data.geometry ? data.geometry : data.coordinates
        },
        properties: {
            time: data.time,
            speed: data.speed,
            altitude: data.altitude
        }
    };
  }

  // Add Mouse Events (Mouseover + Click)
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

  // Add an icon if given
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
        return {
            icon: madeIcon
            /*,getPopup: function (feature) {
                return feature.properties.title;
            }*/
        };
    };
  }

  // Customize the CircleMarker layer with pathOptions
  data.properties.path_options = options.pathOptions;
  data.properties.radius = options.radius ? options.radius: 5;
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

  //console.log("options"); console.log(options);
  var playback = new L.Playback(map, data, null, options);
};


LeafletWidget.methods.removePlayback= function() {
  this.controls.clear();
};

