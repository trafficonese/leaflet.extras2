/* global LeafletWidget, $, L */
LeafletWidget.methods.addClusterCharts = function(geojson, layerId, group, type,
                                                  options, icon, html,
                                                  popup, popupOptions, label, labelOptions,
                                                  clusterOptions, clusterId, customFunc,
                                                  categoryField, categoryMap, popupFields, popupLabels,
                                                  markerOptions, legendOptions) {

  var map = this;

  // options
  var rmax = options.rmax ? options.rmax : 30;
  var strokeWidth = options.strokeWidth ? options.strokeWidth : 1;
  var labelBackground = options.labelBackground;
  var labelFill = options.labelFill ? options.labelFill : "white";
  var labelStroke = options.labelStroke ? options.labelStroke : "black";
  var labelColor = options.labelColor ? options.labelColor : "black";
  var labelOpacity = options.labelOpacity ? options.labelOpacity : 0.9;
  var sortTitlebyCount = options.sortTitlebyCount ? options.sortTitlebyCount : false;
  var aggregation = options.aggregation ? options.aggregation : "sum";

  // Make L.markerClusterGroup, markers, fitBounds and renderLegend
  console.log("geojson"); console.log(geojson)
  console.log("clusterOptions"); console.log(clusterOptions)
  var markerclusters = L.markerClusterGroup(
    Object.assign({
      maxClusterRadius: 2 * rmax,
      iconCreateFunction: defineClusterIcon // this is where the magic happens
    }, clusterOptions)
  )
  map.layerManager.addLayer(markerclusters, "cluster", clusterId, group);
  var markers = L.geoJson(geojson, {
  	pointToLayer: defineFeature,
  	onEachFeature: defineFeaturePopup
  });
  markerclusters.addLayer(markers);
  map.fitBounds(markers.getBounds());
  renderLegend();

  // Show/Hide the legend when the group is shown/hidden
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

  // Functions
  function defineFeature(feature, latlng) {
    var categoryVal = feature.properties[categoryField]
    var myClass = 'clustermarker category-'+categoryVal+' clusterchartsicon icon-'+categoryVal;
    let extraInfo = { clusterId: clusterId };

    //console.log("feature"); console.log(feature)
    // Make DIV-Icon marker
    var myIcon = L.divIcon({
        className: myClass,
        html: feature.properties[html] ? feature.properties[html] : "",
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
    } else if (popupFields !== null ) {
      console.log("popupFields"); console.log(popupFields)
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

    if (popupContent !== '') {
      if (popupOptions !== null){
        layer.bindPopup(popupContent, popupOptions);
      } else {
        layer.bindPopup(popupContent);
      }
    }
  }
  function defineClusterIcon(cluster) {
      var children = cluster.getAllChildMarkers(),
          n = children.length //Get number of markers in cluster
      var r = rmax-2*strokeWidth-(n<10?12:n<100?8:n<1000?4:0), //Calculate clusterpie radius...
          iconDim = (r+strokeWidth)*2, //...and divIcon dimensions (leaflet really want to know the size)
          html;
      var innerRadius = options.innerRadius ? options.innerRadius : -10;

      //bake some svg markup
      if (type == "custom") {

        // Step 1: Define a flexible aggregation function
        function aggregateData(data, categoryField, aggregationFunc, valueField) {
            return d3.nest()
                .key(function(d) { return d.feature.properties[categoryField]; })
                .rollup(function(leaves) {
                    return aggregationFunc(leaves, function(d) { return d.feature.properties[valueField]; });
                })
                .entries(data);
        }

        // Example aggregation functions
        const aggregationFunctions = {
            sum: (leaves, accessor) => d3.sum(leaves, accessor),
            max: (leaves, accessor) => d3.max(leaves, accessor),
            min: (leaves, accessor) => d3.min(leaves, accessor),
            mean: (leaves, accessor) => d3.mean(leaves, accessor),
            variance: (leaves, accessor) => d3.variance(leaves, accessor),
            // Add more as needed
        };

        console.log("children"); console.log(children)
        console.log("categoryField"); console.log(categoryField)
        var data = aggregateData(children, categoryField, aggregationFunctions[aggregation], 'tosum');
        console.log("data"); console.log(data)

        var totalAggregation = aggregationFunctions[aggregation](children, function(d) {
          console.log("totalAggregation - d.feature.properties['tosum']"); console.log(d.feature.properties['tosum'])
          return d.feature.properties['tosum'];
        });
        console.log("Total Aggregation: " + totalAggregation);

        console.log("Bubble chart");
        html = bakeTheBubbleChart({
            data: data,
            valueFunc: function(d) {
              var res = d.values;
              console.log("valueFunc res"); console.log(res)
              return res;
            },
            outerRadius: r,
            innerRadius: r - innerRadius,
            totalAggregation: totalAggregation,
            bubbleClass: 'cluster-bubble',
            bubbleLabelClass: 'clustermarker-cluster-bubble-label',
            pathClassFunc: function(d) {
              console.log('"category-" + d.key;'); console.log("category-" + d.key)
              return "category-" + d.data.key;
            },
            pathTitleFunc: function(d) {
              console.log('pathTitleFunc'); console.log(d.key + ' (' + d.value + ')')
              return d.data.key + ' (' + d.value + ')';
            }
        });

      } else {
        console.log("data");console.log(data)
        console.log("categoryField");console.log(categoryField)
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
        } else if (type == "horizontal") {
          console.log("Barchart horizontal")
          html = bakeTheBarChartHorizontal({
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
      }

      //Create a new divIcon and assign the svg markup to the html property
      var myIcon = new L.DivIcon({
              html: html,
              className: 'clustermarker-cluster',
              iconSize: new L.Point(iconDim, iconDim)
          });

      return myIcon;
  }
  //function that generates a svg markup for a Bubble chart
  function bakeTheBubbleChart(options) {
      if (!options.data || !options.valueFunc) {
          return '';
      }

      if (false) {
        console.log("1")
        var data = options.data,
            valueFunc = options.valueFunc,
            r = options.outerRadius,
            rInner = options.innerRadius,
            pathClassFunc = options.pathClassFunc,
            pathTitleFunc = options.pathTitleFunc,
            origo = (r+strokeWidth), // Center coordinate
            w = origo * 2, // Width and height of the svg element
            h = w,
            donut = d3.layout.pie(),
            arc = d3.svg.arc().innerRadius(rInner).outerRadius(r);

        console.log("3")
        var svg = document.createElementNS(d3.ns.prefix.svg, 'svg');
        var vis = d3.select(svg)
            .data([data])
            .attr('class', options.bubbleClass)
            .attr('width', w)
            .attr('height', h);

        console.log("4 - data");
        console.log(data)
        var arcs = vis.selectAll('g.arc')
            .data(donut.value(valueFunc))
            .enter().append('svg:g')
            .attr('class', 'arc')
            .attr('transform', 'translate(' + origo + ',' + origo + ')');

        arcs.append('svg:path')
            .attr('class', pathClassFunc)
            .attr('stroke-width', strokeWidth)
            .attr('d', arc)

      } else {
        var data = options.data,
          valueFunc = options.valueFunc,
          r = options.outerRadius,
          rInner = options.innerRadius,
          pathClassFunc = options.pathClassFunc,
          pathTitleFunc = options.pathTitleFunc,
          totalAggregation = options.totalAggregation,
          bubbleLabelClass = options.bubbleLabelClass,
          origo = (r+strokeWidth), // Center coordinate
          w = origo * 2, // Width and height of the svg element
          h = w,
          donut = d3.layout.pie(),
          arc = d3.svg.arc().innerRadius(rInner).outerRadius(r);

      let radius = w;

      let pie = donut
          .padAngle(1 / radius)
          .sort(null)
          .value(function(d) { return d.values; });

      var arc = d3.svg.arc()
          .innerRadius(rInner)
          .outerRadius(r);

      //Create the pie chart
      var svg = document.createElementNS(d3.ns.prefix.svg, 'svg');
      var vis = d3.select(svg)
          .attr("width", w)
          .attr("height", h)

      var arcs = vis.selectAll('g.arc')
        .data(pie(data))
        .enter().append('svg:g')
        .attr('class', 'arc')
        .attr('transform', 'translate(' + origo + ',' + origo + ')');
      console.log("arcs"); console.log(arcs)

      arcs.append('svg:path')
        .attr('class', pathClassFunc)
        .attr('stroke-width', strokeWidth)
        .attr('d', arc)
        .append('svg:title')
        .text(pathTitleFunc);

      // Text
      arcs.append('text')
          .attr('transform', function(d) {
              return 'translate(' + arc.centroid(d) + ')';
          })
          .attr('class', bubbleLabelClass)
          .attr('text-anchor', 'middle')
          .attr('fill', labelColor)
          .attr('dy','.3em')
          .text(function(d){
            console.log("TEXT - d"); console.log(d)
            //return d.values;
            return d.data.values;
          })
          //.append('svg:title')
          //.text(allTitles);

      vis.append('text')
          .attr('x', origo)
          .attr('y', origo)
          .attr('class', bubbleLabelClass)
          .attr('text-anchor', 'middle')
          .attr('fill', labelColor)
          .attr('dy', '.3em')
          .text(totalAggregation);  // Display the total aggregation

      }

      console.log("6")
      return serializeXmlNode(svg);
  }
  //function that generates a svg markup for a Pie chart
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
          pieLabel = options.pieLabel ? options.pieLabel : d3.sum(data, valueFunc), //Label for the whole pie
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

      // Arcs
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

      // Create Title for Individual Elements and All in Cluster
      console.log("d3pie data")
      pathTitleFunc = function(d){
            return d.key + ' (' + d.values.length + ')';
      }
      let allTitles = ""
      if (sortTitlebyCount) {
        allTitles = data
              .sort(function(a, b) { return b.values.length - a.values.length; })  // Sort by length in descending order
              .map(function(d) { return pathTitleFunc(d); })
              .join('\n');
      } else {
        let categoryOrder = {};
        for (var key in categoryMap) {
            categoryOrder[categoryMap[key]] = parseInt(key);
        }
        allTitles = data
            .sort(function(a, b) {
                // Get the order values from categoryOrder
                var orderA = categoryOrder[a.key] || Infinity;
                var orderB = categoryOrder[b.key] || Infinity;
                return orderA - orderB; // Sort in ascending order
            })
            .map(function(d) { return pathTitleFunc(d); })
            .join('\n');
      }

      // Show Label Background
      if (labelBackground && labelBackground == true) {
        vis.append('circle')
            .attr('r', rInner-5)
            .attr('transform', 'translate(' + origo + ',' + origo + ')')
            .attr('fill', labelFill)
            .attr('stroke', labelStroke)
            .attr('stroke-width', strokeWidth)
            .attr('opacity', labelOpacity)
            .append('svg:title')
            .text(allTitles); // Title for the rectangle with all values
      }
      // Text
      vis.append('text')
          .attr('x',origo)
          .attr('y',origo)
          .attr('class', pieLabelClass)
          .attr('text-anchor', 'middle')
          .attr('fill', labelColor)
          .attr('dy','.3em')
          .text(pieLabel)
          .append('svg:title')
          .text(allTitles);

      //Return the svg-markup rather than the actual element
      return serializeXmlNode(svg);
  }
  //function that generates a svg markup for a Bar chart
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
        .attr('width', width + strokeWidth)
        .attr('height', height + 20 + strokeWidth);

    // Bars
    vis.selectAll('.bar')
        .data(data)
        .enter().append('rect')
        .attr('class', pathClassFunc)
        .attr('x', function(d) { return x(d.key); })
        .attr('width', x.rangeBand())
        .attr('y', function(d) { return y(d.values.length); })
        .attr('height', function(d) { return height - y(d.values.length); })
        .append('svg:title')
        .text(pathTitleFunc);

    // Create Title for Individual Elements and All in Cluster
    let allTitles = ""
    if (sortTitlebyCount) {
      allTitles = data
            .sort(function(a, b) { return b.values.length - a.values.length; })  // Sort by length in descending order
            .map(function(d) { return pathTitleFunc(d); })
            .join('\n');
    } else {
      let categoryOrder = {};
      for (var key in categoryMap) {
          categoryOrder[categoryMap[key]] = parseInt(key);
      }
      allTitles = data
          .sort(function(a, b) {
              // Get the order values from categoryOrder
              var orderA = categoryOrder[a.key] || Infinity;
              var orderB = categoryOrder[b.key] || Infinity;
              return orderA - orderB; // Sort in ascending order
          })
          .map(function(d) { return pathTitleFunc(d); })
          .join('\n');
    }

    // Bar Label Background
    if (labelBackground && labelBackground == true) {
      vis.append('rect')
          .attr('x', (width - (width - 10)) / 2) // Adjust the width of the background
          .attr('y', height + 5) // Adjust the y position for the background
          .attr('width', width - 10) // Width of the background
          .attr('height', 15) // Height of the background
          .attr('fill', labelFill)
          .attr('stroke', labelStroke)
          .attr('opacity', labelOpacity)
          .attr('stroke-width', strokeWidth)
          .append('svg:title')
          .text(allTitles); // Title for the rectangle with all values
    }

    // Bar Label
    vis.append('text')
        .attr('x', width / 2)
        .attr('y', height + 13) // Adjust the y position for the text
        .attr('class', barLabelClass)
        .attr('text-anchor', 'middle')
        .attr('dy', '.3em')
        .attr('fill', labelColor)
        .text(barLabel)
        .append('svg:title')
        .text(allTitles); // Title for the rectangle with all values

    return serializeXmlNode(svg);
  }
  //function that generates a svg markup for a Bar chart (horizontal)
  function bakeTheBarChartHorizontal(options) {
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
        x = d3.scale.linear().range([0, width]), // Linear scale for horizontal length
        y = d3.scale.ordinal().rangeRoundBands([0, height], 0.1); // Ordinal scale for vertical positioning

    x.domain([0, d3.max(data, function(d) { return d.values.length; })]);
    y.domain(data.map(function(d) { return d.key; }));

    var svg = document.createElementNS(d3.ns.prefix.svg, "svg");
    var vis = d3.select(svg)
        .attr('class', barClass)
        .attr('width', width + strokeWidth)
        .attr('height', height + 20 + strokeWidth);

    // Bars
    vis.selectAll('.bar')
        .data(data)
        .enter().append('rect')
        .attr('class', pathClassFunc)
        .attr('x', 0)
        .attr('y', function(d) { return y(d.key); })
        .attr('width', function(d) { return x(d.values.length); }) // Bar length based on x scale
        .attr('height', y.rangeBand()) // Bar thickness based on y scale
        .append('svg:title')
        .text(pathTitleFunc);

    // Create Title for Individual Elements and All in Cluster
    let allTitles = ""
    //var allTitles = data.map(function(d) { return pathTitleFunc(d); }).join('\n');
    if (sortTitlebyCount) {
      allTitles = data
            .sort(function(a, b) { return b.values.length - a.values.length; })  // Sort by length in descending order
            .map(function(d) { return pathTitleFunc(d); })
            .join('\n');
    } else {
      let categoryOrder = {};
      for (var key in categoryMap) {
          categoryOrder[categoryMap[key]] = parseInt(key);
      }
      allTitles = data
          .sort(function(a, b) {
              // Get the order values from categoryOrder
              var orderA = categoryOrder[a.key] || Infinity;
              var orderB = categoryOrder[b.key] || Infinity;
              return orderA - orderB; // Sort in ascending order
          })
          .map(function(d) { return pathTitleFunc(d); })
          .join('\n');
    }

    // Bar Label Background
    if (labelBackground && labelBackground == true) {
        vis.append('rect')
            .attr('x', 0) // Adjust the width of the background
            .attr('y', height + 3) // Adjust the y position for the background
            .attr('width', width) // Width of the background
            .attr('height', 15) // Height of the background
            .attr('fill', labelFill)
            .attr('stroke', labelStroke)
            .attr('opacity', labelOpacity)
            .attr('stroke-width', strokeWidth)
            .append('svg:title')
            .text(allTitles); // Title for the rectangle with all values
    }

    // Bar Label
    vis.append('text')
        .attr('x', width / 2)
        .attr('y', (height + 8)) // Adjust the y position for the text
        .attr('class', barLabelClass)
        .attr('text-anchor', 'middle')
        .attr('dominant-baseline', 'middle')
        .attr('alignment-baseline', 'middle')
        .attr('dy', '.3em')
        .attr('fill', labelColor)
        .text(barLabel)
        .append('svg:title')
        .text(allTitles); // Title for the rectangle with all values

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




