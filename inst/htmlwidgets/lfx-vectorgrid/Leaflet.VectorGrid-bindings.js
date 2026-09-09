/* global LeafletWidget, $, L, HTMLWidgets, Shiny */
function lfxDefined(obj) {
  var out = {};
  Object.keys(obj).forEach(function(key) {
    if (obj[key] != null) {
      out[key] = obj[key];
    }
  });
  return out;
}

function lfxPatchPointGetLatLng(grid) {
  if (!grid || typeof grid._createLayer !== "function") return grid;
  var orig = grid._createLayer.bind(grid);
  grid._createLayer = function(feat, pxPerExtent, layerStyle) {
    var layer = orig(feat, pxPerExtent, layerStyle);
    if (feat && feat.type === 1) {
      layer.getLatLng = null;
    }
    return layer;
  };
  return grid;
}

LeafletWidget.methods.addVectorgrid = function(data, layerId, group, style, popup) {
  var map = this;

  var pick = function(prop, fallback) {
    return prop != null ? prop : fallback;
  };

  var featureStyle = function(properties) {
    properties = properties || {};
    return {
      stroke: pick(properties.stroke, style.stroke),
      color: pick(properties.color, style.color),
      weight: pick(properties.weight, style.weight),
      opacity: pick(properties.opacity, style.opacity),
      fill: pick(properties.fill, style.fill),
      fillColor: pick(properties.fillColor, style.fillColor),
      fillOpacity: pick(properties.fillOpacity, style.fillOpacity),
      dashArray: pick(properties.dashArray, style.dashArray)
    };
  };

  var addLayer = function(geojson) {
    var highlightId = null;
    var vectorGrid = lfxPatchPointGetLatLng(L.vectorGrid.slicer(geojson, {
      rendererFactory: L.svg.tile,
      interactive: style.interactive !== false,
      vectorTileLayerStyles: {
        sliced: function(properties) {
          return featureStyle(properties);
        }
      },
      getFeatureId: function(f) {
        var p = f.properties || {};
        if (p.vg_id != null) return String(p.vg_id);
        if (f.id != null) return String(f.id);
        return null;
      }
    }));

    var popupContent = function(properties) {
      if (!properties) return null;
      if (properties.vg_popup != null) return String(properties.vg_popup);
      if (popup && properties[popup] != null) return String(properties[popup]);
      return null;
    };

    vectorGrid.on("click", function(e) {
      var properties = e.layer.properties || {};
      var content = popupContent(properties);
      if (content) {
        L.popup()
          .setContent(content)
          .setLatLng(e.latlng)
          .openOn(map);
      }
      if (HTMLWidgets.shinyMode) {
        Shiny.setInputValue(map.id + "_vectorgrid_click", $.extend({
          id: properties.vg_id,
          group: group,
          lat: e.latlng.lat,
          lng: e.latlng.lng,
          properties: properties
        }, {}), {priority: "event"});
      }
    });

    vectorGrid.on("mouseover", function(e) {
      var id = e.layer.properties && e.layer.properties.vg_id;
      if (id == null) return;
      if (highlightId != null) vectorGrid.resetFeatureStyle(highlightId);
      highlightId = String(id);
      var hl = featureStyle(e.layer.properties);
      hl.weight = (hl.weight || 1) + 1;
      hl.color = "#000";
      vectorGrid.setFeatureStyle(highlightId, hl);
    });

    vectorGrid.on("mouseout", function() {
      if (highlightId != null) {
        vectorGrid.resetFeatureStyle(highlightId);
        highlightId = null;
      }
    });

    map.layerManager.addLayer(vectorGrid, "vectorgrid", layerId, group);
  };

  if (typeof data === "string") {
    fetch(data)
      .then(function(response) { return response.json(); })
      .then(addLayer);
  } else {
    addLayer(data);
  }
};

LeafletWidget.methods.addProtobuf = function(urlTemplate, layerId, group, options, styling) {
  var map = this;
  options = options || {};
  var vectorTileOptions = lfxDefined({
    rendererFactory: options.renderer === "svg" ? L.svg.tile : L.canvas.tile,
    vectorTileLayerStyles: styling || {},
    interactive: options.interactive !== false,
    getFeatureId: function(f) {
      var p = f.properties || {};
      if (p.id != null) return String(p.id);
      return null;
    },
    key: options.key,
    minZoom: options.minZoom,
    maxZoom: options.maxZoom,
    subdomains: options.subdomains,
    errorTileUrl: options.errorTileUrl,
    zoomOffset: options.zoomOffset,
    tms: options.tms,
    zoomReverse: options.zoomReverse,
    detectRetina: options.detectRetina,
    tileSize: options.tileSize,
    opacity: options.opacity,
    updateWhenIdle: options.updateWhenIdle,
    updateWhenZooming: options.updateWhenZooming,
    updateInterval: options.updateInterval,
    zIndex: options.zIndex,
    bounds: options.bounds,
    maxNativeZoom: options.maxNativeZoom,
    minNativeZoom: options.minNativeZoom,
    noWrap: options.noWrap,
    pane: options.pane || "tilePane",
    className: options.className,
    keepBuffer: options.keepBuffer,
    attribution: options.attribution,
    fetchOptions: options.fetchOptions
  });

  var pbfLayer = lfxPatchPointGetLatLng(
    L.vectorGrid.protobuf(urlTemplate, vectorTileOptions)
  );

  var origGetTile = pbfLayer._getVectorTilePromise.bind(pbfLayer);
  var belowMinZoom = function(layer) {
    var zoomMap = layer._map;
    if (!zoomMap) return false;
    var minZ = layer.options.minZoom;
    return minZ != null && zoomMap.getZoom() < minZ;
  };
  pbfLayer._getVectorTilePromise = function(coords) {
    if (belowMinZoom(this)) {
      return Promise.resolve({layers: {}});
    }
    var layer = this;
    return origGetTile(coords).then(function(tile) {
      return belowMinZoom(layer) ? {layers: {}} : tile;
    });
  };
  var origCreateTile = pbfLayer.createTile.bind(pbfLayer);
  pbfLayer.createTile = function(coords, done) {
    if (belowMinZoom(this)) {
      var empty = L.DomUtil.create("div");
      L.Util.requestAnimFrame(function() { done(null, empty); });
      return empty;
    }
    return origCreateTile(coords, done);
  };
  pbfLayer.on("add", function() {
    var grid = this;
    var dropTiles = function() {
      if (belowMinZoom(grid) && typeof grid._removeAllTiles === "function") {
        grid._removeAllTiles();
        grid._tileZoom = undefined;
      }
    };
    this._map.on("zoom zoomend", dropTiles);
    this.once("remove", function() {
      if (grid._map) {
        grid._map.off("zoom zoomend", dropTiles);
      }
    });
  });

  pbfLayer.on("click", function(e) {
    var properties = e.layer.properties || {};
    var pop = options.popup ? properties[options.popup] : null;
    if (pop != null) {
      L.popup()
        .setContent(String(pop))
        .setLatLng(e.latlng)
        .openOn(map);
    }
    if (HTMLWidgets.shinyMode) {
      Shiny.setInputValue(map.id + "_vectorgrid_pbf_click", {
        id: properties.id,
        group: group,
        lat: e.latlng.lat,
        lng: e.latlng.lng,
        properties: properties
      }, {priority: "event"});
    }
  });

  if (options.label) {
    var tip = L.tooltip({sticky: true, opacity: 0.9});
    pbfLayer.on("mouseover", function(e) {
      var properties = e.layer.properties || {};
      var text = properties[options.label];
      if (text == null || !e.latlng) return;
      tip.setContent(String(text)).setLatLng(e.latlng);
      if (!tip._map) {
        tip.addTo(map);
      }
    });
    pbfLayer.on("mousemove", function(e) {
      if (tip._map && e.latlng) {
        tip.setLatLng(e.latlng);
      }
    });
    pbfLayer.on("mouseout", function() {
      map.closeTooltip(tip);
    });
  }

  map.layerManager.addLayer(pbfLayer, "vectorgrid", layerId, group);
};

LeafletWidget.methods.removeVectorgrid = function(layerId) {
  this.layerManager.removeLayer("vectorgrid", layerId);
};

LeafletWidget.methods.clearVectorgrid = function() {
  this.layerManager.clearLayers("vectorgrid");
};
