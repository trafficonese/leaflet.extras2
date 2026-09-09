## Test environments

* local Windows 11, R 4.4.0 Patched
* GitHub Actions (R-CMD-check)
* win-builder (R-devel)

## R CMD check results (`devtools::check(remote = TRUE, manual = TRUE)`)

0 errors | 0 warnings | 0 notes

`urlchecker::url_check()` is clean after updating the Leaflet.Geosearch
docs URL to https://leaflet-geosearch.meijer.works/.


## Comments

This is a minor release (1.3.3) with bug fixes and a few new helpers:

* `spinWhile()` keeps the map spinner visible around Shiny server work (#48).
* Sidebar no longer steals Selectize clicks or Firefox wheel events (#78, #66).
* `addWMS()` hides attribution with the layer group, can send custom headers
  (#54), follows same-host HTTP→HTTPS GetFeatureInfo redirects (#14), and
  `setWMSParams()` updates WMS parameters via `leafletProxy()` (#52).
* `addEasyprint()` custom `sizeModes` no longer need extra CSS.
* Tests no longer use deprecated `structure(..., .Label = )` (R-devel NOTE).
