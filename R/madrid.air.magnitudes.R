#' Monitored physical magnitudes
#'
#' A dataset containing information about the physical magnitudes monitored by
#' the air quality monitoring stations located in the city of Madrid.
#'
#' @format A data frame with 27 observations of 4 variables:
#' \describe{
#'  \item{Name}{Magnitude name (e.g., "Carbon monoxide").}
#'  \item{Abbreviation}{Magnitude abbreviation (e.g., "PM10").}
#'  \item{Magnitude}{Numeric code used to refer to this magnitude in the raw
#' data.}
#'  \item{Unit}{Measurement unit (e.g., "m/s").}
#' }
#' @usage data(madrid.air.magnitudes)
#' @source \url{https://datos.madrid.es/dataset/201200-0-calidad-aire-horario}
"madrid.air.magnitudes"
