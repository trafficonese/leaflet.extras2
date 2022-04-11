LeafletWidget.methods.addBuilding = function(apikey, layerId, group, opacity, attribution) {

  var map = this;

/*
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
*/

  // 2.5D buildings to Leaflet web maps.
/*
  new L.TileLayer('https://{s}.tiles.mapbox.com/v3/'+apikey+'/{z}/{x}/{y}.png', {
    attribution: attribution,
    maxZoom: 18,
    maxNativeZoom: 20
  }).addTo(map);
  new OSMBuildings(map).load('https://{s}.data.osmbuildings.org/0.2/anonymous/tile/{z}/{x}/{y}.json');
*/

  // 3D buildings
  var map1 = new OSMBuildings({
  	container: 'map',
  	position: { latitude: 52.51836, longitude: 13.40438 },
  	zoom: 16,
  	minZoom: 15,
  	maxZoom: 20,
  	attribution: attribution
  })
  map1.addMapTiles('https://{s}.tiles.mapbox.com/v3/'+apikey+'/{z}/{x}/{y}.png');
  map1.addGeoJSONTiles('https://{s}.data.osmbuildings.org/0.2/anonymous/tile/{z}/{x}/{y}.json');
};

