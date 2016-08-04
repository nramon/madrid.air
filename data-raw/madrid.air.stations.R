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
# Stations from: http://datos.madrid.es/FWProjects/egob/contenidos/datasets/fich
# eros/MedioAmbiente_CalidadAire/INTPHORA-DIA_V2.2.pdf
# Coordinates from: http://www.eea.europa.eu/data-and-maps/data/airbase-the-euro
# pean-air-quality-database-8
################################################################################
madrid.air.stations <- data.frame(
  rbind(
    c("28079001", "Pº. Recoletos", -3.691945, 40.422501,
      "Closed on 04/05/2009"),
    c("28079002", "Glta. de Carlos V", -3.691945, 40.409725,
      "Closed on 04/12/2006"),
    c("28079004", "Pza. de España", -3.712222, 40.424167, ""),
    c("28079006", "Pza. Dr. Marañón", -3.690833, 40.437778,
      "Closed on 27/11/2009"),
    c("28079007", "Pza. M. de Salamanca", -3.680278, 40.421669,
      "Closed on 30/12/2009"),
    c("28079008", "Escuelas Aguirre", -3.682222, 40.421667, ""),
    c("28079009", "Pza. Luca de Tena", -3.693611, 40.402225,
      "Closed on 07/12/2009"),
    c("28079011", "Av. Ramón y Cajal", -3.677222, 40.451667, ""),
    c("28079012", "Pza. Manuel Becerra", -3.668611, 40.428612,
      "Closed on 30/12/2009"),
    c("28079014", "Pza. Fdez. Ladreda", -3.716667, 40.385,
      "Closed on 02/12/2009"),
    c("28079015", "Pza. Castilla", -3.688611, 40.468334,
      "Closed on 17/10/2008"),
    c("28079016", "Arturo Soria", -3.639167, 40.44, ""),
    c("28079017", "Villaverde Alto", -3.705, 40.346944, ""),
    c("28079018", "C/ Farolillo", -3.731944, 40.394722, ""),
    c("28079023", "Final C/ Alcalá", -3.604444, 40.450279,
      "Closed on 30/12/2009"),
    c("28079024", "Casa de Campo", -3.749167, 40.42, ""),
    c("28079025", "Santa Eugenia", -3.6025, 40.379444,
      "Closed on 16/11/2009"),
    c("28079026", "Urb. Embajada (Barajas)", -3.578889, 40.459999,
      "Closed on 11/01/2010"),
    c("28079027", "Barajas", -3.575, 40.474722, ""),
    c("28079035", "Pza. del Carmen", -3.703333, 40.419167, ""),
    c("28079036", "Moratalaz", -3.645278, 40.408056, ""),
    c("28079038", "Cuatro Caminos", -3.706389, 40.445278, ""),
    c("28079039", "Barrio del Pilar", -3.711389, 40.478333, ""),
    c("28079040", "Vallecas", -3.651389, 40.388056, ""),
    c("28079047", "Méndez Álvaro", -3.686667, 40.398056,
      "Since 21/12/2009"),
    c("28079048", "Pº. Castellana", -3.690278, 40.439722,
      "Since 01/06/2010"),
    c("28079049", "Retiro", -3.685556, 40.409722,
      "Since 01/01/2010"),
    c("28079050", "Pza. Castilla", -3.688333, 40.465833,
      "Since 08/02/2010"),
    c("28079054", "Ensanche Vallecas", -3.611944, 40.372778,
      "Since 11/12/2009"),
    c("28079055", "Urb. Embajada (Barajas)", -3.580556, 40.4625,
      "Since 20/01/2010"),
    c("28079056", "Pza. Fdez. Ladreda", -3.718611, 40.384722,
      "Since 18/01/2010"),
    c("28079057", "Sanchinarro", -3.660278, 40.494167,
      "Since 24/11/2009"),
    c("28079058", "El Pardo", -3.774444, 40.518056,
      "Since 30/11/2009"),
    c("28079059", "Parque Juan Carlos I", -3.608889, 40.465,
      "Since 14/12/2009"),
    c("28079060", "Tres Olivos", -3.689722, 40.500556,
      "Since 14/01/2010")
  ),
  stringsAsFactors = FALSE
)

# Set proper column names and fix column types.
names(madrid.air.stations) <- c("Station", "Location", "Longitude", "Latitude",
                                "Comments")
madrid.air.stations$Longitude <- as.double(madrid.air.stations$Longitude)
madrid.air.stations$Latitude <- as.double(madrid.air.stations$Latitude)

# Set the right encoding for the locations.
Encoding(madrid.air.stations$Location) <- "UTF-8"
