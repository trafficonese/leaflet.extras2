# playbackOptions

A list of options for
[`addPlayback`](https://trafficonese.github.io/leaflet.extras2/reference/addPlayback.md).
For a full list please visit the [plugin
repository](https://github.com/hallahan/LeafletPlayback).

## Usage

``` r
playbackOptions(
  color = "blue",
  radius = 5,
  tickLen = 250,
  speed = 50,
  maxInterpolationTime = 5 * 60 * 1000,
  tracksLayer = TRUE,
  playControl = TRUE,
  dateControl = TRUE,
  sliderControl = TRUE,
  orientIcons = FALSE,
  staleTime = 60 * 60 * 1000,
  transitionpopup = TRUE,
  transitionlabel = TRUE,
  ...
)
```

## Arguments

- color:

  colors of the CircleMarkers.

- radius:

  a numeric value for the radius of the CircleMarkers.

- tickLen:

  Set tick length in milliseconds. Increasing this value, may improve
  performance, at the cost of animation smoothness. Default is 250

- speed:

  Set float multiplier for default animation speed. Default is 50

- maxInterpolationTime:

  Set max interpolation time in milliseconds. Default is 5\*60\*1000 (5
  minutes).

- tracksLayer:

  Set `TRUE` if you want to show layer control on the map. Default is
  `TRUE`

- playControl:

  Set `TRUE` if play button is needed. Default is `TRUE`

- dateControl:

  Set `TRUE` if date label is needed. Default is `TRUE`

- sliderControl:

  Set `TRUE` if slider control is needed. Default is `TRUE`

- orientIcons:

  Set `TRUE` if you want icons to orient themselves on each tick based
  on the bearing towards their next location. Default: `FALSE`

- staleTime:

  Set time before a track is considered stale and faded out. Default is
  60\*60\*1000 (1 hour)

- transitionpopup:

  Should the position of the popup move smoothly, like the marker icon?
  Default: `TRUE`

- transitionlabel:

  Should the position of the label move smoothly, like the marker icon?
  Default: `TRUE`

- ...:

  Further arguments passed to \`L.Playback\`

## Value

A list of options for `addPlayback`

## References

<https://github.com/hallahan/LeafletPlayback>

## See also

Other Playback Functions:
[`addPlayback()`](https://trafficonese.github.io/leaflet.extras2/reference/addPlayback.md),
[`removePlayback()`](https://trafficonese.github.io/leaflet.extras2/reference/removePlayback.md)
