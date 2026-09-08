/* global LeafletWidget, $, L, Shiny, HTMLWidgets */
LeafletWidget.methods.addEasyprint = function(options) {
  (function(){
    var map = this;
    if (map.easyprint) {
      map.easyprint.remove();
      delete map.easyprint;
    }

    // If a group name of a tilelayer is given, get the layer (the method isLoading will be used)
    if (options.tileLayer !== undefined) {
      // If multiple group names are given, take only the first layer
      if (Array.isArray(options.tileLayer)) {
        options.tileLayer = options.tileLayer[0];
      }
      var layers = map.layerManager._byGroup[options.tileLayer]
      if (layers !== undefined) {
        options.tileLayer = layers[Object.keys(layers)];
      } else {
        options.tileLayer = undefined;
      }
    }

    options.sizeModes = Object.values(options.sizeModes)
    map.easyprint = L.easyPrint(options);
    map.controls.add(map.easyprint);

  }).call(this);
};

LeafletWidget.methods.removeEasyprint = function() {
  (function(){
    var map = this;
    if(map.easyprint) {
      map.easyprint.remove();
      delete map.easyprint;
    }
  }).call(this);
};

LeafletWidget.methods.easyprintMap = function(sizeModes, filename) {
  (function(){
    if (this.easyprint) {
      if (typeof sizeModes === "object" && sizeModes.className) {
        sizeModes.target = {className: sizeModes.className}
      }
      this.easyprint.printMap(sizeModes, filename);
    }
  }).call(this);
};

