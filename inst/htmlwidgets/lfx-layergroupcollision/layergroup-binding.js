/* global LeafletWidget, $, L, Shiny, HTMLWidgets */
LeafletWidget.methods.addLayerGroupCollision = function(group, margin) {
  var map = this;

  // Get groups as Array and Loop over all
  var groups = Array.isArray(group) ? group : [group]
  console.log("groups"); console.log(groups)

  groups.forEach(function(grp) {
    var i = 0;


    console.log("grp"); console.log(grp);


    // Get the layers for the given group and call `addLabel` for each one
    var markers = map.layerManager.getLayerGroup(grp);

    //var layercollision = new L.LayerGroup.collision(markers)

    var collisionLayer = L.LayerGroup.collision({margin:margin});
    collisionLayer.addLayer(markers);
    collisionLayer.addTo(map);

/*
    // If the marker group exists add events
    if (markers) {
      // Call `resetLabels` when a layer with the group name is added (LayerControl)
      map.on("overlayadd", function(layer){
        if (layer.name === grp) {
        }
      });
      // Call `resetLabels` after zooming only when the group is visible
      map.on("zoomend", function(e){
        if (map.layerManager.getVisibleGroups().indexOf(markers.groupname) > -1) {
        }
      });

    }
    */

  })
};

