# velocityOptions

Define further options for the velocity layer.

## Usage

``` r
velocityOptions(
  speedUnit = c("m/s", "k/h", "kt"),
  minVelocity = 0,
  maxVelocity = 10,
  velocityScale = 0.005,
  colorScale = NULL,
  ...
)
```

## Arguments

- speedUnit:

  Could be 'm/s' for meter per second, 'k/h' for kilometer per hour or
  'kt' for knots

- minVelocity:

  velocity at which particle intensity is minimum

- maxVelocity:

  velocity at which particle intensity is maximum

- velocityScale:

  scale for wind velocity

- colorScale:

  A vector of hex colors or an RGB matrix

- ...:

  Further arguments passed to the Velocity layer and Windy.js. For more
  information, please visit [leaflet-velocity
  plugin](https://github.com/onaci/leaflet-velocity)

## Value

A list of further options for `addVelocity`

## See also

Other Velocity Functions:
[`addVelocity()`](https://trafficonese.github.io/leaflet.extras2/reference/addVelocity.md),
[`removeVelocity()`](https://trafficonese.github.io/leaflet.extras2/reference/removeVelocity.md),
[`setOptionsVelocity()`](https://trafficonese.github.io/leaflet.extras2/reference/setOptionsVelocity.md)
