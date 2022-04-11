LeafletWidget.methods.addHistory = function(layerId, options) {
  var map = this;
  map.hist = new L.HistoryControl(options);
  map.controls.add(map.hist, layerId);
};

LeafletWidget.methods.goBackHistory = function() {
  if (this.hist) {
    this.hist.goBack();
  }
};
LeafletWidget.methods.goForwardHistory = function() {
  if (this.hist) {
    this.hist.goForward();
  }
};
LeafletWidget.methods.clearHistory = function() {
  if (this.hist) {
    this.hist.clearHistory();
  }
};
LeafletWidget.methods.clearFuture = function() {
  if (this.hist) {
    this.hist.clearFuture();
  }
};
