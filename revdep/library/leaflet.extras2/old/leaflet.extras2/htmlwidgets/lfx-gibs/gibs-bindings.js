LeafletWidget.methods.addGIBS = function(layers, group, date, opacity, transparent) {
  var map = this;

  // Init map.gibs object
  map.gibs = map.gibs || {};

  // Add single GIBS Layer
  if (typeof layers === "string") {
    var gibslayer = new L.GIBSLayer(layers, {
        date: new Date(date),
        transparent: transparent,
        opacity: opacity
    });
    map.gibs[layers] = gibslayer;
    map.layerManager.addLayer(gibslayer, "tile", layers, group);
    return;
  }

  // Add multiple GIBS Layer
  if (typeof layers === "object") {
    layers.forEach(function(layer, idx) {
      var gibslayer = new L.GIBSLayer(layer, {
          date: new Date(date[idx]),
          transparent: transparent[idx],
          opacity: opacity[idx]
      });
      map.gibs[layer] = gibslayer;
      map.layerManager.addLayer(gibslayer, "tile", layer, group[idx]);
    });
  }

};

LeafletWidget.methods.setDate = function(layers, date) {
  var map = this;
  if (typeof layers === "string") {
    map.gibs[layers] && map.gibs[layers].setDate(new Date(date));
  } else {
    layers.forEach(function(layer) {
      map.gibs[layer] && map.gibs[layer].setDate(new Date(date));
    });
  }
};

LeafletWidget.methods.setTransparent = function(layers, bool) {
  var map = this;
  if (typeof layers === "string") {
    map.gibs[layers].setTransparent && map.gibs[layers].setTransparent(bool);
  } else {
    layers.forEach(function(layer) {
      map.gibs[layer].setTransparent && map.gibs[layer].setTransparent(bool);
    });
  }
};
