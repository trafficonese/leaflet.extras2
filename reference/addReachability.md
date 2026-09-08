# Add Isochrones to Leaflet

A leaflet plugin which shows areas of reachability based on time or
distance for different modes of travel using the openrouteservice
isochrones API. Based on the [leaflet.reachability
plugin](https://github.com/traffordDataLab/leaflet.reachability)

## Usage

``` r
addReachability(map, apikey = NULL, options = reachabilityOptions())
```

## Arguments

- map:

  a map widget

- apikey:

  a valid Openrouteservice API-key. Can be obtained from
  [Openrouteservice](https://openrouteservice.org/dev/#/signup)

- options:

  A list of further options. See
  [`reachabilityOptions`](https://trafficonese.github.io/leaflet.extras2/reference/reachabilityOptions.md)

## Value

the new `map` object

## Note

When used in Shiny, 3 events update a certain shiny Input:

1.  reachability:displayed updates `input$MAPID_reachability_displayed`

2.  reachability:delete updates `input$MAPID_reachability_delete`

3.  reachability:error updates `input$MAPID_reachability_error`

## References

<https://github.com/traffordDataLab/leaflet.reachability>

## See also

Other Reachability Functions:
[`reachabilityOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/reachabilityOptions.md),
[`removeReachability()`](https://trafficonese.github.io/leaflet.extras2/reference/removeReachability.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(leaflet)
library(leaflet.extras2)

Sys.setenv("OPRS" = "Your_API_Key")

leaflet() %>%
  addTiles() %>%
  setView(8, 50, 10) %>%
  addReachability()
} # }
```
