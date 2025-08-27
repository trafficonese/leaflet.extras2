test_that("playback", {
  ## Fake SF Data ##########################
  data <- structure(
    list(
      time = structure(c(
        1588259759.91989, 1588259770.0209,
        1588259780.12191, 1588259790.22292, 1588259800.32393, 1588259810.42494,
        1588259820.52595, 1588259830.62696, 1588259840.72797, 1588259850.82898,
        1588259860.92999, 1588259871.031, 1588259881.13201, 1588259891.23302,
        1588259901.33403, 1588259911.43504, 1588259921.53605, 1588259931.63706,
        1588259941.73807, 1588259951.83908, 1588259961.94009, 1588259972.0411,
        1588259982.14211, 1588259992.24312, 1588260002.34413, 1588260012.44514,
        1588260022.54615, 1588260032.64716, 1588260042.74817, 1588260052.84918,
        1588260062.95019, 1588260073.0512, 1588260083.15221, 1588260093.25322,
        1588260103.35423, 1588260113.45524, 1588260123.55625, 1588260133.65726,
        1588260143.75828, 1588260153.85929, 1588260163.9603, 1588260174.06131,
        1588260184.16232, 1588260194.26333, 1588260204.36434, 1588260214.46535,
        1588260224.56636, 1588260234.66737, 1588260244.76838, 1588260254.86939,
        1588260264.9704, 1588260275.07141, 1588260285.17242, 1588260295.27343,
        1588260305.37444, 1588260315.47545, 1588260325.57646, 1588260335.67747,
        1588260345.77848, 1588260355.87949, 1588260365.9805, 1588260376.08151,
        1588260386.18252, 1588260396.28353, 1588260406.38454, 1588260416.48555,
        1588260426.58656, 1588260436.68757, 1588260446.78858, 1588260456.88959,
        1588260466.9906, 1588260477.09161, 1588260487.19262, 1588260497.29363,
        1588260507.39464, 1588260517.49565, 1588260527.59666, 1588260537.69767,
        1588260547.79868, 1588260557.89969, 1588260568.0007, 1588260578.10171,
        1588260588.20272, 1588260598.30373, 1588260608.40474, 1588260618.50575,
        1588260628.60676, 1588260638.70777, 1588260648.80878, 1588260658.90979,
        1588260669.0108, 1588260679.11181, 1588260689.21282, 1588260699.31383,
        1588260709.41484, 1588260719.51585, 1588260729.61686, 1588260739.71787,
        1588260749.81888, 1588260759.91989
      ), class = c("POSIXct", "POSIXt")),
      geometry = structure(
        list(
          structure(c(11.5772219742974, 49.9435995815242), class = c("XY", "POINT", "sfg")),
          structure(c(11.5772673739855, 49.9435878842157), class = c("XY", "POINT", "sfg")),
          structure(c(11.577312773651, 49.9435761868898), class = c("XY", "POINT", "sfg")),
          structure(c(11.5773581732939, 49.9435644895464), class = c("XY", "POINT", "sfg")),
          structure(c(11.5774035729143, 49.9435527921855), class = c("XY", "POINT", "sfg")),
          structure(c(11.5774489725121, 49.9435410948072), class = c("XY", "POINT", "sfg")),
          structure(c(11.5774943720874, 49.9435293974114), class = c("XY", "POINT", "sfg")),
          structure(c(11.57753977164, 49.9435176999982), class = c("XY", "POINT", "sfg")),
          structure(c(11.5775851711701, 49.9435060025675), class = c("XY", "POINT", "sfg")),
          structure(c(11.5776305706777, 49.9434943051193), class = c("XY", "POINT", "sfg")),
          structure(c(11.5776759701626, 49.9434826076537), class = c("XY", "POINT", "sfg")),
          structure(c(11.577721369625, 49.9434709101707), class = c("XY", "POINT", "sfg")),
          structure(c(11.5777667690649, 49.9434592126701), class = c("XY", "POINT", "sfg")),
          structure(c(11.5778121684821, 49.9434475151521), class = c("XY", "POINT", "sfg")),
          structure(c(11.5778575678768, 49.9434358176167), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779029672489, 49.9434241200638), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779483665984, 49.9434124224934), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779536762059, 49.9434380981275), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779526946093, 49.9434696386675), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779517130123, 49.9435011792074), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779507314147, 49.9435327197471), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779497498166, 49.9435642602867), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779487682181, 49.9435958008262), class = c("XY", "POINT", "sfg")),
          structure(c(11.577947786619, 49.9436273413655), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779468050194, 49.9436588819046), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779458234194, 49.9436904224437), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779448418188, 49.9437219629825), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779438602177, 49.9437535035213), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779428786161, 49.9437850440598), class = c("XY", "POINT", "sfg")),
          structure(c(11.577941897014, 49.9438165845983), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779409154114, 49.9438481251366), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779399338083, 49.9438796656747), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779389522047, 49.9439112062128), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779379706006, 49.9439427467506), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779369889959, 49.9439742872884), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779360073908, 49.944005827826), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779350257852, 49.9440373683634), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779340441791, 49.9440689089007), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779330625724, 49.9441004494378), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779320809653, 49.9441319899749), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779310993576, 49.9441635305117), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779301177495, 49.9441950710485), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779291361408, 49.944226611585), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779281545317, 49.9442581521215), class = c("XY", "POINT", "sfg")),
          structure(c(11.577927172922, 49.9442896926578), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779261913118, 49.9443212331939), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779252097011, 49.9443527737299), class = c("XY", "POINT", "sfg")),
          structure(c(11.57792422809, 49.9443843142658), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779232464783, 49.9444158548015), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779222648661, 49.9444473953371), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779212832534, 49.9444789358726), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779203016402, 49.9445104764078), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779193200265, 49.944542016943), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779183384123, 49.944573557478), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779173567976, 49.9446050980129), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779163751823, 49.9446366385476), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779153935666, 49.9446681790822), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779144119504, 49.9446997196166), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779134303337, 49.9447312601509), class = c("XY", "POINT", "sfg")),
          structure(c(11.5779124487164, 49.9447628006851), class = c("XY", "POINT", "sfg")),
          structure(c(11.577883894105, 49.9447454656367), class = c("XY", "POINT", "sfg")),
          structure(c(11.5778517199191, 49.9447217145089), class = c("XY", "POINT", "sfg")),
          structure(c(11.577819545765, 49.9446979633717), class = c("XY", "POINT", "sfg")),
          structure(c(11.5777873716427, 49.944674212225), class = c("XY", "POINT", "sfg")),
          structure(c(11.5777551975522, 49.9446504610688), class = c("XY", "POINT", "sfg")),
          structure(c(11.5777230234934, 49.944626709903), class = c("XY", "POINT", "sfg")),
          structure(c(11.5776908494664, 49.9446029587277), class = c("XY", "POINT", "sfg")),
          structure(c(11.5776586754712, 49.9445792075429), class = c("XY", "POINT", "sfg")),
          structure(c(11.5776265015077, 49.9445554563486), class = c("XY", "POINT", "sfg")),
          structure(c(11.577594327576, 49.9445317051447), class = c("XY", "POINT", "sfg")),
          structure(c(11.5775727043665, 49.9445043209944), class = c("XY", "POINT", "sfg")),
          structure(c(11.5775600454878, 49.9444738501444), class = c("XY", "POINT", "sfg")),
          structure(c(11.5775473866256, 49.9444433792927), class = c("XY", "POINT", "sfg")),
          structure(c(11.5775347277802, 49.9444129084391), class = c("XY", "POINT", "sfg")),
          structure(c(11.5775220689514, 49.9443824375838), class = c("XY", "POINT", "sfg")),
          structure(c(11.5775094101392, 49.9443519667267), class = c("XY", "POINT", "sfg")),
          structure(c(11.5774967513437, 49.9443214958678), class = c("XY", "POINT", "sfg")),
          structure(c(11.5774840925649, 49.9442910250071), class = c("XY", "POINT", "sfg")),
          structure(c(11.5774714338027, 49.9442605541447), class = c("XY", "POINT", "sfg")),
          structure(c(11.5774587750572, 49.9442300832804), class = c("XY", "POINT", "sfg")),
          structure(c(11.5774461163283, 49.9441996124145), class = c("XY", "POINT", "sfg")),
          structure(c(11.5774334576161, 49.9441691415467), class = c("XY", "POINT", "sfg")),
          structure(c(11.5774207989206, 49.9441386706771), class = c("XY", "POINT", "sfg")),
          structure(c(11.5774081402417, 49.9441081998058), class = c("XY", "POINT", "sfg")),
          structure(c(11.5773954815794, 49.9440777289326), class = c("XY", "POINT", "sfg")),
          structure(c(11.5773828229339, 49.9440472580578), class = c("XY", "POINT", "sfg")),
          structure(c(11.5773701643049, 49.9440167871811), class = c("XY", "POINT", "sfg")),
          structure(c(11.5773575056927, 49.9439863163026), class = c("XY", "POINT", "sfg")),
          structure(c(11.5773448470971, 49.9439558454224), class = c("XY", "POINT", "sfg")),
          structure(c(11.5773321885181, 49.9439253745404), class = c("XY", "POINT", "sfg")),
          structure(c(11.5773195299558, 49.9438949036566), class = c("XY", "POINT", "sfg")),
          structure(c(11.5773068714102, 49.943864432771), class = c("XY", "POINT", "sfg")),
          structure(c(11.5772942128812, 49.9438339618837), class = c("XY", "POINT", "sfg")),
          structure(c(11.5772815543689, 49.9438034909946), class = c("XY", "POINT", "sfg")),
          structure(c(11.5772688958733, 49.9437730201036), class = c("XY", "POINT", "sfg")),
          structure(c(11.5772562373943, 49.943742549211), class = c("XY", "POINT", "sfg")),
          structure(c(11.5772435789319, 49.9437120783165), class = c("XY", "POINT", "sfg")),
          structure(c(11.5772309204862, 49.9436816074203), class = c("XY", "POINT", "sfg")),
          structure(c(11.5772182620572, 49.9436511365222), class = c("XY", "POINT", "sfg")),
          structure(c(11.5772056036448, 49.9436206656224), class = c("XY", "POINT", "sfg"))
        ),
        precision = 0,
        bbox = structure(
          c(
            xmin = 11.5772056036448,
            ymin = 49.9434124224934,
            xmax = 11.5779536762059,
            ymax = 49.9447628006851
          ),
          class = "bbox"
        ),
        crs = structure(list(
          epsg = 4326L,
          proj4string = "+proj=longlat +datum=WGS84 +no_defs"
        ), class = "crs"),
        n_empty = 0L, class = c("sfc_POINT", "sfc"), ids = 100L
      )
    ),
    row.names = c(NA, 100L), class = c("sf", "data.frame"),
    sf_column = "geometry", agr = structure(c(time = NA_integer_),
      .Label = c("constant", "aggregate", "identity"), class = "factor"
    )
  )
  ##############################

  ## Test Single Trail ######################
  data$time <- as.numeric(data$time) * 1000
  m <- leaflet() %>%
    addTiles() %>%
    addPlayback(
      data = data,
      options = playbackOptions(radius = 3),
      pathOpts = pathOptions(weight = 5)
    )
  expect_is(m, "leaflet")
  expect_identical(m$x$calls[[2]]$method, "addPlayback")
  expect_identical(
    m$x$calls[[2]]$args[[1]],
    leaflet.extras2:::to_jsonformat(data, "time")
  )

  m <- m %>% removePlayback()
  expect_is(m, "leaflet")
  expect_identical(m$x$calls[[3]]$method, "removePlayback")


  data$time <- as.numeric(data$time) * 1000
  data$popup1 <- paste0("This is a popup for ", data$time)
  m <- leaflet() %>%
    addTiles() %>%
    addPlayback(
      data = data,
      popup = ~popup1,
      options = playbackOptions(radius = 3),
      pathOpts = pathOptions(weight = 5)
    )
  expect_is(m, "leaflet")
  expect_identical(m$x$calls[[2]]$method, "addPlayback")
  expect_identical(
    m$x$calls[[2]]$args[[1]],
    leaflet.extras2:::to_jsonformat(data, "time", popup = data$popup1)
  )

  data$time <- as.numeric(data$time) * 1000
  data$label1 <- paste0("This is a popup for ", data$time)
  m <- leaflet() %>%
    addTiles() %>%
    addPlayback(
      data = data,
      label = ~label1,
      options = playbackOptions(radius = 3),
      pathOpts = pathOptions(weight = 5)
    )
  expect_is(m, "leaflet")
  expect_identical(m$x$calls[[2]]$method, "addPlayback")
  expect_identical(
    m$x$calls[[2]]$args[[1]],
    leaflet.extras2:::to_jsonformat(data, "time", label = data$label1)
  )

  m <- m %>% removePlayback()
  expect_is(m, "leaflet")
  expect_identical(m$x$calls[[3]]$method, "removePlayback")

  ## Date Time Column
  datadt <- data
  datadt$time <- as.Date(
    seq.Date(Sys.Date() - nrow(datadt), Sys.Date(), length.out = nrow(datadt))
  )
  m <- leaflet() %>%
    addTiles() %>%
    addPlayback(
      data = datadt,
      options = playbackOptions(
        radius = 3,
        tickLen = 1000000,
        speed = 10000000000,
        fadeMarkersWhenStale = TRUE,
        dateControl = TRUE,
        staleTime = 1,
        maxInterpolationTime = 5 * 60 * 1000
      ),
      pathOpts = pathOptions(weight = 5)
    )
  expect_is(m, "leaflet")
  expect_identical(m$x$calls[[2]]$method, "addPlayback")
  datadt$time <- as.numeric(datadt$time) * 86400000
  expect_identical(
    m$x$calls[[2]]$args[[1]],
    leaflet.extras2:::to_jsonformat(datadt, "time")
  )

  ## Other Time Column
  dataot <- data
  dataot$othertime <- as.POSIXct(
    seq.POSIXt(Sys.time() - 1000, Sys.time(), length.out = nrow(dataot))
  )
  dataot$time <- NULL
  m <- leaflet() %>%
    addTiles() %>%
    addPlayback(
      data = dataot, time = "othertime",
      options = playbackOptions(radius = 3),
      pathOpts = pathOptions(weight = 5)
    )
  expect_is(m, "leaflet")
  expect_identical(m$x$calls[[2]]$method, "addPlayback")
  dataotverify <- dataot
  dataotverify$time <- as.numeric(dataotverify$othertime) * 1000
  dataotverify$othertime <- NULL
  expect_identical(
    m$x$calls[[2]]$args[[1]],
    leaflet.extras2:::to_jsonformat(dataotverify, "time")
  )


  ## Errors
  datanotime <- data
  datanotime$time <- NULL
  expect_error(
    leaflet() %>%
      addPlayback(
        data = datanotime,
        options = playbackOptions(radius = 3),
        pathOpts = pathOptions(weight = 5)
      )
  )


  ## Test Multiple Trail ##########################
  data1 <- data
  data2 <- data
  data1$time <- as.numeric(as.POSIXct(
    seq.POSIXt(Sys.time() - 1000, Sys.time(), length.out = nrow(data1))
  )) * 1000
  data2$time <- as.numeric(as.POSIXct(
    seq.POSIXt(Sys.time() - 1300, Sys.time(), length.out = nrow(data2))
  )) * 1000

  datam <- list(data1, data2)
  m <- leaflet() %>%
    addTiles() %>%
    addPlayback(
      data = datam,
      options = playbackOptions(radius = 3),
      pathOpts = pathOptions(weight = 5)
    )
  expect_is(m, "leaflet")
  expect_identical(m$x$calls[[2]]$method, "addPlayback")
  expect_identical(
    m$x$calls[[2]]$args[[1]],
    lapply(datam, function(x) {
      leaflet.extras2:::to_jsonformat(x, "time")
    })
  )

  ## Other Time Column
  data1 <- data
  data2 <- data
  data1$otertime <- as.POSIXct(
    seq.POSIXt(Sys.time() - 1000, Sys.time(), length.out = nrow(data1))
  )
  data2$otertime <- as.POSIXct(
    seq.POSIXt(Sys.time() - 1300, Sys.time(), length.out = nrow(data2))
  )
  data2$time <- NULL
  data1$time <- NULL

  datam <- list(data1, data2)
  m <- leaflet() %>%
    addTiles() %>%
    addPlayback(
      data = datam, time = "otertime",
      options = playbackOptions(radius = 3),
      pathOpts = pathOptions(weight = 5)
    )
  expect_is(m, "leaflet")
  expect_identical(m$x$calls[[2]]$method, "addPlayback")
  expect_identical(
    m$x$calls[[2]]$args[[1]],
    lapply(datam, function(x) {
      leaflet.extras2:::to_jsonformat(x, "otertime")
    })
  )

  ## Errors
  datanotime <- datam
  expect_error(
    leaflet() %>%
      addPlayback(
        data = datanotime, time = "no",
        options = playbackOptions(radius = 3),
        pathOpts = pathOptions(weight = 5)
      )
  )



  ## Test Example ###############
  if (inherits(leaflet::atlStorms2005, "sf")) {
    # starting with leaflet 2.3.0
    crds <- sf::st_coordinates(leaflet::atlStorms2005[1, ])
    df <- data.frame(
      time = as.POSIXct(
        seq.POSIXt(Sys.time() - 1000, Sys.time(), length.out = nrow(crds))
      ),
      x = crds[, 1],
      y = crds[, 2]
    )
    spdf <- sf::st_as_sf(df, coords = c("x", "y"))
  } else {
    # can delete once leaflet 2.3 is required.
    library(sp)
    crds <- coordinates(leaflet::atlStorms2005[1, ])[[1]][[1]]
    df <- data.frame(time = as.POSIXct(
      seq.POSIXt(Sys.time() - 1000, Sys.time(), length.out = nrow(crds))
    ))
    spdf <- SpatialPointsDataFrame(crds, df)
  }
  m <- leaflet() %>%
    addTiles() %>%
    addPlayback(
      data = spdf,
      options = playbackOptions(radius = 3),
      pathOpts = pathOptions(weight = 5)
    )

  expect_is(m, "leaflet")
  expect_identical(m$x$calls[[2]]$method, "addPlayback")
  expect_identical(
    m$x$calls[[2]]$args[[1]],
    leaflet.extras2:::to_jsonformat(spdf, "time")
  )

  if (inherits(leaflet::atlStorms2005, "sf")) {
    # starting with leaflet 2.3.0
    crds1 <- sf::st_coordinates(leaflet::atlStorms2005[10, ])
    df1 <- data.frame(
      time = as.POSIXct(
        seq.POSIXt(Sys.time() - 1000, Sys.time(), length.out = nrow(crds))
      ),
      x = crds1[, 1],
      y = crds1[, 2]
    )
    spdf1 <- sf::st_as_sf(df1, coords = c("x", "y"))
  } else {
    # can delete once leaflet 2.3 is required.
    library(sp)
    crds1 <- coordinates(leaflet::atlStorms2005[10, ])[[1]][[1]]
    df1 <- data.frame(time = as.POSIXct(
      seq.POSIXt(Sys.time() - 1000, Sys.time(), length.out = nrow(crds1))
    ))
    spdf1 <- SpatialPointsDataFrame(crds1, df1)
  }

  spdfm <- list(spdf, spdf1)
  m <- leaflet() %>%
    addTiles() %>%
    addPlayback(
      data = spdfm,
      options = playbackOptions(radius = 3),
      pathOpts = pathOptions(weight = 5)
    )
  expect_is(m, "leaflet")
  expect_identical(m$x$calls[[2]]$method, "addPlayback")
})

test_that("playback-error", {
  expect_error(
    leaflet() %>%
      addPlayback(
        data = breweries91, time = "village",
        options = playbackOptions(radius = 3),
        pathOpts = pathOptions(weight = 5)
      )
  )

  ## Deps not fulfilled ######
  with_mocked_bindings(
    {
      expect_error(
        addPlayback(leaflet::leaflet(), data = NULL),
        "The package `sf` is needed"
      )
    },
    requireNamespace = function(package, ..., quietly = FALSE) FALSE,
    .package = "base"
  )
})
