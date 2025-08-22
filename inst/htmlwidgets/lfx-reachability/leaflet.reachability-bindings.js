/* global LeafletWidget, $, L, topojson, csv2geojson, toGeoJSON */
LeafletWidget.methods.addReachability = function(options) {
  var map = this;

  map.reachabilityControl = L.control.reachability(options);
  map.controls.add(map.reachabilityControl);

  // Listen for Events in Shinymode
  if (HTMLWidgets.shinyMode) {
    map.on('reachability:displayed', function (e) {
      Shiny.onInputChange(map.id + "_reachability_displayed", "reachability_displayed", {priority: "event"});
    });
    map.on('reachability:delete', function (e) {
      Shiny.onInputChange(map.id + "_reachability_delete", "reachability_delete", {priority: "event"});
    });
    map.on('reachability:error', function (e) {
      console.warn(e);
      Shiny.onInputChange(map.id + "_reachability_error", "Unfortunately there has been an error calling the API.", {priority: "event"});
    });
    map.on('reachability:no_data', function (e) {
      console.warn(e);
      Shiny.onInputChange(map.id + "_reachability_no_data", "Unfortunately no data was received from the API.", {priority: "event"});
    });
  }
};

LeafletWidget.methods.removeReachability = function() {
  if (this.reachabilityControl) {
    this.removeControl(this.reachabilityControl);
    this.reachabilityControl = null;
  }
};



