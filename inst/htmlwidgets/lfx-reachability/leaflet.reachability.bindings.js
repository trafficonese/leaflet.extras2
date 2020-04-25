/* global LeafletWidget, $, L, topojson, csv2geojson, toGeoJSON */
LeafletWidget.methods.addReachability = function(options) {
  var map = this;
  var reachability = L.control.reachability(options);
  map.controls.add(reachability);

  // Listen for Events in Shinymode
  if (HTMLWidgets.shinyMode) {
    map.on('reachability:displayed', function (e) {
      Shiny.onInputChange(map.id + "_reachability_displayed", null);
    });
    map.on('reachability:delete', function (e) {
      Shiny.onInputChange(map.id + "_reachability_delete", null);
    });
    map.on('reachability:error', function (e) {
      Shiny.onInputChange(map.id + "_reachability_error", null);
    });
  }
};

LeafletWidget.methods.removeReachability = function() {
  this.controls.clear();
};



