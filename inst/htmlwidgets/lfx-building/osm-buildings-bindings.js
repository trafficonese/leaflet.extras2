LeafletWidget.methods.addBuilding = function(layerId, group, opacity, attribution) {
//  (function(){
    var map = this;
    if (map.osmb) {
      map.osmb.remove();
      delete map.osmb;
    }
    console.log(("Schaff ich es hjier"))

    map.setView([52.51836, 13.40438], 16, false);

    new L.TileLayer('https://tile-a.openstreetmap.fr/hot/{z}/{x}/{y}.png', {
      attribution: '© Data <a href="https://openstreetmap.org">OpenStreetMap</a>',
      maxZoom: 18,
      maxNativeZoom: 20
    }).addTo(map);

    var osmb = new OSMBuildings(map)
      .load('https://{s}.data.osmbuildings.org/0.2/59fcc2e8/tile/{z}/{x}/{y}.json');


    osmb.date(new Date(2017, 15, 1, 19, 30))

    map.osmb = osmb;

//  }).call(this);
};


LeafletWidget.methods.updateBuildingTime = function(date) {
  var map = this;
  if (map.osmb) {
    var now = new Date(date);
    console.log("now"); console.log(now)
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
};
