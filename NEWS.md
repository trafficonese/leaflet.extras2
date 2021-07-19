# leaflet.extras2 (development version)

* Included [Leaflet MovingMarkers](https://github.com/ewoken/Leaflet.MovingMarker) plugin
* Included [Leaflet Spin](https://github.com/makinacorpus/Leaflet.Spin) plugin. Thanks to @radbasa
* Included [Labelgun](https://github.com/Geovation/labelgun) plugin.
* `addTimeslider` gained styling options and the arguments `sameDate` and `ordertime` and works for Point / Linestring Simple Feature Collections
* Enable multiple sidebars. Thanks to @jeffreyhanson
* Option `fit` removed for sidebars as plugin CSS/JS was adapted
* Deprecated `menuItem`/`mapmenuItems`/`markermenuItems` and renamed with prefix `context_`. Fixes #10 and #17


# leaflet.extras2 1.1.0

* Included [Leaflet Contextmenu](https://github.com/aratcliffe/Leaflet.contextmenu) plugin
* Included [Leaflet TimeSlider](https://github.com/dwilhelm89/LeafletSlider) plugin
* `addWMS` gained the `layerId` argument and works like `leaflet::addWMSTiles` except for the `popupOptions`
* `Side-by-Side` doesn't propagate click events when dragging. Thanks to `f905a47` of [#23](https://github.com/digidem/leaflet-side-by-side/pull/23) 


# leaflet.extras2 1.0.0

* Initial release
