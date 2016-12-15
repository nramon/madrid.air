# Contributing

If you would like to contribute code, first [fork](https://help.github.com/articles/fork-a-repo/) and [clone](https://help.github.com/articles/cloning-a-repository/) the [repository](https://github.com/nramon/madrid.air).

Install the following R packages:

```
install.packages("devtools")
install.packages("dplyr")
install.packages("lintr")
install.packages("roxygen2")
install.packages("testthat")
install.packages("tidyr")
```

Create a new [branch](https://help.github.com/articles/creating-and-deleting-branches-within-your-repository/) and start making changes to the code.

Do not forget to write [tests](https://CRAN.R-project.org/package=testthat) under the [testthat](https://github.com/nramon/madrid.air/tree/master/tests/testthat) subdirectory for any new code you write!

When you are done, make sure the package builds and all the tests pass:

```
make document
make check
make test
make build
```

Lastly, push to your fork and [create a pull request](https://help.github.com/articles/creating-a-pull-request/).

