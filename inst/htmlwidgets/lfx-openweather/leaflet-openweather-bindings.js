LeafletWidget.methods.addOpenweather = function(apikey, layers, addControl, group, opacity) {

  var map = this;
  var addCurrent = true;

  debugger;
  var overlayMaps = {};
  for (var i = 0; i < layers.length; i++) {
    var name = layers[i];
    overlayMaps[name] = L.OWM[name]({opacity: opacity[i], appId: apikey});
  }

  if (addCurrent) {
    overlayMaps.Cities = L.OWM.current({intervall: 15, lang: 'de', appId: apikey, type: "city" });
  }

  var layerControl = L.control.layers(undefined, overlayMaps, {collapsed: false}).addTo(map);
};

/*
LeafletWidget.methods.removeVelocity  = function(layerId) {
  this.layerManager.removeLayer("velocity", layerId);
};
*/


