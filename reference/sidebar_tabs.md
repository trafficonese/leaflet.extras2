# Create a Sidebar

Create a Sidebar

## Usage

``` r
sidebar_tabs(id = "sidebar", iconList = NULL, ...)
```

## Arguments

- id:

  The id of the sidebar, which must match the `id` of
  [`addSidebar`](https://trafficonese.github.io/leaflet.extras2/reference/addSidebar.md).
  Default is `"sidebar"`

- iconList:

  A list of icons to be shown, when the sidebar is collapsed. The list
  is required and must match the amount of
  [`sidebar_pane`](https://trafficonese.github.io/leaflet.extras2/reference/sidebar_pane.md).

- ...:

  The individual
  [`sidebar_pane`](https://trafficonese.github.io/leaflet.extras2/reference/sidebar_pane.md)'s.

## Value

A `shiny.tag` with individual sidebar panes

## References

<https://github.com/Turbo87/sidebar-v2>,
<https://github.com/Turbo87/sidebar-v2/blob/master/doc/usage.md>

## See also

Other Sidebar Functions:
[`addSidebar()`](https://trafficonese.github.io/leaflet.extras2/reference/addSidebar.md),
[`closeSidebar()`](https://trafficonese.github.io/leaflet.extras2/reference/closeSidebar.md),
[`openSidebar()`](https://trafficonese.github.io/leaflet.extras2/reference/openSidebar.md),
[`removeSidebar()`](https://trafficonese.github.io/leaflet.extras2/reference/removeSidebar.md),
[`sidebar_pane()`](https://trafficonese.github.io/leaflet.extras2/reference/sidebar_pane.md)

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
