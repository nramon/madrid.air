CC=R
RAW_DATA="library(devtools); \
source('data-raw/madrid.air.magnitudes.R'); \
use_data(madrid.air.magnitudes, overwrite=TRUE); \
source('data-raw/madrid.air.stations.R'); \
use_data(madrid.air.stations, overwrite=TRUE);"

.PHONY: dist deps data document check test lint build install

all:

dist: document check test build

# Install the R packages needed to work on the package.
deps:
	${CC} -e "install.packages(c('devtools', 'lintr', 'roxygen2', 'testthat'), repos='https://cloud.r-project.org/');"

# Regenerate the datasets from data-raw. Run it after editing data-raw.
data:
	${CC} -e ${RAW_DATA}

document:
	${CC} -e "devtools::document();"

check:
	${CC} -e "devtools::check();"

test:
	${CC} -e "devtools::test();"

lint:
	${CC} -e "quit(status = length(print(lintr::lint_package())) > 0);"

build:
	${CC} -e "devtools::build();"

install:
	${CC} -e "install.packages('.', repos=NULL);"
