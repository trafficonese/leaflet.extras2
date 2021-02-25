/* global LeafletWidget, $, L */
LeafletWidget.methods.addMovingMarker = function(
    data, duration, icon, layerId, group, options,
    popup, popupOptions, label, labelOptions) {

    var map = this;
    if (map.movingmarker) {
      delete map.movingmarker;
    }

    if (icon) {
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

    map.movingmarker = L.Marker.movingMarker(data, duration, options).addTo(this);

    if (options.pauseOnZoom && options.pauseOnZoom === true) {
      map.on('zoomstart', function() {
        map.movingmarker.pause();
      });
      map.on('zoomend', function() {
          map.movingmarker.start();
      });
    }

    if (popup !== null) {
      map.movingmarker.bindPopup(popup, popupOptions);
    }
    if (label !== null) {
      if (labelOptions !== null) {
        if(labelOptions.permanent) {
          map.movingmarker.bindTooltip(label, labelOptions).openTooltip();
        } else {
          map.movingmarker.bindTooltip(label, labelOptions);
        }
      } else {
        map.movingmarker.bindTooltip(label);
      }
    }

    if (HTMLWidgets.shinyMode) {
      map.movingmarker.on("click", LeafletWidget.methods.mouseHandler(map.id, layerId, group, "movingmarker_click", null), map);
      map.movingmarker.on("mouseover", LeafletWidget.methods.mouseHandler(map.id, layerId, group, "movingmarker_mouseover", null), map);
    }

    map.layerManager.addLayer(map.movingmarker, "marker", layerId, group);

    map.movingmarker.start();
};


LeafletWidget.methods.startMoving = function() {
  var map = this;
  if (map.movingmarker) {
      map.movingmarker.start();
  }
};

LeafletWidget.methods.stopMoving = function() {
  var map = this;
  if (map.movingmarker) {
      map.movingmarker.stop();
  }
};

LeafletWidget.methods.pauseMoving = function() {
  var map = this;
  if (map.movingmarker) {
      map.movingmarker.pause();
  }
};

LeafletWidget.methods.resumeMoving = function() {
  var map = this;
  if (map.movingmarker) {
      map.movingmarker.resume();
  }
};

LeafletWidget.methods.addLatLngMoving = function(latlng, duration) {
  var map = this;
  if (map.movingmarker) {
      map.movingmarker.addLatLng(latlng, duration);
  }
};

LeafletWidget.methods.moveToMoving = function(latlng, duration) {
  var map = this;
  if (map.movingmarker) {
      map.movingmarker.moveTo(latlng, duration);
  }
};

LeafletWidget.methods.addStationMoving = function(pointIndex, duration) {
  var map = this;
  if (map.movingmarker) {
      map.movingmarker.addStation(pointIndex, duration);
  }
};
