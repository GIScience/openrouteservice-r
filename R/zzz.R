.onLoad <- function(lib, pkg) {
  validator$instance <- jsonvalidate::json_validator(system.file("schema/geojson.json", package = pkg))
}
