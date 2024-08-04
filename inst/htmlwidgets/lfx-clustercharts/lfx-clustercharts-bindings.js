/* global LeafletWidget, $, L */
LeafletWidget.methods.addClusterCharts = function(geojson, layerId, group, type,
                                                  options,
                                                  popup, popupOptions, label, labelOptions,
                                                  clusterOptions, clusterId,
                                                  categoryField, categoryMap, popupFields, popupLabels,
                                                  markerOptions, legendOptions) {

  var map = this;

  var rmax = options.rmax ? options.rmax : 30;
  var innerRadius = options.innerRadius ? options.innerRadius : -10;
  var strokeWidth = options.strokeWidth ? options.strokeWidth : 1;

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
    var myClass = 'clustermarker category-'+categoryVal+' icon-'+categoryVal;
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
          popupContent += '<tr class="attribute"><td class="clustermarkerpopuplabel">' + label + ':</td><td>' + val + '</td></tr>';
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
          n = children.length //Get number of markers in cluster
      var r = rmax-2*strokeWidth-(n<10?12:n<100?8:n<1000?4:0), //Calculate clusterpie radius...
          iconDim = (r+strokeWidth)*2, //...and divIcon dimensions (leaflet really want to know the size)
          html;

      //bake some svg markup
      var data = d3.nest() //Build a dataset for the pie chart
            .key(function(d) { return d.feature.properties[categoryField]; })
            .entries(children, d3.map)

      if (type == "pie") {
        console.log("Piechart")
        html = bakeThePie({
          data: data,
          valueFunc: function(d){return d.values.length;},
          outerRadius: r,
          innerRadius: r-innerRadius,
          pieClass: 'cluster-pie',
          pieLabel: n,
          pieLabelClass: 'clustermarker-cluster-pie-label',
          pathClassFunc: function(d){
            return "category-" + d.data.key;
          },
          pathTitleFunc: function(d){
            return d.data.key + ' (' + d.data.values.length + ')';
          }
        })
      } else {
        console.log("Barchart")
        html = bakeTheBarChart({
          data: data,
          barClass: 'cluster-bar',
          barLabel: n,
          width: options.width ? options.width : 70,
          height: options.height ? options.height : 40,
          barLabelClass: 'clustermarker-cluster-bar-label',
          pathClassFunc: function(d){
            return "category-" + d.key;
          },
          pathTitleFunc: function(d){
            return d.key + ' (' + d.values.length + ')';
          }
        });
      }

      //Create a new divIcon and assign the svg markup to the html property
      var myIcon = new L.DivIcon({
              html: html,
              className: 'clustermarker-cluster',
              iconSize: new L.Point(iconDim, iconDim)
          });

      return myIcon;
  }
  //function that generates a svg markup for the Pie chart
  function bakeThePie(options) {
      //data and valueFunc are required
      if (!options.data || !options.valueFunc) {
          return '';
      }
      console.log("bakeThePie with these options"); console.log(options)
      var data = options.data,
          valueFunc = options.valueFunc,
          r = options.outerRadius,
          rInner = options.innerRadius,
          pathClassFunc = options.pathClassFunc,
          pathTitleFunc = options.pathTitleFunc,
          pieClass = options.pieClass,
          pieLabel = options.pieLabel?options.pieLabel:d3.sum(data,valueFunc), //Label for the whole pie
          pieLabelClass = options.pieLabelClass,

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
          .attr('dy','.3em')
          .text(pieLabel);

      //Return the svg-markup rather than the actual element
      return serializeXmlNode(svg);
  }

  //function that generates a svg markup for the Bar chart
  function bakeTheBarChart(options) {
    if (!options.data) {
      return '';
    }
    console.log("bakeTheBarChart with these options"); console.log(options)
    var data = options.data,
        barClass = options.barClass,
        barLabel = options.barLabel ? options.barLabel : d3.sum(data, function(d) { return d.values.length; }),
        barLabelClass = options.barLabelClass,
        width = options.width,
        height = options.height,
        pathClassFunc = options.pathClassFunc,
        pathTitleFunc = options.pathTitleFunc,
        x = d3.scale.ordinal().rangeRoundBands([0, width], 0.1),
        y = d3.scale.linear().range([height, 0]);

    x.domain(data.map(function(d) { return d.key; }));
    y.domain([0, d3.max(data, function(d) { return d.values.length; })]);

    var svg = document.createElementNS(d3.ns.prefix.svg, "svg");
    var vis = d3.select(svg)
        .attr('class', barClass)
        .attr('width', width)
        .attr('height', height);

    vis.selectAll('.bar')
        .data(data)
        .enter().append('rect')
        .attr('class', pathClassFunc)
        .attr('x', function(d) {
          return x(d.key);
        })
        .attr('width', x.rangeBand())
        .attr('y', function(d) { return y(d.values.length); })
        .attr('height', function(d) { return height - y(d.values.length); })
        .append('svg:title')
        .text(pathTitleFunc);

    vis.append('text')
        .attr('x', width / 2)
        .attr('y', height / 2)
        .attr('class', barLabelClass)
        .attr('text-anchor', 'top')
        .attr('dy', '.3em')
        .text(barLabel);

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




