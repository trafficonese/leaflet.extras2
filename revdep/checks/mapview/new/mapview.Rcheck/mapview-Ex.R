pkgname <- "mapview"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('mapview')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("mapView")
### * mapView

flush(stderr()); flush(stdout())

### Name: mapView
### Title: View spatial objects interactively
### Aliases: mapView mapView,RasterLayer-method mapView,stars-method
###   mapView,stars_proxy-method mapView,RasterStackBrick-method
###   mapView,Satellite-method mapView,sf-method mapView,sfc-method
###   mapView,character-method mapView,numeric-method
###   mapView,data.frame-method mapView,XY-method mapView,XYZ-method
###   mapView,XYM-method mapView,XYZM-method mapView,bbox-method
###   mapView,missing-method mapView,NULL-method mapView,list-method
###   mapview,ANY-method mapview mapView,SpatialPixelsDataFrame-method
###   mapView,SpatialGridDataFrame-method
###   mapView,SpatialPointsDataFrame-method mapView,SpatialPoints-method
###   mapView,SpatialPolygonsDataFrame-method
###   mapView,SpatialPolygons-method mapView,SpatialLinesDataFrame-method
###   mapView,SpatialLines-method

### ** Examples

## Not run: 
##D   mapview()
##D 
##D   ## simple features ====================================================
##D   library(sf)
##D 
##D   # sf
##D   mapview(breweries)
##D   mapview(franconia)
##D 
##D   # sfc
##D   mapview(st_geometry(breweries)) # no popup
##D 
##D   # sfg / XY - taken from ?sf::st_point
##D   outer = matrix(c(0,0,10,0,10,10,0,10,0,0),ncol=2, byrow=TRUE)
##D   hole1 = matrix(c(1,1,1,2,2,2,2,1,1,1),ncol=2, byrow=TRUE)
##D   hole2 = matrix(c(5,5,5,6,6,6,6,5,5,5),ncol=2, byrow=TRUE)
##D   pts = list(outer, hole1, hole2)
##D   (pl1 = st_polygon(pts))
##D   mapview(pl1)
##D 
##D   ## raster ==============================================================
##D   if (interactive()) {
##D     library(plainview)
##D 
##D     mapview(plainview::poppendorf[[5]])
##D   }
##D 
##D   ## spatial objects =====================================================
##D   mapview(leaflet::gadmCHE)
##D   mapview(leaflet::atlStorms2005)
##D 
##D 
##D   ## styling options & legends ===========================================
##D   mapview(franconia, color = "white", col.regions = "red")
##D   mapview(franconia, color = "magenta", col.regions = "white")
##D 
##D   mapview(breweries, zcol = "founded")
##D   mapview(breweries, zcol = "founded", at = seq(1400, 2200, 200), legend = TRUE)
##D   mapview(franconia, zcol = "district", legend = TRUE)
##D 
##D   clrs <- sf.colors
##D   mapview(franconia, zcol = "district", col.regions = clrs, legend = TRUE)
##D 
##D   ### multiple layers ====================================================
##D   mapview(franconia) + breweries
##D   mapview(list(breweries, franconia))
##D   mapview(franconia) + mapview(breweries) + trails
##D 
##D   mapview(franconia, zcol = "district") + mapview(breweries, zcol = "village")
##D   mapview(list(franconia, breweries),
##D           zcol = list("district", NULL),
##D           legend = list(TRUE, FALSE))
##D 
##D 
##D   ### burst ==============================================================
##D   mapview(franconia, burst = TRUE)
##D   mapview(franconia, burst = TRUE, hide = TRUE)
##D   mapview(franconia, zcol = "district", burst = TRUE)
##D 
##D 
##D   ### ceci constitue la fin du pipe ======================================
##D   library(poorman)
##D   library(sf)
##D 
##D   franconia %>%
##D     sf::st_union() %>%
##D     mapview()
##D 
##D   franconia %>%
##D     group_by(district) %>%
##D     summarize() %>%
##D     mapview(zcol = "district")
##D 
##D   franconia %>%
##D     group_by(district) %>%
##D     summarize() %>%
##D     mutate(area = st_area(.) / 1e6) %>%
##D     mapview(zcol = "area")
##D 
##D   franconia %>%
##D     mutate(area = sf::st_area(.)) %>%
##D     mapview(zcol = "area", legend = TRUE)
##D 
##D   breweries %>%
##D     st_intersection(franconia) %>%
##D     mapview(zcol = "district")
##D 
##D   franconia %>%
##D     mutate(count = lengths(st_contains(., breweries))) %>%
##D     mapview(zcol = "count")
##D 
##D   franconia %>%
##D     mutate(count = lengths(st_contains(., breweries)),
##D            density = count / st_area(.)) %>%
##D     mapview(zcol = "density")
## End(Not run)




cleanEx()
nameEx("mapshot")
### * mapshot

flush(stderr()); flush(stdout())

### Name: mapshot
### Title: Save mapview or leaflet map as HTML and/or image
### Aliases: mapshot

### ** Examples

## Not run: 
##D   m = mapview(breweries)
##D 
##D   ## create standalone .html
##D   mapshot(m, url = paste0(getwd(), "/map.html"))
##D 
##D   ## create standalone .png; temporary .html is removed automatically unless
##D   ## 'remove_url = FALSE' is specified
##D   mapshot(m, file = paste0(getwd(), "/map.png"))
##D   mapshot(m, file = paste0(getwd(), "/map.png"),
##D           remove_controls = c("homeButton", "layersControl"))
##D 
##D   ## create .html and .png
##D   mapshot(m, url = paste0(getwd(), "/map.html"),
##D           file = paste0(getwd(), "/map.png"))
## End(Not run)




cleanEx()
nameEx("mapviewOptions")
### * mapviewOptions

flush(stderr()); flush(stdout())

### Name: mapviewOptions
### Title: Global options for the mapview package
### Aliases: mapviewOptions mapviewGetOption

### ** Examples

mapviewOptions()
mapviewOptions(na.color = "pink")
mapviewOptions()

mapviewGetOption("platform")

mapviewOptions(default = TRUE)
mapviewOptions()





cleanEx()
nameEx("mapviewWatcher")
### * mapviewWatcher

flush(stderr()); flush(stdout())

### Name: mapviewWatcher
### Title: Start and/or stop automagic mapviewing of spatial objects in
###   your workspace.
### Aliases: mapviewWatcher startWatching stopWatching

### ** Examples

  if (interactive()) {
    library(mapview)

    ## start the watcher
    mapview::startWatching()

    ## load some data and watch the automatic visualisation
    fran = mapview::franconia
    brew = mapview::breweries

    ## stop the watcher
    mapview::stopWatching()

    ## loading or removing things now will not trigger a view update
    rm(brew)
    trls = mapview::trails

    ## re-starting the viewer will re-draw whatever is currently available
    mapview::startWatching()

    ## watcher can also be stopped via mapviewOptions
    mapviewOptions(watch = FALSE)

    rm(trls)

  }




cleanEx()
nameEx("npts")
### * npts

flush(stderr()); flush(stdout())

### Name: npts
### Title: count the number of points/vertices/nodes of sf objects
### Aliases: npts

### ** Examples

npts(franconia)
npts(franconia, by_feature = TRUE)
npts(sf::st_geometry(franconia[1, ])) # first polygon

npts(breweries) # is the same as
nrow(breweries)




cleanEx()
nameEx("ops")
### * ops

flush(stderr()); flush(stdout())

### Name: ops
### Title: mapview + mapview adds data from the second map to the first
### Aliases: ops +,mapview,mapview-method +,mapview,ANY-method
###   +,mapview,NULL-method +,mapview,character-method
###   |,mapview,mapview-method |,mapview,NULL-method |,NULL,mapview-method

### ** Examples

  m1 <- mapView(franconia, col.regions = "red")
  m2 <- mapView(breweries)

  ### add two mapview objects
  m1 + m2

  ### add layers to a mapview object
  if (interactive()) {
    library(plainview)
    m1 + breweries + plainview::poppendorf[[4]]
  }

  m1 <- mapView(franconia, col.regions = "red")
  m2 <- mapView(breweries)

  ### add two mapview objects
  m1 | m2




cleanEx()
nameEx("removeMapJunk")
### * removeMapJunk

flush(stderr()); flush(stdout())

### Name: removeMapJunk
### Title: Delete elements from a map.
### Aliases: removeMapJunk

### ** Examples

if (interactive()) {
  library(mapview)

  map = mapview(franconia)

  removeMapJunk(map, "zoomControl")
}




cleanEx()
nameEx("viewExtent")
### * viewExtent

flush(stderr()); flush(stdout())

### Name: viewExtent
### Title: View extent/bbox of spatial objects interactively
### Aliases: viewExtent

### ** Examples

library(leaflet)

viewExtent(breweries)
viewExtent(franconia) + breweries
mapview(franconia) %>% leafem::addExtent(franconia, fillColor = "yellow")
leaflet() %>% addProviderTiles("OpenStreetMap") %>% leafem::addExtent(breweries)
leaflet() %>% addProviderTiles("OpenStreetMap") %>% leafem::addExtent(breweries)




cleanEx()
nameEx("viewRGB")
### * viewRGB

flush(stderr()); flush(stdout())

### Name: viewRGB
### Title: Red-Green-Blue map view of a multi-layered Raster object
### Aliases: viewRGB viewRGB,RasterStackBrick-method

### ** Examples

if (interactive()) {
  library(raster)
  library(plainview)

  viewRGB(plainview::poppendorf, 4, 3, 2) # true-color
  viewRGB(plainview::poppendorf, 5, 4, 3) # false-color
}




### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
