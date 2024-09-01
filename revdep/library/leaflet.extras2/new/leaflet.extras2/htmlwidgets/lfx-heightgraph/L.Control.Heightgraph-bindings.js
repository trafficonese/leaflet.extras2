LeafletWidget.methods.addHeightgraph = function(data, props, layerId, group, geojson_opts, options) {
  var map = this;

  // Add Last Coordinates of every Linestring to first Coordinates of next Linestring
  var propkeys = Object.keys(props);
  for (var i = 0; i < data.length; i++) {
    data[i].properties = {records: props[propkeys[i]].length, summary: propkeys[i]};
    var tmp = data[i].features;
    for (var j = 0; j < tmp.length; j++) {
      if (tmp[j + 1]) {
        var lncrd = tmp[j].geometry.coordinates.length;
        tmp[j + 1].geometry.coordinates.unshift(
          tmp[j].geometry.coordinates[lncrd - 1]);
      }
    }
  }

  // Add Control + Data to Control
  var hg = L.control.heightgraph(options);
  map.controls.add(hg, "hg_control");
  hg.addData(data);

  // Add Geojson to Map
  let gjlayer = L.geoJson(data, {
    onEachFeature: function(feature, layer) {
      let extraInfo = {
        featureId: feature.id,
        properties: feature.properties
      };
      let popup = feature.properties ? feature.properties.popup : null;
      if (typeof popup !== "undefined" && popup !== null) layer.bindPopup(popup);
      layer.on("click", LeafletWidget.methods.mouseHandler(map.id, layerId, group, "heightgraph_click", extraInfo), this);
      layer.on("mouseover", LeafletWidget.methods.mouseHandler(map.id, layerId, group, "heightgraph_mouseover", extraInfo), this);
      layer.on("mouseout", LeafletWidget.methods.mouseHandler(map.id, layerId, group, "heightgraph_mouseout", extraInfo), this);
    }
  });
  map.layerManager.addLayer(gjlayer, "geojson", layerId, group);
};
