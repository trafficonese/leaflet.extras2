LeafletWidget.methods.addOpenweather = function(layers, group, layerId, options) {
  var map = this;
  var owm;
  // If 1 layer only, convert to Array
  if (typeof layers == "string") {
    layers = [layers];
  }
  for (var i = 0; i < layers.length; i++) {
    var name = layers[i];
    owm = L.OWM[name](options);
    map.layerManager.addLayer(owm, "tile", layerId[i], group[i]);
  }
};


LeafletWidget.methods.addOpenweatherCurrent = function(group, layerId, options) {
  var map = this;

  L.OWM.Current = L.OWM.Current.extend({
    	_createMarker: function(station) {
    		var imageData = this._getImageData(station);
    		var icon = L.divIcon({
    						className: ''
    						, iconAnchor: new L.Point(25, imageData.height/2)
    						, popupAnchor: new L.Point(0, -10)
    						, html: this._icondivtext(station, imageData.url, imageData.width, imageData.height)
    					});
    		var marker = L.marker([station.coord.Lat, station.coord.Lon], {icon: icon})
    		              .on("click", function(x) {
    		                if (HTMLWidgets.shinyMode) {
      		                var obj = {
      		                  lat: x.latlng.lat,
      		                  lng: x.latlng.lng,
      		                  content: x.target._popup._content
      		                };
    		                  Shiny.setInputValue(this._map.id + "_owm_click", obj, {priority: "event"});
    		                }
    		              });
    		return marker;
    	}
  });

  var curr = L.OWM.current(options);
  map.layerManager.addLayer(curr, "marker", layerId, group);
};
