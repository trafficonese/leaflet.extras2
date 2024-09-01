# leaflet.extras2 (development version)

* Included [OSM Buildings](https://osmbuildings.org/documentation/leaflet/) plugin
* Fix for roxygen2 > 7.0.0. #1491
* The opened sidebar tab is returned as Shiny input using the `sidebar_tabs` ID.
* allow `...` in `antpathOptions` to be able to set the pane (e.g.: `renderer= JS('L.svg({pane: "my-pane"})')`)

# leaflet.extras2 1.2.2

* Added `enableContextmenu` and `disableContextmenu`
* Fixed tests for leaflet v2.2.0. Thanks to @gadenbuie (#60)

# leaflet.extras2 1.2.1

* Bugfix when Sidebar is used inside Shiny modules. The sidebar functions `addSidebar` and `openSidebar` now have an argument `ns`, where Shiny's namespacing function (e.g: session$ns) can be included.
* Arrowheads now passes all options in `arrowheadOptions` to `L.polyline`
* Update `leaflet.heightgraph` to [1.3.2](https://github.com/GIScience/Leaflet.Heightgraph/releases/tag/v1.3.2). Has no dependency to `d3` anymore.
* Skip tests which use an internet connection
* Adapted URLs and deleted old Mapkey URL

# leaflet.extras2 1.2.0

* Included [Arrowheads](https://github.com/slutske22/leaflet-arrowheads) plugin
* Included [Leaflet.Sync](https://github.com/jieter/Leaflet.Sync) plugin
* Included [Leaflet MovingMarkers](https://github.com/ewoken/Leaflet.MovingMarker) plugin
* Included [Leaflet Spin](https://github.com/makinacorpus/Leaflet.Spin) plugin. Thanks to @radbasa
* Included [Labelgun](https://github.com/Geovation/labelgun) plugin.
* `addTimeslider` gained styling options and the arguments `label`, `labelOptions`, `sameDate` and `ordertime` and works for Point / Linestring Simple Feature Collections
* Enable multiple sidebars. Thanks to @jeffreyhanson
* Option `fit` removed for sidebars as plugin CSS/JS was adapted
* Deprecated `menuItem`/`mapmenuItems`/`markermenuItems` and renamed with prefix `context_`. Fixes #10 and #17
* Some improvement for the `easyprint` plugin: (Fixes #31)
  - It is now possible to include multiple custom `sizeModes` in `easyprintOptions`. The example [easyprint_app.R](./inst/examples/easyprint_app.R) has been extended to demonstrate the new functionalities. 
  - The `tileLayer` option now accepts a group name for a tilelayer for which printing will wait until the layer is fully loaded.
* The `addPlayback` is now capable of displaying labels and popups for every timestep. The transition of labels and popups can be controlled with `transitionpopup` and `transitionlabel`.
* The function `addHistory` now requires the *fontawesome* package, since the dependency is not included in shiny's shared directory anymore.
* The function `addWMS` gained the argument `checkempty`, which will check the returning HTML-body tag. If the body is empty, no popup is opened.
* The function `addMovingMarker` now accepts icons created by `makeAwesomeIcon`.

# leaflet.extras2 1.1.0

* Included [Leaflet Contextmenu](https://github.com/aratcliffe/Leaflet.contextmenu) plugin
* Included [Leaflet TimeSlider](https://github.com/dwilhelm89/LeafletSlider) plugin
* `addWMS` gained the `layerId` argument and works like `leaflet::addWMSTiles` except for the `popupOptions`
* `Side-by-Side` doesn't propagate click events when dragging. Thanks to `f905a47` of [#23](https://github.com/digidem/leaflet-side-by-side/pull/23) 


# leaflet.extras2 1.0.0

* Initial release
