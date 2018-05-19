PKGNAME := $(shell grep '^Package:' DESCRIPTION | sed -E 's/^Package:[[:space:]]+//')
PKGVER := $(shell grep '^Version:' DESCRIPTION | sed -E 's/^Version:[[:space:]]+//')
PKGDIR = $(shell basename $(dir $(realpath $(firstword $(MAKEFILE_LIST)))))

RSCRIPT = Rscript --vanilla

%.md: %.Rmd
	${RSCRIPT} -e 'rmarkdown::render("$<")'

README.md: vignettes/openrouteservice.Rmd

readme: README.md

document:
	${RSCRIPT} -e "devtools::document()"

build: document readme
	cd ..; R CMD build ${PKGDIR}

install: build
	R CMD INSTALL ../${PKGNAME}_${PKGVER}.tar.gz

check: build
	cd ..; R CMD check --as-cran --no-manual ${PKGNAME}_${PKGVER}.tar.gz

website:
	${RSCRIPT} -e "pkgdown::build_site()"

clean:
	${RSCRIPT} -e "pkgdown::clean_site()"

publish: clean website
	./update_web.sh

spellcheck:
	${RSCRIPT} -e "devtools::spell_check()"

.PHONY: readme document build install check website clean publish spellcheck
