/* global LeafletWidget, $, L, Shiny, HTMLWidgets */
LeafletWidget.methods.addLayerGroupConditional = function(groups, conditions) {

  var map = this;
  var conditionalGroup = L.layerGroup.conditional();
  console.log("groups"); console.log(groups); console.log("conditions"); console.log(conditions)

  // Loop through each group
  groups.forEach(function(group) {
    // Loop through conditions for each group
    Object.keys(conditions).forEach(function(condition) {
      var groupList = conditions[condition];
      if (!Array.isArray(groupList)) {
        groupList = [groupList];
      }
      groupList.forEach(function(group) {
        var layer = map.layerManager.getLayerGroup(group);
        if (!layer) {
          console.warn("Layer not found in group " + group);
          return;
        }
        // Add the layer with the associated condition
        conditionalGroup.addConditionalLayer(eval(condition), layer);
      })
    });
  });

  // Add the conditional group to the map
  conditionalGroup.addTo(map)
  console.log("conditionalGroup");console.log(conditionalGroup);

  // Set up the zoom handler to update conditional layers
  var zoomHandler = function() {
    var zoomLevel = map.getZoom();
    console.log("zoomHandler: " + zoomLevel)
    conditionalGroup.updateConditionalLayers(zoomLevel);
  };
  map.on("zoomend", zoomHandler);

  // Set initial state of conditional layers
  setTimeout(function() {
    zoomHandler()
  }, 200);

};
