# hexbinOptions

A list of options for customizing the appearance/behavior of the hexbin
layer.

## Usage

``` r
hexbinOptions(
  duration = 200,
  colorScaleExtent = NULL,
  radiusScaleExtent = NULL,
  colorRange = c("#f7fbff", "#08306b"),
  radiusRange = c(5, 15),
  pointerEvents = "all",
  resizetoCount = FALSE,
  tooltip = "Count "
)
```

## Arguments

- duration:

  Transition duration for the hexbin layer

- colorScaleExtent:

  extent of the color scale for the hexbin layer. This is used to
  override the derived extent of the color values and is specified as a
  vector of the form c(min= numeric, max= numeric). Can be a numeric
  vector or a custom [`JS`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
  array, like (`JS("[40, undefined]")`)

- radiusScaleExtent:

  This is the same exact configuration option as colorScaleExtent, only
  applied to the radius extent.

- colorRange:

  Sets the range of the color scale used to fill the hexbins on the
  layer.

- radiusRange:

  Sets the range of the radius scale used to size the hexbins on the
  layer.

- pointerEvents:

  This value is passed directly to an element-level css style for
  pointer-events. You should only modify this config option if you want
  to change the mouse event behavior on hexbins. This will modify when
  the events are propagated based on the visibility state and/or part of
  the hexbin being hovered.

- resizetoCount:

  Resizes the hexbin to the count. Default is `FALSE`. If set to `TRUE`
  it will resize based on the amount of underlying elements. You can
  also pass a custom [`JS`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
  function.

- tooltip:

  Should tooltips be displayed? If set to `TRUE`, it will show the
  amount of underlying elements. If a string is given, it will append
  the string before the count. To disable tooltips, please pass `NULL`
  or `FALSE`. You can also pass a custom
  [`JS`](https://rdrr.io/pkg/htmlwidgets/man/JS.html) function.

## Value

A list of hexbin-specific options

## See also

Other Hexbin-D3 Functions:
[`addHexbin()`](https://trafficonese.github.io/leaflet.extras2/reference/addHexbin.md),
[`clearHexbin()`](https://trafficonese.github.io/leaflet.extras2/reference/clearHexbin.md),
[`hideHexbin()`](https://trafficonese.github.io/leaflet.extras2/reference/hideHexbin.md),
[`showHexbin()`](https://trafficonese.github.io/leaflet.extras2/reference/showHexbin.md),
[`updateHexbin()`](https://trafficonese.github.io/leaflet.extras2/reference/updateHexbin.md)
