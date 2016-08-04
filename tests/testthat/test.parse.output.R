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

test_that("CSV output is working", {
	
	# Delete the CSV file if it already exists.
	if (file.exists("test.parse.output.csv")) {
		unlink("test.parse.output.csv") 
	}

	# Save the dataset to disk.
	data <- madrid.air.parse("test.parse.output.data", output="test.parse.output.csv")

	# Check the generated CSV file.
	expect_equal(file.exists("test.parse.output.csv"), TRUE)
	expect_equal(length(readLines("test.parse.output.csv")), 25) # One line per hour plusheader.

	# Clean-up.
	unlink("test.parse.output.csv")
})
