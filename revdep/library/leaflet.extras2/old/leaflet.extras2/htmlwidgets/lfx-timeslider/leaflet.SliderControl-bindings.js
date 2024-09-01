/* global LeafletWidget, $, L */
LeafletWidget.methods.addTimeslider = function(data, options) {
  var map = this;
  if (map.sliderControl) {
    map.sliderControl.remove();
    delete map.sliderControl;
  }

  //Create a marker layer
  var layer = L.geoJson(data);
  options.layer = layer;

  map.sliderControl = L.control.sliderControl(options);

  //Make sure to add the slider to the map ;-)
  map.addControl(map.sliderControl);

  //And initialize the slider
  map.sliderControl.startSlider();

};


LeafletWidget.methods.removeTimeslider = function() {
  var map = this;
  if (map.sliderControl) {
    map.sliderControl.remove();
    delete map.sliderControl;
  }
};

