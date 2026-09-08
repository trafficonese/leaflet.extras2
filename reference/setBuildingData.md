# Update the OSM-Buildings Data

Update the OSM-Buildings Data

## Usage

``` r
setBuildingData(map, data)
```

## Arguments

- map:

  A map widget object created from
  [`leaflet`](https://rstudio.github.io/leaflet/reference/leaflet.html).

- data:

  A GeoJSON object containing Polygon features representing the
  buildings. The properties of these polygons can include attributes
  like `height`, `color`, `roofColor`, and others as specified in the
  OSM Buildings documentation.

## See also

Other OSM-Buildings Plugin:
[`addBuildings()`](https://trafficonese.github.io/leaflet.extras2/reference/addBuildings.md),
[`setBuildingStyle()`](https://trafficonese.github.io/leaflet.extras2/reference/setBuildingStyle.md),
[`updateBuildingTime()`](https://trafficonese.github.io/leaflet.extras2/reference/updateBuildingTime.md)
