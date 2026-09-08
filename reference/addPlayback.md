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
  [`popupOptions`](https://rstudio.github.io/leaflet/reference/map-options.html)
  to provide popups

- labelOptions:

  A Vector of
  [`labelOptions`](https://rstudio.github.io/leaflet/reference/map-options.html)
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

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addPlayback","args":[{"type":"Feature","name":null,"geometry":{"type":"MultiPoint","coordinates":[[-67.5,15.8],[-68.5,16.5],[-69.59999999999999,17.3],[-70.5,17.8],[-71.3,18.3],[-72.2,18.6],[-72.7,19.8],[-72.90000000000001,21.6],[-73,23.5],[-72.40000000000001,25.1],[-70.8,27.9]]},"properties":{"time":[1788891702511.352,1788891802511.35,1788891902511.349,1788892002511.347,1788892102511.346,1788892202511.344,1788892302511.342,1788892402511.341,1788892502511.339,1788892602511.338,1788892702511.336]},"popupContent":["I am a popup for <b>ALPHA<\/b> and <b>2026-09-08 18:21:42.511352<\/b>","I am a popup for <b>ALPHA<\/b> and <b>2026-09-08 18:23:22.51135<\/b>","I am a popup for <b>ALPHA<\/b> and <b>2026-09-08 18:25:02.511349<\/b>","I am a popup for <b>ALPHA<\/b> and <b>2026-09-08 18:26:42.511347<\/b>","I am a popup for <b>ALPHA<\/b> and <b>2026-09-08 18:28:22.511346<\/b>","I am a popup for <b>ALPHA<\/b> and <b>2026-09-08 18:30:02.511344<\/b>","I am a popup for <b>ALPHA<\/b> and <b>2026-09-08 18:31:42.511342<\/b>","I am a popup for <b>ALPHA<\/b> and <b>2026-09-08 18:33:22.511341<\/b>","I am a popup for <b>ALPHA<\/b> and <b>2026-09-08 18:35:02.511339<\/b>","I am a popup for <b>ALPHA<\/b> and <b>2026-09-08 18:36:42.511338<\/b>","I am a popup for <b>ALPHA<\/b> and <b>2026-09-08 18:38:22.511336<\/b>"],"tooltipContent":["2026-09-08 18:21:42.511352","2026-09-08 18:23:22.51135","2026-09-08 18:25:02.511349","2026-09-08 18:26:42.511347","2026-09-08 18:28:22.511346","2026-09-08 18:30:02.511344","2026-09-08 18:31:42.511342","2026-09-08 18:33:22.511341","2026-09-08 18:35:02.511339","2026-09-08 18:36:42.511338","2026-09-08 18:38:22.511336"]},{"pathOptions":{"interactive":true,"className":"","weight":5},"popupOptions":{"maxWidth":300,"minWidth":50,"autoPan":true,"keepInView":false,"closeButton":true,"className":"","offset":[0,-35]},"popups":true,"labels":true,"color":"blue","radius":3,"tickLen":36000,"speed":50,"maxInterpolationTime":1000,"tracksLayer":true,"playControl":true,"dateControl":true,"sliderControl":true,"orientIcons":false,"staleTime":3600000,"transitionpopup":true,"transitionlabel":true}]}],"limits":{"lat":[15.8,27.9],"lng":[-73,-67.5]}},"evals":[],"jsHooks":[]}

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

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addPlayback","args":[{"ALPHA":{"type":"Feature","name":null,"geometry":{"type":"MultiPoint","coordinates":[[-67.5,15.8],[-68.5,16.5],[-69.59999999999999,17.3],[-70.5,17.8],[-71.3,18.3],[-72.2,18.6],[-72.7,19.8],[-72.90000000000001,21.6],[-73,23.5],[-72.40000000000001,25.1],[-70.8,27.9]]},"properties":{"time":[1788652800000,1788670080000,1788687360000,1788704640000,1788721920000,1788739200000,1788756480000,1788773760000,1788791040000,1788808320000,1788825600000]},"popupContent":["<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-06","<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-06 04:48:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-06 09:36:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-06 14:24:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-06 19:12:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-07","<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-07 04:48:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-07 09:36:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-07 14:24:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-07 19:12:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ALPHA<br><b>Time<\/b>: 2026-09-08"],"tooltipContent":["Time: 2026-09-06","Time: 2026-09-06 04:48:00","Time: 2026-09-06 09:36:00","Time: 2026-09-06 14:24:00","Time: 2026-09-06 19:12:00","Time: 2026-09-07","Time: 2026-09-07 04:48:00","Time: 2026-09-07 09:36:00","Time: 2026-09-07 14:24:00","Time: 2026-09-07 19:12:00","Time: 2026-09-08"]},"ARLENE":{"type":"Feature","name":null,"geometry":{"type":"MultiPoint","coordinates":[[-84,16.9],[-83.90000000000001,17.4],[-83.90000000000001,18.2],[-84,19],[-84.09999999999999,19.7],[-84.2,20.4],[-84.40000000000001,21.2],[-84.5,21.8],[-84.7,23],[-85.09999999999999,24.9],[-85.59999999999999,26.5],[-85.59999999999999,26.5],[-86.8,27.7],[-87.2,28.9],[-87.5,30.1],[-87.5,30.3],[-87.59999999999999,31.4],[-87.7,32.7],[-88,35],[-87.8,37],[-87.5,38.5],[-86,40.5],[-85,42],[-84,43],[-81.09999999999999,43.7],[-77.59999999999999,44.8]]},"properties":{"time":[1788652800000,1788659712000,1788666624000,1788673536000,1788680448000,1788687360000,1788694272000,1788701184000,1788708096000,1788715008000,1788721920000,1788728832000,1788735744000,1788742656000,1788749568000,1788756480000,1788763392000,1788770304000,1788777216000,1788784128000,1788791040000,1788797952000,1788804864000,1788811776000,1788818688000,1788825600000]},"popupContent":["<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-06","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-06 01:55:12","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-06 03:50:24","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-06 05:45:36","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-06 07:40:48","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-06 09:36:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-06 11:31:12","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-06 13:26:24","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-06 15:21:36","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-06 17:16:48","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-06 19:12:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-06 21:07:12","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-06 23:02:24","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-07 00:57:36","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-07 02:52:48","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-07 04:48:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-07 06:43:12","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-07 08:38:24","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-07 10:33:36","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-07 12:28:48","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-07 14:24:00","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-07 16:19:12","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-07 18:14:24","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-07 20:09:36","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-07 22:04:48","<h3>Customized Popup<\/h3><b>Name<\/b>: ARLENE<br><b>Time<\/b>: 2026-09-08"],"tooltipContent":["Time: 2026-09-06","Time: 2026-09-06 01:55:12","Time: 2026-09-06 03:50:24","Time: 2026-09-06 05:45:36","Time: 2026-09-06 07:40:48","Time: 2026-09-06 09:36:00","Time: 2026-09-06 11:31:12","Time: 2026-09-06 13:26:24","Time: 2026-09-06 15:21:36","Time: 2026-09-06 17:16:48","Time: 2026-09-06 19:12:00","Time: 2026-09-06 21:07:12","Time: 2026-09-06 23:02:24","Time: 2026-09-07 00:57:36","Time: 2026-09-07 02:52:48","Time: 2026-09-07 04:48:00","Time: 2026-09-07 06:43:12","Time: 2026-09-07 08:38:24","Time: 2026-09-07 10:33:36","Time: 2026-09-07 12:28:48","Time: 2026-09-07 14:24:00","Time: 2026-09-07 16:19:12","Time: 2026-09-07 18:14:24","Time: 2026-09-07 20:09:36","Time: 2026-09-07 22:04:48","Time: 2026-09-08"]},"BRET":{"type":"Feature","name":null,"geometry":{"type":"MultiPoint","coordinates":[[-95.40000000000001,19.7],[-95.7,19.9],[-95.8,20],[-96.40000000000001,20.4],[-97.3,20.8],[-98.09999999999999,21.4],[-98.5,22]]},"properties":{"time":[1788652800000,1788681600000,1788710400000,1788739200000,1788768000000,1788796800000,1788825600000]},"popupContent":["<h3>Customized Popup<\/h3><b>Name<\/b>: BRET<br><b>Time<\/b>: 2026-09-06","<h3>Customized Popup<\/h3><b>Name<\/b>: BRET<br><b>Time<\/b>: 2026-09-06 08:00:00","<h3>Customized Popup<\/h3><b>Name<\/b>: BRET<br><b>Time<\/b>: 2026-09-06 16:00:00","<h3>Customized Popup<\/h3><b>Name<\/b>: BRET<br><b>Time<\/b>: 2026-09-07","<h3>Customized Popup<\/h3><b>Name<\/b>: BRET<br><b>Time<\/b>: 2026-09-07 08:00:00","<h3>Customized Popup<\/h3><b>Name<\/b>: BRET<br><b>Time<\/b>: 2026-09-07 16:00:00","<h3>Customized Popup<\/h3><b>Name<\/b>: BRET<br><b>Time<\/b>: 2026-09-08"],"tooltipContent":["Time: 2026-09-06","Time: 2026-09-06 08:00:00","Time: 2026-09-06 16:00:00","Time: 2026-09-07","Time: 2026-09-07 08:00:00","Time: 2026-09-07 16:00:00","Time: 2026-09-08"]},"CINDY":{"type":"Feature","name":null,"geometry":{"type":"MultiPoint","coordinates":[[-86.7,18.3],[-87.2,18.6],[-87.59999999999999,19],[-87.90000000000001,19.3],[-88.5,20.9],[-89,22.3],[-89.7,23.9],[-90.2,25.1],[-90.40000000000001,26.4],[-90.5,27.6],[-90.3,28.5],[-90.09999999999999,29.2],[-90,29.6],[-89.5,30.2],[-88.90000000000001,30.8],[-88.09999999999999,31.6],[-87.2,32.4],[-86.2,33.2],[-84.09999999999999,34.6],[-81.8,35.6],[-80,37.1],[-78.3,37.8],[-76.7,38.4],[-74.8,39.1],[-72,39.5],[-70.7,40.8],[-69.8,41.6],[-69.59999999999999,43.5],[-69.8,44.9],[-70,45.5],[-67.59999999999999,46.5],[-66.40000000000001,48],[-64.5,48.5],[-62.5,48.5]]},"properties":{"time":[1788652800000,1788658036363.636,1788663272727.273,1788668509090.909,1788673745454.545,1788678981818.182,1788684218181.818,1788689454545.455,1788694690909.091,1788699927272.727,1788705163636.364,1788710400000,1788715636363.636,1788720872727.273,1788726109090.909,1788731345454.545,1788736581818.182,1788741818181.818,1788747054545.455,1788752290909.091,1788757527272.727,1788762763636.364,1788768000000,1788773236363.636,1788778472727.273,1788783709090.909,1788788945454.545,1788794181818.182,1788799418181.818,1788804654545.455,1788809890909.091,1788815127272.727,1788820363636.364,1788825600000]},"popupContent":["<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-06","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-06 01:27:16.363636","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-06 02:54:32.727273","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-06 04:21:49.090909","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-06 05:49:05.454545","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-06 07:16:21.818182","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-06 08:43:38.181818","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-06 10:10:54.545455","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-06 11:38:10.909091","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-06 13:05:27.272727","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-06 14:32:43.636364","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-06 16:00:00","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-06 17:27:16.363636","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-06 18:54:32.727273","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-06 20:21:49.090909","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-06 21:49:05.454545","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-06 23:16:21.818182","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-07 00:43:38.181818","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-07 02:10:54.545455","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-07 03:38:10.909091","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-07 05:05:27.272727","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-07 06:32:43.636364","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-07 08:00:00","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-07 09:27:16.363636","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-07 10:54:32.727273","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-07 12:21:49.090909","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-07 13:49:05.454545","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-07 15:16:21.818182","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-07 16:43:38.181818","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-07 18:10:54.545455","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-07 19:38:10.909091","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-07 21:05:27.272727","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-07 22:32:43.636364","<h3>Customized Popup<\/h3><b>Name<\/b>: CINDY<br><b>Time<\/b>: 2026-09-08"],"tooltipContent":["Time: 2026-09-06","Time: 2026-09-06 01:27:16.363636","Time: 2026-09-06 02:54:32.727273","Time: 2026-09-06 04:21:49.090909","Time: 2026-09-06 05:49:05.454545","Time: 2026-09-06 07:16:21.818182","Time: 2026-09-06 08:43:38.181818","Time: 2026-09-06 10:10:54.545455","Time: 2026-09-06 11:38:10.909091","Time: 2026-09-06 13:05:27.272727","Time: 2026-09-06 14:32:43.636364","Time: 2026-09-06 16:00:00","Time: 2026-09-06 17:27:16.363636","Time: 2026-09-06 18:54:32.727273","Time: 2026-09-06 20:21:49.090909","Time: 2026-09-06 21:49:05.454545","Time: 2026-09-06 23:16:21.818182","Time: 2026-09-07 00:43:38.181818","Time: 2026-09-07 02:10:54.545455","Time: 2026-09-07 03:38:10.909091","Time: 2026-09-07 05:05:27.272727","Time: 2026-09-07 06:32:43.636364","Time: 2026-09-07 08:00:00","Time: 2026-09-07 09:27:16.363636","Time: 2026-09-07 10:54:32.727273","Time: 2026-09-07 12:21:49.090909","Time: 2026-09-07 13:49:05.454545","Time: 2026-09-07 15:16:21.818182","Time: 2026-09-07 16:43:38.181818","Time: 2026-09-07 18:10:54.545455","Time: 2026-09-07 19:38:10.909091","Time: 2026-09-07 21:05:27.272727","Time: 2026-09-07 22:32:43.636364","Time: 2026-09-08"]},"DELTA":{"type":"Feature","name":null,"geometry":{"type":"MultiPoint","coordinates":[[-48,27],[-47.5,26.7],[-46.7,26.7],[-45.9,27.2],[-44.8,27.7],[-43.5,28],[-42.2,28.3],[-41.1,29],[-40.1,29.9],[-39.6,30.9],[-40.1,31.5],[-39.9,31.4],[-39.8,31.2],[-40.5,30.7],[-40.9,29.9],[-41.3,28.8],[-41.2,27.4],[-40.8,26.4],[-40.2,25.5],[-39.6,25],[-39,24.8],[-38.9,24.6],[-39,24.1],[-39.3,23.8],[-39.6,23.3],[-39.8,22.8],[-39.8,22.3],[-39.4,21.8],[-38.4,22],[-37.3,22.6],[-35.8,23.5],[-34,24.8],[-31.9,26.7],[-29.9,28.3],[-27.5,29.1],[-24.8,29.9],[-21.6,30.2],[-18.2,30.2],[-14.6,30.2],[-10.9,30.7],[-6.6,32.6],[-1,35.3]]},"properties":{"time":[1788652800000,1788657014634.146,1788661229268.293,1788665443902.439,1788669658536.585,1788673873170.732,1788678087804.878,1788682302439.024,1788686517073.171,1788690731707.317,1788694946341.463,1788699160975.61,1788703375609.756,1788707590243.902,1788711804878.049,1788716019512.195,1788720234146.342,1788724448780.488,1788728663414.634,1788732878048.781,1788737092682.927,1788741307317.073,1788745521951.219,1788749736585.366,1788753951219.512,1788758165853.658,1788762380487.805,1788766595121.951,1788770809756.098,1788775024390.244,1788779239024.39,1788783453658.537,1788787668292.683,1788791882926.829,1788796097560.976,1788800312195.122,1788804526829.268,1788808741463.415,1788812956097.561,1788817170731.707,1788821385365.854,1788825600000]},"popupContent":["<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-06","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-06 01:10:14.634146","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-06 02:20:29.268293","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-06 03:30:43.902439","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-06 04:40:58.536585","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-06 05:51:13.170732","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-06 07:01:27.804878","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-06 08:11:42.439024","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-06 09:21:57.073171","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-06 10:32:11.707317","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-06 11:42:26.341463","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-06 12:52:40.97561","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-06 14:02:55.609756","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-06 15:13:10.243902","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-06 16:23:24.878049","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-06 17:33:39.512195","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-06 18:43:54.146342","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-06 19:54:08.780488","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-06 21:04:23.414634","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-06 22:14:38.04878","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-06 23:24:52.682927","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-07 00:35:07.317073","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-07 01:45:21.95122","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-07 02:55:36.585366","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-07 04:05:51.219512","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-07 05:16:05.853658","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-07 06:26:20.487805","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-07 07:36:35.121951","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-07 08:46:49.756098","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-07 09:57:04.390244","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-07 11:07:19.02439","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-07 12:17:33.658537","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-07 13:27:48.292683","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-07 14:38:02.926829","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-07 15:48:17.560976","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-07 16:58:32.195122","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-07 18:08:46.829268","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-07 19:19:01.463415","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-07 20:29:16.097561","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-07 21:39:30.731707","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-07 22:49:45.365854","<h3>Customized Popup<\/h3><b>Name<\/b>: DELTA<br><b>Time<\/b>: 2026-09-08"],"tooltipContent":["Time: 2026-09-06","Time: 2026-09-06 01:10:14.634146","Time: 2026-09-06 02:20:29.268293","Time: 2026-09-06 03:30:43.902439","Time: 2026-09-06 04:40:58.536585","Time: 2026-09-06 05:51:13.170732","Time: 2026-09-06 07:01:27.804878","Time: 2026-09-06 08:11:42.439024","Time: 2026-09-06 09:21:57.073171","Time: 2026-09-06 10:32:11.707317","Time: 2026-09-06 11:42:26.341463","Time: 2026-09-06 12:52:40.97561","Time: 2026-09-06 14:02:55.609756","Time: 2026-09-06 15:13:10.243902","Time: 2026-09-06 16:23:24.878049","Time: 2026-09-06 17:33:39.512195","Time: 2026-09-06 18:43:54.146342","Time: 2026-09-06 19:54:08.780488","Time: 2026-09-06 21:04:23.414634","Time: 2026-09-06 22:14:38.04878","Time: 2026-09-06 23:24:52.682927","Time: 2026-09-07 00:35:07.317073","Time: 2026-09-07 01:45:21.95122","Time: 2026-09-07 02:55:36.585366","Time: 2026-09-07 04:05:51.219512","Time: 2026-09-07 05:16:05.853658","Time: 2026-09-07 06:26:20.487805","Time: 2026-09-07 07:36:35.121951","Time: 2026-09-07 08:46:49.756098","Time: 2026-09-07 09:57:04.390244","Time: 2026-09-07 11:07:19.02439","Time: 2026-09-07 12:17:33.658537","Time: 2026-09-07 13:27:48.292683","Time: 2026-09-07 14:38:02.926829","Time: 2026-09-07 15:48:17.560976","Time: 2026-09-07 16:58:32.195122","Time: 2026-09-07 18:08:46.829268","Time: 2026-09-07 19:19:01.463415","Time: 2026-09-07 20:29:16.097561","Time: 2026-09-07 21:39:30.731707","Time: 2026-09-07 22:49:45.365854","Time: 2026-09-08"]}},{"pathOptions":{"interactive":true,"className":"","weight":5},"popupOptions":{"maxWidth":300,"minWidth":50,"autoPan":true,"keepInView":false,"closeButton":true,"className":"","offset":[0,-35]},"labelOptions":{"interactive":false,"permanent":true,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},"popups":true,"labels":true,"color":["red","green","blue","orange","yellow"],"radius":3,"tickLen":1000000,"speed":5000,"maxInterpolationTime":10000,"tracksLayer":true,"playControl":true,"dateControl":true,"sliderControl":true,"orientIcons":false,"staleTime":3600000,"transitionpopup":false,"transitionlabel":false,"playCommand":"Let's go","stopCommand":"Stop it!"}]}],"limits":{"lat":[15.8,48.5],"lng":[-98.5,-1]}},"evals":[],"jsHooks":[]}
```
