/* global LeafletWidget, $, L */
LeafletWidget.methods.addClusterCharts = function(geojson, layerId, group, type,
                                                  options, icon, html,
                                                  popup, popupOptions, label, labelOptions,
                                                  clusterOptions, clusterId,
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
  var valueField = options.valueField ? options.valueField : null;
  var digits = options.digits ? options.digits : null;

  // Make L.markerClusterGroup, markers, fitBounds and renderLegend
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
    var myClass = 'clustermarker category-'+categoryVal+' icon-'+categoryVal;
    let extraInfo = { clusterId: clusterId };

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
      popupContent = props[popup] + '';
    } else if (popupFields !== null ) {
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
          n = children.length,
          r = rmax - 2 * strokeWidth - (n<10?12:n<100?8:n<1000?4:0),
          iconDim = (r + strokeWidth) * 2,
          html,
          innerRadius = options.innerRadius ? options.innerRadius : -10;

      //bake some svg markup
      if (type == "custom") {

        // Define aggregation function
        function aggregateData(data, categoryField, aggregationFunc, valueField) {
            return d3.nest()
                .key(function(d) { return d.feature.properties[categoryField]; })
                .rollup(function(leaves) {
                    return aggregationFunc(leaves, function(d) { return d.feature.properties[valueField]; });
                })
                .entries(data);
        }

        // Aggregation functions
        const aggregationFunctions = {
            sum: (leaves, accessor) => d3.sum(leaves, accessor),
            max: (leaves, accessor) => d3.max(leaves, accessor),
            min: (leaves, accessor) => d3.min(leaves, accessor),
            mean: (leaves, accessor) => d3.mean(leaves, accessor),
            median: (leaves, accessor) => d3.median(leaves, accessor),
            //mode: (leaves, accessor) => d3.mode(leaves, accessor),
            //cumsum: (leaves, accessor) => d3.cumsum(leaves, accessor),
            //least: (leaves, accessor) => d3.least(leaves, accessor),
            //variance: (leaves, accessor) => d3.variance(leaves, accessor),
            //deviation: (leaves, accessor) => d3.deviation(leaves, accessor),
        };

        // Aggregate Data based on the category `categoryField` and the value `valueField`
        var data = aggregateData(children, categoryField, aggregationFunctions[aggregation], valueField);

        // Calculate full aggregation for centered Text
        var totalAggregation = aggregationFunctions[aggregation](children, function(d) {
          return d.feature.properties[valueField];
        });
        totalAggregation = totalAggregation.toFixed(digits);

        // Make Chart
        html = bakeTheBubbleChart({
            data: data,
            valueFunc: function(d) { return d.values; },
            outerRadius: r,
            innerRadius: r - innerRadius,
            totalAggregation: totalAggregation,
            bubbleClass: 'cluster-bubble',
            bubbleLabelClass: 'clustermarker-cluster-bubble-label',
            pathClassFunc: function(d) {
              return "category-" + d.data.key;
            },
            pathTitleFunc: function(d) {
              return d.data.key + ' (' + d.value + ')';
            }
        });

      } else {
        var data = d3.nest() //Build a dataset for the pie chart
              .key(function(d) { return d.feature.properties[categoryField]; })
              .entries(children, d3.map)

        if (type == "pie") {
          html = bakeThePie({
            data: data,
            valueFunc: function(d) { return d.values.length; },
            outerRadius: r,
            innerRadius: r - innerRadius,
            pieLabel: n,
            pieClass: 'cluster-pie',
            pieLabelClass: 'clustermarker-cluster-pie-label',
            pathClassFunc: function(d) {
              return "category-" + d.data.key;
            },
            pathTitleFunc: function(d) {
              return d.data.key + ' (' + d.data.values.length + ')';
            }
          })
        } else if (type == "horizontal") {
          html = bakeTheBarChartHorizontal({
            data: data,
            width: options.width ? options.width : 70,
            height: options.height ? options.height : 40,
            barLabel: n,
            barClass: 'cluster-bar',
            barLabelClass: 'clustermarker-cluster-bar-label',
            pathClassFunc: function(d) {
              return "category-" + d.key;
            },
            pathTitleFunc: function(d) {
              return d.key + ' (' + d.values.length + ')';
            }
          });
        } else {
          html = bakeTheBarChart({
            data: data,
            width: options.width ? options.width : 70,
            height: options.height ? options.height : 40,
            barLabel: n,
            barClass: 'cluster-bar',
            barLabelClass: 'clustermarker-cluster-bar-label',
            pathClassFunc: function(d) {
              return "category-" + d.key;
            },
            pathTitleFunc: function(d) {
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
      var data = options.data,
        valueFunc = options.valueFunc,
        r = options.outerRadius,
        rInner = options.innerRadius,
        pathClassFunc = options.pathClassFunc,
        pathTitleFunc = options.pathTitleFunc,
        totalAggregation = options.totalAggregation,
        bubbleLabelClass = options.bubbleLabelClass,
        origo = (r + strokeWidth),
        w = origo * 2,
        h = w,
        donut = d3.layout.pie(),
        arc = d3.svg.arc().innerRadius(rInner).outerRadius(r);

    let radius = w;

    let pie = donut
        .padAngle(1 / radius)
        //.sort(null)
        .value(valueFunc);

    var arc = d3.svg.arc()
        .innerRadius(rInner)
        .outerRadius(r);

    // Create SVG
    var svg = document.createElementNS(d3.ns.prefix.svg, 'svg');
    var vis = d3.select(svg)
        .attr("width", w)
        .attr("height", h)

    // Create the Arcs
    var arcs = vis.selectAll('g.arc')
      .data(pie(data))
      .enter().append('svg:g')
      .attr('class', 'arc')
      .attr('transform', 'translate(' + origo + ',' + origo + ')');

    arcs.append('svg:path')
      .attr('class', pathClassFunc)
      .attr('stroke-width', strokeWidth)
      .attr('d', arc)

    // Display the text of each Arc
    arcs.append('text')
        .attr('transform', function(d) {
            return 'translate(' + arc.centroid(d) + ')';
        })
        .attr('class', bubbleLabelClass)
        .attr('text-anchor', 'middle')
        .attr('fill', labelColor)
        .attr('dy','.3em')
        .text(function(d){ return d.data.values.toFixed(digits); })
        .append('svg:title')
        .text(pathTitleFunc);

    // Show Label Background
    if (labelBackground && labelBackground == true) {
      vis.append('circle')
          .attr('r', rInner-5)
          .attr('transform', 'translate(' + origo + ',' + origo + ')')
          .attr('fill', labelFill)
          .attr('stroke', labelStroke)
          .attr('stroke-width', strokeWidth)
          .attr('opacity', labelOpacity)
    }

    // Display the total aggregation in the Center
    vis.append('text')
        .attr('x', origo)
        .attr('y', origo)
        .attr('class', bubbleLabelClass)
        .attr('text-anchor', 'middle')
        .attr('fill', labelColor)
        .attr('stroke', labelStroke)
        .attr('opacity', labelOpacity)
        .attr('stroke-width', strokeWidth)
        .attr('dy', '.3em')
        .text(totalAggregation);

      return serializeXmlNode(svg);
  }
  //function that generates a svg markup for a Pie chart
  function bakeThePie(options) {
      if (!options.data || !options.valueFunc) {
          return '';
      }
      var data = options.data,
          valueFunc = options.valueFunc,
          r = options.outerRadius,
          rInner = options.innerRadius,
          pathClassFunc = options.pathClassFunc,
          pathTitleFunc = options.pathTitleFunc,
          pieClass = options.pieClass,
          pieLabel = options.pieLabel ? options.pieLabel : d3.sum(data, valueFunc),
          pieLabelClass = options.pieLabelClass,
          origo = (r + strokeWidth),
          w = origo * 2,
          h = w,
          donut = d3.layout.pie(),
          arc = d3.svg.arc().innerRadius(rInner).outerRadius(r);

      // Create SVG
      var svg = document.createElementNS(d3.ns.prefix.svg, 'svg');
      var vis = d3.select(svg)
          .data([data])
          .attr('class', pieClass)
          .attr('width', w)
          .attr('height', h);

      // Create the Arcs
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
      pathTitleFunc = function(d) {
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
            .text(allTitles);
      }

      // Text
      vis.append('text')
          .attr('x',origo)
          .attr('y',origo)
          .attr('class', pieLabelClass)
          .attr('text-anchor', 'middle')
          .attr('fill', labelColor)
          .attr('stroke', labelStroke)
          .attr('opacity', labelOpacity)
          .attr('stroke-width', strokeWidth)
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

    // Create svg
    var svg = document.createElementNS(d3.ns.prefix.svg, "svg");
    var vis = d3.select(svg)
        .attr('class', barClass)
        .attr('width', width + strokeWidth)
        .attr('height', height + 20 + strokeWidth);

    // Create Bars
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
          .attr('x', (width - (width - 10)) / 2)
          .attr('y', height + 5)
          .attr('width', width - 10)
          .attr('height', 15)
          .attr('fill', labelFill)
          .attr('stroke', labelStroke)
          .attr('opacity', labelOpacity)
          .attr('stroke-width', strokeWidth)
          .append('svg:title')
          .text(allTitles);
    }

    // Bar Label (below)
    vis.append('text')
        .attr('x', width / 2)
        .attr('y', height + 13)
        .attr('class', barLabelClass)
        .attr('text-anchor', 'middle')
        .attr('fill', labelColor)
        .attr('stroke', labelStroke)
        .attr('opacity', labelOpacity)
        .attr('stroke-width', strokeWidth)
        .attr('dy', '.3em')
        .text(barLabel)
        .append('svg:title')
        .text(allTitles);

    return serializeXmlNode(svg);
  }
  //function that generates a svg markup for a Bar chart (horizontal)
  function bakeTheBarChartHorizontal(options) {
    if (!options.data) {
      return '';
    }
    var data = options.data,
        barClass = options.barClass,
        barLabel = options.barLabel ? options.barLabel : d3.sum(data, function(d) { return d.values.length; }),
        barLabelClass = options.barLabelClass,
        width = options.width,
        height = options.height,
        pathClassFunc = options.pathClassFunc,
        pathTitleFunc = options.pathTitleFunc,
        x = d3.scale.linear().range([0, width]),
        y = d3.scale.ordinal().rangeRoundBands([0, height], 0.1);

    x.domain([0, d3.max(data, function(d) { return d.values.length; })]);
    y.domain(data.map(function(d) { return d.key; }));

    // Create SVG
    var svg = document.createElementNS(d3.ns.prefix.svg, "svg");
    var vis = d3.select(svg)
        .attr('class', barClass)
        .attr('width', width + strokeWidth)
        .attr('height', height + 20 + strokeWidth);

    // Create Bars
    vis.selectAll('.bar')
        .data(data)
        .enter().append('rect')
        .attr('class', pathClassFunc)
        .attr('x', 0)
        .attr('y', function(d) { return y(d.key); })
        .attr('width', function(d) { return x(d.values.length); })
        .attr('height', y.rangeBand())
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
            .attr('x', 0)
            .attr('y', height + 3)
            .attr('width', width)
            .attr('height', 15)
            .attr('fill', labelFill)
            .attr('stroke', labelStroke)
            .attr('opacity', labelOpacity)
            .attr('stroke-width', strokeWidth)
            .append('svg:title')
            .text(allTitles);
    }

    // Bar Label
    vis.append('text')
        .attr('x', width / 2)
        .attr('y', (height + 8))
        .attr('class', barLabelClass)
        .attr('text-anchor', 'middle')
        .attr('dominant-baseline', 'middle')
        .attr('alignment-baseline', 'middle')
        .attr('stroke', labelStroke)
        .attr('opacity', labelOpacity)
        .attr('stroke-width', strokeWidth)
        .attr('dy', '.3em')
        .attr('fill', labelColor)
        .text(barLabel)
        .append('svg:title')
        .text(allTitles);

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
      div.innerHTML = legendOptions.title ? '<div class="legendheading">' + legendOptions.title + '</div>' : '';

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




