# timesliderOptions

A list of options for
[`addTimeslider`](https://trafficonese.github.io/leaflet.extras2/reference/addTimeslider.md).

## Usage

``` r
timesliderOptions(
  position = c("topright", "bottomleft", "bottomright", "topleft"),
  timeAttribute = "time",
  isEpoch = FALSE,
  startTimeIdx = 0,
  timeStrLength = 19,
  maxValue = -1,
  minValue = 0,
  showAllOnStart = FALSE,
  range = FALSE,
  follow = FALSE,
  alwaysShowDate = FALSE,
  rezoom = NULL,
  sameDate = FALSE
)
```

## Arguments

- position:

  position of control: "topleft", "topright", "bottomleft", or
  "bottomright". Default is `topright`.

- timeAttribute:

  The column name of the time property. Default is `"time"`

- isEpoch:

  whether the time attribute is seconds elapsed from epoch. Default is
  `FALSE`

- startTimeIdx:

  where to start looking for a timestring Default is `0`

- timeStrLength:

  the size of `yyyy-mm-dd hh:mm:ss` - if milliseconds are present this
  will be larger. Default is `19`

- maxValue:

  Set the maximum value of the slider. Default is `-1`

- minValue:

  Set the minimum value of the slider. Default is `0`

- showAllOnStart:

  Specify whether all markers should be initially visible. Default is
  `FALSE`

- range:

  To use a range-slider, set to `TRUE.` Default is `FALSE` Default is
  `FALSE`

- follow:

  To display only the markers at the specific timestamp specified by the
  slider. Specify a value of 1 (or true) to display only a single data
  point at a time, and a value of null (or false) to display the current
  marker and all previous markers. The range property overrides the
  follow property. Default is `FALSE`

- alwaysShowDate:

  Should the Date always be visible. Default is `FALSE`

- rezoom:

  Use the rezoom property to ensure the markers being displayed remain
  in view. Default is `NULL`

- sameDate:

  Show only data with the current selected time. Default is `FALSE`

## Value

A list of options for `addTimeslider`

## References

<https://github.com/dwilhelm89/LeafletSlider>

## See also

Other Timeslider Functions:
[`addTimeslider()`](https://trafficonese.github.io/leaflet.extras2/reference/addTimeslider.md),
[`removeTimeslider()`](https://trafficonese.github.io/leaflet.extras2/reference/removeTimeslider.md)
