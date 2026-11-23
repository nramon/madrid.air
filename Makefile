CC=R
RAW_DATA="library(devtools); \
source('data-raw/madrid.air.magnitudes.R'); \
use_data(madrid.air.magnitudes, overwrite=TRUE); \
source('data-raw/madrid.air.stations.R'); \
use_data(madrid.air.stations, overwrite=TRUE);"

.PHONY: dist data document check test build install

all:

dist: document check test build

# Regenerate the datasets from data-raw. Run it after editing data-raw.
data:
	${CC} -e ${RAW_DATA}

document:
	${CC} -e "devtools::document();"

check:
	${CC} -e "devtools::check();"

test:
	${CC} -e "devtools::test();"

build:
	${CC} -e "devtools::build();"

install:
	${CC} -e "install.packages('.', repos=NULL);"
