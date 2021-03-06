##     metaclipR.etccdi Construct a directed graph for encoding ETCDDI climate index transformations
##
##     Copyright (C) 2018 Predictia (http://www.predictia.es)
##
##     This program is free software: you can redistribute it and/or modify
##     it under the terms of the GNU General Public License as published by
##     the Free Software Foundation, either version 3 of the License, or
##     (at your option) any later version.
## 
##     This program is distributed in the hope that it will be useful,
##     but WITHOUT ANY WARRANTY; without even the implied warranty of
##     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##     GNU General Public License for more details.
## 
##     You should have received a copy of the GNU General Public License
##     along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' @title Directed metadata graph construction for ETCDDI climate index transformations
#' @description Build a directed metadata graph describing a ETCDDI climate index transformation on a 
#' climate4R grid 
#' @param package package
#' @param version version
#' @param fun function name. Unused (set to \code{"climdexGrid"})
#' @param output Optional. The output R object name, as character string
#' @param arg.list Argument list. See details
#' @param graph Output from previous metaclipR function. A list with an i-graph class object plus the name of the parent node 
#' from which the climate index step hangs.
#' \code{transformeR} indicated in argument \code{fun}.
#' @details This function takes as reference the semantics defined in the Data Source and Transformation ontology
#' defined in the Metaclip Framework (\url{http://metaclip.predictia.es/}).
#' 
#' \strong{Argument list}
#' 
#' The following (minimal) list of arguments is required to define an ETCCDI climate index transformation:
#' \itemize{
#' \item \code{index.code}
#' }
#' 
#' Further optional arguments can be passed to \code{arg.list} for a more detailed description of the command call.
#' The different arguments are explained in the the help page of \code{\link[climate4R.climdex]{climdexGrid}}. 
#' 
#' @references 
#' 
#' \href{https://github.com/Predictia/metaclip}{METACLIP Overview}
#' 
#' \href{http://visualdataweb.de/webvowl/#iri=http://metaclip.predictia.es/datasource/datasource.owl}{Visual schema of the data transformation ontology} 
#' 
#' \href{http://www.meteo.unican.es/en/climate4r}{Climate4R page at University of Cantabria}
#' 
#' @family transformation
#' @export
#' @importFrom igraph make_empty_graph add_vertices add_edges 
#' @author D. San Martín, J. Bedia
#' @examples \dontrun{
#' require(climate4R.climdex)
#' require(igraph)
#' data("tasmax.eobs")
#' a <- metaclipR.DatasetSubset(output = "tasmax.eobs",
#'                              fun = "subsetGrid",
#'                              arg.list = list(lonLim = c(-10,4.5),
#'                              latLim = c(35,44),
#'                              season = 1:12,
#'                              years = 1991:2010))
#'
#' tx10p <- climdexGrid(index.code = "TX10p",
#'                      tx = tasmax.eobs,
#'                      index.arg.list = list(freq = "annual"))
#' 
#' arg.list <- list(index.code = "TX10p",
#'                  index.arg.list = list(freq = "annual"))
#' 
#' require(visualizeR)
#' spatialPlot(climatology(tx10p),
#'             backdrop.theme = "countries",
#'             main = "Mean percentage of days when TX < 10 degC (1991-2010)")
#' metadata <- metaclipR.etccdi(graph = a, arg.list = arg.list)            
#' plot(metadata$graph)
#' }
 

metaclipR.etccdi <- function(graph,
                             package = "climate4R.climdex",
                             version = "0.1.2",
                             output = NULL,
                             fun = "climdexGrid",
                             arg.list = NULL) {
    if (class(graph$graph) != "igraph") stop("Invalid input graph (not an 'igraph-class' object)")
    if (is.null(arg.list$index.code)) {
        stop("The 'index.code' argument is missing in the argument list, with no default")
    }
    orig.node <- graph$parentnodename
    graph <- graph$graph
    cicalc.node <- paste("ClimateIndexCalculation", randomName(), sep = ".")
    # ClimateIndex calculation node
    graph <- my_add_vertices(graph,
                             nv = 1,
                             name = cicalc.node,
                             label = "ClimateIndexCalculation",
                             className = "ds:ClimateIndexCalculation")
    graph <- add_edges(graph,
                       c(getNodeIndexbyName(graph, orig.node),
                         getNodeIndexbyName(graph, cicalc.node)),
                       label = "ds:hadClimateIndexCalculation")
    # Climate index node
    isKnownIndex <- ifelse(arg.list$index.code %in% suppressMessages(knownClassIndividuals("ETCCDI")), TRUE, FALSE)
    if (isKnownIndex) {
        nodename <- paste0("ds:", arg.list$index.code)
        cn <- "ds:ETCCDI"
    } else {
        nodename <- paste0("CimateIndex.", randomName())
        cn <- "ds:ClimateIndex"
    }
    graph <- my_add_vertices(graph,
                             nv = 1,
                             name = nodename,
                             label = paste("ClimateIndex", arg.list$index.code, sep = "."),
                             className = cn)
    graph <- add_edges(graph,
                       c(getNodeIndexbyName(graph, cicalc.node),
                         getNodeIndexbyName(graph, nodename)),
                       label = "ds:withClimateIndex")
    # TemporalResolution ---------------------
    # hasTimeStep
    if (!is.null(output)) {
        output <- get(output)
        output$Data <- NULL
        time.step <- getHasTimeStep(output)
        output <- NULL
        cell.method <- arg.list$index.code
        timeres.nodename <- paste("TemporalResolution", randomName(), sep = ".")
        graph <- add_vertices(graph,
                              nv = 1,
                              name = timeres.nodename,
                              label = "TemporalResolution",
                              className = "ds:TemporalResolution",
                              attr = list("ds:hasTimeStep" = time.step,
                                          "ds:hasCellMethod" = cell.method))
        graph <- add_edges(graph, 
                           c(getNodeIndexbyName(graph, cicalc.node),
                             getNodeIndexbyName(graph, timeres.nodename)),
                           label = "ds:hasTemporalResolution")
    }
    # Package/Command/Argument metadata ---------------------------------------
    if ("tn" %in% names(arg.list)) arg.list <- arg.list[-grep("tn", names(arg.list))]
    if ("tx" %in% names(arg.list)) arg.list <- arg.list[-grep("tx", names(arg.list))]
    if ("pr" %in% names(arg.list)) arg.list <- arg.list[-grep("pr", names(arg.list))]
    graph <- metaclip.graph.Command(graph, package, version, fun, arg.list,
                                    origin.node.name = cicalc.node)
    return(list("graph" = graph, "parentnodename" = cicalc.node))
}
