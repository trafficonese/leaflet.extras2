LeafletWidget.methods.addGeosearch = function(providerConfig, options) {
  (function(){
    var map = this;
    if (map.geosearch) {
      map.geosearch.remove();
      delete map.geosearch;
    }

    //console.log("providerConfig");console.log(providerConfig)
    const providerType = providerConfig.type;
    const providerOptions = providerConfig.options || {};
    const providerMap = {
      Bing: GeoSearch.BingProvider,
      Esri: GeoSearch.EsriProvider,
      GeocodeEarth: GeoSearch.GeocodeEarthProvider,
      Google: GeoSearch.GoogleProvider,
      Here: GeoSearch.HereProvider,
      LocationIQ: GeoSearch.LocationIQProvider,
      OpenCage: GeoSearch.OpenCageProvider,
      OSM: GeoSearch.OpenStreetMapProvider,
      Pelias: GeoSearch.PeliasProvider,
      Geoapify: GeoSearch.GeoapifyProvider,
      AMap: GeoSearch.AMapProvider,
      GeoApiFr: GeoSearch.GeoApiFrProvider
    };

    const ProviderConstructor = providerMap[providerType];
    const provider = new ProviderConstructor(providerOptions);
    //console.log("provider");console.log(provider)

    const optionsIcon = Object.assign({
      marker: {
          icon: new L.Icon.Default(),
        }
      }, options);
    const controlOptions = Object.assign({ provider: provider }, optionsIcon);
    //console.log("controlOptions");console.log(controlOptions)

    const searchControl = new GeoSearch.GeoSearchControl(controlOptions);

    map.on('geosearch/showlocation', function(e) {
      console.log("geosearch/showlocation"); console.log(e)
      Shiny.onInputChange(map.id+"_geosearch_result", e.location || null );
    });
    map.on('geosearch/marker/dragend', function(e) {
      console.log("geosearch/marker/dragend"); console.log(e)
      Shiny.onInputChange(map.id+"_geosearch_dragend", e.location || null);
    });

    map.geosearch = searchControl;
    map.controls.add(map.geosearch);

  }).call(this);
};


LeafletWidget.methods.removeGeosearch = function() {
  (function(){
    var map = this;
    if(map.geosearch) {
      $(".geosearch .reset").trigger("click");
      map.geosearch.remove();
      delete map.geosearch;
    }
  }).call(this);
};

