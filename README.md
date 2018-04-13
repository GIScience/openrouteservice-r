# openrouteservice R package

The *openrouteservice* package provides easy access to the
[openrouteservice](https://openrouteservice.org) (ORS) API from R. It
allows you to painlessly consume the following services:

-   [directions](https://openrouteservice.org/documentation/#/reference/directions/directions)
-   [geocode](https://openrouteservice.org/documentation/#/reference/geocode/geocode)
    powered by [Pelias](https://pelias.io)
-   [isochrones](https://openrouteservice.org/documentation/#/reference/isochrones/isochrones)
-   [matrix](https://openrouteservice.org/documentation/#/reference/matrix/matrix)
-   [pois](https://github.com/GIScience/openpoiservice#api-documentation)

For further details, please visit:

-   [openrouteservice.org](https://openrouteservice.org)
-   [ORS API
    documentation](https://openrouteservice.org/documentation/)
-   [openrouteservice-r
    documentation](http://GIScience.github.io/openrouteservice-r/)

By using this package, you agree to the ORS [terms and
conditions](https://openrouteservice.org/terms-of-service/).

## Installation

The package is not yet available from CRAN, but you can install the
development version directly from GitHub.

    # install.packages("devtools")
    devtools::install_github("GIScience/openrouteservice-r")
