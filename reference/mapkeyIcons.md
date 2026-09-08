# Create a list of Mapkey icon data

An icon can be represented as a list of the form
`list(color, iconSize, ...)`. This function is vectorized over its
arguments to create a list of icon data. Shorter argument values will be
re-cycled. `NULL` values for these arguments will be ignored.

## Usage

``` r
mapkeyIcons(
  icon = "mapkey",
  color = "#ff0000",
  iconSize = 12,
  background = "#1F7499",
  borderRadius = "100%",
  hoverScale = 1.4,
  hoverEffect = TRUE,
  hoverCSS = NULL,
  additionalCSS = NULL,
  htmlCode = NULL,
  boxShadow = TRUE
)
```

## Arguments

- icon:

  ID of the mapkey Icon you want to use.

- color:

  Any CSS color (e.g. 'red','rgba(20,160,90,0.5)', '#686868', ...)

- iconSize:

  Size of Icon in Pixels. Default is 12

- background:

  Any CSS color or false for no background

- borderRadius:

  Any number (for circle size/2, for square 0.001)

- hoverScale:

  Any real number (best result in range 1 - 2, use 1 for no effect)

- hoverEffect:

  Switch on/off effect on hover

- hoverCSS:

  CSS code (e.g.
  `"background-color:#992b00 !important; color:#99defc !important;"`)

- additionalCSS:

  CSS code (e.g. `"border:4px solid #aa3838;"`)

- htmlCode:

  e.g. `'&#57347;&#xe003;'`.

- boxShadow:

  Should a shadow be visible

## Value

A list of mapkey-icon data that can be passed to the argument `icon`

## References

<https://github.com/mapshakers/leaflet-mapkey-icon>

## See also

Other Mapkey Functions:
[`[.leaflet_mapkey_icon_set()`](https://trafficonese.github.io/leaflet.extras2/reference/sub-.leaflet_mapkey_icon_set.md),
[`addMapkeyMarkers()`](https://trafficonese.github.io/leaflet.extras2/reference/addMapkeyMarkers.md),
[`makeMapkeyIcon()`](https://trafficonese.github.io/leaflet.extras2/reference/makeMapkeyIcon.md),
[`mapkeyIconList()`](https://trafficonese.github.io/leaflet.extras2/reference/mapkeyIconList.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(leaflet)
leaflet() %>%
  addMapkeyMarkers(
    data = breweries91,
    icon = mapkeyIcons(
      color = "red",
      borderRadius = 0,
      iconSize = 25
    )
  )
} # }
```
