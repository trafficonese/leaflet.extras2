## ---- echo=FALSE--------------------------------------------------------------
run <- FALSE
if (requireNamespace("rgdal", quietly=TRUE)) run <- TRUE

## ---- eval=run----------------------------------------------------------------
library(rgdal)

## ---- eval=run----------------------------------------------------------------
rgdal::rgdal_extSoftVersion()

## ---- eval=run----------------------------------------------------------------
rgdal::new_proj_and_gdal()

