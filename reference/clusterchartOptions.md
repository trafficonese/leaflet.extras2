# clusterchartOptions

Adds options for clusterCharts

## Usage

``` r
clusterchartOptions(
  rmax = 30,
  size = c(20, 20),
  width = 40,
  height = 50,
  strokeWidth = 1,
  innerRadius = 10,
  labelBackground = FALSE,
  labelFill = "white",
  labelStroke = "black",
  labelColor = "black",
  labelOpacity = 0.9,
  digits = 2,
  sortTitlebyCount = TRUE
)
```

## Arguments

- rmax:

  The maximum radius of the clusters.

- size:

  The size of the cluster markers.

- width:

  The width of the bar-charts.

- height:

  The height of the bar-charts.

- strokeWidth:

  The stroke width of the chart.

- innerRadius:

  The inner radius of pie-charts.

- labelBackground:

  Should the label have a background? Default is \`FALSE\`

- labelFill:

  The label background color. Default is \`white\`

- labelStroke:

  The label stroke color. Default is \`black\`

- labelColor:

  The label color. Default is \`black\`

- labelOpacity:

  The label color. Default is \`0.9\`

- digits:

  The amount of digits. Default is \`2\`

- sortTitlebyCount:

  Should the svg-title be sorted by count or by the categories.

## See also

Other clusterCharts:
[`addClusterCharts()`](https://trafficonese.github.io/leaflet.extras2/reference/addClusterCharts.md)
