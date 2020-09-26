/* global LeafletWidget, $, L */
LeafletWidget.methods.addVectorgrid = function(data, group, style, layerId) {
  var map = this;
  var geojson;

	var highlight;
	var clearHighlight = function() {
		if (highlight) {
			vectorGrid.resetFeatureStyle(highlight);
		}
		highlight = null;
	};

  //debugger;
  var handleResponse = function(data) {
    var vectorGrid = L.vectorGrid.slicer(data, {
      rendererFactory: L.svg.tile,
      //rendererFactory: L.canvas.tile,
      vectorTileLayerStyles: {
  			sliced: function(properties, zoom) {
  			  //debugger;
  				return {
  					fillColor: properties.fillColor ? properties.fillColor : (style.fillColor ? style.fillColor : '007fff'),
   					opacity:  properties.opacity ? properties.opacity : (style.opacity ? style.opacity : 0.7),
  					weight: properties.weight ? properties.weight : (style.weight ? style.weight : 4),
  					fillOpacity: properties.fillOpacity ? properties.fillOpacity : (style.fillOpacity ? style.fillOpacity : 1),
  					stroke: properties.stroke ? properties.stroke : (style.stroke ? style.stroke : true),
  					fill: properties.fill ? properties.fill : (style.fill ? style.fill : true),
  					color: properties.color ? properties.color : (style.color ? style.color : '007fff')
  				};
  			}
      },
      interactive: style.interactive,
      getFeatureId: function(f) {
        //console.log("getFeatureId");
  		}
    });
    /*
    vectorGrid.on('mouseover', function(e) {
          console.log("mouseover on vectorGrid");
      		var properties = e.layer.properties;
      		//debugger;
      		L.popup()
      			.setContent(properties.vg_label || properties.name)
      			.setLatLng(e.latlng)
      			.openOn(map);

      		clearHighlight();
      		highlight = properties.wb_a3;

      		var p = properties.mapcolor7 % 5;
      		var style = {
      			fillColor: p === 0 ? '#800026' :
      					p === 1 ? '#E31A1C' :
      					p === 2 ? '#FEB24C' :
      					p === 3 ? '#B2FE4C' : '#FFEDA0',
      			fillOpacity: 0.5,
      			fillOpacity: 1,
      			stroke: true,
      			fill: true,
      			color: 'red',
      			opacity: 1,
      			weight: 2,
      		};

      		vectorGrid.setFeatureStyle(properties.wb_a3, style);
      		L.DomEvent.stop(e);
      	})
    */
    vectorGrid.on('click', function(e) {
      debugger;
  		L.popup()
  			.setContent(String(e.layer.properties.vg_label || e.layer.properties.name))
  			.setLatLng(e.latlng)
  			.openOn(map);

      if (!HTMLWidgets.shinyMode) return;
      let latLng = e.target.getLatLng ? e.target.getLatLng() : e.latlng;
      if (latLng) {
        let latLngVal = L.latLng(latLng); // make sure it has consistent shape
        latLng = {lat: latLngVal.lat, lng: latLngVal.lng};
      }
      let eventInfo = $.extend(
        {
          id: e.layer.properties[layerId],
          properties: e.layer.properties
        },
        group !== null ? {group: group} : null,
        latLng
      );
      Shiny.setInputValue(map.id + "_vectorgrid_click", eventInfo, {priority: "event"});
      L.DomEvent.stop(e);
    });

    map.layerManager.addLayer(vectorGrid, "vectorgrid", null, group);
  };

  //Create a layer
  if (typeof data === "string") {
    fetch(data)
      .then(response => response.json())
      .then(geojson => handleResponse(geojson));
  } else {
    handleResponse(data);
  }

};

LeafletWidget.methods.removeVectorgrid = function(layerId) {
  this.layerManager.removeLayer("vectorgrid", layerId);
};

LeafletWidget.methods.clearVectorgrid = function() {
  this.layerManager.clearLayers("vectorgrid");
};





LeafletWidget.methods.addProtobuf = function(urlTemplate, layerId, group, options, styling) {
  var map = this;
  //debugger;

	var vectorTileOptions = {
	  // VectorGrid Options
		rendererFactory: L.canvas.tile,
		//rendererFactory: L.svg.tile,
		key: options.key,
		vectorTileLayerStyles: styling,
		interactive: options.interactive,	// Make sure that this VectorGrid fires mouse/pointer events
		getFeatureId: function(f) {},

    // Tile Options
		minZoom: options.minZoom,
		maxZoom: options.maxZoom,
		subdomains: options.subdomains,
		errorTileUrl: options.errorTileUrl,
		zoomOffset: options.zoomOffset,
		tms: options.tms,
		zoomReverse: options.zoomReverse,
		detectRetina: options.detectRetina,
		// crossOrigin: options.crossOrigin,

		// GridLayer Options
		tileSize: options.tileSize,
		opacity: options.opacity,
		updateWhenIdle: options.updateWhenIdle,
		updateWhenZooming: options.updateWhenZooming ? options.updateWhenZooming : true,
		updateInterval: options.updateInterval ? options.updateInterval: 200,
		zIndex: options.zIndex ? options.zIndex : 1,
		bounds: options.bounds,
		maxNativeZoom: options.maxNativeZoom,
		minNativeZoom: options.minNativeZoom,
		noWrap: options.noWrap,
		pane: options.pane ? options.pane : "tilePane",
		className: options.className ? options.className : "",
		keepBuffer: options.keepBuffer ? options.keepBuffer : 2,

		// Layer options
		attribution: options.attribution
	};

	var pbfLayer = L.vectorGrid.protobuf(urlTemplate, vectorTileOptions);
	pbfLayer.on('click', function(e) {
	  console.log("click"); console.log(e);
	  let pop = e.layer.properties[options.popup];
	  if (pop) {
  		L.popup()
  			.setContent(String(pop))
  			.setLatLng(e.latlng)
  			.openOn(map);
	  }

		if (HTMLWidgets.shinyMode) {
      var obj = {
        lat: e.latlng.lat,
        lng: e.latlng.lng,
        properties: e.layer.properties
      };
      Shiny.setInputValue(this._map.id + "_vectorgrid_pbf_click", obj, {priority: "event"});
    }
	});

  map.layerManager.addLayer(pbfLayer, "vectorgrid", layerId, group);
};





if ( false) {
  var vectorTileStyling = {
			water: {
				fill: true,
				weight: 1,
				fillColor: '#06cccc',
				color: '#06cccc',
				fillOpacity: 0.2,
				opacity: 0.4
			},
			admin: {
				weight: 1,
				fillColor: 'pink',
				color: 'pink',
				fillOpacity: 0.2,
				opacity: 0.4
			},
			waterway: {
				weight: 1,
				fillColor: '#2375e0',
				color: '#2375e0',
				fillOpacity: 0.2,
				opacity: 0.4
			},
			landcover: {
				fill: true,
				weight: 1,
				fillColor: '#53e033',
				color: '#53e033',
				fillOpacity: 0.2,
				opacity: 0.4,
			},
			landuse: {
				fill: true,
				weight: 1,
				fillColor: '#e5b404',
				color: '#e5b404',
				fillOpacity: 0.2,
				opacity: 0.4
			},
			park: {
				fill: true,
				weight: 1,
				fillColor: '#84ea5b',
				color: '#84ea5b',
				fillOpacity: 0.2,
				opacity: 0.4
			},
			boundary: {
				weight: 1,
				fillColor: '#c545d3',
				color: '#c545d3',
				fillOpacity: 0.2,
				opacity: 0.4
			},
			aeroway: {
				weight: 1,
				fillColor: '#51aeb5',
				color: '#51aeb5',
				fillOpacity: 0.2,
				opacity: 0.4
			},
			road: {	// mapbox & nextzen only
				weight: 1,
				fillColor: '#f2b648',
				color: '#f2b648',
				fillOpacity: 0.2,
				opacity: 0.4
			},
			tunnel: {	// mapbox only
				weight: 0.5,
				fillColor: '#f2b648',
				color: '#f2b648',
				fillOpacity: 0.2,
				opacity: 0.4,
// 					dashArray: [4, 4]
			},
			bridge: {	// mapbox only
				weight: 0.5,
				fillColor: '#f2b648',
				color: '#f2b648',
				fillOpacity: 0.2,
				opacity: 0.4,
// 					dashArray: [4, 4]
			},
			transportation: {	// openmaptiles only
				weight: 0.5,
				fillColor: '#f2b648',
				color: '#f2b648',
				fillOpacity: 0.2,
				opacity: 0.4,
// 					dashArray: [4, 4]
			},
			transit: {	// nextzen only
				weight: 0.5,
				fillColor: '#f2b648',
				color: '#f2b648',
				fillOpacity: 0.2,
				opacity: 0.4,
// 					dashArray: [4, 4]
			},
			building: {
				fill: true,
				weight: 1,
				fillColor: '#2b2b2b',
				color: '#2b2b2b',
				fillOpacity: 0.2,
				opacity: 0.4
			},
			water_name: {
				weight: 1,
				fillColor: '#022c5b',
				color: '#022c5b',
				fillOpacity: 0.2,
				opacity: 0.4
			},
			transportation_name: {
				weight: 1,
				fillColor: '#bc6b38',
				color: '#bc6b38',
				fillOpacity: 0.2,
				opacity: 0.4
			},
			place: {
				weight: 1,
				fillColor: '#f20e93',
				color: '#f20e93',
				fillOpacity: 0.2,
				opacity: 0.4
			},
			housenumber: {
				weight: 1,
				fillColor: '#ef4c8b',
				color: '#ef4c8b',
				fillOpacity: 0.2,
				opacity: 0.4
			},
			poi: {
				weight: 1,
				fillColor: '#3bb50a',
				color: '#3bb50a',
				fillOpacity: 0.2,
				opacity: 0.4
			},
			earth: {	// nextzen only
				fill: true,
				weight: 1,
				fillColor: '#c0c0c0',
				color: '#c0c0c0',
				fillOpacity: 0.2,
				opacity: 0.4
			},

			// Do not symbolize some stuff for mapbox
			country_label: [],
			marine_label: [],
			state_label: [],
			place_label: [],
			waterway_label: [],
			poi_label: [],
			road_label: [],
			housenum_label: [],


			// Do not symbolize some stuff for openmaptiles
			country_name: [],
			marine_name: [],
			state_name: [],
			place_name: [],
			waterway_name: [],
			poi_name: [],
			road_name: [],
			housenum_name: [],
	};
	// Monkey-patch some properties for nextzen layer names, because
	// instead of "building" the data layer is called "buildings" and so on
	vectorTileStyling.buildings  = vectorTileStyling.building;
	vectorTileStyling.boundaries = vectorTileStyling.boundary;
	vectorTileStyling.places     = vectorTileStyling.place;
	vectorTileStyling.pois       = vectorTileStyling.poi;
	vectorTileStyling.roads      = vectorTileStyling.road;
  }
