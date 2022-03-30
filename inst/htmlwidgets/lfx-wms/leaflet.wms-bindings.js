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
        var openpopup = true;
        if (options.checkempty) {
          var psdinf = info.match(/<body[^>]*>((.|[\n\r])*)<\/body>/im);
          console.log(psdinf)
          if (psdinf[1]) {
            debugger;
            if (psdinf[1].trim() == "") {
              openpopup = false
            }
          } else {
            openpopup = false
          }
        }
        if (openpopup) {
          this._map.openPopup(info, latlng, popupOptions);
        }

        // Adaptation for R/Shiny
        if (HTMLWidgets && HTMLWidgets.shinyMode && openpopup) {
          latlng.info = info;
          Shiny.setInputValue(this._map.id+"_wms_click", latlng, {priority: "event"});
        }
    }
  });

  // Add WMS source
  var source = L.wms.source(baseUrl, options);
  this.layerManager.addLayer(source.getLayer(options.layers), "tile", layerId, group);
};
