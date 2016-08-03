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

################################################################################
# Magnitudes from: http://datos.madrid.es/FWProjects/egob/contenidos/datasets/fi
# cheros/MedioAmbiente_CalidadAire/INTPHORA-DIA_V2.2.pdf
################################################################################
madrid.air.magnitudes <- data.frame(
    rbind(
        c("Benzene", "BEN", 30, "µg/m³"),
        c("Hydrocarbons (methane)", "CH4", 43, "mg/m³"),
        c("Carbon monoxide", "CO", 6, "mg/m³"),
        c("Wind direction", "DV", 82, "º or quadrant"),
        c("Ethylbenzene", "EBE", 35, "µg/m³"),
        c("Relative humidity", "HR", 86, "%"),
        c("Acid Rain", "LLA", 89, "pH"),
        c("Precipitation", "LL", 92, "l/m²"),
        c("Metaxylene", "MXY", 37, "µg/m³"),
        c("Non-methane hydrocarbons (hexane)", "NMHC", 44, "mg/m³"),
        c("Nitrogen dioxide", "NO2", 7, "µg/m³"),
        c("Nitrogen monoxide", "NO", 8, "µg/m³"),
        c("Nitrogen oxides", "NOx", 12, "µg/m³"),
        c("Ozone", "O3", 14, "µg/m³"),
        c("Orthoxylene", "OXY", 39, "µg/m³"),
        c("Particulate matter < 10 µm", "PM10", 10, "µg/m³"),
        c("Particulate matter < 2.5 µm", "PM2.5", 9, "µg/m³"),
        c("Pressure", "PRB", 87, "mb"),
        c("Paraxylene", "PXY", 38, "µg/m³"),
        c("Solar irradiance", "RS", 88, "kW/m²"),
        c("Sulfur dioxide", "SO2", 1, "µg/m³"),
        c("Total hydrocarbons (hexane)", "TCH", 42, "mg/m³"),
        c("Temperature", "TMP", 83, "ºC"),
        c("Toluene", "TOL", 20, "µg/m³"),
        c("Ultraviolet radiation", "UV", 80, "mW/m²"),
        c("Wind speed", "VV", 81, "m/s"),
        c("Unknown", "Unknown", 85, "Unknown")
    ),
	stringsAsFactors = FALSE
)

# Set proper column names.
names(madrid.air.magnitudes) <- c("Name", "Abbreviation", "Magnitude", "Unit")

# Set the right encoding for magnitude names and units.
Encoding(madrid.air.magnitudes$Name) <- "UTF-8"
Encoding(madrid.air.magnitudes$Unit) <- "UTF-8"
