% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metaclipR.easyVerification.R
\name{metaclipR.easyVerification}
\alias{metaclipR.easyVerification}
\title{Directed metadata graph construction for outputs}
\usage{
metaclipR.easyVerification(package = "easyVerification", version = "0.4.4",
  fun, arg.list, ForecastGraph, ReferenceGraph, ReferenceForecastGraph = NULL)
}
\arguments{
\item{package}{Verification package. Default to \code{"easyVerification"}}

\item{version}{A character string of the package version (e.g. as returned by \code{\link[utils]{packageVersion}})}

\item{fun}{Verification function. Default to \code{"veriApply"}.}

\item{arg.list}{argument list passed by \code{\link{metaclip.graph}}.}

\item{ForecastGraph}{metaclipR output containing the forecast (hindcast) definition}

\item{ReferenceGraph}{metaclipR output  containing the reference (observations) definition}

\item{ReferenceForecastGraph}{Optional. metaclipR output containing the reference forecast definition}
}
\description{
Build a directed metadata graph from veriApply calls, and other verification routines
}
\details{
This function takes as reference the semantics defined in the Seasonal Forecast Verification ontology
defined in the Metaclip Framework (\url{http://metaclip.predictia.es/}).
}
\seealso{
Other validation: \code{\link{metaclipR.Validation}}
}
\author{
D. San Martín, J. Bedia
}
