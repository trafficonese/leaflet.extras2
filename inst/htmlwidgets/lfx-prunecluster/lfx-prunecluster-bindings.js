/* global LeafletWidget, $, L */

function asArray(value) {
  if (value instanceof Array) return value;else return [value];
}

function unpackStrings(iconset) {
  if (!iconset) {
    return iconset;
  }
  if (typeof(iconset.index) === "undefined") {
    return iconset;
  }

  iconset.data = asArray(iconset.data);
  iconset.index = asArray(iconset.index);

  return $.map(iconset.index, function(e, i) {
    return iconset.data[e];
  });
}


LeafletWidget.methods.addPruneCluster = function(geojson, layerId, group,
                                                  options, icon, categoryField, color,
                                                  popup, popupOptions, label, labelOptions,
                                                  clusterOptions, clusterId,
                                                  markerOptions) {

  var map = this;

  var pruneCluster = new PruneClusterForLeaflet(80);
  console.log("pruneCluster"); console.log(pruneCluster)

  pruneCluster.BuildLeafletClusterIcon = function(cluster) {
      var e = new L.Icon.MarkerCluster();
      console.log("BuildLeafletClusterIcon e");console.log(e);
      console.log("BuildLeafletClusterIcon cluster");console.log(cluster);
      e.stats = cluster.stats;
      e.population = cluster.population;
      return e;
  };
	pruneCluster.PrepareLeafletMarker = function (marker, data, category){
		if (data.icon) {
			if (typeof data.icon === 'function') {
				marker.setIcon(data.icon(data, category));
			} else {
				marker.setIcon(data.icon);
			}
		}

		if (data.popup) {
			var content = typeof data.popup === 'function' ? data.popup(data, category) : data.popup;
			if (marker.getPopup()) {
				marker.setPopupContent(content, popupOptions);
			} else {
				marker.bindPopup(content, popupOptions);
			}
		}
		if (data.label) {
			var content = typeof data.label === 'function' ? data.label(data, category) : data.label;
			if (marker.getLabel()) {
				marker.setPopupContent(content, labelOptions);
			} else {
				marker.bindTooltip(content, labelOptions);
			}
		}
	};
  pruneCluster.BuildLeafletCluster = function(cluster, position) {
      var m = new L.Marker(position, {
        icon: pruneCluster.BuildLeafletClusterIcon(cluster)
      });

      m.on('click', function() {
        console.log("BuildLeafletCluster click");console.log(this);
        // Compute the  cluster bounds (it's slow : O(n))
        var markersArea = pruneCluster.Cluster.FindMarkersInArea(cluster.bounds);
        var b = pruneCluster.Cluster.ComputeBounds(markersArea);

        if (b) {
          var bounds = new L.LatLngBounds(
            new L.LatLng(b.minLat, b.maxLng),
            new L.LatLng(b.maxLat, b.minLng));

          var zoomLevelBefore = pruneCluster._map.getZoom();
          var zoomLevelAfter = pruneCluster._map.getBoundsZoom(bounds, false, new L.Point(20, 20, null));

          // If the zoom level doesn't change
          if (zoomLevelAfter === zoomLevelBefore) {
            // Send an event for the LeafletSpiderfier
            pruneCluster._map.fire('overlappingmarkers', {
              cluster: pruneCluster,
              markers: markersArea,
              center: m.getLatLng(),
              marker: m
            });

            pruneCluster._map.setView(position, zoomLevelAfter);
          }
          else {
            pruneCluster._map.fitBounds(bounds);
          }
        }
      });
      m.on('mouseover', function() {
        console.log("BuildLeafletCluster mouseover");console.log(this);
        //do mouseover stuff here
      });
      m.on('mouseout', function() {
        console.log("BuildLeafletCluster mouseout");console.log(this);
        //do mouseout stuff here
      });

      return m;
  };

  //var colors = ['#ff4b00', '#bac900', '#EC1813', '#55BCBE', '#D2204C', '#FF0000', '#ada59a', '#3e647e'],
  let pi2 = Math.PI * 2;

  L.Icon.MarkerCluster = L.Icon.extend({
        options: {
            iconSize: new L.Point(44, 44),
            className: 'prunecluster leaflet-markercluster-icon'
        },

        createIcon: function () {
            // based on L.Icon.Canvas from shramov/leaflet-plugins (BSD licence)
            var e = document.createElement('canvas');
            this._setIconStyles(e, 'icon');
            var s = this.options.iconSize;
            e.width = s.x;
            e.height = s.y;
            this.draw(e.getContext('2d'), s.x, s.y);
            return e;
        },

        createShadow: function () {
            return null;
        },

        draw: function(canvas, width, height) {

            var lol = 0;

            var start = 0;
            console.log("color"); console.log(color);
            console.log("categoryField"); console.log(categoryField);
            console.log("this"); console.log(this);

            for (var i = 0, l = color.category.length; i < l; ++i) {
                var category = color.category[i];
                var col = color.color[i];

                var size = this.stats[i] / this.population;


                if (size > 0) {
                    canvas.beginPath();
                    canvas.moveTo(22, 22);
                    canvas.fillStyle = col;
                    var from = start + 0.14,
                        to = start + size * pi2;

                    if (to < from) {
                        from = start;
                    }
                    canvas.arc(22,22,22, from, to);

                    start = start + size*pi2;
                    canvas.lineTo(22,22);
                    canvas.fill();
                    canvas.closePath();
                }

            }

            canvas.beginPath();
            canvas.fillStyle = 'white';
            canvas.arc(22, 22, 18, 0, Math.PI*2);
            canvas.fill();
            canvas.closePath();

            canvas.fillStyle = '#555';
            canvas.textAlign = 'center';
            canvas.textBaseline = 'middle';
            canvas.font = 'bold 12px sans-serif';

            canvas.fillText(this.population, 22, 22, 40);
        }
    });


  function createIcon(data, category) {
    console.log("data");console.log(data);
    console.log("category");console.log(category);
    console.log("icon");console.log(icon);

    icon.iconUrl         = unpackStrings(icon.iconUrl);
    icon.iconRetinaUrl   = unpackStrings(icon.iconRetinaUrl);
    icon.shadowUrl       = unpackStrings(icon.shadowUrl);
    icon.shadowRetinaUrl = unpackStrings(icon.shadowRetinaUrl);

    let opts = icon;
    if (!opts.iconUrl) {
      return new L.Icon.Default();
    }
    if (opts.iconWidth) {
      opts.iconSize = [opts.iconWidth, opts.iconHeight];
    }
    if (opts.shadowWidth) {
      opts.shadowSize = [opts.shadowWidth, opts.shadowHeight];
    }
    if (opts.iconAnchorX) {
      opts.iconAnchor = [opts.iconAnchorX, opts.iconAnchorY];
    }
    if (opts.shadowAnchorX) {
      opts.shadowAnchor = [opts.shadowAnchorX, opts.shadowAnchorY];
    }
    if (opts.popupAnchorX) {
      opts.popupAnchor = [opts.popupAnchorX, opts.popupAnchorY];
    }
    return L.icon(opts);
  }

  // Convert GeoJSON features to PruneCluster markers
  console.log("geojson"); console.log(geojson);
  var features = geojson.features;
  features.forEach(function(feature) {
    var coords = feature.geometry.coordinates;
    var properties = feature.properties;

    // Create a marker
    var marker = new PruneCluster.Marker(coords[1], coords[0]);

    if (categoryField && feature.properties[categoryField]) {
      marker.category = feature.properties[categoryField];
    } else {
      //marker.category = Math.floor(Math.random() * Math.random() * colors.length);
    }


    // Handle custom icon, popup, label, etc.
    if (popup) {
      marker.data.popup = L.popup(popupOptions).setContent(properties[popup]);
    }
    if (label) {
      marker.data.label = L.tooltip(labelOptions).setContent(properties[label]);
      // marker.bindTooltip(properties[label], labelOptions);
    }

    if (icon) {
      marker.data.icon = createIcon;
    }

    // Additional properties or options can be applied here
    pruneCluster.RegisterMarker(marker);
  });

  // Apply cluster options if provided
  if (clusterOptions) {
    console.log("clusterOptions is true"); console.log(clusterOptions)
    // Configure pruneCluster with provided clusterOptions
    if (clusterOptions.maxClusterRadius !== undefined) {
      pruneCluster.Cluster.Size = clusterOptions.maxClusterRadius;
    }
    if (clusterOptions.minClusterSize !== undefined) {
      pruneCluster.Cluster.DisableClusteringAtZoom = clusterOptions.minClusterSize;
    }
    if (clusterOptions.customMarkerIcon) {
      pruneCluster.PrepareLeafletMarker = function(marker, data, category) {
        marker.setIcon(L.icon(clusterOptions.customMarkerIcon));
      };
    }
  }

  // Add the PruneCluster to the map
  map.layerManager.addLayer(pruneCluster, null, layerId, group);

};
