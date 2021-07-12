/* global LeafletWidget, $, L, Shiny, HTMLWidgets */
LeafletWidget.methods.addLabelgun = function(group, entries, weight) {
  var map = this;
  var hideLabel = function(label){ label.labelObject.style.opacity = 0;};
  var showLabel = function(label){ label.labelObject.style.opacity = 1;};
  labelEngine = new labelgun.default(hideLabel, showLabel, entries);
  debugger;

  var i = 0;
  var markers = map.layerManager.getLayerGroup(group);
  markers.eachLayer(function(label){
    label.added = true;
    var j = ++i;
    addLabel(label, j, weight[j]);
  });
  resetLabels(markers, weight);
  map.on("overlayadd", function(layer){
    if (layer.name === group) {
      resetLabels(markers, weight);
    }
  });

  map.on("zoomend", function(){
    resetLabels(markers, weight);
  });
  function resetLabels(markers, weight) {
    var i = 0;
    markers.eachLayer(function(label){
      addLabel(label, ++i, weight[i]);
    });
    labelEngine.update();
  }
  function addLabel(layer, id, weight) {
    // This is ugly but there is no getContainer method on the tooltip :(
    var label = layer.getTooltip()._source._tooltip._container;
    if (label) {
      // We need the bounding rectangle of the label itself
      var rect = label.getBoundingClientRect();
      // We convert the container coordinates (screen space) to Lat/lng
      var bottomLeft = map.containerPointToLatLng([rect.left, rect.bottom]);
      var topRight = map.containerPointToLatLng([rect.right, rect.top]);
      var boundingBox = {
        bottomLeft : [bottomLeft.lng, bottomLeft.lat],
        topRight   : [topRight.lng, topRight.lat]
      };

      var wght = weight;
      wght = typeof wght === 'number' ? wght : parseInt(Math.random() * (5 - 1) + 1);
      // Ingest the label into labelgun itself
      labelEngine.ingestLabel(
        boundingBox,
        id,
        weight,
        label,
        "Label_" + id,
        false
      );

      // If the label hasn't been added to the map already
      // add it and set the added flag to true
      if (!layer.added) {
        layer.addTo(map);
        layer.added = true;
      }
    }
  }
};

