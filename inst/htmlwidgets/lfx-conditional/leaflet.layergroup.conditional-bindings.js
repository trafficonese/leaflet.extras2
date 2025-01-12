/* global LeafletWidget, $, L, Shiny, HTMLWidgets */
LeafletWidget.methods.addLayerGroupConditional = function(groups, conditions) {

  const map = this;
  let conditionalGroup = L.layerGroup.conditional();
  map.conditionalGroup = conditionalGroup;

  // Loop through each group
  groups.forEach(function(group) {
    // Loop through conditions for each group
    Object.keys(conditions).forEach(function(condition) {
      let groupList = conditions[condition];
      if (!Array.isArray(groupList)) {
        groupList = [groupList];
      }
      groupList.forEach(function(group) {
        let layer = map.layerManager.getLayerGroup(group);
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

  // Set up the zoom handler to update conditional layers
  let zoomHandler = function() {
    conditionalGroup.updateConditionalLayers(map.getZoom());
  };
  map.on("zoomend", zoomHandler);

  // Set initial state of conditional layers
  setTimeout(function() {
    zoomHandler()
  }, 500);

};


LeafletWidget.methods.removeConditionalLayer = function(groups) {
  const map = this;
  if (!Array.isArray(groups)) {
    groups = [groups];
  }
  groups.forEach(function(group) {
    let layer = map.layerManager.getLayerGroup(group);
    if (layer && map.conditionalGroup) {
      map.conditionalGroup.removeConditionalLayer(layer)
    } else {
      console.warn("Layer not found " + group);
    }
  })
};

LeafletWidget.methods.clearConditionalLayers = function() {
  this.conditionalGroup.clearConditionalLayers()
};
