# Add a Sidebar Leaflet Control

The sidebar HTML must be created with
[`sidebar_tabs`](https://trafficonese.github.io/leaflet.extras2/reference/sidebar_tabs.md)
and
[`sidebar_pane`](https://trafficonese.github.io/leaflet.extras2/reference/sidebar_pane.md)
before
[`leafletOutput`](https://rstudio.github.io/leaflet/reference/map-shiny.html)
is called.

## Usage

``` r
addSidebar(map, id = "sidebar", options = list(position = "left"), ns = NULL)
```

## Arguments

- map:

  A leaflet map widget

- id:

  Id of the sidebar-div. Must match with the `id` of
  [`sidebar_tabs`](https://trafficonese.github.io/leaflet.extras2/reference/sidebar_tabs.md)

- options:

  A named list with the only option `position`, which should be either
  `left` or `right`.

- ns:

  The namespace function, if used in Shiny modules.

## Value

the new `map` object

## References

<https://github.com/Turbo87/sidebar-v2>

## See also

Other Sidebar Functions:
[`closeSidebar()`](https://trafficonese.github.io/leaflet.extras2/reference/closeSidebar.md),
[`openSidebar()`](https://trafficonese.github.io/leaflet.extras2/reference/openSidebar.md),
[`removeSidebar()`](https://trafficonese.github.io/leaflet.extras2/reference/removeSidebar.md),
[`sidebar_pane()`](https://trafficonese.github.io/leaflet.extras2/reference/sidebar_pane.md),
[`sidebar_tabs()`](https://trafficonese.github.io/leaflet.extras2/reference/sidebar_tabs.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(shiny)

# run example app showing a single sidebar
runApp(paste0(
  system.file("examples", package = "leaflet.extras2"),
  "/sidebar_app.R"
))

# run example app showing two sidebars
runApp(paste0(
  system.file("examples", package = "leaflet.extras2"),
  "/multi_sidebar_app.R"
))
} # }
```
