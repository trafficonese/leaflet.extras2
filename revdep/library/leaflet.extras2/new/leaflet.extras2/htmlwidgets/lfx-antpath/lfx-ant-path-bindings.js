LeafletWidget.methods.addAntpath = function(polygons, layerId, group, options, popup,
                                            popupOptions, label, labelOptions, highlightOptions) {

  let df = new LeafletWidget.DataFrame()
    .col("shapes", polygons)
    .col("layerId", layerId)
    .col("group", group)
    .col("popup", popup)
    .col("popupOptions", popupOptions)
    .col("label", label)
    .col("labelOptions", labelOptions)
    .col("highlightOptions", highlightOptions)
    .cbind(options);

  LeafletWidget.methods.addGenericLayers(this, "antpath", df, function(df, i) {
    let shapes = df.get(i, "shapes");
    shapes = shapes.map(shape => HTMLWidgets.dataframeToD3(shape[0]));
    if(shapes.length > 1) {
      return L.polyline.antPath(shapes, df.get(i));
    } else {
      return L.polyline.antPath(shapes[0], df.get(i));
    }
  });

};

LeafletWidget.methods.removeAntpath = function(layerId) {
  this.layerManager.removeLayer("antpath", layerId);
};

LeafletWidget.methods.clearAntpath = function() {
  this.layerManager.clearLayers("antpath");
};
