#' Longitudinal dataset with repeated measures of depression and rumination
#'
#' @description Example dataset with a measure of depression symptoms (BDI) and a secondary process measure (RQ; Rumination Questionnaire) to illustrate how the package works.
#' @docType data
#' @usage data(sgdata)
#' @format A longitudinal dataset in wide format, i.e one row per person, one column per variable.
#' \itemize{
#'   \item{id}{: ID variable, unique identifier for each person}
#'   \item{bdi_s0}{: BDI value, baseline assessment}
#'   \item{bdi_s1}{: BDI value, session 1}
#'   \item{bdi_s2}{: BDI value, session 2}
#'   \item{bdi_s3}{: BDI value, session 3}
#'   \item{bdi_s4}{: BDI value, session 4}
#'   \item{bdi_s5}{: BDI value, session 5}
#'   \item{bdi_s6}{: BDI value, session 6}
#'   \item{bdi_s7}{: BDI value, session 7}
#'   \item{bdi_s8}{: BDI value, session 8}
#'   \item{bdi_s9}{: BDI value, session 9}
#'   \item{bdi_s10}{: BDI value, session 10}
#'   \item{bdi_s11}{: BDI value, session 11}
#'   \item{bdi_s12}{: BDI value, session 12}
#'   \item{bdi_fu1}{: BDI value, follow-up measure 1}
#'   \item{bdi_fu2}{: BDI value, follow-up measure 2}
#'   \item{rq_s0}{: RQ value, baseline assessment}
#'   \item{rq_s1}{: RQ value, session 1}
#'   \item{rq_s2}{: RQ value, session 2}
#'   \item{rq_s3}{: RQ value, session 3}
#'   \item{rq_s4}{: RQ value, session 4}
#'   \item{rq_s5}{: RQ value, session 5}
#'   \item{rq_s6}{: RQ value, session 6}
#'   \item{rq_s7}{: RQ value, session 7}
#'   \item{rq_s8}{: RQ value, session 8}
#'   \item{rq_s9}{: RQ value, session 9}
#'   \item{rq_s10}{: RQ value, session 10}
#'   \item{rq_s11}{: RQ value, session 11}
#'   \item{rq_s12}{: RQ value, session 12}
#'   \item{rq_fu1}{: RQ value, follow-up measure 1}
#'   \item{rq_fu2}{: RQ value, follow-up measure 2}
#' }
#' @keywords dataset
#' @examples
#' # Load data into global environment
#' data(sgdata)
"sgdata"


#' Longitudinal dataset with repeated measures of depression and rumination (bad variable names)
#'
#' @description Same as \code{sgdata} but with bad vaiable names to illustrate that the package can also work with inconsistent names.
#' @docType data
#' @usage data(sgdata_bad)
#' @format A longitudinal dataset in wide format, i.e one row per person, one column per variable.
#' \itemize{
#'   \item{id}{: ID variable, unique identifier for each person}
#'   \item{bdi_intake}{: BDI value, baseline assessment}
#'   \item{bdi1}{: BDI value, session 1}
#'   \item{wk2bdi}{: BDI value, session 2}
#'   \item{bdi.S3}{: BDI value, session 3}
#'   \item{bdis4}{: BDI value, session 4}
#'   \item{bdi_session5}{: BDI value, session 5}
#'   \item{bdi_weekSix}{: BDI value, session 6}
#'   \item{beck.dep.inv_sess7}{: BDI value, session 7}
#'   \item{weeeek8bdi}{: BDI value, session 8}
#'   \item{bdi_nine}{: BDI value, session 9}
#'   \item{bdii10}{: BDI value, session 10}
#'   \item{bDi11}{: BDI value, session 11}
#'   \item{bdi_s12_end}{: BDI value, session 12}
#'   \item{bdi_fu1}{: BDI value, follow-up measure 1}
#'   \item{bdi_followup2}{: BDI value, follow-up measure 2}
#'   \item{rq_intake}{: RQ value, baseline assessment}
#'   \item{rqi1}{: RQ value, session 1}
#'   \item{wk2rq}{: RQ value, session 2}
#'   \item{rq.S3}{: RQ value, session 3}
#'   \item{rq_s4}{: RQ value, session 4}
#'   \item{rq_session5}{: RQ value, session 5}
#'   \item{rq_weekSix}{: RQ value, session 6}
#'   \item{rq_sess7}{: RQ value, session 7}
#'   \item{weeeek8rq}{: RQ value, session 8}
#'   \item{rqnine}{: RQ value, session 9}
#'   \item{rq10}{: RQ value, session 10}
#'   \item{rqi11}{: RQ value, session 11}
#'   \item{rq_s12_end}{: RQ value, session 12}
#'   \item{prq_fu1}{: RQ value, follow-up measure 1}
#'   \item{rqq_followup2}{: RQ value, follow-up measure 2}
#' }
#' @keywords dataset
#' @examples
#' # Load data into global environment
#' data(sgdata_bad)
"sgdata_bad"
