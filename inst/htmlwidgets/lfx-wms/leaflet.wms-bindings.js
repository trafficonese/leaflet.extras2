function patchWmsSourceOnce() {
  if (L.wms.Source._lfxPatched) {
    return;
  }
  L.wms.Source = L.wms.Source.extend({
    'showFeatureInfo': function(latlng, info) {
        if (!this._map) {
            return;
        }

        var openpopup = true;
        if (this.options.checkempty) {
          var psdinf = info.match(/<body[^>]*>((.|[\n\r])*)<\/body>/im);
          if (psdinf && psdinf[1]) {
            if (psdinf[1].trim() == "") {
              openpopup = false;
            }
          } else {
            openpopup = false;
          }
        }
        if (openpopup) {
          this._map.openPopup(info, latlng, this.options.popupOptions);
        }

      if (HTMLWidgets && HTMLWidgets.shinyMode) {
        latlng.info = info;
        Shiny.setInputValue(this._map.id+"_wms_click", latlng, {priority: "event"});
      }
    }
  });
  L.wms.Source._lfxPatched = true;
}

function applyWmsParams(layer, params) {
  if (!layer || !layer._source || !layer._source._overlay || !params) {
    return;
  }
  var overlay = layer._source._overlay;
  if (overlay.setParams) {
    overlay.setParams(params);
  }
  L.extend(layer._source.options, params);
}

function collectWmsLayers(map, layerId, group) {
  var found = [];
  function consider(layer) {
    if (layer && layer._source && layer._source._overlay) {
      found.push(layer);
    }
  }
  if (layerId != null && layerId !== "") {
    [].concat(layerId).forEach(function(id) {
      consider(map.layerManager.getLayer("tile", id));
    });
    return found;
  }
  if (group != null && group !== "") {
    var grp = map.layerManager.getLayerGroup(group, false);
    if (grp && grp.eachLayer) {
      grp.eachLayer(consider);
    }
    return found;
  }
  var byCat = map.layerManager._byCategory;
  if (byCat && byCat.tile) {
    Object.keys(byCat.tile).forEach(function(stamp) {
      consider(byCat.tile[stamp]);
    });
  }
  return found;
}

LeafletWidget.methods.addWMS = function(baseUrl, layerId, group, options, popupOptions) {
  options = options || {};
  if (options.crs) {
    options.crs = LeafletWidget.utils.getCRS(options.crs);
  }
  options.popupOptions = popupOptions;

  patchWmsSourceOnce();

  var source = L.wms.source(baseUrl, options);
  this.layerManager.addLayer(source.getLayer(options.layers), "tile", layerId, group);
};

LeafletWidget.methods.setWMSParams = function(layerId, group, params) {
  collectWmsLayers(this, layerId, group).forEach(function(layer) {
    applyWmsParams(layer, params);
  });
};
