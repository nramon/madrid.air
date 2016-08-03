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

test_that("daily data is properly parsed", {
	
	# Test daily data for 2001/03
	data <- madrid.air.parse("test.parse.daily.2001.data")

	# One row per day.
	expect_equal(nrow(data), 31)

	# Six variables.
	expect_equal(ncol(data), 6)

	# Test variables for 2001/11/15
	expect_equal(as.character(data[7, 1]), "28079001")
	expect_equal(data[7, 2], 2001)
	expect_equal(data[7, 3], 3)
	expect_equal(data[7, 4], 7)
	expect_equal(as.character(data[7, 5]), "CO")
	expect_equal(data[7, 6], 1.34)
})
