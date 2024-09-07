LeafletWidget.methods.addWMSHeader = function(baseUrl, layerId, group, options, header) {

  console.log("addWMSHeader header:"); console.log(header)

  if(options && options.crs) {
    options.crs = LeafletWidget.utils.getCRS(options.crs);
  }

  // Add WMS source
  var source = L.TileLayer.wmsHeader(baseUrl, options, [header], null);
  this.layerManager.addLayer(source, "tile", layerId, group);
};
