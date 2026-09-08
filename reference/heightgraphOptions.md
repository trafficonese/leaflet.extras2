# heightgraphOptions

Customize the heightgraph with the following additional options.

## Usage

``` r
heightgraphOptions(
  position = c("bottomright", "topleft", "topright", "bottomleft"),
  width = 800,
  height = 200,
  margins = list(top = 10, right = 30, bottom = 55, left = 50),
  expand = TRUE,
  expandCallback = NULL,
  mappings = NULL,
  highlightStyle = list(color = "red"),
  translation = NULL,
  xTicks = 3,
  yTicks = 3
)
```

## Arguments

- position:

  position of control: "topleft", "topright", "bottomleft", or
  "bottomright". Default is `bottomright`.

- width:

  The width of the expanded heightgraph display in pixels. Default is
  `800`.

- height:

  The height of the expanded heightgraph display in pixels. Default is
  `200`.

- margins:

  The margins define the distance between the border of the heightgraph
  and the actual graph inside. You are able to specify margins for top,
  right, bottom and left in pixels. Default is
  `list(top = 10, right = 30, bottom = 55, left = 50)`.

- expand:

  Boolean value that defines if the heightgraph should be expanded on
  creation. Default is `200`.

- expandCallback:

  Function to be called if the heightgraph is expanded or reduced. The
  state of the heightgraph is passed as an argument. It is `TRUE` when
  expanded and `FALSE` when reduced. Default is `NULL`.

- mappings:

  You may add a mappings object to customize the colors and labels in
  the height graph. Without adding custom mappings the segments and
  labels within the graph will be displayed in random colors. Each key
  of the object must correspond to the `summary` key in `properties`
  within the `FeatureCollection`. Default is `NULL`.

- highlightStyle:

  You can customize the highlight style when using the horizontal line
  to find parts of the route above an elevation value. Use any Leaflet
  Path options as value of the highlightStyle parameter. Default is
  `list(color = "red")`.

- translation:

  You can change the labels of the heightgraph info field by passing
  translations for `distance`, `elevation`, `segment_length`, `type` and
  `legend`. Default is `NULL`.

- xTicks:

  Specify the tick frequency in the x axis of the graph. Corresponds
  approximately to 2 to the power of value ticks. Default is `3`.

- yTicks:

  Specify the tick frequency in the y axis of the graph. Corresponds
  approximately to 2 to the power of value ticks. Default is `3`.

## Value

A list of further options for `addHeightgraph`

## See also

Other Heightgraph Functions:
[`addHeightgraph()`](https://trafficonese.github.io/leaflet.extras2/reference/addHeightgraph.md)
