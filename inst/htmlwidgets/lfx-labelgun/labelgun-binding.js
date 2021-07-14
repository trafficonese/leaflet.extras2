/* global LeafletWidget, $, L, Shiny, HTMLWidgets */
LeafletWidget.methods.addLabelgun = function(group, weight, entries) {
  var map = this;

  // We provide two functions, to hide/show the labels.
  // Here the callbacks set the labels opacity to 0 and 1 respectively.
  var hideLabel = function(label){ label.labelObject.style.opacity = 0;};
  var showLabel = function(label){ label.labelObject.style.opacity = 1;};
  labelEngine = new labelgun.default(hideLabel, showLabel, entries);

  // Get groups as Array and Loop over all
  var groups = Array.isArray(group) ? group : [group]
  groups.forEach(function(grp) {
    var i = 0;
    // Get the layers for the given group and call `addLabel` for each one
    var markers = map.layerManager.getLayerGroup(grp);

    // If the marker group exists add events
    if (markers) {
      // Call `resetLabels` when a layer with the group name is added (LayerControl)
      map.on("overlayadd", function(layer){
        if (layer.name === grp) {
          resetLabels(markers, weight);
        }
      });
      // Call `resetLabels` after zooming only when the group is visible
      map.on("zoomend", function(e){
        if (map.layerManager.getVisibleGroups().indexOf(markers.groupname) > -1) {
          resetLabels(markers, weight);
        }
      });

      // Call `resetLabels` initially
      resetLabels(markers, weight);
    }
  })


  function resetLabels(markers, weight) {
    // Call `addLabel` for each marker with an optional weight
    var j = 0;
    markers.eachLayer(function(label){
      addLabel(label, j, Array.isArray(weight) ? weight[j] : weight);
      j++;
    });
    // Update the labelEngine
    labelEngine.update();
  }
  function addLabel(layer, id, weight) {
    // Get container of the tooltip
    var label = layer.getTooltip()._source._tooltip._container;
    if (label) {
      // Get bounding rectangle of the label itself
      var rect = label.getBoundingClientRect();

      // Convert the container coordinates (screen space) to Lat/lng
      var bottomLeft = map.containerPointToLatLng([rect.left, rect.bottom]);
      var topRight = map.containerPointToLatLng([rect.right, rect.top]);
      var boundingBox = {
        bottomLeft : [bottomLeft.lng, bottomLeft.lat],
        topRight   : [topRight.lng, topRight.lat]
      };

      // Get Weight
      var wght = weight;
      wght = typeof wght === 'number' ? wght : parseInt(Math.random() * (5 - 1) + 1);
      // console.log(weight + " => " + wght)

      // Ingest the label into labelgun itself
      labelEngine.ingestLabel(
        boundingBox,
        id,
        wght,
        label,
        "Label_" + id,
        false
      );

      // Add the label if it hasn't been added to the map already
      if (!layer.added) {
        layer.addTo(map);
        layer.added = true;
      }
    }
  }
};

