# Copyright (C) 2016 Ramon Novoa <ramonnovoa AT gmail DOT com>
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# We will need the magnitude and station datasets.
data(madrid.air.magnitudes, envir=environment())
data(madrid.air.stations, envir=environment())

# Supress warnings.
Month = Day = Hour = Value = ValidationCode = NULL

################################################################################
#' Air quality data parser.
#'
#' Parses raw air quality data published by \url{http://datos.madrid.es/} and returns
#' a clean data frame.
#'
#' @param input Input file containing the raw air quality data.
#' @param output Optional CSV file where the air quality data data frame will
#' be saved.
#' @param station Filter data by station code (see
#' \code{\link{madrid.air.stations}}).
#' @param magnitude Filter data by magnitude name (see
#' \code{\link{madrid.air.magnitudes}}).
#' @return A data frame containing air quality data.
#' @examples
#' # Download and parse daily data.
#' download.file('http://datos.madrid.es/egob/catalogo/201410-14-calidad-aire-diario.txt',
#'               '201410-14-calidad-aire-diario.txt')
#' madrid.air.parse('201410-14-calidad-aire-diario.txt')
#'
#' # Save air quality data to disk.
#' madrid.air.parse('201410-14-calidad-aire-diario.txt',
#'                  output='201410-14-calidad-aire-diario.csv')
#'
#' # Download and parse hourly data.
#' download.file('http://datos.madrid.es/egob/catalogo/201200-29-calidad-aire-horario.zip',
#'               '201200-29-calidad-aire-horario.zip')
#' unzip('201200-29-calidad-aire-horario.zip')
#' madrid.air.parse('Ene_mo01.txt')
#'
#' # Check station information.
#' data(madrid.air.stations)
#' madrid.air.stations
#'
#' # Filter by station.
#' madrid.air.parse('Ene_mo01.txt', station=28079001)
#'
#' # Check magnitude information.
#' data(madrid.air.magnitudes)
#' madrid.air.magnitudes
#'
#' # Filter by magnitude.
#' madrid.air.parse('Ene_mo01.txt', magnitude='CO')
#' @export
################################################################################
madrid.air.parse <- function (input, output = NA, station = NA, magnitude = NA) {
	
	# Read the first record to parse the year and period.
	air_data <- read.fwf(input, widths=c(8, 2, 2, 2, 2, 2, 2),
	                     stringsAsFactors=F, n=1)
	period = air_data[1, 4]
	year = air_data[1,5] + 2000

	# Parse air quality data.
	if (period == 2) {
		air_data <- madrid.air.parser.hourly(input)
	} else if (period == 4) {
		air_data <- madrid.air.parser.daily(input, year)
	} else {
		stop("Invalid file format.")
	}

	# Filter by station.
	if (!is.na(station)) {
		air_data <- air_data[air_data$Station == station ,]
	}

	# Filter by magnitude
	if (!is.na(magnitude)) {
		air_data <- air_data[air_data$Magnitude == magnitude ,]
	}

	# Save the dataset to disk.
	if (!is.na(output)) {
		write.csv(air_data, file=output, row.names=F, quote=F)
	}

	air_data
}

################################################################################
################################################################################
## Helper functions.
################################################################################
################################################################################

################################################################################
# Parses daily air quality data and returns a data frame.
#
# Args:
# 	input: Source file containing the raw air quality data.
# 	year: The year the data was collected.
#
# Returns:
# 	A data frame.
################################################################################
madrid.air.parser.daily <- function (input, year, output = NA) {
	
	# There was an extra column before 2011 with the value 00 in daily
	# data. See: http://datos.madrid.es/FWProjects/egob/contenidos/datasets/fich
	# eros/MedioAmbiente_CalidadAire/INTPHORA-DIA_V2.2.pdf
	if (year < 2011) {
		air_data <- read.fwf(input, widths=c(8, 2, 2, 2, 2, 2, 2,
		                     rep(6, 31)), stringsAsFactors=F)

		# Remove the extra column.
		air_data <- air_data[,-7]
	} else {
		air_data <- read.fwf(input, widths=c(8, 2, 2, 2, 2, 2,
		                     rep(6, 31)), stringsAsFactors=F)
	}

	# Remove the measurement technique and period columns.
	air_data <- air_data[,-c(3, 4)]

	# Set appropriate column names.
	names(air_data) <- c("Station", "Magnitude", "Year", "Month", c(1:31))

	# Leave one daily observation per row.
	air_data <- tidyr::gather(air_data, Day, Value, 5:35)

	# Perform common parsing operations.
	air_data <- madrid.air.parser.common(air_data)

	# Rearrange the columns.
	air_data <- air_data[,c("Station", "Year", "Month", "Day", "Magnitude",
	                        "Value")]

	# Sort by date.
	air_data <- dplyr::arrange(air_data, Month, Day)

	air_data
}

################################################################################
# Parses hourly air quality data and returns a data frame.
#
# Args:
# 	input: Source file containing the raw air quality data.
#
# Returns:
# 	A data frame.
################################################################################
madrid.air.parser.hourly <- function (input) {
	
	air_data <- read.fwf(input, widths=c(8, 2, 2, 2, 2, 2, 2, rep(6, 24)),
	                        stringsAsFactors=F)

	# Remove the measurement technique and period columns.
	air_data <- air_data[,-c(3, 4)]

	# Set appropriate column names.
	names(air_data) <- c("Station", "Magnitude", "Year", "Month", "Day",
	                     c(1:24))

	# Leave one hourly observation per row.
	air_data <- tidyr::gather(air_data, Hour, Value, 6:29)

	# Perform common parsing operations.
	air_data <- madrid.air.parser.common(air_data)

	# Rearrange the columns.
	air_data <- air_data[,c("Station", "Year", "Month", "Day", "Hour",
	                        "Magnitude", "Value")]

	# Fix some column types.
	air_data$Hour <- as.integer(air_data$Hour)

	# Sort by date.
	air_data <- dplyr::arrange(air_data, Month, Day, Hour)

	air_data
}

################################################################################
# Performs parsing operation common to daily and hourly data.
#
# Args:
# 	input: A data frame containing daily or hourly air quality data.
#
# Returns:
# 	A data frame.
################################################################################
madrid.air.parser.common <- function (air_data) {

	# Separate the validation code from the actual value.
	air_data <- tidyr::separate(air_data, Value, c("Value", "ValidationCode"), sep=5)
	
	# We will only keep valid data (validation code "V").
	air_data <- dplyr::filter(air_data, ValidationCode == "V")
	
	# Sanity check.
	if (nrow(air_data) == 0) {
		stop("Invalid file format.")
	}

	# Remove the validation code from the dataset.
	air_data <- air_data[, -which(names(air_data) %in% c("ValidationCode"))]
	
	# Convert values to double precision numbers.
	air_data$Value <- as.double(air_data$Value)

	# Save magnitudes as a factor.
	air_data$Magnitude <- factor(air_data$Magnitude,
	                             levels=madrid.air.magnitudes[, "Magnitude"],
	                             labels=madrid.air.magnitudes[, "Abbreviation"])
	
	# Remove unknown magnitudes.
	# Note: There is no description for magnitude 85 in the docs!!!
	air_data <- air_data[!is.na(air_data$Magnitude),]
	
	# Some station codes changed after 2011. Rename old codes to new
	# codes. See: http://datos.madrid.es/FWProjects/egob/contenidos/datasets/fic
	# heros/MedioAmbiente_CalidadAire/INTPHORA-DIA_V2.2.pdf
	air_data[air_data$Station == 28079003, "Station"] <- 28079035 # Pza. del Carmen.
	air_data[air_data$Station == 28079005, "Station"] <- 28079039 # Barrio del Pilar.
	air_data[air_data$Station == 28079010, "Station"] <- 28079038 # Cuatro Caminos.
	air_data[air_data$Station == 28079013, "Station"] <- 28079040 # Vallecas.
	air_data[air_data$Station == 28079020, "Station"] <- 28079036 # Moratalaz.
	air_data[air_data$Station == 28079086, "Station"] <- 28079060 # Tres Olivos.

	# Fix the Year column.
	air_data$Year <- air_data$Year + 2000

	# Fix some column types.
	air_data$Year <- as.integer(air_data$Year)
	air_data$Month <- as.integer(air_data$Month)
	air_data$Day <- as.integer(air_data$Day)
	air_data$Station <- as.factor(air_data$Station)

	air_data
}
