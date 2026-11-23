[![Build Status](https://travis-ci.org/nramon/madrid.air.svg?branch=master)](https://travis-ci.org/nramon/madrid.air) [![codecov](https://codecov.io/gh/nramon/madrid.air/branch/master/graph/badge.svg)](https://codecov.io/gh/nramon/madrid.air) [![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/265/badge)](https://bestpractices.coreinfrastructure.org/projects/265)

# Madrid Air Quality Data Parser

Convert raw air quality data published by [https://datos.madrid.es/](https://datos.madrid.es/) to a clean data frame.

The original format is hard to interpret:

```
28;079;4;6;28079004_6_48;2024;04;01;0.3;V;0.3;V;0.3;V;0.3;V;0.3;V;0.3;V;0.3;V;0.4;V;0.4;V;...
```

[madrid.air](https://github.com/nramon/madrid.air) allows you to convert it to a more readable form:

```
   Station Year Month Day Hour Magnitude Value
1 28079004 2024     4   1    1        CO   0.3
2 28079004 2024     4   1    2        CO   0.3
3 28079004 2024     4   1    3        CO   0.3
...
```

Both the CSV and TXT formats published by Madrid City Council are supported. Files for all years, back to 2001, are available in these formats.

## Installation

To install [madrid.air](https://github.com/nramon/madrid.air) from GitHub start the R CMD interface and run the following commands:

```
install.packages("devtools")
library(devtools)
install_github("nramon/madrid.air")
```

## Downloading Madrid air quality data

Both [daily](https://datos.madrid.es/dataset/201410-0-calidad-aire-diario) and [hourly](https://datos.madrid.es/dataset/201200-0-calidad-aire-horario) data can be freely downloaded from [https://datos.madrid.es/](https://datos.madrid.es/) (also listed in [datos.gob.es](https://datos.gob.es/es/catalogo/l01280796-calidad-del-aire-datos-diarios-desde-2001)).

* Daily data is published as one CSV or TXT file per year. For example, `https://datos.madrid.es/dataset/201410-0-calidad-aire-diario/resource/201410-4-calidad-aire-diario-csv/download/201410-4-calidad-aire-diario-csv.csv` contains 2024. The most recent years are published together in a single, regularly updated file whose name includes a timestamp, so use the dataset page to get its current link.
* Hourly data is published as one ZIP file per year containing one CSV/TXT file per month. For example, `https://datos.madrid.es/dataset/201200-0-calidad-aire-horario/resource/201200-0-calidad-aire-horario-zip/download/201200-0-calidad-aire-horario-zip.zip` contains 2024.

The file format is described in the [official documentation](https://datos.madrid.es/dataset/201200-0-calidad-aire-horario/resource/201200-17-calidad-aire-horario/download/interprete_ficheros_20calidad_20del_20aire_global.pdf).

## Usage

See the package documentation for usage instructions and examples:

```
library(madrid.air)
?madrid.air
?madrid.air.parse
?madrid.air.magnitudes
?madrid.air.stations
```

## Bugs and issues

To provide feedback please use the [issue tracker](https://github.com/nramon/madrid.air/issues).

## Contributing

See [CONTRIBUTING.md](https://github.com/nramon/madrid.air/blob/master/CONTRIBUTING.md).

## Copyright

Copyright (C) 2016 Ramon Novoa <ramonnovoa@gmail.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
