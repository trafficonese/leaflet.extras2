## Test environments

* local Windows 11, R 4.4.0 Patched
* GitHub Actions (R-CMD-check)
* win-builder (R-devel)

## R CMD check results (`devtools::check(remote = TRUE, manual = TRUE)`)

0 errors | 0 warnings | 0 notes

`urlchecker::url_check()` is clean after updating the Leaflet.Geosearch
docs URL to https://leaflet-geosearch.meijer.works/.


## Comments

This is a patch that removes grDevices from the Imports
