% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{varBetafun_gls}
\alias{varBetafun_gls}
\title{Compute covariance of Beta for a Generalized Least Squares (\code{GLS}) Model}
\usage{
varBetafun_gls(varpar, gls_obj)
}
\arguments{
\item{varpar}{variance parameters.}

\item{gls_obj}{a \code{gls} object.}
}
\value{
covariance of Beta, a numerical scalar.
}
\description{
Compute covariance of Beta for a Generalized Least Squares (\code{GLS}) Model
}
\details{
This code is adapted from code in \code{get_covbeta} internal function of 
 \pkg{pbkrtest} package.
}
\keyword{internal}
