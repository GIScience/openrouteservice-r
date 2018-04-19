#!/bin/bash

Rscript --vanilla -e "rmarkdown::render('README.Rmd'); pkgdown::build_site()"
