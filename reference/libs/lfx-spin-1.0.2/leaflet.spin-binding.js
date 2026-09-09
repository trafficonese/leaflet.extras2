LeafletWidget.methods.spinner = function(state, options) {
  var map = this;
  if (typeof map.spin !== "function") {
    return;
  }
  map.spin(state, options);
  if (state && HTMLWidgets.shinyMode && window.Shiny && Shiny.setInputValue) {
    requestAnimationFrame(function() {
      requestAnimationFrame(function() {
        Shiny.setInputValue(map.id + "_spinner_shown", Date.now(), {priority: "event"});
      });
    });
  }
};
