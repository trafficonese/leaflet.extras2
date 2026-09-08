# Arrowhead Options

Additional list of options for polylines with arrowheads. You can also
pass options inherited from
[L.Path](https://leafletjs.com/reference.html#path)

## Usage

``` r
arrowheadOptions(
  yawn = 60,
  size = "15%",
  frequency = "allvertices",
  proportionalToTotal = FALSE,
  offsets = NULL,
  perArrowheadOptions = NULL,
  ...
)
```

## Arguments

- yawn:

  Defines the width of the opening of the arrowhead, given in degrees.
  The larger the angle, the wider the arrowhead.

- size:

  Determines the size of the arrowhead. Accepts three types of values:

  - A string with the suffix `'m'`, i.e. `'500m'` will set the size of
    the arrowhead to that number of meters.

  - A string with the suffix `'%'`, i.e. `'15%'` will render arrows
    whose size is that percentage of the size of the parent polyline. If
    the polyline has multiple segments, it will take the percent of the
    average size of the segments.

  - A string the suffix `'px'`, i.e. `'20px'` will render an arrowhead
    whose size stays at a constant pixel value, regardless of zoom
    level. Will look strange at low zoom levels or for smaller parent
    vectors. Ideal for larger parent vectors and at higher zoom levels.

- frequency:

  How many arrowheads are rendered on a polyline.

  - `'allvertices'` renders an arrowhead on each vertex.

  - `'endonly'` renders only one at the end.

  - A numeric value renders that number of arrowheads evenly spaced
    along the polyline.

  - A string with suffix `'m'`, i.e. `'100m'` will render arrowheads
    spaced evenly along the polyline with roughly that many meters
    between each one.

  - A string with suffix `'px'`, i.e. `'30px'` will render arrowheads
    spaced evenly with roughly that many pixels between each, regardless
    of zoom level.

- proportionalToTotal:

  Only relevant when size is given as a percent. Useful when frequency
  is set to `'endonly'`. Will render the arrowheads with a size
  proportional to the entire length of the multi-segmented polyline,
  rather than proportional to the average length of all the segments.

- offsets:

  Enables the developer to have the arrowheads start or end at some
  offset from the start and/or end of the polyline. This option can be a
  list with \`start\` and \`end\` names. The values must be strings
  defining the size of the offset in either meters or pixels, i.e.
  `list('start' = '100m', 'end' = '15px')`.

- perArrowheadOptions:

  Enables the developer to customize arrowheads on a one-by-one basis.
  Must be in the form of a function of i, which is the index of the
  arrowhead as it is rendered in the loop through all arrowheads. Must
  return an options object. Cannnot account for `frequency` or
  `proportionalToTotal` from within the `perArrowheadOptions` callback.
  See the example for details.

- ...:

  Additional options for arrowheads, inherited from
  [L.Path](https://leafletjs.com/reference.html#path)

## Value

A list of options for `addArrowhead` polylines

## References

<https://github.com/slutske22/leaflet-arrowheads#options>

## See also

Other Arrowhead Functions:
[`addArrowhead()`](https://trafficonese.github.io/leaflet.extras2/reference/addArrowhead.md),
[`clearArrowhead()`](https://trafficonese.github.io/leaflet.extras2/reference/clearArrowhead.md),
[`removeArrowhead()`](https://trafficonese.github.io/leaflet.extras2/reference/removeArrowhead.md)
