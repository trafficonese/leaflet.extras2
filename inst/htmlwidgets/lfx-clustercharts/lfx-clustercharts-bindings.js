/* global LeafletWidget, $, L */
LeafletWidget.methods.addClusterCharts = function(geojson, layerId, group, rmax, size,
                                                  popup, popupOptions, label, labelOptions,
                                                  clusterOptions, clusterId,
                                                  categoryField, categoryMap, popupFields, popupLabels,
                                                  markerOptions, legendOptions) {

  var map = this;

  var markerclusters = L.markerClusterGroup(
    Object.assign({
      maxClusterRadius: 2 * rmax,
      iconCreateFunction: defineClusterIcon // this is where the magic happens
    }, clusterOptions)
  )

  map.addLayer(markerclusters);
  map.layerManager.addLayer(markerclusters, "cluster", clusterId, group);

  console.log("geojson"); console.log(geojson)
  var markers = L.geoJson(geojson, {
  	pointToLayer: defineFeature,
  	onEachFeature: defineFeaturePopup
  });
  markerclusters.addLayer(markers);
  map.fitBounds(markers.getBounds());
  renderLegend();

  map.on('overlayadd', function(eventlayer){
    if (eventlayer.name == group) {
      $(".clusterlegend").show()
    }
  });
  map.on('overlayremove', function(eventlayer){
    if (eventlayer.name == group) {
      $(".clusterlegend").hide()
    }
  });

  function defineFeature(feature, latlng) {
    var categoryVal = feature.properties[categoryField]
    var myClass = 'marker category-'+categoryVal+' icon-'+categoryVal;
    //console.log("myClass"); console.log(myClass)
    let extraInfo = { clusterId: clusterId };

    // Make DIV-Icon marker
    var myIcon = L.divIcon({
        className: myClass,
        iconSize: null
    });
    var marker = L.marker(latlng,
      Object.assign({
        icon: myIcon
      }, markerOptions)
    );

    // Add Labels
    if (label !== null && feature.properties[label] && feature.properties[label] !== null) {
      var labelshow = feature.properties[label];
      if (labelOptions !== null) {
        if(labelOptions.permanent) {
          marker.bindTooltip(labelshow, labelOptions).openTooltip();
        } else {
          marker.bindTooltip(labelshow, labelOptions);
        }
      } else {
        marker.bindTooltip(labelshow);
      }
    }
    // Add Mouse events with layerId and Group
    var lid = feature.properties[layerId] ? feature.properties[layerId] : layerId
    var lgr = feature.properties[group] ? feature.properties[group] : group
    marker.on("click", LeafletWidget.methods.mouseHandler(map.id, lid, lgr, "marker_click", extraInfo), this);
    marker.on("mouseover", LeafletWidget.methods.mouseHandler(map.id, lid, lgr, "marker_mouseover", extraInfo), this);
    marker.on("mouseout", LeafletWidget.methods.mouseHandler(map.id, lid, lgr, "marker_mouseout", extraInfo), this);
    marker.on("dragend", LeafletWidget.methods.mouseHandler(map.id, lid, lgr, "marker_dragend", extraInfo), this);

    return marker;
  }
  function defineFeaturePopup(feature, layer) {
    var props = feature.properties,
                popupContent = '';
    if (popup && props[popup]) {
      popupContent = props[popup];
    } else {
      popupContent += '<table class="map-popup">';
      popupFields.map( function(key, idx) {
        if (props[key]) {
          var val = props[key],
            label = popupLabels[idx];
          popupContent += '<tr class="attribute"><td class="clustermarkerlabel">' + label + ':</td><td>' + val + '</td></tr>';
        }
      });
      popupContent += '</table>';
    }
    if (popupOptions !== null){
      layer.bindPopup(popupContent, popupOptions);
    } else {
      layer.bindPopup(popupContent);
    }
  }
  function defineClusterIcon(cluster) {
      var children = cluster.getAllChildMarkers(),
          n = children.length, //Get number of markers in cluster
          strokeWidth = 1, //Set clusterpie stroke width
          r = rmax-2*strokeWidth-(n<10?12:n<100?8:n<1000?4:0), //Calculate clusterpie radius...
          iconDim = (r+strokeWidth)*2, //...and divIcon dimensions (leaflet really want to know the size)
          data = d3.nest() //Build a dataset for the pie chart
            .key(function(d) { return d.feature.properties[categoryField]; })
            .entries(children, d3.map),
          //bake some svg markup
          html = bakeThePie({data: data,
                              valueFunc: function(d){return d.values.length;},
                              strokeWidth: 1,
                              outerRadius: r,
                              innerRadius: r-10,
                              pieClass: 'cluster-pie',
                              pieLabel: n,
                              pieLabelClass: 'marker-cluster-pie-label',
                              pathClassFunc: function(d){
                                return "category-"+d.data.key;
                              },
                              pathTitleFunc: function(d){
                                return d.data.key+' ('+d.data.values.length+' element)';
                              }
                            }),
          //Create a new divIcon and assign the svg markup to the html property
          myIcon = new L.DivIcon({
              html: html,
              className: 'marker-cluster',
              iconSize: new L.Point(iconDim, iconDim)
          });

      //console.log("data"); console.log(data)
      return myIcon;
  }
  //function that generates a svg markup for the pie chart
  function bakeThePie(options) {
      //data and valueFunc are required
      if (!options.data || !options.valueFunc) {
          return '';
      }
      var data = options.data,
          valueFunc = options.valueFunc,
          r = options.outerRadius?options.outerRadius:28, //Default outer radius = 28px
          rInner = options.innerRadius?options.innerRadius:r-10, //Default inner radius = r-10
          strokeWidth = options.strokeWidth?options.strokeWidth:1, //Default stroke is 1
          pathClassFunc = options.pathClassFunc?options.pathClassFunc:function(){return '';}, //Class for each path
          pathTitleFunc = options.pathTitleFunc?options.pathTitleFunc:function(){return '';}, //Title for each path
          pieClass = options.pieClass?options.pieClass:'marker-cluster-pie', //Class for the whole pie
          pieLabel = options.pieLabel?options.pieLabel:d3.sum(data,valueFunc), //Label for the whole pie
          pieLabelClass = options.pieLabelClass?options.pieLabelClass:'marker-cluster-pie-label',//Class for the pie label

          origo = (r+strokeWidth), //Center coordinate
          w = origo*2, //width and height of the svg element
          h = w,
          donut = d3.layout.pie(),
          arc = d3.svg.arc().innerRadius(rInner).outerRadius(r);

      //Create an svg element
      var svg = document.createElementNS(d3.ns.prefix.svg, 'svg');
      //Create the pie chart
      var vis = d3.select(svg)
          .data([data])
          .attr('class', pieClass)
          .attr('width', w)
          .attr('height', h);

      var arcs = vis.selectAll('g.arc')
          .data(donut.value(valueFunc))
          .enter().append('svg:g')
          .attr('class', 'arc')
          .attr('transform', 'translate(' + origo + ',' + origo + ')');

      console.log("pathTitleFunc"); console.log(pathTitleFunc)
      arcs.append('svg:path')
          .attr('class', pathClassFunc)
          .attr('stroke-width', strokeWidth)
          .attr('d', arc)
          .append('svg:title')
            .text(pathTitleFunc);

      vis.append('text')
          .attr('x',origo)
          .attr('y',origo)
          .attr('class', pieLabelClass)
          .attr('text-anchor', 'middle')
          //.attr('dominant-baseline', 'central')
          //IE doesn't seem to support dominant-baseline, but setting dy to .3em does the trick
          .attr('dy','.3em')
          .text(pieLabel);
      //Return the svg-markup rather than the actual element
      return serializeXmlNode(svg);
  }
  //Helper function
  function serializeXmlNode(xmlNode) {
      if (typeof window.XMLSerializer != "undefined") {
          return (new window.XMLSerializer()).serializeToString(xmlNode);
      } else if (typeof xmlNode.xml != "undefined") {
          return xmlNode.xml;
      }
      return "";
  }

  //Function for generating a legend with the same categories as in the clusterPie
  function renderLegend() {
    var data = Object.entries(categoryMap).map(([key, value]) => ({
      key: key,
      value: value
    }));
    var legendControl = L.control({position: legendOptions.position});

    legendControl.onAdd = function(map) {
      var div = L.DomUtil.create('div', 'clusterlegend');
      div.innerHTML = '<div class="legendheading">' + legendOptions.title + '</div>';

      var legendItems = d3.select(div)
          .selectAll('.legenditem')
          .data(data);

      legendItems.enter()
          .append('div')
          .attr('class', function(d) {
              console.log("d"); console.log(d)
              return 'category-' + d.value;
          })
          .classed('legenditem', true)
          .text(function(d) { return d.value; });

      return div;
    };

    // Add the custom control to the map
    legendControl.addTo(map);
  }

};




