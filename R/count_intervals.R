#' Number of between session intervals analysed for sudden gains
#'
#' @param data A dataset in wide format with an id variable and the sudden gains variables.
#' @param cutoff A number specifying the cut-off for criterion 1.
#' @param id_var_name A string of the id variable name.
#' @param sg_var_name A string of the sudden gains variable name.
#' @param analysed A logical indicating wheter sum of analysed or not analysed session should be reported.


#' @return A wide dataset indicating at which between session interval a sudden gain occured for each person in \code{data}.
#' @export

count_intervals <- function(data, cutoff, id_var_name, sg_var_name, analysed = analyzed, analyzed = analysed) {
  data <- suddengains::identify_sg(data, cutoff, id_var_name, sg_var_name)

  if (analysed == TRUE | analyzed == TRUE) {
  sum <- sum(!is.na(select(data, starts_with("sg_"))))
  }

  if (analysed == FALSE | analyzed == FALSE) {
    sum <- sum(is.na(select(data, starts_with("sg_"))))
  }

  sum
}
