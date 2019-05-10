[![Travis-CI Build
Status](https://travis-ci.org/GIScience/openrouteservice-r.svg?branch=master)](https://travis-ci.org/GIScience/openrouteservice-r)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/GIScience/openrouteservice-r?branch=master&svg=true)](https://ci.appveyor.com/project/aoles/openrouteservice-r)
[![Coverage
Status](https://img.shields.io/codecov/c/github/GIScience/openrouteservice-r/master.svg)](https://codecov.io/github/GIScience/openrouteservice-r?branch=master)
[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)

openrouteservice R client
=========================

*openrouteservice* R package provides easy access to the
[openrouteservice](https://openrouteservice.org) (ORS) API from R. It
allows you to painlessly consume the following services:

-   [directions](https://openrouteservice.org/dev/#/api-docs/directions)
    (routing)
-   [geocode](https://openrouteservice.org/dev/#/api-docs/geocode)
    powered by [Pelias](https://pelias.io)
-   [isochrones](https://openrouteservice.org/dev/#/api-docs/isochrones)
    (accessibility)
-   time-distance
    [matrix](https://openrouteservice.org/dev/#/api-docs/matrix)
-   [pois](https://openrouteservice.org/dev/#/api-docs/pois) (points of
    interest)
-   SRTM
    [elevation](https://openrouteservice.org/dev/#/api-docs/elevation)
    for point and lines geometries

Disclaimer
----------

By using this package, you agree to the ORS [terms and
conditions](https://openrouteservice.org/terms-of-service/).

Installation
------------

The package is not yet available from CRAN, but you can install the
development version directly from GitHub.

    # install.packages("remotes")
    remotes::install_github("GIScience/openrouteservice-r")

Get started
-----------

See the package
[vignette](https://giscience.github.io/openrouteservice-r/articles/openrouteservice.html)
for an overview of the offered functionality.

Local ORS instance
------------------

The default is to fire any requests against the free public services at
&lt;api.openrouteservice.org&gt;. In order to query a different
openrouteservice instance, say a local one, set

    options(openrouteservice.url = "http://localhost:8080/ors")

If necessary, endpoint configuration can be further customized through
`openrouteservice.paths` which specifies a named list of paths. The
defaults are equivalent of having

    options(openrouteservice.paths = list(directions = "v2/directions",
                                          isochrones = "v2/isochrones",
                                          matrix = "v2/matrix",
                                          geocode = "geocode",
                                          pois = "pois",
                                          elevation = "elevation"))

Package News
------------

### version 0.2.5

#### NEW FEATURES

-   Improved `ors_elevation()` response handling.

### version 0.2.4

#### NEW FEATURES

-   `ors_directions()`, `ors_isochrones()`, `ors_elevation()` and
    `ors_geocode()` can now output `sf` objects (\#42).

### version 0.2.3

#### NEW FEATURES

-   `ors_isochrones()` now accepts `locations` provided as `data.frame`
    (\#38).
