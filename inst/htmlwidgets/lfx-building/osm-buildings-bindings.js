LeafletWidget.methods.addBuilding = function(apikey, layerId, group, options) {

  var map = this;

  let rotation = 0;
  function rotate() {
    map.setRotation(rotation);
    rotation = (rotation+1) % 360;
    requestAnimationFrame(rotate);
  }

  var buildings = new OSMBuildings({
  	container: 'map',
  	//position: { latitude: 52.51836, longitude: 13.40438 },
  	zoom: 16,
  	minZoom: 15,
  	maxZoom: 20,
    tilt: 40,
    rotation: 300,
    effects: ['shadows'],
  	attribution: '© Data <a href="https://openstreetmap.org/copyright/">OpenStreetMap</a> © Map <a href="https://mapbox.com/">Mapbox</a> © 3D <a href="https://osmbuildings.org/copyright/">OSM Buildings</a>'
  });

  //buildings.addMapTiles('https://api.mapbox.com/styles/v1/osmbuildings/cjt9gq35s09051fo7urho3m0f/tiles/256/{z}/{x}/{y}@2x?access_token=' + apikey);
  buildings.addGeoJSONTiles('https://{s}.data.osmbuildings.org/0.2/dixw8kmb/tile/{z}/{x}/{y}.json');

  //LeafletWidget.methods.addLayer(buildings, "building", layerId, group);

};

