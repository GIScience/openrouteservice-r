[![Travis-CI Build
Status](https://travis-ci.org/GIScience/openrouteservice-r.svg?branch=master)](https://travis-ci.org/GIScience/openrouteservice-r)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/GIScience/openrouteservice-r?branch=master&svg=true)](https://ci.appveyor.com/project/aoles/openrouteservice-r)
[![Coverage
Status](https://img.shields.io/codecov/c/github/GIScience/openrouteservice-r/master.svg)](https://codecov.io/github/GIScience/openrouteservice-r?branch=master)

openrouteservice R client
=========================

The *openrouteservice* package provides easy access to the
[openrouteservice](https://openrouteservice.org) (ORS) API from R. It
allows you to painlessly consume the following services:

-   [directions](https://openrouteservice.org/documentation/#/reference/directions/directions)
    (routing)
-   [geocode](https://openrouteservice.org/documentation/#/reference/geocode/geocode)
    powered by [Pelias](https://pelias.io)
-   [isochrones](https://openrouteservice.org/documentation/#/reference/isochrones/isochrones)
    (accessibilty)
-   time-distance
    [matrix](https://openrouteservice.org/documentation/#/reference/matrix/matrix)
-   [pois](https://github.com/GIScience/openpoiservice#api-documentation)
    (points of interest)

Disclaimer
----------

By using this package, you agree to the ORS [terms and
conditions](https://openrouteservice.org/terms-of-service/).

Installation
------------

The package is not yet available from CRAN, but you can install the
development version directly from GitHub.

    # install.packages("devtools")
    devtools::install_github("GIScience/openrouteservice-r")

Get started
-----------

See the package
[vignette](https://giscience.github.io/openrouteservice-r/articles/openrouteservice.html)
for an overview of the offered functionality.
