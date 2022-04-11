LeafletWidget.methods.addWMS = function(baseUrl, layerId, group, options, popupOptions) {

  if(options && options.crs) {
    options.crs = LeafletWidget.utils.getCRS(options.crs);
  }

  // Hijacked showFeatureInfo-function to extend for Shiny
  L.wms.Source = L.wms.Source.extend({
    'showFeatureInfo': function(latlng, info) {
        // Hook to handle displaying parsed AJAX response to the user
        if (!this._map) {
            return;
        }

        // TODO - Check if body is empty?
        this._map.openPopup(info, latlng, popupOptions);

        // Adaptation for R/Shiny
        if (HTMLWidgets && HTMLWidgets.shinyMode) {
          latlng.info = info;
          Shiny.setInputValue(this._map.id+"_wms_click", latlng, {priority: "event"});
        }
    }
  });

  // Add WMS source
  var source = L.wms.source(baseUrl, options);
  this.layerManager.addLayer(source.getLayer(options.layers), "tile", layerId, group);
};
