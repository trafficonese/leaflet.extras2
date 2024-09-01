gibs_layerslink <- paste0(system.file("htmlwidgets/lfx-gibs", package = "leaflet.extras2"), "/gibs_layers_meta.json")
gibs_layers <- jsonify::from_json(json = gibs_layerslink, simplify = TRUE)
gibs_layers <- data.frame(do.call(rbind, gibs_layers), stringsAsFactors = FALSE)
gibs_layers$title <- as.character(gibs_layers$title)
gibs_layers$template <- as.character(gibs_layers$template)
gibs_layers$zoom <- as.integer(gibs_layers$zoom)
gibs_layers$date <- as.logical(gibs_layers$date)
rownames(gibs_layers) <- NULL
usethis::use_data(gibs_layers, overwrite = TRUE)
