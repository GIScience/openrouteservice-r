[![Travis-CI Build
Status](https://travis-ci.org/GIScience/openrouteservice-r.svg?branch=master)](https://travis-ci.org/GIScience/openrouteservice-r)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/GIScience/openrouteservice-r?branch=master&svg=true)](https://ci.appveyor.com/project/aoles/openrouteservice-r)
[![Coverage
Status](https://img.shields.io/codecov/c/github/GIScience/openrouteservice-r/master.svg)](https://codecov.io/github/GIScience/openrouteservice-r?branch=master)
[![lifecycle](https://lifecycle.r-lib.org/articles/figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

openrouteservice R client
=========================

*openrouteservice* R package provides easy access to the
[openrouteservice](https://openrouteservice.org) (ORS) API from R. It
allows you to painlessly consume the following services:

-   [directions](https://openrouteservice.org/dev/#/api-docs/v2/directions/%7Bprofile%7D/post)
    (routing)
-   [geocode](https://openrouteservice.org/dev/#/api-docs/geocode)
    powered by [Pelias](https://pelias.io)
-   [isochrones](https://openrouteservice.org/dev/#/api-docs/v2/isochrones/%7Bprofile%7D/post)
    (accessibility)
-   time-distance
    [matrix](https://openrouteservice.org/dev/#/api-docs/v2/matrix/%7Bprofile%7D/post)
-   [pois](https://openrouteservice.org/dev/#/api-docs/pois/post)
    (points of interest)
-   SRTM
    [elevation](https://openrouteservice.org/dev/#/api-docs/elevation)
    for point and lines geometries
-   routing
    [optimization](https://openrouteservice.org/dev/#/api-docs/optimization/post)
    based on [Vroom](http://vroom-project.org/)

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
                                          elevation = "elevation",
                                          optimization = "optimization"))

Package News
------------

### version 0.4.0

#### NEW FEATURES

-   Enable optimization endpoint.

### version 0.3.3

#### BUG FIXES

-   Fixed resolving of URL paths to endpoints.

### version 0.3.2

#### NEW FEATURES

-   More descriptive messages for API response errors.
