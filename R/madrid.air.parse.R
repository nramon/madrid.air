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
data(madrid.air.magnitudes, envir = environment())
data(madrid.air.stations, envir = environment())

#' Air quality data parser.
#'
#' Parses raw air quality data published by \url{https://datos.madrid.es/} and
#' returns a clean data frame. The CSV (semicolon separated, with header) and
#' TXT (comma separated, no header) formats are supported.
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
#' # Download and parse daily data for 2024 (CSV).
#' base <- 'https://datos.madrid.es/dataset/201410-0-calidad-aire-diario/'
#' base <- paste0(base, 'resource/')
#' download.file(paste0(base, '201410-4-calidad-aire-diario-csv/download/',
#'                      '201410-4-calidad-aire-diario-csv.csv'),
#'               '201410-4-calidad-aire-diario-csv.csv')
#' madrid.air.parse('201410-4-calidad-aire-diario-csv.csv')
#'
#' # Save air quality data to disk.
#' madrid.air.parse('201410-4-calidad-aire-diario-csv.csv',
#'                  output='201410-4-calidad-aire-diario.csv')
#'
#' # Download and parse hourly data for 2024. The zip file contains one
#' # file per month.
#' base <- 'https://datos.madrid.es/dataset/201200-0-calidad-aire-horario/'
#' base <- paste0(base, 'resource/')
#' download.file(paste0(base, '201200-0-calidad-aire-horario-zip/download/',
#'                      '201200-0-calidad-aire-horario-zip.zip'),
#'               '201200-0-calidad-aire-horario-zip.zip')
#' unzip('201200-0-calidad-aire-horario-zip.zip')
#' madrid.air.parse('Anio24/abr_mo24.csv')
#'
#' # Check station information.
#' data(madrid.air.stations)
#' madrid.air.stations
#'
#' # Filter by station.
#' madrid.air.parse('Anio24/abr_mo24.csv', station=28079001)
#'
#' # Check magnitude information.
#' data(madrid.air.magnitudes)
#' madrid.air.magnitudes
#'
#' # Filter by magnitude.
#' madrid.air.parse('Anio24/abr_mo24.csv', magnitude='CO')
#' @export
################################################################################
madrid.air.parse <- function(input,
                             output = NA,
                             station = NA,
                             magnitude = NA) {
  # Read the raw data into a common wide representation.
  raw <- madrid.air.read(input)

  # Leave one observation per row and clean up the data.
  air_data <- madrid.air.parser.long(raw)

  # Filter by station.
  if (!is.na(station)) {
    air_data <- air_data[air_data$Station == station, ]
  }

  # Filter by magnitude
  if (!is.na(magnitude)) {
    air_data <- air_data[air_data$Magnitude == magnitude, ]
  }

  # Save the dataset to disk.
  if (!is.na(output)) {
    utils::write.csv(air_data, file = output, row.names = FALSE, quote = FALSE)
  }

  air_data
}

################################################################################
################################################################################
## Helper functions.
################################################################################
################################################################################

################################################################################
# Reads a raw air quality file in any of the supported formats.
#
# Supported formats:
#   * CSV: semicolon separated, with a header (PROVINCIA;MUNICIPIO;...).
#   * TXT: comma separated, no header.
#
# Args:
#   input: Source file containing the raw air quality data.
#
# Returns:
#   A list with the following elements:
#     period: "hourly" or "daily".
#     meta: A data frame with columns Station, Magnitude, Year, Month and,
#           for hourly data, Day. One row per input record.
#     values: A character matrix with one row per record and one column per
#             day (daily data) or hour (hourly data).
#     flags: A character matrix of the same shape with the validation codes.
################################################################################
madrid.air.read <- function(input) {
  first <- readLines(input, n = 1, warn = FALSE)
  if (length(first) == 0 || is.na(first)) {
    stop("Invalid file format.")
  }

  if (grepl("PROVINCIA", first, fixed = TRUE)) {
    madrid.air.read.csv(input)
  } else if (grepl(",", first, fixed = TRUE)) {
    madrid.air.read.txt(input)
  } else {
    stop("Invalid file format.")
  }
}

################################################################################
# Reads the CSV format. The header tells us whether the file is hourly (DIA,
# H01, V01, ...) or daily (D01, V01, ...).
################################################################################
madrid.air.read.csv <- function(input) {
  # The first line may start with a byte order mark.
  data <- utils::read.table(input,
    sep = ";", header = TRUE, quote = "\"",
    colClasses = "character", comment.char = "",
    fileEncoding = "UTF-8-BOM"
  )

  cols <- names(data)
  value_cols <- grep("^[DH][0-9]{2}$", cols)
  flag_cols <- grep("^V[0-9]{2}$", cols)
  required <- c("PROVINCIA", "MUNICIPIO", "ESTACION", "MAGNITUD", "ANO", "MES")
  valid <- length(value_cols) > 0 &&
    length(value_cols) == length(flag_cols) &&
    all(required %in% cols)
  if (!valid) {
    stop("Invalid file format.")
  }

  meta <- data.frame(
    Station = madrid.air.station.code(
      data$PROVINCIA,
      data$MUNICIPIO,
      data$ESTACION
    ),
    Magnitude = as.integer(data$MAGNITUD),
    Year = as.integer(data$ANO),
    Month = as.integer(data$MES)
  )
  period <- "daily"
  if ("DIA" %in% cols) {
    meta$Day <- as.integer(data$DIA)
    period <- "hourly"
  }

  list(
    period = period, meta = meta,
    values = as.matrix(data[, value_cols]),
    flags = as.matrix(data[, flag_cols])
  )
}

################################################################################
# Reads the TXT format: comma separated, no header. Fields are province,
# municipality, station, magnitude, sampling point, period (02 hourly, 04
# daily), year, month, [day (hourly only)], followed by value,flag pairs.
################################################################################
madrid.air.read.txt <- function(input) {
  first <- utils::read.table(input,
    sep = ",", header = FALSE, nrows = 1,
    colClasses = "character", comment.char = ""
  )
  if (ncol(first) < 8) {
    stop("Invalid file format.")
  }

  period <- as.integer(first[1, 6])
  if (is.na(period) || !(period %in% c(2, 4))) {
    stop("Invalid file format.")
  }
  hourly <- period == 2
  prefix <- ifelse(hourly, 9, 8)
  n <- ifelse(hourly, 24, 31)

  data <- utils::read.table(input,
    sep = ",", header = FALSE,
    colClasses = "character", comment.char = "",
    col.names = paste0("X", seq_len(prefix + 2 * n))
  )

  meta <- data.frame(
    Station = madrid.air.station.code(
      data[, 1], data[, 2],
      data[, 3]
    ),
    Magnitude = as.integer(data[, 4]),
    Year = as.integer(data[, 7]),
    Month = as.integer(data[, 8])
  )
  if (hourly) {
    meta$Day <- as.integer(data[, 9])
  }

  list(
    period = ifelse(hourly, "hourly", "daily"), meta = meta,
    values = as.matrix(data[, prefix + 2 * seq_len(n) - 1]),
    flags = as.matrix(data[, prefix + 2 * seq_len(n)])
  )
}

################################################################################
# Builds a station code (e.g. 28079004) from the province, municipality and
# station fields.
################################################################################
madrid.air.station.code <- function(province, municipality, station) {
  as.numeric(province) * 1000000 + as.numeric(municipality) * 1000 +
    as.numeric(station)
}

################################################################################
# Converts the wide representation returned by madrid.air.read into a clean
# data frame with one observation per row.
#
# Args:
#   raw: A list as returned by madrid.air.read.
#
# Returns:
#   A data frame.
################################################################################
madrid.air.parser.long <- function(raw) {
  hourly <- raw$period == "hourly"
  n_rows <- nrow(raw$values)
  n_units <- ncol(raw$values)

  # One row per record and day/hour.
  rec <- rep(seq_len(n_rows), times = n_units)
  unit <- rep(seq_len(n_units), each = n_rows)
  flags <- as.vector(raw$flags)
  values <- suppressWarnings(as.double(as.vector(raw$values)))

  # We will only keep valid data (validation code "V").
  keep <- !is.na(flags) & flags == "V" & !is.na(values)

  # Sanity check.
  if (!any(keep)) {
    stop("Invalid file format.")
  }
  rec <- rec[keep]
  unit <- unit[keep]

  air_data <- raw$meta[rec, c("Station", "Year", "Month"), drop = FALSE]
  if (hourly) {
    air_data$Day <- raw$meta$Day[rec]
    air_data$Hour <- as.integer(unit)
  } else {
    air_data$Day <- as.integer(unit)
  }
  air_data$Magnitude <- raw$meta$Magnitude[rec]
  air_data$Value <- values[keep]

  # Save magnitudes as a factor.
  magnitudes <- madrid.air.magnitudes # nolint: object_usage_linter.
  air_data$Magnitude <- factor(as.character(air_data$Magnitude),
    levels = as.character(magnitudes$Magnitude),
    labels = magnitudes$Abbreviation
  )

  # Remove unknown magnitudes.
  # Note: There is no description for magnitude 85 in the docs!!!
  air_data <- air_data[!is.na(air_data$Magnitude), ]

  # Some station codes changed after 2011. Rename old codes to new codes.
  # Pza. del Carmen.
  air_data[air_data$Station == 28079003, "Station"] <- 28079035

  # Barrio del Pilar.
  air_data[air_data$Station == 28079005, "Station"] <- 28079039

  # Cuatro Caminos.
  air_data[air_data$Station == 28079010, "Station"] <- 28079038

  # Vallecas.
  air_data[air_data$Station == 28079013, "Station"] <- 28079040

  # Moratalaz.
  air_data[air_data$Station == 28079020, "Station"] <- 28079036

  # Tres Olivos.
  air_data[air_data$Station == 28079086, "Station"] <- 28079060

  # Fix some column types.
  air_data$Year <- as.integer(air_data$Year)
  air_data$Month <- as.integer(air_data$Month)
  air_data$Station <- as.factor(air_data$Station)

  # Rearrange the columns.
  cols <- c("Station", "Year", "Month", "Day")
  if (hourly) {
    cols <- c(cols, "Hour")
  }
  air_data <- air_data[, c(cols, "Magnitude", "Value")]

  # Sort by date.
  if (hourly) {
    air_data <- air_data[order(
      air_data$Year, air_data$Month, air_data$Day,
      air_data$Hour
    ), ]
  } else {
    air_data <- air_data[order(air_data$Year, air_data$Month, air_data$Day), ]
  }
  rownames(air_data) <- NULL

  air_data
}
