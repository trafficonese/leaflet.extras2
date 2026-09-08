# Antpath Options

Additional list of options for 'ant-path' animated polylines.

## Usage

``` r
antpathOptions(
  delay = 400,
  paused = FALSE,
  reverse = FALSE,
  hardwareAccelerated = FALSE,
  dashArray = c(10, 20),
  pulseColor = "#ffffff",
  lineCap = NULL,
  lineJoin = NULL,
  interactive = TRUE,
  pointerEvents = NULL,
  className = "",
  ...
)
```

## Arguments

- delay:

  Add a delay to the animation flux. Default is `400`

- paused:

  Should the animation be paused. Default is `FALSE`

- reverse:

  Defines if the flow follows the path order or not. Default is `FALSE`

- hardwareAccelerated:

  Makes the animation run with hardware acceleration. Default is `FALSE`

- dashArray:

  The size of the animated dashes. Default is `c(10, 20)`

- pulseColor:

  Adds a color to the dashed flux. Default is `#ffffff`

- lineCap:

  a string that defines [shape to be used at the
  end](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-linecap)
  of the stroke.

- lineJoin:

  a string that defines [shape to be used at the
  corners](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-linejoin)
  of the stroke.

- interactive:

  whether the element emits mouse events

- pointerEvents:

  sets the `pointer-events` attribute on the path if SVG backend is used

- className:

  a CSS class name set on an element

- ...:

  extra options passed to underlying JavaScript object constructor.

## Value

A list of options for `addAntpath` animated polylines

## See also

Other Antpath Functions:
[`addAntpath()`](https://trafficonese.github.io/leaflet.extras2/reference/addAntpath.md),
[`clearAntpath()`](https://trafficonese.github.io/leaflet.extras2/reference/clearAntpath.md),
[`removeAntpath()`](https://trafficonese.github.io/leaflet.extras2/reference/removeAntpath.md)
