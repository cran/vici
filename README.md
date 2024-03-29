
<!-- README.md is generated from README.Rmd. Please edit that file -->

# vici - Vaccine Induced Cellular Immunogenicity with Bivariate Modeling <a><img src='man/figures/logo.svg' align="right" height="139" /></a>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/vici)](https://CRAN.R-project.org/package=vici)
[![R-CMD-check](https://github.com/sistm/vici/workflows/R-CMD-check/badge.svg?branch=file_version)](https://github.com/sistm/vici/actions/workflows/R-CMD-check.yaml?query=branch%3Afile_version)
[![Downloads](https://cranlogs.r-pkg.org/badges/vicis?color=blue)](https://www.r-pkg.org/pkg/vici)
<!-- badges: end -->

`vici` encapsulate a shiny app for accurate estimation of vaccine
induced immunogenicity with bivariate linear modeling.

> Lhomme E, Hejblum BP, Lacabaratz C, Wiedemann A, Lelièvre JD, Lévy Y,
> Thiébaut R, Richert L (2020). Analyzing cellular immunogenicity in
> vaccine clinical trials: a new statistical method including
> non-specific responses for accurate estimation of vaccine effect.
> Journal of Immunological Methods, 477:112711.
> [doi:10.1016/j.jim.2019.112711](https://doi.org/10.1016/j.jim.2019.112711).

## Installation

You can install the released version of vici from the
[CRAN](https://cran.r-project.org/) with:

``` r
install.packages("vici")
```

or get the development version from
[GitHub](https://github.com/sistm/vici):

``` r
#install.packages("remotes")
remotes::install_github("sistm/vici", ref = "file_version")
```

Then you can launch the app with:

``` r
vici::run_app()
```

## Deployed VICI

- Latest **development** version is deployed at
  <https://shiny-vici.apps.math.cnrs.fr/>  
- Latest **stable** version is deployed at
  <http://vici.bph.u-bordeaux.fr/>

– Boris Hejblum
