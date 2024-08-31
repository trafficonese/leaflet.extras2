/* global LeafletWidget, $, L */
LeafletWidget.methods.addDivicon = function(
    lats, lngs, icon, layerId, group, options,
    classes, htmls,
    popups, popupOptions, labels, labelOptions,
    clusterId, clusterOptions, divOptions) {

    var map = this;
    console.log("addDivicon")

    // Convert inputs to arrays if they are single strings
    classes = toArray(classes, lats.length);
    htmls = toArray(htmls, lats.length);
    popups = toArray(popups, lats.length);
    labels = toArray(labels, lats.length);
    layerIds = toArray(layerId, lats.length);

    for (var i = 0; i < lats.length; i++) {
      var lat = lats[i];
      var lng = lngs[i];
      var iconClass = classes[i];
      var html = htmls[i];
      var popupContent = popups[i];
      var labelContent = labels[i];
      var layerId = layerIds[i];

      // Create a new marker with DivIcon
      var divIconOptions = Object.assign({}, divOptions, {
          className: iconClass,
          html: html
      });
     var divmarker = new L.Marker([lat, lng],
       Object.assign({}, options, {
            icon: new L.DivIcon(divIconOptions)
        }));

      // Bind popup to the marker if popup content is provided
      if (popupContent) {
          divmarker.bindPopup(popupContent, popupOptions);
      }

      // Assign label (tooltip) to marker if label content is provided
      if (labelContent) {
          divmarker.bindTooltip(labelContent, labelOptions);
      }

      // Add the marker to the map's layer manager
      map.layerManager.addLayer(divmarker, "marker", layerId, group);

      divmarker.on("click", LeafletWidget.methods.mouseHandler(map.id, layerId, group, "marker_click", ""), this);
      divmarker.on("mouseover", LeafletWidget.methods.mouseHandler(map.id, layerId, group, "marker_mouseover", ""), this);
      divmarker.on("mouseout", LeafletWidget.methods.mouseHandler(map.id, layerId, group, "marker_mouseout", ""), this);
      divmarker.on("dragend", LeafletWidget.methods.mouseHandler(map.id, layerId, group, "marker_dragend", ""), this);

      if (clusterId) {
        map.layerManager.addLayer(divmarker, "cluster", clusterId, group);
      }

    }
};


// Convert single string inputs to arrays
function toArray(input, length) {
    if (typeof input === 'string') {
        return Array(length).fill(input);
    }
    return input;
}


/*
addDivicon(map, df, group, markerFunc) {
  (function() {
    for (let i = 0; i < df.nrow(); i++) {
      if($.isNumeric(df.get(i, "lat")) && $.isNumeric(df.get(i, "lng"))) {
        (function() {
          let marker = markerFunc(df, i);
          let thisId = df.get(i, "layerId");
          let thisGroup = cluster ? null : df.get(i, "group");
          this.layerManager.addLayer(marker, "marker", thisId, thisGroup, df.get(i, "ctGroup", true), df.get(i, "ctKey", true));

          let popup = df.get(i, "popup");
          let popupOptions = df.get(i, "popupOptions");
          if (popup !== null) {
            if (popupOptions !== null){
              marker.bindPopup(popup, popupOptions);
            } else {
              marker.bindPopup(popup);
            }
          }
          let label = df.get(i, "label");
          let labelOptions = df.get(i, "labelOptions");
          if (label !== null) {
            if (labelOptions !== null) {
              if(labelOptions.permanent) {
                marker.bindTooltip(label, labelOptions).openTooltip();
              } else {
                marker.bindTooltip(label, labelOptions);
              }
            } else {
              marker.bindTooltip(label);
            }
          }
          //marker.on("click", mouseHandler(this.id, thisId, thisGroup, "marker_click"), this);
          //marker.on("mouseover", mouseHandler(this.id, thisId, thisGroup, "marker_mouseover"), this);
          //marker.on("mouseout", mouseHandler(this.id, thisId, thisGroup, "marker_mouseout"), this);
          //marker.on("dragend", mouseHandler(this.id, thisId, thisGroup, "marker_dragend"), this);

        }).call(this);
      }
    }

    if (cluster) {
      this.layerManager.addLayer(clusterGroup, "cluster", clusterId, group);
    }
  }).call(map);
}

*/
