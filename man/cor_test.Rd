% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cor_test.R
\name{cor_test}
\alias{cor_test}
\title{Correlation test}
\usage{
cor_test(
  data,
  x,
  y,
  method = "pearson",
  ci = 0.95,
  bayesian = FALSE,
  bayesian_prior = "medium",
  bayesian_ci_method = "hdi",
  bayesian_test = c("pd", "rope", "bf"),
  include_factors = FALSE,
  partial = FALSE,
  partial_bayesian = FALSE,
  multilevel = FALSE,
  robust = FALSE,
  ...
)
}
\arguments{
\item{data}{A data frame.}

\item{x, y}{Names of two variables present in the data.}

\item{method}{A character string indicating which correlation coefficient is to be used for the test. One of "pearson" (default), "kendall", or "spearman", "biserial", "polychoric", "tetrachoric", "biweight", "distance", "percentage" (for percentage bend correlation) or "shepherd" (for Shepherd's Pi correlation). Setting "auto" will attempt at selecting the most relevant method (polychoric when ordinal factors involved, tetrachoric when dichotomous factors involved, point-biserial if one dichotomous and one continuous and pearson otherwise).}

\item{ci}{Confidence/Credible Interval level. If "default", then it is set to 0.95 (95\% CI).}

\item{bayesian, partial_bayesian}{If TRUE, will run the correlations under a Bayesian framework. Note that for partial correlations, you will also need to set \code{partial_bayesian} to \code{TRUE} to obtain "full" Bayesian partial correlations. Otherwise, you will obtain pseudo-Bayesian partial correlations (i.e., Bayesian correlation based on frequentist partialization).}

\item{bayesian_prior}{For the prior argument, several named values are recognized: "medium.narrow", "medium", "wide", and "ultrawide". These correspond to scale values of 1/sqrt(27), 1/3, 1/sqrt(3) and 1, respectively. See the \code{BayesFactor::correlationBF} function.}

\item{bayesian_ci_method, bayesian_test}{See arguments in \code{\link[=parameters]{model_parameters}} for \code{BayesFactor} tests.}

\item{include_factors}{If \code{TRUE}, the factors are kept and eventually converted to numeric or used as random effects (depending of \code{multilevel}). If \code{FALSE}, factors are removed upfront.}

\item{partial}{Can be TRUE or "semi" for partial and semi-partial correlations, respectively.}

\item{multilevel}{If \code{TRUE}, the factors are included as random factors. Else, if \code{FALSE} (default), they are included as fixed effects in the simple regression model.}

\item{robust}{If TRUE, will rank-transform the variables prior to estimating the correlation. Note that, for instance, a Pearson's correlation on rank-transformed data is equivalent to a Spearman's rank correlation. Thus, using \code{robust=TRUE} and \code{method="spearman"} is redundant. Nonetheless, it is an easy way to increase the robustness of the correlation (as well as obtaining Bayesian Spearman rank Correlations).}

\item{...}{Arguments passed to or from other methods.}
}
\description{
This function performs a correlation test between two variables.
}
\details{
\subsection{Correlation Types}{
\itemize{
\item \strong{Pearson's correlation}: This is the most common correlation method. It corresponds to the covariance of the two variables normalized (i.e., divided) by the product of their standard deviations.
\item \strong{Spearman's rank correlation}: A non-parametric measure of rank correlation (statistical dependence between the rankings of two variables). The Spearman correlation between two variables is equal to the Pearson correlation between the rank values of those two variables; while Pearson's correlation assesses linear relationships, Spearman's correlation assesses monotonic relationships (whether linear or not). Confidence Intervals (CI) for Spearman's correlations are computed using the Fieller et al. (1957) correction (see Bishara and Hittner, 2017).
\item \strong{Kendall's rank correlation}: In the normal case, the Kendall correlation is preferred than the Spearman correlation because of a smaller gross error sensitivity (GES) and a smaller asymptotic variance (AV), making it more robust and more efficient. However, the interpretation of Kendall's tau is less direct than that of Spearman's rho, in the sense that it quantifies the difference between the \% of concordant and discordant pairs among all possible pairwise events. Confidence Intervals (CI) for Kendall's correlations are computed using the Fieller et al. (1957) correction (see Bishara and Hittner, 2017).
\item \strong{Biweight midcorrelation}: A measure of similarity that is median-based, instead of the traditional mean-based, thus being less sensitive to outliers. It can be used as a robust alternative to other similarity metrics, such as Pearson correlation (Langfelder \& Horvath, 2012).
\item \strong{Distance correlation}: Distance correlation measures both linear and non-linear association between two random variables or random vectors. This is in contrast to Pearson's correlation, which can only detect linear association between two random variables.
\item \strong{Percentage bend correlation}: Introduced by Wilcox (1994), it is based on a down-weight of a specified percentage of marginal observations deviating from the median (by default, 20\%).
\item \strong{Shepherd's Pi correlation}: Equivalent to a Spearman's rank correlation after outliers removal (by means of bootstrapped Mahalanobis distance).
\item \strong{Point-Biserial and biserial correlation}: Correlation coefficient used when one variable is continuous and the other is dichotomous (binary). Point-Biserial is equivalent to a Pearson's correlation, while Biserial should be used when the binary variable is assumed to have an underlying continuity. For example, anxiety level can be measured on a continuous scale, but can be classified dichotomously as high/low.
\item \strong{Polychoric correlation}: Correlation between two theorised normally distributed continuous latent variables, from two observed ordinal variables.
\item \strong{Tetrachoric correlation}: Special case of the polychoric correlation applicable when both observed variables are dichotomous.
}}

\subsection{Partial Correlation}{
\strong{Partial correlations} are estimated as the correlation between two variables after adjusting for the (linear) effect of one or more other variable.
The correlation test is then run after having partialized the dataset, independently from it. In other words, it considers partialization as an independent step generating a different dataset, rather than belonging to the same model.
This is why some discrepancies are to be expected for the t- and p-values, CIs, BFs etc (but \emph{not} the correlation coefficient) compared to other implementations (e.g., \code{ppcor}).
(The size of these discrepancies depends on the number of covariates partialled-out and the strength of the linear association between all variables.)
Such partial correlations can be represented as Gaussian Graphical Models (GGM), an increasingly popular tool in psychology. A GGM traditionally include a set of variables depicted as circles ("nodes"), and a set of lines that visualize relationships between them, which thickness represents the strength of association (see Bhushan et al., 2019).
\cr\cr
\strong{Multilevel correlations} are a special case of partial correlations where the variable to be adjusted for is a factor and is included as a random effect in a mixed model.
}

\subsection{Notes}{
\itemize{
  \item Kendall and Spearman correlations when \code{bayesian=TRUE}: These are technically Pearson Bayesian correlations of rank transformed data, rather than pure Bayesian rank correlations (which have different priors).

}}
}
\examples{
library(correlation)

cor_test(iris, "Sepal.Length", "Sepal.Width")
cor_test(iris, "Sepal.Length", "Sepal.Width", method = "spearman")
cor_test(iris, "Sepal.Length", "Sepal.Width", method = "kendall")
cor_test(iris, "Sepal.Length", "Sepal.Width", method = "biweight")
cor_test(iris, "Sepal.Length", "Sepal.Width", method = "distance")
cor_test(iris, "Sepal.Length", "Sepal.Width", method = "percentage")
cor_test(iris, "Sepal.Length", "Sepal.Width", method = "shepherd")
cor_test(iris, "Sepal.Length", "Sepal.Width", bayesian = TRUE)

# Tetrachoric
data <- iris
data$Sepal.Width_binary <- ifelse(data$Sepal.Width > 3, 1, 0)
data$Petal.Width_binary <- ifelse(data$Petal.Width > 1.2, 1, 0)
cor_test(data, "Sepal.Width_binary", "Petal.Width_binary", method = "tetrachoric")

# Biserial
cor_test(data, "Sepal.Width", "Petal.Width_binary", method = "biserial")

# Polychoric
data$Petal.Width_ordinal <- as.factor(round(data$Petal.Width))
data$Sepal.Length_ordinal <- as.factor(round(data$Sepal.Length))
cor_test(data, "Petal.Width_ordinal", "Sepal.Length_ordinal", method = "polychoric")

# When one variable is continuous, will run 'polyserial' correlation
cor_test(data, "Sepal.Width", "Sepal.Length_ordinal", method = "polychoric")

# Robust (these two are equivalent)
cor_test(iris, "Sepal.Length", "Sepal.Width", method = "pearson", robust = TRUE)
cor_test(iris, "Sepal.Length", "Sepal.Width", method = "spearman", robust = FALSE)

# Partial
cor_test(iris, "Sepal.Length", "Sepal.Width", partial = TRUE)
cor_test(iris, "Sepal.Length", "Sepal.Width", multilevel = TRUE)
\donttest{
cor_test(iris, "Sepal.Length", "Sepal.Width", partial_bayesian = TRUE)
}

}
