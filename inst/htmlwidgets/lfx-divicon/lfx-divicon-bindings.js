/* global LeafletWidget, $, L */
LeafletWidget.methods.addDivicon = function(
    lat, lng, layerId, group, options,
    className, html,
    popup, popupOptions, label, labelOptions,
    clusterId, clusterOptions, divOptions,
    crosstalkOptions) {

    (function() {
      // Make a Dataframe
      let df = new LeafletWidget.DataFrame()
        .col("lat", lat)
        .col("lng", lng)
        .col("layerId", layerId)
        .col("group", group)
        .col("popup", popup)
        .col("popupOptions", popupOptions)
        .col("label", label)
        .col("labelOptions", labelOptions)
        .col("className", className)
        .col("html", html)
        .cbind(options)
        .cbind(crosstalkOptions || {});

      // Add Cluster
      let clusterGroup = this.layerManager.getLayer("cluster", clusterId),
        cluster = clusterOptions !== null;
      if (cluster && !clusterGroup) {
        clusterGroup = L.markerClusterGroup.layerSupport(clusterOptions);
        if(clusterOptions.freezeAtZoom) {
          let freezeAtZoom = clusterOptions.freezeAtZoom;
          delete clusterOptions.freezeAtZoom;
          clusterGroup.freezeAtZoom(freezeAtZoom);
        }
        clusterGroup.clusterLayerStore = new LeafletWidget.ClusterLayerStore(clusterGroup);
      }
      let extraInfo = cluster ? { clusterId: clusterId } : {};

      for (let i = 0; i < df.nrow(); i++) {
        if($.isNumeric(df.get(i, "lat")) && $.isNumeric(df.get(i, "lng"))) {
          (function() {

            let thisId = df.get(i, "layerId");
            let thisGroup = cluster ? null : df.get(i, "group");

            // Create a new marker with DivIcon
            var divIconOptions = Object.assign({}, divOptions, {
                className: df.get(i, "className"),
                html: df.get(i, "html")
            });
            var divmarker = new L.Marker(
              [df.get(i, "lat"), df.get(i, "lng")],
              Object.assign({}, options, {
                  icon: new L.DivIcon(divIconOptions)
              }));

            if (cluster) {
              clusterGroup.clusterLayerStore.add(divmarker, thisId);
            } else {
              this.layerManager.addLayer(divmarker, "marker", thisId, thisGroup, df.get(i, "ctGroup", true), df.get(i, "ctKey", true));
            }

            // Bind popup to the marker if popup content is provided
            let popup = df.get(i, "popup");
            let popupOptions = df.get(i, "popupOptions");
            if (popup !== null) {
              if (popupOptions !== null){
                divmarker.bindPopup(popup, popupOptions);
              } else {
                divmarker.bindPopup(popup);
              }
            }

            // Assign label (tooltip) to marker if label content is provided
            let label = df.get(i, "label");
            let labelOptions = df.get(i, "labelOptions");
            if (label !== null) {
              if (labelOptions !== null) {
                if(labelOptions.permanent) {
                  divmarker.bindTooltip(label, labelOptions).openTooltip();
                } else {
                  divmarker.bindTooltip(label, labelOptions);
                }
              } else {
                divmarker.bindTooltip(label);
              }
            }

            // Add the marker to the map's layer manager
            this.layerManager.addLayer(divmarker, "marker", thisId, thisGroup);

            // Add Listener
            divmarker.on("click", LeafletWidget.methods.mouseHandler(this.id, thisId, thisGroup, "marker_click", extraInfo), this);
            divmarker.on("mouseover", LeafletWidget.methods.mouseHandler(this.id, thisId, thisGroup, "marker_mouseover", extraInfo), this);
            divmarker.on("mouseout", LeafletWidget.methods.mouseHandler(this.id, thisId, thisGroup, "marker_mouseout", extraInfo), this);
            divmarker.on("dragend", LeafletWidget.methods.mouseHandler(this.id, thisId, thisGroup, "marker_dragend", extraInfo), this);

          }).call(this);
        }
      }
      if (cluster) {
        this.layerManager.addLayer(clusterGroup, "cluster", clusterId, group);
      }
    }).call(this);

};

