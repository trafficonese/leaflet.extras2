LeafletWidget.methods.addWMS = function(baseUrl, layers, group, options) {

  if(options && options.crs) {
    options.crs = LeafletWidget.utils.getCRS(options.crs);
  }

  L.wms.Source = L.wms.Source.extend({
    'showFeatureInfo': function(latlng, info) {
        debugger;
        // Hook to handle displaying parsed AJAX response to the user
        if (!this._map) {
            return;
        }
        if (info.match(/<body[^>]*>((.|[\n\r])*)<\/body>/im)[1].trim() !== "") {
          this._map.openPopup(info, latlng);
          latlng.info = info;
          Shiny.setInputValue(this._map.id+"_wms_click", latlng, {priority: "event"});
        }
    }
  });
  // Add WMS source
  var source = L.wms.source(baseUrl, options);

  // This works too, but doesn respect the layerId ??
  //this.layerManager.addLayer(source.getLayer(layers), "tile", layers, group);

  // Add layers
  if (typeof(layers) === "string") {
    var layer = source.getLayer(layers);
    this.layerManager.addLayer(layer, "tile", layers, group);
  } else {
    layers.forEach(e => this.layerManager.addLayer(
      source.getLayer(e), "tile", e, e));
  }
};
