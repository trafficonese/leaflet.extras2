# Make Mapkey Icon

Make Mapkey Icon

## Usage

``` r
makeMapkeyIcon(
  icon = "mapkey",
  color = "#ff0000",
  iconSize = 12,
  background = "#1F7499",
  borderRadius = "100%",
  hoverScale = 1.4,
  hoverEffect = TRUE,
  additionalCSS = NULL,
  hoverCSS = NULL,
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

- additionalCSS:

  CSS code (e.g. `"border:4px solid #aa3838;"`)

- hoverCSS:

  CSS code (e.g.
  `"background-color:#992b00 !important; color:#99defc !important;"`)

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
[`mapkeyIconList()`](https://trafficonese.github.io/leaflet.extras2/reference/mapkeyIconList.md),
[`mapkeyIcons()`](https://trafficonese.github.io/leaflet.extras2/reference/mapkeyIcons.md)

## Examples

``` r
makeMapkeyIcon(
  icon = "traffic_signal",
  color = "#0000ff",
  iconSize = 12,
  boxShadow = FALSE,
  background = "transparent"
)
#> $icon
#> [1] "traffic_signal"
#> 
#> $color
#> [1] "#0000ff"
#> 
#> $size
#> [1] 12
#> 
#> $background
#> [1] "transparent"
#> 
#> $borderRadius
#> [1] "100%"
#> 
#> $hoverScale
#> [1] 1.4
#> 
#> $hoverEffect
#> [1] TRUE
#> 
#> $boxShadow
#> [1] FALSE
#> 
#> attr(,"class")
#> [1] "leaflet_mapkey_icon"
```
