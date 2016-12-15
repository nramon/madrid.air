CC=R
RAW_DATA="library(devtools); \
source('data-raw/madrid.air.magnitudes.R'); \
use_data(madrid.air.magnitudes, overwrite=TRUE); \
source('data-raw/madrid.air.stations.R'); \
use_data(madrid.air.stations, overwrite=TRUE);"

.PHONY:document check test build

all:document check test build

document:
	${CC} -e ${RAW_DATA} -e "document();"

check:
	${CC} -e ${RAW_DATA} -e "check();"

test:
	${CC} -e ${RAW_DATA} -e "test();"

build:
	${CC} -e ${RAW_DATA} -e "build();"
