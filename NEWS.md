# openrouteservice 0.5.2

## NEW FEATURES

- sf output for snapping.

# openrouteservice 0.5.1

## BUG FIXES

- sf output for POIs endpoint (#81)

# openrouteservice 0.5.0

## NEW FEATURES

- Enable snap endpoint.

# openrouteservice 0.4.0

## NEW FEATURES

- Enable optimization endpoint.

# openrouteservice 0.3.3

## BUG FIXES

- Fixed resolving of URL paths to endpoints.

# openrouteservice 0.3.2

## NEW FEATURES

- More descriptive messages for API response errors.

# openrouteservice 0.3.1

## NEW FEATURES

- Arguments corresponding to array parameters don't need to be wrapped in `I()`.

# openrouteservice 0.2.7

## NEW FEATURES

- `ors_elevation()` now accepts point coordinates in matrix form.

## BUG FIXES

- `ors_elevation()` does not issue a message on missing encoding anymore.

# openrouteservice 0.2.6

## NEW FEATURES

- `ors_pois()` gains `sf` output.

# openrouteservice 0.2.5

## NEW FEATURES

- Improved `ors_elevation()` response handling.

# openrouteservice 0.2.4

## NEW FEATURES

- `ors_directions()`, `ors_isochrones()`, `ors_elevation()` and `ors_geocode()`
can now output `sf` objects (#42).

# openrouteservice 0.2.3

## NEW FEATURES

- `ors_isochrones()` now accepts `locations` provided as `data.frame` (#38).

# openrouteservice 0.2.2

## BUG FIXES

- Improve handling of paths to openrouteservice endpoints (#46).

# openrouteservice 0.2.1

## NEW FEATURES

- `ors_elevation()` example added to vignette.

# openrouteservice 0.2.0

## NEW FEATURES

- Switched to openrouteservice API v2.

# openrouteservice 0.1.25

## NEW FEATURES

- `ors_elevation()` provides access to the new endpoint.
