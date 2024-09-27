[![R-CMD-check](https://github.com/GIScience/openrouteservice-r/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/GIScience/openrouteservice-r/actions/workflows/R-CMD-check.yaml)
[![Coverage
Status](https://img.shields.io/codecov/c/github/GIScience/openrouteservice-r/master.svg)](https://app.codecov.io/github/GIScience/openrouteservice-r?branch=master)
[![lifecycle](https://lifecycle.r-lib.org/articles/figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

# openrouteservice R client

*openrouteservice* R package provides easy access to the
[openrouteservice](https://openrouteservice.org) (ORS) API from R. It
allows you to painlessly consume the following services:

-   [directions](https://openrouteservice.org/dev/#/api-docs/v2/directions/%7Bprofile%7D/post)
    (routing)
-   [geocoding](https://openrouteservice.org/dev/#/api-docs/geocode)
    powered by [Pelias](https://pelias.io)
-   [isochrones](https://openrouteservice.org/dev/#/api-docs/v2/isochrones/%7Bprofile%7D/post)
    (accessibility)
-   time-distance
    [matrices](https://openrouteservice.org/dev/#/api-docs/v2/matrix/%7Bprofile%7D/post)
-   [snapping](https://openrouteservice.org/dev/#/api-docs/v2/snap/%7Bprofile%7D/post)
    to ways
-   [pois](https://openrouteservice.org/dev/#/api-docs/pois/post)
    (points of interest)
-   SRTM
    [elevation](https://openrouteservice.org/dev/#/api-docs/elevation)
    for point and lines geometries
-   routing
    [optimization](https://openrouteservice.org/dev/#/api-docs/optimization/post)
    based on [Vroom](http://vroom-project.org/)

## Disclaimer

By using this package, you agree to the ORS [terms and
conditions](https://openrouteservice.org/terms-of-service/).

## Installation

The package is not yet available from CRAN, but you can install the
development version directly from GitHub.

    # install.packages("pak")
    pak::pak("GIScience/openrouteservice-r")

## Get started

See the package
[vignette](https://giscience.github.io/openrouteservice-r/articles/openrouteservice.html)
for an overview of the offered functionality.

## Local ORS instance

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
                                          optimization = "optimization",
                                          snap = "v2/snap"))

## Recent package news

### version 0.5.2

#### NEW FEATURES

-   sf output for snapping.

### version 0.5.1

#### BUG FIXES

-   sf output for POIs endpoint (#81)

### version 0.5.0

#### NEW FEATURES

-   Enable snap endpoint.

## Publications citing openrouteservice R package

Please feel free to reach out if you would like to have your work added
to the list below.

1.  Baumer BS, Kaplan DT, Horton NJ. Modern data science with r.
    Chapman; Hall/CRC; 2017.

2.  Shields N, Willis C, Imms C, McKenzie G, Van Dorsselaer B, Bruder
    AM, et al. Feasibility of scaling-up a community-based exercise
    program for young people with disability. Disability and
    Rehabilitation. 2022;44(9):1669–81.

3.  Cubells J, Miralles-Guasch C, Marquet O. E-scooter and bike-share
    route choice and detours: Modelling the influence of built
    environment and sociodemographic factors. Journal of transport
    geography. 2023;111:103664.

4.  Bhowon Y, Prendergast LA, Taylor NF, Shields N. Using geospatial
    analysis to determine the proximity of community gyms for a
    population-based cohort of young people with cerebral palsy.
    Physiotherapy Canada. 2023;e20220064.

5.  Jain A, LaValley M, Dukes K, Lane K, Winter M, Spangler KR, et
    al. Modeling health and well-being measures using ZIP code spatial
    neighborhood patterns. Scientific Reports. 2024;14(1):9180.
