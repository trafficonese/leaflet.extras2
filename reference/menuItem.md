# menuItem

menuItem

## Usage

``` r
menuItem(text, callback = NULL, ...)
```

## Arguments

- text:

  The label to use for the menu item

- callback:

  A callback function to be invoked when the menu item is clicked. The
  callback is passed an object with properties identifying the location
  the menu was opened at: `latlng`, `layerPoint` and `containerPoint`.
  The callback-function must be valid JavaScript and will be wrapped in
  [`JS`](https://rdrr.io/pkg/htmlwidgets/man/JS.html).

- ...:

  For further options please visit
  <https://github.com/aratcliffe/Leaflet.contextmenu>

## Value

A contextmenu item list

## See also

Other Contextmenu Functions:
[`addContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/addContextmenu.md),
[`addItemContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/addItemContextmenu.md),
[`context_mapmenuItems()`](https://trafficonese.github.io/leaflet.extras2/reference/context_mapmenuItems.md),
[`context_markermenuItems()`](https://trafficonese.github.io/leaflet.extras2/reference/context_markermenuItems.md),
[`context_menuItem()`](https://trafficonese.github.io/leaflet.extras2/reference/context_menuItem.md),
[`disableContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/disableContextmenu.md),
[`enableContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/enableContextmenu.md),
[`hideContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/hideContextmenu.md),
[`insertItemContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/insertItemContextmenu.md),
[`mapmenuItems()`](https://trafficonese.github.io/leaflet.extras2/reference/mapmenuItems.md),
[`markermenuItems()`](https://trafficonese.github.io/leaflet.extras2/reference/markermenuItems.md),
[`removeItemContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/removeItemContextmenu.md),
[`removeallItemsContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/removeallItemsContextmenu.md),
[`setDisabledContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/setDisabledContextmenu.md),
[`showContextmenu()`](https://trafficonese.github.io/leaflet.extras2/reference/showContextmenu.md)
