% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/antpath.R
\name{antpathOptions}
\alias{antpathOptions}
\title{Antpath Options}
\usage{
antpathOptions(
  delay = 400,
  paused = FALSE,
  reverse = FALSE,
  hardwareAccelerated = FALSE,
  dashArray = c(10, 20),
  pulseColor = "#ffffff",
  lineCap = NULL,
  lineJoin = NULL,
  interactive = TRUE,
  pointerEvents = NULL,
  className = "",
  ...
)
}
\arguments{
\item{delay}{Add a delay to the animation flux. Default is \code{400}}

\item{paused}{Should the animation be paused. Default is \code{FALSE}}

\item{reverse}{Defines if the flow follows the path order or not. Default is
\code{FALSE}}

\item{hardwareAccelerated}{Makes the animation run with hardware
acceleration. Default is \code{FALSE}}

\item{dashArray}{The size of the animated dashes. Default is \code{c(10, 20)}}

\item{pulseColor}{Adds a color to the dashed flux. Default is \code{#ffffff}}

\item{lineCap}{a string that defines
\href{https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-linecap}{shape
 to be used at the end} of the stroke}

\item{lineJoin}{a string that defines
\href{https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/stroke-linejoin}{shape
 to be used at the corners} of the stroke}

\item{interactive}{whether the element emits mouse events}

\item{pointerEvents}{sets the \code{pointer-events} attribute on the path if
SVG backend is used}

\item{className}{a CSS class name set on an element}

\item{...}{extra options passed to underlying Javascript object constructor.}
}
\value{
A list of options for \code{addAntpath} animated polylines
}
\description{
Additional list of options for 'ant-path' animated polylines.
}
\seealso{
Other Antpath Functions: 
\code{\link{addAntpath}()},
\code{\link{clearAntpath}()},
\code{\link{removeAntpath}()}
}
\concept{Antpath Functions}
