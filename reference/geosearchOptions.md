# geosearchOptions

Add extra options. For a full list please visit the [plugin
repository](https://leaflet-geosearch.meijer.works/) or see the [source
code](https://github.com/smeijer/leaflet-geosearch/blob/main/src/SearchControl.ts#L23)

## Usage

``` r
geosearchOptions(
  style = c("button", "bar"),
  resetButton = "x",
  notFoundMessage = "Nothing found",
  autoComplete = TRUE,
  autoCompleteDelay = 250,
  showMarker = TRUE,
  showPopup = FALSE,
  maxMarkers = 1,
  retainZoomLevel = FALSE,
  animateZoom = TRUE,
  autoClose = FALSE,
  searchLabel = "Enter address",
  keepResult = FALSE,
  updateMap = TRUE,
  ...
)
```

## Arguments

- style:

  Character. UI style, one of "bar" or "button".

- resetButton:

  Icon or Character for the reset button.

- notFoundMessage:

  Message shown if no result is found.

- autoComplete:

  Logical. Enable autocomplete suggestions.

- autoCompleteDelay:

  Delay in ms before suggestions appear.

- showMarker:

  Logical. Show marker for result location.

- showPopup:

  Logical. Show popup on result location.

- maxMarkers:

  Max number of markers shown.

- retainZoomLevel:

  Logical.

- animateZoom:

  Logical.

- autoClose:

  Logical. Close results after selection.

- searchLabel:

  Placeholder text.

- keepResult:

  Logical. Keep last result shown.

- updateMap:

  Logical. Pan/zoom map on result.

- ...:

  Further arguments passed to \`addGeosearch\`

## Value

A list of options for `addGeosearch`

## See also

Other Geosearch Functions:
[`addGeosearch()`](https://trafficonese.github.io/leaflet.extras2/reference/addGeosearch.md),
[`removeGeosearch()`](https://trafficonese.github.io/leaflet.extras2/reference/removeGeosearch.md)
