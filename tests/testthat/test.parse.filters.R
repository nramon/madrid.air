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

test_that("filters are working", {
	
	# Filter by station.
	data <- madrid.air.parse("test.parse.filters.data", station=28079002)

	# One row per hour
	expect_equal(sum(data$Station == 28079002), 24)

	# Filter by magnitude.
	data <- madrid.air.parse("test.parse.filters.data", magnitude="CO")

	# One row per hour.
	expect_equal(sum(as.character(data$Magnitude) == "CO"), 24)
})
