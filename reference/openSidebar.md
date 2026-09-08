# Open the Sidebar by ID

Open the Sidebar by ID

## Usage

``` r
openSidebar(map, id, sidebar_id = NULL, ns = NULL)
```

## Arguments

- map:

  A leaflet map widget

- id:

  The id of the
  [`sidebar_pane`](https://trafficonese.github.io/leaflet.extras2/reference/sidebar_pane.md)
  to open.

- sidebar_id:

  The id of the sidebar (per
  [`sidebar_tabs`](https://trafficonese.github.io/leaflet.extras2/reference/sidebar_tabs.md)).
  Defaults to `NULL` such that the first sidebar is used.

- ns:

  The namespace function, if used in Shiny modules.

## Value

the new `map` object

## See also

Other Sidebar Functions:
[`addSidebar()`](https://trafficonese.github.io/leaflet.extras2/reference/addSidebar.md),
[`closeSidebar()`](https://trafficonese.github.io/leaflet.extras2/reference/closeSidebar.md),
[`removeSidebar()`](https://trafficonese.github.io/leaflet.extras2/reference/removeSidebar.md),
[`sidebar_pane()`](https://trafficonese.github.io/leaflet.extras2/reference/sidebar_pane.md),
[`sidebar_tabs()`](https://trafficonese.github.io/leaflet.extras2/reference/sidebar_tabs.md)
