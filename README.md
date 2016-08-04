[![Build Status](https://travis-ci.org/nramon/madrid.air.svg?branch=master)](https://travis-ci.org/nramon/madrid.air) [![codecov](https://codecov.io/gh/nramon/madrid.air/branch/master/graph/badge.svg)](https://codecov.io/gh/nramon/madrid.air)

# Madrid Air Quality Data Parser

Convert raw air quality data published by [http://datos.madrid.es/](http://datos.madrid.es/) to a clean data frame.

The original format is hard to interpret:

```
2807900214060201042844.55V52.04V48.30V48.37V23.60V27.89V28.42V13.75V19.11V38.89V26.32V27.05V41.60V46.91V58.52V77.15V74.55V60.91V52.33V46.20V23.47V9.500V12.24V18.92V
```

[madrid.air](https://github.com/nramon/madrid.air) allows you to convert it to a more readable form:

```
     Station Year Month Day Hour Magnitude Value
1	28079002 2001     4  28    1        O3 44.55
2	28079002 2001     4  28    2        O3 52.04
3	28079002 2001     4  28    3        O3 48.30
...
```

## Installation

To install [madrid.air](https://github.com/nramon/madrid.air) from GitHub start the R CMD interface and run the following commands:

```
install.packages("devtools")
library(devtools)
install_github("nramon/madrid.air")
```

## Downloading Madrid air quality data

Both [daily](http://datos.madrid.es/sites/v/index.jsp?vgnextoid=aecb88a7e2b73410VgnVCM2000000c205a0aRCRD&vgnextchannel=374512b9ace9f310VgnVCM100000171f5a0aRCRD) and [hourly](http://datos.madrid.es/sites/v/index.jsp?vgnextoid=f3c0f7d512273410VgnVCM2000000c205a0aRCRD&vgnextchannel=374512b9ace9f310VgnVCM100000171f5a0aRCRD) data can be freely downloaded from [http://datos.madrid.es/](http://datos.madrid.es/).

## Usage

See the package documentation for usage instructions and examples:

```
library(madrid.air)
?madrid.air
?madrid.air.parse
?madrid.air.magnitudes
?madrid.air.stations
```

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
