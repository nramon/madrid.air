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
#' @source \url{http://datos.madrid.es/FWProjects/egob/contenidos/datasets/ficheros/MedioAmbiente_CalidadAire/INTPHORA-DIA_V2.2.pdf}
"madrid.air.magnitudes"
