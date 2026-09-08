# easyprintOptions

Create a list of further options for the easyprint plugin.

## Usage

``` r
easyprintOptions(
  title = "Print map",
  position = "topleft",
  sizeModes = list("A4Portrait", "A4Landscape", "CurrentSize"),
  defaultSizeTitles = NULL,
  exportOnly = FALSE,
  tileLayer = NULL,
  tileWait = 500,
  filename = "map",
  hidden = FALSE,
  hideControlContainer = TRUE,
  hideClasses = NULL,
  customWindowTitle = NULL,
  spinnerBgColor = "#0DC5C1",
  customSpinnerClass = "epLoader"
)
```

## Arguments

- title:

  Sets the text which appears as the tooltip of the print/export button

- position:

  Positions the print button

- sizeModes:

  Either a character vector with one of the following options:
  `CurrentSize`, `A4Portrait`, `A4Landscape`. Custom pixel sizes can be
  mixed in as lists with `width` and `height` (and optionally `name` /
  `className`):
  `list("CurrentSize", list(width = 3000, height = 1800, name = "High res"))`.
  `CurrentSize` exports at the current map widget size (often low
  resolution in Quarto/HTML documents). A custom size resizes the map
  before export. By default `keepView = TRUE`: the current view is kept
  (zoom in, same aspect ratio; the PNG may be smaller than
  `width`/`height` on one side). Use `keepView = FALSE` to keep the zoom
  level and show a larger area, like A4.
  `list(scale = 3, name = "3x current view")` multiplies the current
  widget size and keeps the exact view. A custom `className` and CSS
  background-image are optional; see `./inst/examples/easyprint.R` and
  `./inst/examples/easyprint_app.R`.

- defaultSizeTitles:

  Button tooltips for the default page sizes

- exportOnly:

  If set to `TRUE` the map is exported to a .png file

- tileLayer:

  The group name of one tile layer that you can wait for to draw
  (helpful when resizing to a custom size)

- tileWait:

  How long to wait for the tiles to draw (helpful when resizing). Custom
  sizes always wait at least this long so tiles can reload.

- filename:

  Name of the file if `exportOnly` option is `TRUE`

- hidden:

  Set to `TRUE` if you don't want to display the toolbar. Instead you
  can create your own buttons or fire print events programmatically.

- hideControlContainer:

  Hides the leaflet controls like the zoom buttons and the attribution
  on the print out

- hideClasses:

  Use a character vector or list of CSS-classes to hide on the output
  image.

- customWindowTitle:

  A title for the print window which will get added to the printed paper

- spinnerBgColor:

  A valid css colour for the spinner background color

- customSpinnerClass:

  A class for a custom css spinner to use while waiting for the print.

## Value

A list of options for the 'easyprint' control

## References

<https://github.com/rowanwins/leaflet-easyPrint>

## See also

Other EasyPrint Functions:
[`addEasyprint()`](https://trafficonese.github.io/leaflet.extras2/reference/addEasyprint.md),
[`easyprintMap()`](https://trafficonese.github.io/leaflet.extras2/reference/easyprintMap.md),
[`removeEasyprint()`](https://trafficonese.github.io/leaflet.extras2/reference/removeEasyprint.md)
