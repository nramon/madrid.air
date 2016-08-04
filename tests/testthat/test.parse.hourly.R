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

test_that("hourly data is properly parsed", {

  # Test daily data for 2001/04/28
  data <- madrid.air.parse("test.parse.hourly.data")

  # One row per hour
  expect_equal(nrow(data), 24)

  # Seven variables.
  expect_equal(ncol(data), 7)

  # Test variables for 2001/04/28 12:00
  expect_equal(as.character(data[12, 1]), "28079002")
  expect_equal(as.character(data[12, 2]), "2001")
  expect_equal(as.character(data[12, 3]), "4")
  expect_equal(as.character(data[12, 4]), "28")
  expect_equal(as.character(data[12, 5]), "12")
  expect_equal(as.character(data[12, 6]), "O3")
  expect_equal(data[12, 7], 27.05)
})
