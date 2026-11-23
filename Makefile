CC=R
PKG=$(shell sed -n 's/^Package: //p' DESCRIPTION)
VERSION=$(shell sed -n 's/^Version: //p' DESCRIPTION)
TARBALL=${PKG}_${VERSION}.tar.gz
SAVE_DATA="for (name in c('madrid.air.magnitudes', 'madrid.air.stations')) { \
source(paste0('data-raw/', name, '.R')); \
save(list = name, file = paste0('data/', name, '.rda'), compress = 'bzip2'); }"

.PHONY: dist deps data document check test lint build install

all:

dist: document check test build

# Install the R packages needed to run the tests and the linter. To
# regenerate the documentation (make document) install roxygen2 as well.
deps:
	${CC} -e "install.packages(c('lintr', 'testthat'), repos='https://cloud.r-project.org/');"

# Regenerate the datasets from data-raw. Run it after editing data-raw.
data:
	${CC} -e ${SAVE_DATA}

document:
	${CC} -e "roxygen2::roxygenise();"

check: build
	${CC} CMD check --no-manual ${TARBALL}

test:
	NOT_CRAN=true ${CC} -e "testthat::test_local();"

lint:
	${CC} -e "quit(status = length(print(lintr::lint_package())) > 0);"

build:
	${CC} CMD build .

install:
	${CC} -e "install.packages('.', repos=NULL);"
