/* global LeafletWidget, $, L */
LeafletWidget.methods.addMapkeyMarkers = function(
    lat, lng, icon, layerId, group, options,
    popup, popupOptions, clusterOptions, clusterId, label, labelOptions) {
    (function(){
      var icondf;

      var getIcon;
      if (icon) {

        // This cbinds the icon URLs and any other icon options; they're all
      // present on the icon object.
      icondf = new LeafletWidget.DataFrame().cbind(icon);

      // Constructs an icon from a specified row of the icon dataframe.
      getIcon = function(i) {
        var opts = icondf.get(i);
        if (!opts) {
          return new L.icon.mapkey();
        }

        opts.iconSize = [opts.iconSize, opts.iconSize];
        //L.icon.mapkey({icon:"school",color:'#725139',background:'#f2c357',size:30}
        return new L.icon.mapkey(opts);

      };
    }

    if(!($.isEmptyObject(lat) || $.isEmptyObject(lng)) ||
      ($.isNumeric(lat) && $.isNumeric(lng))) {

      var df = new LeafletWidget.DataFrame()
        .col('lat', lat)
        .col('lng', lng)
        .col('layerId', layerId)
        .col('group', group)
        .col('popup', popup)
        .col('popupOptions', popupOptions)
        .col('label', label)
        .col('labelOptions', labelOptions)
        .cbind(options);

      if (icon) icondf.effectiveLength = df.nrow();

      LeafletWidget.methods.addGenericMarkers(
        this, df, group, clusterOptions, clusterId, function(df, i) {
          var options = df.get(i);
          if (icon) options.icon = getIcon(i);
          return L.marker([df.get(i, 'lat'), df.get(i, 'lng')], options);
        });
    }

  }).call(this);
};
