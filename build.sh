#!/bin/bash
# Build the madrid.air package.
R -e "library(devtools); \
source('data-raw/madrid.air.magnitudes.R'); \
use_data(madrid.air.magnitudes, overwrite=TRUE); \
source('data-raw/madrid.air.stations.R'); \
use_data(madrid.air.stations, overwrite=TRUE); \
document(); \
test(); \
build()"
