
[![Project Status: Active – The project is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active) [![Last-changedate](https://img.shields.io/badge/last%20change-2018--04--23-green.svg)](/commits/master) [![License: GPL-3](https://img.shields.io/badge/License-GPLv3-yellow.svg)](https://opensource.org/licenses/GPL-3.0) [![keybase verified](https://img.shields.io/badge/keybase-verified-brightgreen.svg)](https://gist.github.com/trafficonese/46fbf2ba7b5713151d7e) [![Travis-CI Build Status](https://travis-ci.org/trafficonese/leaflet.extras2.svg?branch=master)](https://travis-ci.org/trafficonese/leaflet.extras2) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/trafficonese/leaflet.extras2?branch=master&svg=true)](https://ci.appveyor.com/project/trafficonese/leaflet.extras) [![packageversion](https://img.shields.io/badge/Package%20version-1.0.0-orange.svg?style=flat-square)](commits/master) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/leaflet.extras)](https://cran.r-project.org/package=leaflet.extras) [![](http://cranlogs.r-pkg.org/badges/grand-total/leaflet.extras)](http://cran.rstudio.com/web/packages/leaflet.extras/index.html)

leaflet.extras2
--------------

The goal of `leaflet.extras2` package is to provide extra functionality to the [leaflet](https://cran.r-project.org/web/packages/leaflet/index.html) R package using various [leaflet plugins](http://leafletjs.com/plugins).

### Installation

For CRAN version

``` r
install.packages('leaflet.extras2')
```

For latest development version

``` r
# We need latest leaflet package from Github, as CRAN package is too old.
devtools::install_github('rstudio/leaflet')
devtools::install_github('trafficonese/leaflet.extras2')
```

### Progress

Plugins integrated so far ...

-   [Pulse Icon](https://github.com/mapshakers/leaflet-icon-pulse):


If you need a plugin that is not already implemented create an [issue](https://github.com/trafficonese/leaflet.extras2/issues/new). See the [FAQ](#FAQ) section below for details.

### Documentation

The R functions have been documented using roxygen, and should provide enough help to get started on using a feature. However some plugins have lots of options and it's not feasible to document every single detail. In such cases you are encouraged to check the plugin's documentation.

Currently there are no vignettes (contributions welcome), but there are plenty of [examples](https://github.com/trafficonese/leaflet.extras2/tree/master/inst/examples) available. You can see most of these examples in action at [Rpubs:trafficonese](http://rpubs.com/trafficonese).

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

*I need a plugin which requires 1.x version of the leaflet JavaScript library*

As of version 1.0.0, `leaflet.extras2` supports leaflet.js version 1.x.


### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
