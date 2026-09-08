# Make Mapkey-icon set

Make Mapkey-icon set

## Usage

``` r
mapkeyIconList(...)
```

## Arguments

- ...:

  icons created from
  [`makeMapkeyIcon()`](https://trafficonese.github.io/leaflet.extras2/reference/makeMapkeyIcon.md)

## Value

A list of class `"leaflet_mapkey_icon_set"`

## References

<https://github.com/mapshakers/leaflet-mapkey-icon>

## See also

Other Mapkey Functions:
[`[.leaflet_mapkey_icon_set()`](https://trafficonese.github.io/leaflet.extras2/reference/sub-.leaflet_mapkey_icon_set.md),
[`addMapkeyMarkers()`](https://trafficonese.github.io/leaflet.extras2/reference/addMapkeyMarkers.md),
[`makeMapkeyIcon()`](https://trafficonese.github.io/leaflet.extras2/reference/makeMapkeyIcon.md),
[`mapkeyIcons()`](https://trafficonese.github.io/leaflet.extras2/reference/mapkeyIcons.md)

## Examples

``` r
iconSet <- mapkeyIconList(
  red = makeMapkeyIcon(color = "#ff0000"),
  blue = makeMapkeyIcon(color = "#0000ff")
)
iconSet[c("red", "blue")]
#> $red
#> $icon
#> [1] "mapkey"
#> 
#> $color
#> [1] "#ff0000"
#> 
#> $size
#> [1] 12
#> 
#> $background
#> [1] "#1F7499"
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
#> [1] TRUE
#> 
#> attr(,"class")
#> [1] "leaflet_mapkey_icon"
#> 
#> $blue
#> $icon
#> [1] "mapkey"
#> 
#> $color
#> [1] "#0000ff"
#> 
#> $size
#> [1] 12
#> 
#> $background
#> [1] "#1F7499"
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
#> [1] TRUE
#> 
#> attr(,"class")
#> [1] "leaflet_mapkey_icon"
#> 
#> attr(,"class")
#> [1] "leaflet_mapkey_icon_set"
```
