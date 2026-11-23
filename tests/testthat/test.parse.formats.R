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

test_that("daily CSV data is properly parsed", {
  data <- madrid.air.parse("test.parse.daily.csv.data")

  # Days with a valid measurement only.
  expect_equal(ncol(data), 6)
  expect_equal(as.character(data[1, 1]), "28079004")
  expect_equal(data[1, 2], 2020)
  expect_equal(data[1, 3], 1)
  expect_equal(data[1, 4], 1)
  expect_equal(as.character(data[1, 5]), "SO2")
  expect_equal(data[1, 6], 9)

  # Days flagged as invalid are discarded.
  expect_equal(nrow(data[data$Month == 1, ]), 20)
})

test_that("daily CSV data with a byte order mark is properly parsed", {
  data <- madrid.air.parse("test.parse.daily.bom.csv.data")
  expect_equal(as.character(data[1, 1]), "28079011")
  expect_equal(data[1, 2], 2025)
  expect_equal(data[1, 6], 68)
})

test_that("daily TXT data is properly parsed", {
  data <- madrid.air.parse("test.parse.daily.txt.data")
  expect_equal(as.character(data[1, 1]), "28079004")
  expect_equal(data[1, 2], 2024)
  expect_equal(as.character(data[1, 5]), "CO")
  expect_equal(data[1, 6], 0.5)
})

test_that("hourly CSV and TXT data are equivalent", {
  csv <- madrid.air.parse("test.parse.hourly.csv.data")
  txt <- madrid.air.parse("test.parse.hourly.txt.data")

  # One row per hour for the first record.
  expect_equal(ncol(csv), 7)
  expect_equal(nrow(csv[csv$Day == 1 & csv$Magnitude == "CO", ]), 24)
  expect_equal(csv[1, 5], 1)
  expect_equal(csv[1, 7], 0.3)
  expect_equal(txt[txt$Day == 1, ], csv[csv$Day == 1, ])
})

test_that("the legacy fixed-width format is rejected", {
  expect_error(
    madrid.air.parse("test.parse.legacy.data"),
    "Invalid file format."
  )
})

test_that("empty files are rejected", {
  expect_error(
    madrid.air.parse("test.parse.empty.data"),
    "Invalid file format."
  )
})

test_that("CSV files with an unexpected header are rejected", {
  expect_error(
    madrid.air.parse("test.parse.badheader.data"),
    "Invalid file format."
  )
})

test_that("TXT files with too few fields are rejected", {
  expect_error(
    madrid.air.parse("test.parse.shorttxt.data"),
    "Invalid file format."
  )
})
