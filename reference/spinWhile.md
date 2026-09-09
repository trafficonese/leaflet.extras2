# Run work while a map spinner is visible (Shiny)

Starts the spinner, waits until the browser has painted it (and Shiny
has flushed that update), then evaluates `expr` and always stops the
spinner.

## Usage

``` r
spinWhile(
  mapId,
  expr,
  options = NULL,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- mapId:

  The `outputId` of the `leafletOutput`.

- expr:

  Expression to evaluate after the spinner is shown.

- options:

  Passed to
  [`startSpinner`](https://trafficonese.github.io/leaflet.extras2/reference/addSpinner.md).

- session:

  The Shiny session; default is the current domain.

## Value

The Shiny session (invisible).

## See also

Other Spinner Functions:
[`addSpinner()`](https://trafficonese.github.io/leaflet.extras2/reference/addSpinner.md)

## Examples

``` r
if (FALSE) { # \dontrun{
observeEvent(input$go, {
  spinWhile("leaf", {
    Sys.sleep(2)
    leafletProxy("leaf") %>% addMarkers(data = quakes, ~long, ~lat)
  })
})
} # }
```
