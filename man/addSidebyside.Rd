% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sidebyside.R
\name{addSidebyside}
\alias{addSidebyside}
\title{Add Side by Side View}
\usage{
addSidebyside(
  map,
  layerId = NULL,
  leftId = NULL,
  rightId = NULL,
  options = list(thumbSize = 42, padding = 0)
)
}
\arguments{
\item{map}{a map widget}

\item{layerId}{the layer id, needed for \code{\link{removeSidebyside}}}

\item{leftId}{the \code{layerId} of the Tile layer that should be
visible on the \strong{left} side}

\item{rightId}{the \code{layerId} of the Tile layer that should be
visible on the \strong{right} side}

\item{options}{A list of options. Currently only \code{thumbSize} and
\code{padding} can be changed.}
}
\value{
the new \code{map} object
}
\description{
A Leaflet control to add a split screen to compare two map overlays.
The plugin works with Panes, see the example.
}
\note{
It is currently not working correctly if the \code{baseGroups} are
  defined in \code{\link[leaflet]{addLayersControl}}.
}
\examples{
library(leaflet)
library(leaflet.extras2)

leaflet(quakes) \%>\%
  addMapPane("left", zIndex = 0) \%>\%
  addMapPane("right", zIndex = 0) \%>\%
  addTiles(
    group = "base", layerId = "baseid",
    options = pathOptions(pane = "right")
  ) \%>\%
  addProviderTiles(providers$CartoDB.DarkMatter,
    group = "carto", layerId = "cartoid",
    options = pathOptions(pane = "left")
  ) \%>\%
  addCircleMarkers(
    data = breweries91[1:15, ], color = "blue", group = "blue",
    options = pathOptions(pane = "left")
  ) \%>\%
  addCircleMarkers(data = breweries91[15:20, ], color = "yellow", group = "yellow") \%>\%
  addCircleMarkers(
    data = breweries91[15:30, ], color = "red", group = "red",
    options = pathOptions(pane = "right")
  ) \%>\%
  addLayersControl(overlayGroups = c("blue", "red", "yellow")) \%>\%
  addSidebyside(
    layerId = "sidecontrols",
    rightId = "baseid",
    leftId = "cartoid"
  )
}
\references{
\url{https://github.com/digidem/leaflet-side-by-side}
}
\seealso{
Other Sidebyside Functions: 
\code{\link{removeSidebyside}()}
}
\concept{Sidebyside Functions}
