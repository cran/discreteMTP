\name{amnesia}
\docType{data}
\alias{amnesia}
\title{
Amnesia And Other Drug Reactions In The MHRA Pharmacovigilence Spontaneous Reporting System 
}
\description{
For each of 2446 drugs in the MHRA database (column 1), the number of cases with Amnesia as an adverse event (column 2), and the number of cases with adverse event for this drug (column 3).  
In total, 682648 adverse drug reactions were reported, among them 2044 cases of amnesia.
}
\usage{data(amnesia)}
\format{
  A data frame with 2446 rows representing drugs with the following 3 columns:
  \describe{
    \item{\code{DrugName}}{The name of the drug.}
    \item{\code{AmnesiaCases}}{Number of the amnesia cases reported for the drug.}
    \item{\code{AllAdverseCases}}{Number of all adverse drug reactions reported for the drug.}
  }
}
\details{
The data was collected from the Drug Analysis Prints published by the Medicines and Healthecare products Regulatory Agency (MHRA).
}
\source{
\href{http://www.mhra.gov.uk/Safetyinformation/Howwemonitorthesafetyofproducts/Medicines/TheYellowCardScheme/YellowCarddata/Druganalysisprints/index.htm}{Drug Analysis Prints on MHRA site.}}
\references{
Heller, R., and Gur, H. (2011). False discovery rate controlling procedures for discrete tests.
  \emph{arXiv:1112.4627v1} \href{http://arxiv.org/abs/1112.4627v1}{link}.
}
\keyword{datasets}