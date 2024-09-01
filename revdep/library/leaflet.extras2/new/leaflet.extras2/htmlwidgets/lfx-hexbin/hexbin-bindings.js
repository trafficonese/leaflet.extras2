LeafletWidget.methods.addHexbin = function(data, layerId, group, options) {
  var map = this;

  // Create the hexlayer
  var hexLayer = L.hexbinLayer(options).data(data);

  // Add Tooltips
  if (options.tooltip !== undefined) {
    var toolcont;
    if (typeof options.tooltip === "function") {
      toolcont = options.tooltip;
    } else {
      var tooltip = options.tooltip ? options.tooltip : "Count ";
      toolcont = function(d) {return tooltip + d.length;};
    }

    hexLayer.hoverHandler(
					L.HexbinHoverHandler.tooltip({
					   tooltipContent: toolcont
					})
		);
  }

  // Add resizetoCount method
  if (options && options.resizetoCount) {
    if (typeof options.resizetoCount === "function") {
     hexLayer.radiusValue(options.resizetoCount);
    } else {
     hexLayer.radiusValue(function(d) { return d.length; });
    }
  }

  // Add Click Event for Shiny
  if (HTMLWidgets.shinyMode) {
    hexLayer.dispatch()
    	.on('click', function(d, i) {
    	   var pts = [];
    	   d.forEach(x => pts.push(x.o));
    	   Shiny.setInputValue(map.id+"_hexbin_click", {index: i, pts: pts}, {priority: "event"});
    });
  }

  // Add to map, so we can access it later
  map.hexLayer = hexLayer;

  // Add Layer
  // TODO - layerId and group dont work
  map.layerManager.addLayer(hexLayer, "hexbin", layerId, group);
};

LeafletWidget.methods.updateHexbin = function(data, colorRange) {
  // TODO - add radiusRange, etc.. (all options?)
  if (this.hexLayer) {
    // Only data() calls redraw().
    // TODO - How to expose more options without an endless mess of ifelses
    if (colorRange !== null) {
      if (data === null) {
        this.hexLayer
          .colorRange(colorRange)
          .redraw();
      } else {
        this.hexLayer
          .colorRange(colorRange)
          .data(data);
      }
    } else {
      this.hexLayer.data(data);
    }
  }
};

LeafletWidget.methods.hideHexbin = function() {
  $('.hexbin').fadeOut("slow");
};

LeafletWidget.methods.showHexbin = function() {
  $('.hexbin').fadeIn("fast");
};

LeafletWidget.methods.clearHexbin = function() {
  this.hexLayer.data([]);
};
