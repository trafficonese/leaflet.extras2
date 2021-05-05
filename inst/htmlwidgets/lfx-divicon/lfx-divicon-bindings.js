/* global LeafletWidget, $, L */
LeafletWidget.methods.addDivicon = function(
    data, duration, icon, layerId, group, options,
    popup, popupOptions, label, labelOptions) {

    var map = this;

    debugger;
    var divmarker = new L.Marker([57.666667, -2.64], {
      icon: new L.DivIcon({
          className: 'my-div-icon',
          html: '<img class="my-div-image" src="http://png-3.vector.me/files/images/4/0/402272/aiga_air_transportation_bg_thumb"/>'+
                '<span class="my-div-span">RAF Banff Airfield</span>'
      })
    });

    map.layerManager.addLayer(divmarker, "marker", layerId, group);
};




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
          /*
          marker.on("click", mouseHandler(this.id, thisId, thisGroup, "marker_click"), this);
          marker.on("mouseover", mouseHandler(this.id, thisId, thisGroup, "marker_mouseover"), this);
          marker.on("mouseout", mouseHandler(this.id, thisId, thisGroup, "marker_mouseout"), this);
          marker.on("dragend", mouseHandler(this.id, thisId, thisGroup, "marker_dragend"), this);
          */
        }).call(this);
      }
    }

    if (cluster) {
      this.layerManager.addLayer(clusterGroup, "cluster", clusterId, group);
    }
  }).call(map);
}
