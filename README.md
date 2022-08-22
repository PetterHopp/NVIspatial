# NVIspatial: Tools to facilitate working with Spatial Data at NVI

<!-- README.md is generated from README.Rmd. Please edit that file -->

-   [Overview](#overview)
-   [Installation](#installation)
-   [Usage](#usage)
-   [Copyright and license](#copyright-and-license)
-   [Contributing](#contributing)

## Overview

`NVIspatial`provides tools to facilitate working with spatial data at
NVI. Currently, NVI spatial holds the function ‘is\_it\_in\_Norway’. The
package will be extended with other tools for handling (Norwegian)
spatial data.

`NVIspatial` is part of `NVIverse`, a collection of R-packages with
tools to facilitate data management and data reporting at the Norwegian
Veterinary Institute (NVI). The `NVIverse` consists of the following
packages: `NVIconfig`, `NVIdb`, `NVIspatial`, `NVIpretty`, `NVIbatch`,
`OKplan`, `OKcheck`, `NVIcheckmate`, `NVIpackager`, `NVIrpackages`. See
[Contribute to
NVIspatial](https://github.com/NorwegianVeterinaryInstitute/NVIspatial/blob/main/CONTRIBUTING.md)
for more information.

## Installation

`NVIspatial` is available at
[GitHub](https://github.com/NorwegianVeterinaryInstitute). To install
`NVIspatial` you will need:

-   R version > 4.0.0
-   R package `remotes`
-   Rtools 4.0 or Rtools 4.2 depending on R version

First install and attach the `remotes` package.

    install.packages("remotes")
    library(remotes)

To install (or update) the `NVIspatial` package, run the following code:

    remotes::install_github("NorwegianVeterinaryInstitute/NVIspatial",
        upgrade = FALSE,
        build = TRUE,
        build_vignettes = TRUE)

## Usage

The `NVIspatial` package needs to be attached.

    library(NVIspatial)

`NVIspatial` provides tools to facilitate working with spatial data at
NVI. Currently, NVI spatial holds the function ‘is\_it\_in\_Norway’. The
package will be extended with other tools for handling (Norwegian)
spatial data.

The full list of all available functions and datasets can be accessed by
typing

    help(package = "NVIspatial")

Please check the NEWS for information on new features, bug fixes and
other changes.

## Copyright and license

Copyright (c) 2022 Norwegian Veterinary Institute.  
Licensed under the BSD\_3\_clause License. See
[License](https://github.com/NorwegianVeterinaryInstitute/NVIspatial/blob/main/LICENSE)
for details.

## Contributing

Contributions to develop `NVIspatial` is highly appreciated. There are
several ways you can contribute to this project: ask a question, propose
an idea, report a bug, improve the documentation, or contribute code.
See [Contribute to
NVIspatial](https://github.com/NorwegianVeterinaryInstitute/NVIspatial/blob/main/CONTRIBUTING.md)
for more information.

------------------------------------------------------------------------

<!-- Code of conduct -->

Please note that the NVIspatial project is released with a [Contributor
Code of
Conduct](https://github.com/NorwegianVeterinaryInstitute/NVIspatial/blob/main/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.
