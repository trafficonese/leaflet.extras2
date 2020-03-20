LeafletWidget.methods.addHexbin = function(data, group, options) {

  debugger;

  var options = {
  	radius : 20,
  	opacity: 1,
  	duration: 200,

  	colorScaleExtent: [ 1, undefined ],
  	radiusScaleExtent: [ 1, undefined ],
  	colorDomain: null,
  	radiusDomain: null,
  	colorRange: [ '#f7fbff', '#08306b' ],
  	radiusRange: [ 5, 15 ],

  	pointerEvents: 'all'
  };

	// Create the hexlayer
	var hexLayer = L.hexbinLayer(options).data(data);

  debugger;

  hexLayer.dispatch()
  	.on('mouseover', function(d, i) {
  		//console.log({ type: 'mouseover', event: d, index: i, context: this });
  	})
  	.on('mouseout', function(d, i) {
  		//console.log({ type: 'mouseout', event: d, index: i, context: this });
  	})
  	.on('click', function(d, i) {
  		console.log({ type: 'click', event: d, index: i, context: this });
  	});

	this.layerManager.addLayer(hexLayer, "hexbin", "layerId", "group");
};
