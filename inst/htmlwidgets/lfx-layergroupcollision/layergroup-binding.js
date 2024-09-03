/* global LeafletWidget, $, L, Shiny, HTMLWidgets */
LeafletWidget.methods.addLayerGroupCollision = function(
    data, group, margin) {

		var collisionLayer = L.LayerGroup.collision({margin: margin});

		for (var i=0; i < data.features.length; i++) {
			var feat = data.features[i];

      // Note that the markers are not interactive because MSIE on a WinPhone will take *ages*
      // to run addEventListener() on them.
      var marker = new L.marker(
        L.GeoJSON.coordsToLatLng(feat.geometry.coordinates), {
            icon: L.divIcon({
    					html:
    						"<span class='" + feat.properties["className__"] + "'>" +
    						feat.properties["html__"] +
    						"</span>"
    				})
            , interactive: false	// Post-0.7.3
	          , clickable:   false	//      0.7.3
      });

			collisionLayer.addLayer(marker);
		}
		this.layerManager.addLayer(collisionLayer, "collison", null, group);

};
