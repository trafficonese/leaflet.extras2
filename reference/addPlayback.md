# Add Playback to Leaflet

The [LeafletPlayback
plugin](https://github.com/hallahan/LeafletPlayback) provides the
ability to replay GPS Points in the form of POINT Simple Features.
Rather than simply animating a marker along a polyline, the speed of the
animation is synchronized to a clock. The playback functionality is
similar to a video player; you can start and stop playback or change the
playback speed.

## Usage

``` r
addPlayback(
  map,
  data,
  time = "time",
  icon = NULL,
  pathOpts = pathOptions(),
  popup = NULL,
  label = NULL,
  popupOptions = NULL,
  labelOptions = NULL,
  options = playbackOptions(),
  name = NULL
)
```

## Arguments

- map:

  a map widget

- data:

  data must be a POINT Simple Feature or a list of POINT Simple
  Feature's with a time column.

- time:

  The column name of the time column. Default is `"time"`.

- icon:

  an icon which can be created with
  [`makeIcon`](https://rstudio.github.io/leaflet/reference/makeIcon.html)

- pathOpts:

  style the CircleMarkers with
  [`pathOptions`](https://rstudio.github.io/leaflet/reference/map-options.html)

- popup:

  A formula with the column names for the popup content

- label:

  A formula with the column names for the label content

- popupOptions:

  A Vector of
  [`popupOptions()`](https://rstudio.github.io/leaflet/reference/map-options.html)
  to provide popups

- labelOptions:

  A Vector of
  [`labelOptions()`](https://rstudio.github.io/leaflet/reference/map-options.html)
  to provide label options for each label. Default `NULL`

- options:

  List of additional options. See
  [`playbackOptions`](https://trafficonese.github.io/leaflet.extras2/reference/playbackOptions.md)

- name:

  A formula with the column names for the feature name

## Value

the new `map` object

## Note

If used in Shiny, you can listen to 2 events

- \`map-ID\`+"\_pb_mouseover"

- \`map-ID\`+"\_pb_click"

## References

<https://github.com/hallahan/LeafletPlayback>

## See also

Other Playback Functions:
[`playbackOptions()`](https://trafficonese.github.io/leaflet.extras2/reference/playbackOptions.md),
[`removePlayback()`](https://trafficonese.github.io/leaflet.extras2/reference/removePlayback.md)

## Examples

``` r
library(leaflet)
library(leaflet.extras2)
library(sf)

## Single Elements
data <- sf::st_as_sf(leaflet::atlStorms2005[1, ])
data <- st_cast(data, "POINT")
#> Warning: repeating attributes for all sub-geometries for which they may not be constant
data$time <- as.POSIXct(
  seq.POSIXt(Sys.time() - 1000, Sys.time(), length.out = nrow(data))
)
data$label <- as.character(data$time)

leaflet() %>%
  addTiles() %>%
  addPlayback(
    data = data, label = ~label,
    popup = ~ sprintf(
      "I am a popup for <b>%s</b> and <b>%s</b>",
      Name, label
    ),
    popupOptions = popupOptions(offset = c(0, -35)),
    options = playbackOptions(
      radius = 3,
      tickLen = 36000,
      speed = 50,
      maxInterpolationTime = 1000
    ),
    pathOpts = pathOptions(weight = 5)
  )

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addPlayback","args":[{"type":"Feature","name":null,"geometry":{"type":"MultiPoint","coordinates":[[-67.5,15.8],[-68.5,16.5],[-69.59999999999999,17.3],[-70.5,17.8],[-71.3,18.3],[-72.2,18.6],[-72.7,19.8],[-72.90000000000001,21.6],[-73,23.5],[-72.40000000000001,25.1],[-70.8,27.9]]},"properties":{"time":[1789293057727.481,1789293157727.479,1789293257727.478,1789293357727.476,1789293457727.475,1789293557727.473,1789293657727.472,1789293757727.47,1789293857727.469,1789293957727.467,1789294057727.466]},"popupContent":["I am a popup for <b>ALPHA<\/b> and <b>2026-09-13 09:50:57.727481<\/b>","I am a popup for <b>ALPHA<\/b> and <b>2026-09-13 09:52:37.727479<\/b>","I am a popup for <b>ALPHA<\/b> and <b>2026-09-13 09:54:17.727478<\/b>","I am a popup for <b>ALPHA<\/b> and <b>2026-09-13 09:55:57.727476<\/b>","I am a popup for <b>ALPHA<\/b> and <b>2026-09-13 09:57:37.727475<\/b>","I am a popup for <b>ALPHA<\/b> and <b>2026-09-13 09:59:17.727473<\/b>","I am a popup for <b>ALPHA<\/b> and <b>2026-09-13 10:00:57.727472<\/b>","I am a popup for <b>ALPHA<\/b> and <b>2026-09-13 10:02:37.72747<\/b>","I am a popup for <b>ALPHA<\/b> and <b>2026-09-13 10:04:17.727469<\/b>","I am a popup for <b>ALPHA<\/b> and <b>2026-09-13 10:05:57.727467<\/b>","I am a popup for <b>ALPHA<\/b> and <b>2026-09-13 10:07:37.727466<\/b>"],"tooltipContent":["2026-09-13 09:50:57.727481","2026-09-13 09:52:37.727479","2026-09-13 09:54:17.727478","2026-09-13 09:55:57.727476","2026-09-13 09:57:37.727475","2026-09-13 09:59:17.727473","2026-09-13 10:00:57.727472","2026-09-13 10:02:37.72747","2026-09-13 10:04:17.727469","2026-09-13 10:05:57.727467","2026-09-13 10:07:37.727466"]},{"pathOptions":{"interactive":true,"className":"","weight":5},"popupOptions":{"maxWidth":300,"minWidth":50,"autoPan":true,"keepInView":false,"closeButton":true,"className":"","offset":[0,-35]},"popups":true,"labels":true,"color":"blue","radius":3,"tickLen":36000,"speed":50,"maxInterpolationTime":1000,"tracksLayer":true,"playControl":true,"dateControl":true,"sliderControl":true,"orientIcons":false,"staleTime":3600000,"transitionpopup":true,"transitionlabel":true}]}],"limits":{"lat":[15.8,27.9],"lng":[-73,-67.5]}},"evals":[],"jsHooks":[]}

## Multiple Elements
data <- sf::st_as_sf(leaflet::atlStorms2005[1:5, ])
data$Name <- as.character(data$Name)
data <- st_cast(data, "POINT")
#> Warning: repeating attributes for all sub-geometries for which they may not be constant
data$time <- unlist(lapply(rle(data$Name)$lengths, function(x) {
  seq.POSIXt(as.POSIXct(Sys.Date() - 2), as.POSIXct(Sys.Date()), length.out = x)
}))
data$time <- as.POSIXct(data$time, origin = "1970-01-01")
data$label <- paste0("Time: ", data$time)
data$popup <- sprintf(
  "<h3>Customized Popup</h3><b>Name</b>: %s<br><b>Time</b>: %s",
  data$Name, data$time
)
data <- split(data, f = data$Name)

leaflet() %>%
  addTiles() %>%
  addPlayback(
    data = data,
    popup = ~popup,
    label = ~label,
    popupOptions = popupOptions(offset = c(0, -35)),
    labelOptions = labelOptions(noHide = TRUE),
    options = playbackOptions(
      radius = 3,
      tickLen = 1000000,
      speed = 5000,
      maxInterpolationTime = 10000,
      transitionpopup = FALSE,
      transitionlabel = FALSE,
      playCommand = "Let's go",
      stopCommand = "Stop it!",
      color = c(
        "red", "green", "blue",
        "orange", "yellow"
      )
    ),
    pathOpts = pathOptions(weight = 5)
  )

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addPlayback","args":[{"ALPHA":{"type":"Feature","name":null,"geometry":{"type":"MultiPoint","coordinates":[[-67.5,15.8],[-68.5,16.5],[-69.59999999999999,17.3],[-70.5,17.8],[-71.3,18.3],[-72.2,18.6],[-72.7,19.8],[-72.90000000000001,21.6],[-73,23.5],[-72.40000000000001,25.1],[-70.8,27.9]]},"properties":{"time":[1789084800000,1789102080000,1789119360000,1789136640000,1789153920000,1789171200000,1789188480000,1789205760000,1789223040000,1789240320000,1789257600000]},"popupContent":["<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-11","<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-11 04:48:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-11 09:36:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-11 14:24:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-11 19:12:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-12","<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-12 04:48:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-12 09:36:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-12 14:24:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-12 19:12:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-13"],"tooltipContent":["Time: 2026-09-11","Time: 2026-09-11 04:48:00","Time: 2026-09-11 09:36:00","Time: 2026-09-11 14:24:00","Time: 2026-09-11 19:12:00","Time: 2026-09-12","Time: 2026-09-12 04:48:00","Time: 2026-09-12 09:36:00","Time: 2026-09-12 14:24:00","Time: 2026-09-12 19:12:00","Time: 2026-09-13"]},"ARLENE":{"type":"Feature","name":null,"geometry":{"type":"MultiPoint","coordinates":[[-84,16.9],[-83.90000000000001,17.4],[-83.90000000000001,18.2],[-84,19],[-84.09999999999999,19.7],[-84.2,20.4],[-84.40000000000001,21.2],[-84.5,21.8],[-84.7,23],[-85.09999999999999,24.9],[-85.59999999999999,26.5],[-85.59999999999999,26.5],[-86.8,27.7],[-87.2,28.9],[-87.5,30.1],[-87.5,30.3],[-87.59999999999999,31.4],[-87.7,32.7],[-88,35],[-87.8,37],[-87.5,38.5],[-86,40.5],[-85,42],[-84,43],[-81.09999999999999,43.7],[-77.59999999999999,44.8]]},"properties":{"time":[1789084800000,1789091712000,1789098624000,1789105536000,1789112448000,1789119360000,1789126272000,1789133184000,1789140096000,1789147008000,1789153920000,1789160832000,1789167744000,1789174656000,1789181568000,1789188480000,1789195392000,1789202304000,1789209216000,1789216128000,1789223040000,1789229952000,1789236864000,1789243776000,1789250688000,1789257600000]},"popupContent":["<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-11","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-11 01:55:12","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-11 03:50:24","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-11 05:45:36","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-11 07:40:48","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-11 09:36:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-11 11:31:12","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-11 13:26:24","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-11 15:21:36","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-11 17:16:48","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-11 19:12:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-11 21:07:12","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-11 23:02:24","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-12 00:57:36","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-12 02:52:48","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-12 04:48:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-12 06:43:12","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-12 08:38:24","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-12 10:33:36","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-12 12:28:48","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-12 14:24:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-12 16:19:12","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-12 18:14:24","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-12 20:09:36","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-12 22:04:48","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-13"],"tooltipContent":["Time: 2026-09-11","Time: 2026-09-11 01:55:12","Time: 2026-09-11 03:50:24","Time: 2026-09-11 05:45:36","Time: 2026-09-11 07:40:48","Time: 2026-09-11 09:36:00","Time: 2026-09-11 11:31:12","Time: 2026-09-11 13:26:24","Time: 2026-09-11 15:21:36","Time: 2026-09-11 17:16:48","Time: 2026-09-11 19:12:00","Time: 2026-09-11 21:07:12","Time: 2026-09-11 23:02:24","Time: 2026-09-12 00:57:36","Time: 2026-09-12 02:52:48","Time: 2026-09-12 04:48:00","Time: 2026-09-12 06:43:12","Time: 2026-09-12 08:38:24","Time: 2026-09-12 10:33:36","Time: 2026-09-12 12:28:48","Time: 2026-09-12 14:24:00","Time: 2026-09-12 16:19:12","Time: 2026-09-12 18:14:24","Time: 2026-09-12 20:09:36","Time: 2026-09-12 22:04:48","Time: 2026-09-13"]},"BRET":{"type":"Feature","name":null,"geometry":{"type":"MultiPoint","coordinates":[[-95.40000000000001,19.7],[-95.7,19.9],[-95.8,20],[-96.40000000000001,20.4],[-97.3,20.8],[-98.09999999999999,21.4],[-98.5,22]]},"properties":{"time":[1789084800000,1789113600000,1789142400000,1789171200000,1789200000000,1789228800000,1789257600000]},"popupContent":["<h3>Customized Popup<\/h3><b>Name<\/b>: BRET<br><b>Time<\/b>: 2026-09-11","<h3>Customized Popup<\/h3><b>Name<\/b>: BRET<br><b>Time<\/b>: 2026-09-11 08:00:00","<h3>Customized Popup<\/h3><b>Name<\/b>: BRET<br><b>Time<\/b>: 2026-09-11 16:00:00","<h3>Customized Popup<\/h3><b>Name<\/b>: BRET<br><b>Time<\/b>: 2026-09-12","<h3>Customized Popup<\/h3><b>Name<\/b>: BRET<br><b>Time<\/b>: 2026-09-12 08:00:00","<h3>Customized Popup<\/h3><b>Name<\/b>: BRET<br><b>Time<\/b>: 2026-09-12 16:00:00","<h3>Customized Popup<\/h3><b>Name<\/b>: BRET<br><b>Time<\/b>: 2026-09-13"],"tooltipContent":["Time: 2026-09-11","Time: 2026-09-11 08:00:00","Time: 2026-09-11 16:00:00","Time: 2026-09-12","Time: 2026-09-12 08:00:00","Time: 2026-09-12 16:00:00","Time: 2026-09-13"]},"CINDY":{"type":"Feature","name":null,"geometry":{"type":"MultiPoint","coordinates":[[-86.7,18.3],[-87.2,18.6],[-87.59999999999999,19],[-87.90000000000001,19.3],[-88.5,20.9],[-89,22.3],[-89.7,23.9],[-90.2,25.1],[-90.40000000000001,26.4],[-90.5,27.6],[-90.3,28.5],[-90.09999999999999,29.2],[-90,29.6],[-89.5,30.2],[-88.90000000000001,30.8],[-88.09999999999999,31.6],[-87.2,32.4],[-86.2,33.2],[-84.09999999999999,34.6],[-81.8,35.6],[-80,37.1],[-78.3,37.8],[-76.7,38.4],[-74.8,39.1],[-72,39.5],[-70.7,40.8],[-69.8,41.6],[-69.59999999999999,43.5],[-69.8,44.9],[-70,45.5],[-67.59999999999999,46.5],[-66.40000000000001,48],[-64.5,48.5],[-62.5,48.5]]},"properties":{"time":[1789084800000,1789090036363.636,1789095272727.273,1789100509090.909,1789105745454.545,1789110981818.182,1789116218181.818,1789121454545.455,1789126690909.091,1789131927272.727,1789137163636.364,1789142400000,1789147636363.636,1789152872727.273,1789158109090.909,1789163345454.545,1789168581818.182,1789173818181.818,1789179054545.455,1789184290909.091,1789189527272.727,1789194763636.364,1789200000000,1789205236363.636,1789210472727.273,1789215709090.909,1789220945454.545,1789226181818.182,1789231418181.818,1789236654545.455,1789241890909.091,1789247127272.727,1789252363636.364,1789257600000]},"popupContent":["<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-11","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-11 01:27:16.363636","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-11 02:54:32.727273","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-11 04:21:49.090909","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-11 05:49:05.454545","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-11 07:16:21.818182","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-11 08:43:38.181818","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-11 10:10:54.545455","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-11 11:38:10.909091","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-11 13:05:27.272727","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-11 14:32:43.636364","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-11 16:00:00","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-11 17:27:16.363636","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-11 18:54:32.727273","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-11 20:21:49.090909","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-11 21:49:05.454545","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-11 23:16:21.818182","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-12 00:43:38.181818","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-12 02:10:54.545455","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-12 03:38:10.909091","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-12 05:05:27.272727","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-12 06:32:43.636364","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-12 08:00:00","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-12 09:27:16.363636","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-12 10:54:32.727273","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-12 12:21:49.090909","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-12 13:49:05.454545","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-12 15:16:21.818182","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-12 16:43:38.181818","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-12 18:10:54.545455","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-12 19:38:10.909091","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-12 21:05:27.272727","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-12 22:32:43.636364","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-13"],"tooltipContent":["Time: 2026-09-11","Time: 2026-09-11 01:27:16.363636","Time: 2026-09-11 02:54:32.727273","Time: 2026-09-11 04:21:49.090909","Time: 2026-09-11 05:49:05.454545","Time: 2026-09-11 07:16:21.818182","Time: 2026-09-11 08:43:38.181818","Time: 2026-09-11 10:10:54.545455","Time: 2026-09-11 11:38:10.909091","Time: 2026-09-11 13:05:27.272727","Time: 2026-09-11 14:32:43.636364","Time: 2026-09-11 16:00:00","Time: 2026-09-11 17:27:16.363636","Time: 2026-09-11 18:54:32.727273","Time: 2026-09-11 20:21:49.090909","Time: 2026-09-11 21:49:05.454545","Time: 2026-09-11 23:16:21.818182","Time: 2026-09-12 00:43:38.181818","Time: 2026-09-12 02:10:54.545455","Time: 2026-09-12 03:38:10.909091","Time: 2026-09-12 05:05:27.272727","Time: 2026-09-12 06:32:43.636364","Time: 2026-09-12 08:00:00","Time: 2026-09-12 09:27:16.363636","Time: 2026-09-12 10:54:32.727273","Time: 2026-09-12 12:21:49.090909","Time: 2026-09-12 13:49:05.454545","Time: 2026-09-12 15:16:21.818182","Time: 2026-09-12 16:43:38.181818","Time: 2026-09-12 18:10:54.545455","Time: 2026-09-12 19:38:10.909091","Time: 2026-09-12 21:05:27.272727","Time: 2026-09-12 22:32:43.636364","Time: 2026-09-13"]},"DELTA":{"type":"Feature","name":null,"geometry":{"type":"MultiPoint","coordinates":[[-48,27],[-47.5,26.7],[-46.7,26.7],[-45.9,27.2],[-44.8,27.7],[-43.5,28],[-42.2,28.3],[-41.1,29],[-40.1,29.9],[-39.6,30.9],[-40.1,31.5],[-39.9,31.4],[-39.8,31.2],[-40.5,30.7],[-40.9,29.9],[-41.3,28.8],[-41.2,27.4],[-40.8,26.4],[-40.2,25.5],[-39.6,25],[-39,24.8],[-38.9,24.6],[-39,24.1],[-39.3,23.8],[-39.6,23.3],[-39.8,22.8],[-39.8,22.3],[-39.4,21.8],[-38.4,22],[-37.3,22.6],[-35.8,23.5],[-34,24.8],[-31.9,26.7],[-29.9,28.3],[-27.5,29.1],[-24.8,29.9],[-21.6,30.2],[-18.2,30.2],[-14.6,30.2],[-10.9,30.7],[-6.6,32.6],[-1,35.3]]},"properties":{"time":[1789084800000,1789089014634.146,1789093229268.293,1789097443902.439,1789101658536.585,1789105873170.732,1789110087804.878,1789114302439.024,1789118517073.171,1789122731707.317,1789126946341.463,1789131160975.61,1789135375609.756,1789139590243.902,1789143804878.049,1789148019512.195,1789152234146.342,1789156448780.488,1789160663414.634,1789164878048.781,1789169092682.927,1789173307317.073,1789177521951.219,1789181736585.366,1789185951219.512,1789190165853.658,1789194380487.805,1789198595121.951,1789202809756.098,1789207024390.244,1789211239024.39,1789215453658.537,1789219668292.683,1789223882926.829,1789228097560.976,1789232312195.122,1789236526829.268,1789240741463.415,1789244956097.561,1789249170731.707,1789253385365.854,1789257600000]},"popupContent":["<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-11","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-11 01:10:14.634146","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-11 02:20:29.268293","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-11 03:30:43.902439","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-11 04:40:58.536585","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-11 05:51:13.170732","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-11 07:01:27.804878","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-11 08:11:42.439024","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-11 09:21:57.073171","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-11 10:32:11.707317","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-11 11:42:26.341463","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-11 12:52:40.97561","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-11 14:02:55.609756","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-11 15:13:10.243902","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-11 16:23:24.878049","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-11 17:33:39.512195","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-11 18:43:54.146342","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-11 19:54:08.780488","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-11 21:04:23.414634","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-11 22:14:38.04878","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-11 23:24:52.682927","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-12 00:35:07.317073","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-12 01:45:21.95122","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-12 02:55:36.585366","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-12 04:05:51.219512","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-12 05:16:05.853658","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-12 06:26:20.487805","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-12 07:36:35.121951","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-12 08:46:49.756098","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-12 09:57:04.390244","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-12 11:07:19.02439","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-12 12:17:33.658537","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-12 13:27:48.292683","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-12 14:38:02.926829","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-12 15:48:17.560976","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-12 16:58:32.195122","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-12 18:08:46.829268","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-12 19:19:01.463415","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-12 20:29:16.097561","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-12 21:39:30.731707","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-12 22:49:45.365854","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-13"],"tooltipContent":["Time: 2026-09-11","Time: 2026-09-11 01:10:14.634146","Time: 2026-09-11 02:20:29.268293","Time: 2026-09-11 03:30:43.902439","Time: 2026-09-11 04:40:58.536585","Time: 2026-09-11 05:51:13.170732","Time: 2026-09-11 07:01:27.804878","Time: 2026-09-11 08:11:42.439024","Time: 2026-09-11 09:21:57.073171","Time: 2026-09-11 10:32:11.707317","Time: 2026-09-11 11:42:26.341463","Time: 2026-09-11 12:52:40.97561","Time: 2026-09-11 14:02:55.609756","Time: 2026-09-11 15:13:10.243902","Time: 2026-09-11 16:23:24.878049","Time: 2026-09-11 17:33:39.512195","Time: 2026-09-11 18:43:54.146342","Time: 2026-09-11 19:54:08.780488","Time: 2026-09-11 21:04:23.414634","Time: 2026-09-11 22:14:38.04878","Time: 2026-09-11 23:24:52.682927","Time: 2026-09-12 00:35:07.317073","Time: 2026-09-12 01:45:21.95122","Time: 2026-09-12 02:55:36.585366","Time: 2026-09-12 04:05:51.219512","Time: 2026-09-12 05:16:05.853658","Time: 2026-09-12 06:26:20.487805","Time: 2026-09-12 07:36:35.121951","Time: 2026-09-12 08:46:49.756098","Time: 2026-09-12 09:57:04.390244","Time: 2026-09-12 11:07:19.02439","Time: 2026-09-12 12:17:33.658537","Time: 2026-09-12 13:27:48.292683","Time: 2026-09-12 14:38:02.926829","Time: 2026-09-12 15:48:17.560976","Time: 2026-09-12 16:58:32.195122","Time: 2026-09-12 18:08:46.829268","Time: 2026-09-12 19:19:01.463415","Time: 2026-09-12 20:29:16.097561","Time: 2026-09-12 21:39:30.731707","Time: 2026-09-12 22:49:45.365854","Time: 2026-09-13"]}},{"pathOptions":{"interactive":true,"className":"","weight":5},"popupOptions":{"maxWidth":300,"minWidth":50,"autoPan":true,"keepInView":false,"closeButton":true,"className":"","offset":[0,-35]},"labelOptions":{"interactive":false,"permanent":true,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},"popups":true,"labels":true,"color":["red","green","blue","orange","yellow"],"radius":3,"tickLen":1000000,"speed":5000,"maxInterpolationTime":10000,"tracksLayer":true,"playControl":true,"dateControl":true,"sliderControl":true,"orientIcons":false,"staleTime":3600000,"transitionpopup":false,"transitionlabel":false,"playCommand":"Let's go","stopCommand":"Stop it!"}]}],"limits":{"lat":[15.8,48.5],"lng":[-98.5,-1]}},"evals":[],"jsHooks":[]}
```
