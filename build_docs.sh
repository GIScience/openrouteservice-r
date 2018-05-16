#!/bin/bash
git rm -rf docs
rm -rf docs
Rscript --vanilla -e "rmarkdown::render('README.Rmd'); pkgdown::build_site()"
git add docs
