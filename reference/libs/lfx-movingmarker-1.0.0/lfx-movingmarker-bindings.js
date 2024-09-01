/* global LeafletWidget, $, L */
LeafletWidget.methods.addMovingMarker = function(
    data, duration, icon, layerId, group, options,
    popup, popupOptions, label, labelOptions) {

    var map = this;
    if (map.movingmarker === undefined) {
      map.movingmarker = {};
    }
    if (map.movingmarker[layerId]) {
      delete map.movingmarker[layerId];
    }

    if (icon) {
      if (icon.class == "awesome" && L.AwesomeMarkers) {
        if (icon.squareMarker) {
          icon.className = "awesome-marker awesome-marker-square";
        }
        options.icon = new L.AwesomeMarkers.icon(icon);
      } else {
        if (!icon.iconUrl) {
          options.icon = L.Icon.Default();
        }
        if (icon.iconWidth) {
          icon.iconSize = [icon.iconWidth, icon.iconHeight];
        }
        if (icon.shadowWidth) {
          icon.shadowSize = [icon.shadowWidth, icon.shadowHeight];
        }
        if (icon.iconAnchorX) {
          icon.iconAnchor = [icon.iconAnchorX, icon.iconAnchorY];
        }
        if (icon.shadowAnchorX) {
          icon.shadowAnchor = [icon.shadowAnchorX, icon.shadowAnchorY];
        }
        if (icon.popupAnchorX) {
          icon.popupAnchor = [icon.popupAnchorX, icon.popupAnchorY];
        }
        options.icon = new L.Icon(icon);
      }
    }

    map.movingmarker[layerId] = L.Marker.movingMarker(data, duration, options).addTo(this);

    if (options.pauseOnZoom && options.pauseOnZoom === true) {
      map.on('zoomstart', function() {
        map.movingmarker[layerId].pause();
      });
      map.on('zoomend', function() {
          map.movingmarker[layerId].resume();
      });
    }

    if (popup !== null) {
      map.movingmarker[layerId].bindPopup(popup, popupOptions);
    }
    if (label !== null) {
      if (labelOptions !== null) {
        if(labelOptions.permanent) {
          map.movingmarker[layerId].bindTooltip(label, labelOptions).openTooltip();
        } else {
          map.movingmarker[layerId].bindTooltip(label, labelOptions);
        }
      } else {
        map.movingmarker[layerId].bindTooltip(label);
      }
    }

    if (HTMLWidgets.shinyMode) {
      map.movingmarker[layerId].on("click", LeafletWidget.methods.mouseHandler(map.id, layerId, group, "movingmarker_click", null), map);
      map.movingmarker[layerId].on("mouseover", LeafletWidget.methods.mouseHandler(map.id, layerId, group, "movingmarker_mouseover", null), map);
    }

    map.layerManager.addLayer(map.movingmarker[layerId], "marker", layerId, group);
};


LeafletWidget.methods.startMoving = function(layerId) {
  var map = this;
  layerId = getids(map, layerId);
  layerId.forEach(function(id) {
    if (map.movingmarker && map.movingmarker[id]) {
        map.movingmarker[id].start();
    }
  })
};

LeafletWidget.methods.stopMoving = function(layerId) {
  var map = this;
  layerId = getids(map, layerId);
  layerId.forEach(function(id) {
    if (map.movingmarker && map.movingmarker[id]) {
        map.movingmarker[id].stop();
    }
  })
};

LeafletWidget.methods.pauseMoving = function(layerId) {
  var map = this;
  layerId = getids(map, layerId);
  layerId.forEach(function(id) {
    if (map.movingmarker && map.movingmarker[id]) {
        map.movingmarker[id].pause();
    }
  })
};

LeafletWidget.methods.resumeMoving = function(layerId) {
  var map = this;
  layerId = getids(map, layerId);
  layerId.forEach(function(id) {
    if (map.movingmarker && map.movingmarker[id]) {
        map.movingmarker[id].resume();
    }
  })
};

LeafletWidget.methods.addLatLngMoving = function(layerId, latlng, duration) {
  var map = this;
  layerId = getids(map, layerId);
  layerId.forEach(function(id) {
    if (map.movingmarker && map.movingmarker[id]) {
        map.movingmarker[id].addLatLng(latlng, duration);
    }
  })
};

LeafletWidget.methods.moveToMoving = function(layerId, latlng, duration) {
  var map = this;
  layerId = getids(map, layerId);
  layerId.forEach(function(id) {
    if (map.movingmarker && map.movingmarker[id]) {
        map.movingmarker[id].moveTo(latlng, duration);
    }
  })
};

LeafletWidget.methods.addStationMoving = function(layerId, pointIndex, duration) {
  var map = this;
  layerId = getids(map, layerId);
  layerId.forEach(function(id) {
    if (map.movingmarker && map.movingmarker[id]) {
        map.movingmarker[id].addStation(pointIndex, duration);
    }
  })
};


getids = function(map, layerId) {
  if (layerId === null || layerId === undefined) {
    return Object.keys(map.movingmarker)
  } else {
    return [].concat(layerId);
  }
}
