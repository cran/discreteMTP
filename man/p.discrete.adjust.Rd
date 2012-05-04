\name{p.discrete.adjust}
\alias{p.discrete.adjust}
\alias{p.discrete.adjust.methods}
\title{Adjusted Discrete Distributed P-values for Multiple Testing
}
\description{
Given a set of p-values and their discrete cumulative distribution functions (CDF), returns p-values adjusted using one of several methods.
}
\usage{
p.discrete.adjust(p, pCDF, method = p.discrete.adjust.methods, cutoff = 1, n = length(p))

p.discrete.adjust.methods
## c("BH", "BL", "BHmidp", "BLmidp", "DBH", "DBL", "none")
}
\arguments{
  \item{p}{
  numeric vector of p-values (possibly with \code{\link{NA}}s). Any other \R is coerced by \code{\link{as.numeric}}. Same as in \code{\link{p.adjust}}.
}
  \item{pCDF}{
  a list of numeric vectors, where each vector is the vector of atoms (in ascending order) of the step function that is the CDF of the corresponding p-value. 
}
  \item{method}{
  correction method. See details.
}
  \item{cutoff}{
  an upper limit for the p-values to be adjusted; set this (to non-default) if p-values above the cutoff may be viewed as corresponding to null hypotheses.
}
  \item{n}{number of comparisons, must be at least length(p).
}
}
\details{
The adjustment methods include the step-up Benjamini & Hochberg (1995) procedure on mid P-values ("BHmidp"); the step-up procedure of Heyse (2011, "DBH"); the step-down Benjamini & Liu (1999) procedure on mid P-values ("BLmidp"); the step-down procedure of Heller &  Gur (2011, "DBL").  
For completeness, the  step-up Benjamini & Hochberg (1995) procedure ("BH") and the step-down Benjamini & Liu (1999) procedure ("BL") are also provided. 

For discrete tests, the procedures "BHmidP" and "BLmidP" have closer nominal FDR levels than "BH" and "BL" respectively.  
Moroever, when the p-values are independent procedure "DBL" has proven FDR control, along with procedures "BH" and "BL".  
For power comparisons across methods, see Heller &  Gur (2011).  

The \code{cutoff} can be set to a value between 0 and 1, usually 0.05 is a good conservative guess that will aleviate the computational burden without power loss. All unadjusted p-values above this value will not be adjusted, and will receive a default value of 1 in the output vector. The purpose of \code{cutoff} is to reduce substaintially computational costs in very large number of tests.

\code{n} can be set to a value larger than \code{length(p)} which means the unobserved p-values are assumed to be equal to 1.
}
\value{
A numeric vector of the adjusted p-values (of the same length as \code{p}).
}
\references{
Benjamini, Y., and Hochberg, Y. (1995).Controlling the false discovery rate: a practical and powerful approach to multiple testing.
  \emph{Journal of the Royal Statistical Society Series} B, \bold{57}, 289--300.
  
Benjamini, Y., and Liu, W. (1999). A step-down multiple hypotheses testing procedure that controls the false discovery rate under independence.
  \emph{Statistical planning and inference}, \bold{82}, 163--170.

Heller, R., and Gur, H. (2011). False discovery rate controlling procedures for discrete tests.
  \emph{arXiv:1112.4627v1} \href{http://arxiv.org/abs/1112.4627v1}{link}.

Heyse, J. (2011). A false discovery rate procedure for categorical data.
  \emph{Resent Advances in Biostatistics: False Discovery Rates, Survival Analysis, and Related Topics}, 43--58.
}

\note{The function structure  and code is mainly based on the code in \code{\link{p.adjust}} writen by R Development Core Team.
 The \code{BH} method is identical to the code in \code{\link{p.adjust}} .
}

\author{
Ruth Heller, Hadas Gur and Shay Yaacoby.

Maintainer: Shay Yaacoby \email{shay66@gmail.com}

}
\seealso{
\code{\link{p.adjust}}
}
\examples{
data(amnesia)

A11 <- amnesia$AmnesiaCases 
A21 <- sum(amnesia$AllAdverseCases) - A11
A12 <- amnesia$AllAdverseCases - A11
A22 <- sum(amnesia$AllAdverseCases) - sum(amnesia$AmnesiaCases) - A12

## Entry j in each of the four vectors is the data for the test of no association
## between drug j and amnesia :  
##                        Drug j    Other Drugs
##  Amnesia               A11[j]    A12[j]      A1.[j]      
##  Other Adverse events  A21[j]    A22[j]      A2.[j]
##                        n         N-n         N		

## For example, the 2X2 contingency table to test the hypothesis of
## amensia adverse drug reaction in the drug "ZOPICLONE":
matrix(c(A11[2444], A21[2444], A12[2444], A22[2444]),nrow = 2)

A1. <- sum(amnesia$AmnesiaCases)
A2. <- sum(amnesia$AllAdverseCases) - A1.   
n <- A11 + A12
k <- pmin(n,A1.)

pCDFlist <- list()
pvec <- numeric(nrow(amnesia))

## Calculation of the p-values and the p-values CDFs: 

for (i in 1:nrow(amnesia))
{
  x <- 0:k[i]
  pCDFlist[[i]] <- dhyper(x ,A1., A2. ,n[i]) + phyper(x ,A1. ,A2. ,n[i] ,lower.tail = FALSE)
  pCDFlist[[i]] <- rev(pCDFlist[[i]])
  pvec[i] <- dhyper(A11[i] ,A1. ,A2. ,n[i]) + phyper(A11[i] ,A1. ,A2. ,n[i] ,lower.tail = FALSE)
}

pBH <- p.discrete.adjust(pvec, pCDFlist, method = "BH")
pBL <- p.discrete.adjust(pvec, pCDFlist, method = "BL")
pBHmidp <- p.discrete.adjust(pvec, pCDFlist, method = "BHmidp")
pBLmidp <- p.discrete.adjust(pvec, pCDFlist, method = "BLmidp")
pDBH <- p.discrete.adjust(pvec, pCDFlist, method = "DBH")
pDBL <- p.discrete.adjust(pvec, pCDFlist, method = "DBL")

## Number of rejected hypothesis at level 0.05:
q <- 0.05
sum(pBL <= q)     ## 16  
sum(pBLmidp <= q) ## 17
sum(pDBL <= q)    ## 21
sum(pBH <= q)     ## 24
sum(pBHmidp <= q) ## 25
sum(pDBH <= q)    ## 27

## plotting:
o = order(pvec)

matplot(1:length(pvec), cbind(pvec[o], pBL[o], pBLmidp[o], pDBL[o], pBH[o], pBHmidp[o], pDBH[o]),
        type = "l", lty = c(4,3,3,3,2,2,2), 
        col = c("#4735B2","#B25A00","#24B200","#106B99","#B25A00","#24B200","#106B99"),
        xlim = c(1,100), xlab = "Rank", ylab = "Adjusted p-values")
abline(0.05,0,col = "grey")
legend("bottomright",legend=c("pvec-unadjusted","pBL","pBLmidp","pDBL","pBH","pBHmidp","pDBH"),
       lty = c(4,3,3,3,2,2,2),
       col = c("#4735B2","#B25A00","#24B200","#106B99","#B25A00","#24B200","#106B99"))
}
