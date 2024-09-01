LeafletWidget.methods.addBuilding = function(buildingURL, group, eachFn, clickFn, data) {
  (function(){
    var map = this;
    if (map.osmb) {
      map.osmb.remove();
      delete map.osmb;
    }

    var osmb = new OSMBuildings(map)
      .date(new Date())

    if (data) {
      if (data.features && data.features[0].properties.height && data.features[0].geometry.type == "Polygon") {
        console.log("data is defined"); console.log(data);
        osmb.set(data);
      } else {
        console.error("The data is not a correct GeoJSON of type 'Polygon' or has no property 'height'.");
      }
    } else {
      osmb.load(buildingURL);
    }

    if (eachFn && typeof eachFn === 'function') {
      osmb.each(eachFn);
    }
    if (clickFn && typeof clickFn === 'function') {
      osmb.click(clickFn);
    }

    map.layerManager.addLayer(osmb, "building", null, group);
    map.osmb = osmb;

  }).call(this);
};


LeafletWidget.methods.updateBuildingTime = function(date) {
  (function(){
    var map = this;
    if (map.osmb) {
      var now = new Date(date);
      var Y = now.getFullYear(),
        M = now.getMonth(),
        D = now.getDate(),
        h = now.getHours(),
        m = now.getMinutes();

      // Update the date on the OSMBuildings instance
      map.osmb.date(new Date(Y, M, D, h, m));
    } else {
      console.error("OSMBuildings instance is not initialized.");
    }
  }).call(this);
};

LeafletWidget.methods.setBuildingStyle = function(style) {
  (function(){
    var map = this;
    if (map.osmb) {
      map.osmb.style(style);
    } else {
      console.error("OSMBuildings instance is not initialized.");
    }
  }).call(this);
};

LeafletWidget.methods.setBuildingData = function(data) {
  (function(){
    var map = this;
    if (map.osmb) {
      map.osmb.set(data);
    } else {
      console.error("OSMBuildings instance is not initialized.");
    }
  }).call(this);
};
