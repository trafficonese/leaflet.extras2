/* global LeafletWidget, $, L, Shiny, HTMLWidgets */
LeafletWidget.methods.addContextmenu = function() {
  var map = this;

  if (HTMLWidgets.shinyMode) {
    map.on("contextmenu.select", function(e) {
      var obj = {
        text: e.el.innerText
      };
      if (e.data.relatedTarget) {
        var data = {
          layerId: e.data.relatedTarget.options.layerId,
          group: e.data.relatedTarget.options.group,
          lat: e.data.relatedTarget.options.lat,
          lng: e.data.relatedTarget.options.lng,
          label: e.data.relatedTarget.options.label
        };
        obj = Object.assign(obj, data);
      } else {
        obj = Object.assign(obj, e.data.latlng);
      }
      Shiny.setInputValue(map.id + "_contextmenu_select", obj, {priority: "event"});
    });
  }
};

LeafletWidget.methods.showContextmenu = function(coords) {
  this.contextmenu.showAt(new L.LatLng(coords.lat[0], coords.lng[0]));
};
LeafletWidget.methods.hideContextmenu = function() {
  this.contextmenu.hide();
};
LeafletWidget.methods.addItemContextmenu = function(options) {
  // Requires https://github.com/rstudio/leaflet/pull/696 to be merged!
  this.contextmenu.addItem(options);
};
LeafletWidget.methods.insertItemContextmenu = function(options, index) {
  // Requires https://github.com/rstudio/leaflet/pull/696 to be merged!
  this.contextmenu.insertItem(options, index);
};
LeafletWidget.methods.removeItemContextmenu = function(index) {
  var map = this;
  if (Array.isArray(index)) {
    index.forEach(function(i) {
      map.contextmenu.removeItem(index);
    })
  } else {
    map.contextmenu.removeItem(index);
  }
};
LeafletWidget.methods.setDisabledContextmenu = function(index, disabled) {
  var map = this;
  if (Array.isArray(index)) {
    index.forEach(function(i) {
      map.contextmenu.setDisabled(i, disabled);
    })
  } else {
    map.contextmenu.setDisabled(index, disabled);
  }
};
LeafletWidget.methods.removeallItemsContextmenu = function() {
  this.contextmenu.removeAllItems();
};

