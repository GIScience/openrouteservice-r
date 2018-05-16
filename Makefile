PACKAGE := $(shell grep '^Package:' DESCRIPTION | sed -E 's/^Package:[[:space:]]+//')
RSCRIPT = Rscript --vanilla

pkgd:
	${RSCRIPT} -e "pkgdown::build_site()"

website: pkgd
	./update_web.sh
