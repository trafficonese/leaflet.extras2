# leaflet.extras2

<!-- badges: start -->
[![](https://www.r-pkg.org/badges/version/leaflet.extras2)](https://www.r-pkg.org/pkg/leaflet.extras2)
[![R build status](https://github.com/trafficonese/leaflet.extras2/workflows/R-CMD-check/badge.svg)](https://github.com/trafficonese/leaflet.extras2/actions)
[![cran checks](https://badges.cranchecks.info/worst/leaflet.extras2.svg)](https://cran.r-project.org/web/checks/check_results_leaflet.extras2.html)
[![CRAN RStudio mirror downloads](https://cranlogs.r-pkg.org/badges/leaflet.extras2?color=brightgreen)](https://www.r-pkg.org/pkg/leaflet.extras2)
[![CRAN Downloads](http://cranlogs.r-pkg.org/badges/grand-total/leaflet.extras2)](https://rdrr.io/cran/leaflet.extras2/)
[![Codecov test coverage](https://codecov.io/gh/trafficonese/leaflet.extras2/branch/master/graph/badge.svg)](https://app.codecov.io/gh/trafficonese/leaflet.extras2?branch=master)
<!-- badges: end -->

The goal of `leaflet.extras2` package is to provide extra functionality to the [leaflet](https://cran.r-project.org/package=leaflet) and [leaflet.extras](https://github.com/bhaskarvk/leaflet.extras) R packages using various leaflet plugins.

### Installation

For CRAN version

``` r
install.packages('leaflet.extras2')
```

For latest development version

``` r
remotes::install_github('trafficonese/leaflet.extras2')
```

### Integrated Plugins

If you need a plugin that is not already implemented create an [issue](https://github.com/trafficonese/leaflet.extras2/issues/new). See the [FAQ](#FAQ) section below for details.

-   [Ant Path](https://github.com/rubenspgcavalcante/leaflet-ant-path)
-   [Arrowheads](https://github.com/slutske22/leaflet-arrowheads)
-   [Contextmenu](https://github.com/aratcliffe/Leaflet.contextmenu)
-   [Easy Print](https://github.com/rowanwins/leaflet-easyPrint)
-   [GIBS](https://github.com/aparshin/leaflet-GIBS)
-   [Heightgraph](https://github.com/GIScience/Leaflet.Heightgraph)
-   [Hexbin-D3](https://github.com/bluehalo/leaflet-d3#hexbins-api)
-   [History](https://github.com/cscott530/leaflet-history)
-   [Labelgun](https://github.com/Geovation/labelgun)
-   [Leaflet.Sync](https://github.com/jieter/Leaflet.Sync)
-   [Mapkey Icons](https://github.com/mapshakers/leaflet-mapkey-icon)
-   [Moving Markers](https://github.com/ewoken/Leaflet.MovingMarker)
-   [OpenWeatherMap](https://github.com/trafficonese/leaflet-openweathermap)
-   [Playback](https://github.com/hallahan/LeafletPlayback)
-   [Reachability](https://github.com/traffordDataLab/leaflet.reachability)
-   [Sidebar-v2](https://github.com/Turbo87/sidebar-v2)
-   [Side-by-Side](https://github.com/digidem/leaflet-side-by-side)
-   [Spin](https://github.com/makinacorpus/Leaflet.Spin)
-   [Timeslider](https://github.com/dwilhelm89/LeafletSlider)
-   [Tangram](https://github.com/tangrams/tangram)
-   [Velocity](https://github.com/onaci/leaflet-velocity)
-   [WMS](https://github.com/heigeo/leaflet.wms)


### Documentation

The R functions have been documented using roxygen, and should provide enough help to get started on using a feature. However some plugins have lots of options and it's not feasible to document every single detail. In such cases you are encouraged to check the plugin's documentation and the [examples](https://github.com/trafficonese/leaflet.extras2/tree/master/inst/examples).

### FAQ

*I want to use a certain leaflet plugin not integrated so far.*

-   **Good Solution**: Create issues for plugins you wish incorporated but before that search the existing issues to see if issue already exists and if so comment on that issue instead of creating duplicates.
-   **Better Solution**: It would help in prioritizing if you can include additional details like why you need the plugin, how helpful will it be to everyone etc.
-   **Best Solution**: Code it yourself and submit a pull request. This is the fastest way to get a plugin into the package. Checkout this little [tutorial](https://github.com/trafficonese/leaflet.extras2/blob/master/HowTo.md).

*I submitted an issue for a plugin long time ago but it is still not available.*

This package is being developed purely on a voluntary basis on spare time without any monetary compensation. So the development progress can stall at times. It may also not be possible to prioritize one-off requests that no one else is interested in. Getting more people interested in a feature request will help prioritize development. Other option is to contribute code. That will get you added to the contributor list.

*I found a bug.*

-   **Good Solution**: Search existing issue list and if no one has reported it create a new issue.
-   **Better Solution**: Along with issue submission provide a minimal reproducible code sample.
-   **Best Solution**: Fix the issue and submit a pull request. This is the fastest way to get a bug fixed.


### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
