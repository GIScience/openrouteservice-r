.onLoad <- function(lib, pkg) {
  validate_geojson <<- jsonvalidate::json_validator(system.file("schema/geojson.json", package = pkg))
}
