# leaflet.extras2


The goal of `leaflet.extras2` package is to provide extra functionality to the [leaflet](https://cran.r-project.org/web/packages/leaflet/index.html) and [leaflet.extras](https://github.com/bhaskarvk/leaflet.extras) R packages using various [leaflet plugins](http://leafletjs.com/plugins).

### Installation

For CRAN version

``` r
install.packages('leaflet.extras2')
```

For latest development version

``` r
remotes::install_github('trafficonese/leaflet.extras2')
```

### Progress

Plugins integrated so far ...

-   [Ant Path](https://github.com/rubenspgcavalcante/leaflet-ant-path)
-   [Easy Print](https://github.com/rowanwins/leaflet-easyPrint)
-   [Mapkey Icons](https://github.com/mapshakers/leaflet-icon-mapkey)
-   [Playback](https://github.com/hallahan/LeafletPlayback)
-   [Reachability](https://github.com/traffordDataLab/leaflet.reachability)
-   [Side-by-Side](https://github.com/digidem/leaflet-side-by-side)
-   [Tangram](https://github.com/tangrams/tangram)
-   [Velocity](https://github.com/danwild/leaflet-velocity)
-   [WMS](https://github.com/heigeo/leaflet.wms)


If you need a plugin that is not already implemented create an [issue](https://github.com/trafficonese/leaflet.extras2/issues/new). See the [FAQ](#FAQ) section below for details.

### Documentation

The R functions have been documented using roxygen, and should provide enough help to get started on using a feature. However some plugins have lots of options and it's not feasible to document every single detail. In such cases you are encouraged to check the plugin's documentation.

Currently there are no vignettes (contributions welcome), but there are plenty of [examples](https://github.com/trafficonese/leaflet.extras2/tree/master/inst/examples) available.

### FAQ

*I want to use a certain leaflet plugin not integrated so far.*

-   **Good Solution**: Create issues for plugins you wish incorporated but before that search the existing issues to see if issue already exists and if so comment on that issue instead of creating duplicates.
-   **Better Solution**: It would help in prioritizing if you can include additional details like why you need the plugin, how helpful will it be to everyone etc.
-   **Best Solution**: Code it yourself and submit a pull request. This is the fastest way to get a plugin into the package.

*I submitted an issue for a plugin long time ago but it is still not available.*

This package is being developed purely on a voluntary basis on spare time without any monetary compensation. So the development progress can stall at times. It may also not be possible to prioritize one-off requests that no one else is interested in. Getting more people interested in a feature request will help prioritize development. Other option is to contribute code. That will get you added to the contributer list and a thanks tweet.

*I found a bug.*

-   **Good Solution**: Search existing issue list and if no one has reported it create a new issue.
-   **Better Solution**: Along with issue submission provide a minimal reproducible code sample.
-   **Best Solution**: Fix the issue and submit a pull request. This is the fastest way to get a bug fixed.


### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
