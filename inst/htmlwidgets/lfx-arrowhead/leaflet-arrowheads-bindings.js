LeafletWidget.methods.addArrowhead = function(polygons, layerId, group, options, popup,
                                            popupOptions, label, labelOptions, highlightOptions,
                                            arrowheadOptions) {

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

  LeafletWidget.methods.addGenericLayers(this, "shape", df, function(df, i) {
    let shapes = df.get(i, "shapes");
    shapes = shapes.map(shape => HTMLWidgets.dataframeToD3(shape[0]));
    if(shapes.length > 1) {
      return L.polyline(shapes, df.get(i)).arrowheads(arrowheadOptions);
    } else {
      return L.polyline(shapes[0], df.get(i)).arrowheads(arrowheadOptions);
    }
  });
};


LeafletWidget.methods.clearArrowhead = function(group) {
  var grp = this.layerManager._byGroup[group];
  Object.entries(grp).forEach(([key, value]) => {
    if (grp[key] && grp[key].deleteArrowheads) {
      grp[key].deleteArrowheads()
    }
  })
}


LeafletWidget.methods.removeArrowhead = function(layerid) {
  var lids = Array.isArray(layerid) ? layerid : [layerid]
  lids.forEach(e => {
    var lyr = this.layerManager.getLayer("shape", e);
    if (lyr && lyr.arrowheads) {
      lyr.deleteArrowheads()
    }
  })
}

