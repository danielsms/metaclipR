% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metaclipR.AnomalyMap.R
\name{metaclipR.AnomalyMap}
\alias{metaclipR.AnomalyMap}
\title{Directed metadata graph construction for Map graphical products}
\usage{
metaclipR.AnomalyMap(package = "visualizeR", version = "1.1.1",
  graph = NULL, input.grid = NULL, fun = "spatialPlot", arg.list = NULL,
  withInput = NULL, epsg.code = "EPSG:4979")
}
\arguments{
\item{package}{package}

\item{version}{version}

\item{graph}{i-graph class object containing the input grid whose values are to be mapped}

\item{input.grid}{Optional. The input grid passed to the plotting function. Some metadata are extracted from 
this object if not explicit from the plotting arguments (e.g., the spatial extent of the map).}

\item{fun}{function name. Default to \code{spatialPlot}, from package \code{visualizeR}.}

\item{arg.list}{Argument list (A named list in key-value format).}

\item{withInput}{The name of the parent node from which the aggregation step hangs.
\code{transformeR} indicated in argument \code{fun}.}

\item{epsg.code}{A character string indicating the EPSG code of the map projection. Default to \code{"4979"}
(the most widely used WGS84 proj).}
}
\description{
Build a directed metadata graph describing a map
}
\details{
This function takes as reference the semantics defined in the Data Source and Transformation ontology
defined in the Metaclip Framework (\url{http://metaclip.predictia.es/}).
}
\references{
\href{https://docs.google.com/presentation/d/1Bn7M7IIFVvOoKG7YymXkDnNH4vJOqO6xmimeUI6Uxc0/view#slide=id.g23b883c69b_0_194}{Visual schema of the graphical product ontology}
\href{http://www.meteo.unican.es/en/climate4r}{Climate4R page at University of Cantabria}
}
\seealso{
Other graphical.products: \code{\link{metaclipR.EnsoPlume}},
  \code{\link{metaclipR.SkillMap}},
  \code{\link{metaclipR.SpatialPlot}}
}
\author{
D. San Martín, J. Bedia
}
