
test_that("clustercharts", {

  # shipIcon <- leaflet::makeIcon(
  #   iconUrl = "./icons/Icon5.svg"
  #   ,className = "lsaicons"
  #   ,iconWidth = 24, iconHeight = 24, iconAnchorX = 0, iconAnchorY = 0
  # )


  ## data ##########
  data <- sf::st_as_sf(breweries91)
  data$category <- sample(c("Schwer", "Mäßig", "Leicht", "kein Schaden"), size = nrow(data), replace = TRUE)
  data$label <- paste0(data$brewery, "<br>", data$address)
  data$id <- paste0("ID", seq.int(nrow(data)))
  data$popup <- paste0("<h6>", data$brewery, "</h6><div>", data$address, "</div>")
  data$tosum <- sample(1:100, nrow(data), replace = TRUE)
  data$tosumlabel <- paste("Sum: ", data$tosum)
  data$web <- gsub(">(.*?)<", ">",data$tosum,"<", data$web)
  data$web <- ifelse(is.na(data$web), "", paste0("<div class='markerhtml'>", data$web, "</div>"))

  ## simple example  ##########
  m <- leaflet() %>% addProviderTiles("CartoDB") %>%
    addClusterCharts(data = data
                     , categoryField = "category"
                     , categoryMap =
                       data.frame(labels = c("Schwer", "Mäßig", "Leicht", "kein Schaden"),
                                  colors  = c("lightblue", "orange", "lightyellow", "lightgreen")))
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-clustercharts")
  expect_equal(deps[[length(deps)-1]]$name, "leaflet-markercluster")
  expect_equal(deps[[length(deps)-2]]$name, "lfx-clustercharts-css")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "addClusterCharts")

  ## simple example (SP-data)  ##########
  m <- leaflet() %>% addProviderTiles("CartoDB") %>%
    addClusterCharts(data = as(data, "Spatial")
                     , categoryField = "category"
                     , categoryMap =
                       data.frame(labels = c("Schwer", "Mäßig", "Leicht", "kein Schaden"),
                                  colors  = c("lightblue", "orange", "lightyellow", "lightgreen")))
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-clustercharts")
  expect_equal(deps[[length(deps)-1]]$name, "leaflet-markercluster")
  expect_equal(deps[[length(deps)-2]]$name, "lfx-clustercharts-css")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "addClusterCharts")

  ## simple example with popupFields / popupLabels ##########
  m <- leaflet() %>% addProviderTiles("CartoDB") %>%
    addClusterCharts(data = data
                     , categoryField = "category"
                     , categoryMap =
                       data.frame(labels = c("Schwer", "Mäßig", "Leicht", "kein Schaden"),
                                  colors  = c("lightblue", "orange", "lightyellow", "lightgreen"))
                     , popupFields = c("id","brewery","address","zipcode", "category","tosum")
                     , popupLabels = c("id","Brauerei","Addresse","PLZ", "Art", "tosum")
                     )
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-clustercharts")
  expect_equal(deps[[length(deps)-1]]$name, "leaflet-markercluster")
  expect_equal(deps[[length(deps)-2]]$name, "lfx-clustercharts-css")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "addClusterCharts")

  m <- leaflet() %>% addProviderTiles("CartoDB") %>%
    addClusterCharts(data = data
                     , categoryField = "category"
                     , categoryMap =
                       data.frame(labels = c("Schwer", "Mäßig", "Leicht", "kein Schaden"),
                                  colors  = c("lightblue", "orange", "lightyellow", "lightgreen"))
                     , popupFields = c("id","brewery","address","zipcode", "category","tosum")
    )
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-clustercharts")
  expect_equal(deps[[length(deps)-1]]$name, "leaflet-markercluster")
  expect_equal(deps[[length(deps)-2]]$name, "lfx-clustercharts-css")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "addClusterCharts")

  ## No `categoryMap` - Error ##########
  m <- expect_error(
    leaflet() %>%
      addProviderTiles("CartoDB") %>%
      addClusterCharts(data = data
                       , categoryField = "category"
      ))

  ## No `categoryField` - Error ##########
  m <- expect_error(
    leaflet() %>%
      addProviderTiles("CartoDB") %>%
      addClusterCharts(data = data
                       , categoryMap =
                         data.frame(colors  = c("lightblue", "orange", "lightyellow", "lightgreen")
                         )
      ))

  ## No `colors` in `categoryMap` ##########
  m <- expect_warning(
    leaflet() %>%
    addProviderTiles("CartoDB") %>%
    addClusterCharts(data = data
                     , categoryField = "category"
                     , categoryMap =
                       data.frame(labels = c("Schwer", "Mäßig", "Leicht", "kein Schaden")
                                  # ,colors  = c("lightblue", "orange", "lightyellow", "lightgreen")
                                  )
    ))
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-clustercharts")
  expect_equal(deps[[length(deps)-1]]$name, "leaflet-markercluster")
  expect_equal(deps[[length(deps)-2]]$name, "lfx-clustercharts-css")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "addClusterCharts")

  ## No `labels` in `categoryMap` ##########
  m <- expect_warning(
    leaflet() %>%
      addProviderTiles("CartoDB") %>%
      addClusterCharts(data = data
                       , categoryField = "category"
                       , categoryMap =
                         data.frame(colors  = c("lightblue", "orange", "lightyellow", "lightgreen")
                         )
      ))
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-clustercharts")
  expect_equal(deps[[length(deps)-1]]$name, "leaflet-markercluster")
  expect_equal(deps[[length(deps)-2]]$name, "lfx-clustercharts-css")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "addClusterCharts")

  ## Multiple Sizes ##########
  m <- leaflet() %>%
      addProviderTiles("CartoDB") %>%
      addClusterCharts(data = data
                       , categoryField = "category"
                       , categoryMap =
                         data.frame(labels = c("Schwer", "Mäßig", "Leicht", "kein Schaden")
                                    ,colors  = c("lightblue", "orange", "lightyellow", "lightgreen")
                         )
                       , options = clusterchartOptions(size = c(10,40))
      )
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-clustercharts")
  expect_equal(deps[[length(deps)-1]]$name, "leaflet-markercluster")
  expect_equal(deps[[length(deps)-2]]$name, "lfx-clustercharts-css")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "addClusterCharts")

  ## Icons (single) ##########
  shipIcon <- makeIcon(
    iconUrl = "https://cdn-icons-png.flaticon.com/512/1355/1355883.png",
    iconWidth = 40, iconHeight = 50,
    iconAnchorX = 0, iconAnchorY = 0
  )
  m <- leaflet() %>%
    addProviderTiles("CartoDB") %>%
    addClusterCharts(data = data
                     , categoryField = "category"
                     , icon = shipIcon
                     , categoryMap =
                       data.frame(labels = c("Schwer", "Mäßig", "Leicht", "kein Schaden")
                                  ,colors  = c("lightblue", "orange", "lightyellow", "lightgreen")
                       )
                     , popupFields = c("id","brewery","address","zipcode", "category","tosum","tosum2")
                     , popupLabels = c("id","Brauerei","Addresse","PLZ", "Art", "tosum","tosum2")
                     , label = "label"
                     , options = clusterchartOptions(size = 50)
    )
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-clustercharts")
  expect_equal(deps[[length(deps)-1]]$name, "leaflet-markercluster")
  expect_equal(deps[[length(deps)-2]]$name, "lfx-clustercharts-css")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "addClusterCharts")

  ## Icons (multiple) ##########
  shipIcon <- iconList(
      "Schwer"       = makeIcon("https://leafletjs.com/examples/custom-icons/leaf-red.png",
                                iconWidth = 40, iconHeight = 50),
      "Mäßig"        = makeIcon("https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Maki2-ferry-18.svg/480px-Maki2-ferry-18.svg.png",
                                iconWidth = 40),
      "Leicht"       = makeIcon("https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Maki2-danger-24.svg/240px-Maki2-danger-24.svg.png",
                                iconWidth = 40),
      "kein Schaden" = makeIcon("https://leafletjs.com/examples/custom-icons/leaf-green.png",
                                iconWidth = 40, iconHeight = 50)
    )
  m <- leaflet() %>%
    addProviderTiles("CartoDB") %>%
    addClusterCharts(data = data
                     , categoryField = "category"
                     , icon = shipIcon
                     , categoryMap =
                       data.frame(labels = c("Schwer", "Mäßig", "Leicht", "kein Schaden")
                                  ,colors  = c("lightblue", "orange", "lightyellow", "lightgreen")
                       )
                     , popupFields = c("id","brewery","address","zipcode", "category","tosum","tosum2")
                     , popupLabels = c("id","Brauerei","Addresse","PLZ", "Art", "tosum","tosum2")
                     , label = "label"
                     , options = clusterchartOptions(size = c(30,35))
    )
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-clustercharts")
  expect_equal(deps[[length(deps)-1]]$name, "leaflet-markercluster")
  expect_equal(deps[[length(deps)-2]]$name, "lfx-clustercharts-css")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "addClusterCharts")

  ## Icons in `categoryMap`  ##########
  iconvec <- c("https://leafletjs.com/examples/custom-icons/leaf-red.png",
              "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Maki2-ferry-18.svg/480px-Maki2-ferry-18.svg.png",
              "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Maki2-ferry-18.svg/480px-Maki2-ferry-18.svg.png",
              "https://leafletjs.com/examples/custom-icons/leaf-green.png")
  m <- leaflet() %>% addProviderTiles("CartoDB") %>%
    addClusterCharts(data = as(data, "Spatial")
                     , categoryField = "category"
                     , categoryMap =
                       data.frame(labels = c("Schwer", "Mäßig", "Leicht", "kein Schaden"),
                                  colors  = c("lightblue", "orange", "lightyellow", "lightgreen"),
                                  icons = iconvec)
                     , options = clusterchartOptions(size = 50)
                     , popupFields = c("id","brewery","address","zipcode", "category","tosum","tosum2")
                     , popupLabels = c("id","Brauerei","Addresse","PLZ", "Art", "tosum","tosum2")
                     , label = "label")
  deps <- findDependencies(m)
  expect_equal(deps[[length(deps)]]$name, "lfx-clustercharts")
  expect_equal(deps[[length(deps)-1]]$name, "leaflet-markercluster")
  expect_equal(deps[[length(deps)-2]]$name, "lfx-clustercharts-css")
  expect_equal(m$x$calls[[length(m$x$calls)]]$method, "addClusterCharts")

  ## ALL ############
  m <- leaflet() %>% addMapPane("clusterpane", 420) %>%
    addClusterCharts(data = data
                     , aggregation = "sum"
                     , valueField = "tosum"
                     , options = clusterchartOptions(rmax = 50,
                                                     size = 40,
                                                     # size = c(100,140),
                                                     labelBackground = TRUE,
                                                     labelStroke = "orange",
                                                     labelColor = "gray",
                                                     labelOpacity = 0.5,
                                                     innerRadius = 20,
                                                     digits = 0,
                                                     sortTitlebyCount = TRUE)
                     # , type = "bar"
                     # , type = "horizontal"
                     # , type = "custom"
                     , categoryField = "category"
                     , html = "web"
                     , icon = shipIcon
                     , categoryMap =
                       data.frame(labels = c("Schwer", "Mäßig", "Leicht", "kein Schaden"),
                                  colors  = c("lightblue", "orange", "lightyellow", "lightgreen"))
                     , group = "clustermarkers"
                     , layerId = "id"
                     , clusterId = "id"
                     , popupFields = c("id","brewery","address","zipcode", "category","tosum","tosum2")
                     , popupLabels = c("id","Brauerei","Addresse","PLZ", "Art", "tosum","tosum2")
                     , label = "label"
                     , markerOptions = markerOptions(interactive = TRUE,
                                                     draggable = TRUE,
                                                     keyboard = TRUE,
                                                     title = "Some Marker Title",
                                                     zIndexOffset = 100,
                                                     opacity = 1,
                                                     riseOnHover = TRUE,
                                                     riseOffset = 400)
                     , legendOptions = list(position = "bottomright", title = "Unfälle im Jahr 2003")
                     , clusterOptions = markerClusterOptions(showCoverageOnHover = TRUE,
                                                             zoomToBoundsOnClick = TRUE,
                                                             spiderfyOnMaxZoom = TRUE,
                                                             removeOutsideVisibleBounds = TRUE,
                                                             spiderLegPolylineOptions = list(weight = 1.5, color = "#222", opacity = 0.5),
                                                             freezeAtZoom = TRUE,
                                                             clusterPane = "clusterpane",
                                                             spiderfyDistanceMultiplier = 2
                     )
                     , labelOptions = labelOptions(opacity = 0.8, textsize = "14px")
                     , popupOptions = popupOptions(maxWidth = 900, minWidth = 200, keepInView = TRUE)
    )

})
