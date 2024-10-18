<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R-CMD-check](https://github.com/GIScience/openrouteservice-r/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/GIScience/openrouteservice-r/actions/workflows/R-CMD-check.yaml)
[![Coverage
Status](https://img.shields.io/codecov/c/github/GIScience/openrouteservice-r/master.svg)](https://app.codecov.io/github/GIScience/openrouteservice-r?branch=master)
[![lifecycle](https://lifecycle.r-lib.org/articles/figures/lifecycle-stable.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![CRAN
checks](https://badges.cranchecks.info/summary/openrouteservice.svg)](https://cran.r-project.org/web/checks/check_results_openrouteservice.html)
[![CRAN
release](https://www.r-pkg.org/badges/version-ago/openrouteservice)](https://cran.r-project.org/package=openrouteservice)
[![CRAN
downloads](https://cranlogs.r-pkg.org:443/badges/openrouteservice)](https://cran.r-project.org/package=openrouteservice)
<!-- badges: end -->

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
    to OpenStreetMap ways
-   [exporting](https://openrouteservice.org/dev/#/api-docs/v2/export/%7Bprofile%7D/post)
    the underlying routing graph structure
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

The latest release version can be readily obtained from CRAN via a call
to

    install.packages("openrouteservice")

For running the current development version from GitHub it is
recommended to use [pak](https://CRAN.R-project.org/package=pak), as it
handles the installation of all the necessary packages and their system
dependencies automatically.

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

    options(openrouteservice.url = "http://localhost:8082/ors")

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
                                          snap = "v2/snap",
                                          export = "v2/export"))

## Package news

### version 0.6.0

#### NEW FEATURES

-   Enable export endpoint.

### version 0.5.2

#### NEW FEATURES

-   sf output for snapping.

### version 0.5.1

#### BUG FIXES

-   sf output for POIs endpoint (#81)

### version 0.5.0

#### NEW FEATURES

-   Enable snap endpoint.

## Publications using openrouteservice R package

Please feel free to reach out if you would like to have your work added
to the list below.

1.  Baumer BS, Kaplan DT, Horton NJ. Modern data science with r.
    Chapman; Hall/CRC; 2017.

2.  Cervigni E, Renton M, McKenzie FH, Hickling S, Olaru D. Describing
    and mapping diversity and accessibility of the urban food
    environment with open data and tools. Applied Geography.
    2020;125:102352.

3.  Petricola S, Reinmuth M, Lautenbach S, Hatfield C, Zipf A. Assessing
    road criticality and loss of healthcare accessibility during floods:
    The case of cyclone idai, mozambique 2019. International journal of
    health geographics. 2022;21(1):14.

4.  Weenink P. Overcoming the modifiable areal unit problem (MAUP) of
    socio-economic variables in real estate modelling
    *P**h**D**t**h**e**s**i**s*
    . 2022.

5.  Shields N, Willis C, Imms C, McKenzie G, Van Dorsselaer B, Bruder
    AM, et al. Feasibility of scaling-up a community-based exercise
    program for young people with disability. Disability and
    Rehabilitation. 2022;44(9):1669–81.

6.  Veloso R, Cespedes J, Caunhye A, Alem D. Brazilian disaster datasets
    and real-world instances for optimization and machine learning. Data
    in brief. 2022;42:108012. </span>

7.  Cubells J, Miralles-Guasch C, Marquet O. E-scooter and bike-share
    route choice and detours: Modelling the influence of built
    environment and sociodemographic factors. Journal of transport
    geography. 2023;111:103664.

8.  Bhowon Y, Prendergast LA, Taylor NF, Shields N. Using geospatial
    analysis to determine the proximity of community gyms for a
    population-based cohort of young people with cerebral palsy.
    Physiotherapy Canada. 2023;e20220064.

9.  Amato S, Benson JS, Stewart B, Sarathy A, Osler T, Hosmer D, et
    al. Current patterns of trauma center proliferation have not led to
    proportionate improvements in access to care or mortality after
    injury: An ecologic study. Journal of Trauma and Acute Care Surgery.
    2023;94(6):755–64.

10. Jain A, LaValley M, Dukes K, Lane K, Winter M, Spangler KR, et
    al. Modeling health and well-being measures using ZIP code spatial
    neighborhood patterns. Scientific Reports. 2024;14(1):9180.
