#' Define the Cut-off for SG Criterion 1 using modified RCI Formula
#'
#' @param data_sessions A dataset in wide format with values for pre _s0 and post treatment _end
#' @param data_item A dataset in item-by-item scores for the SG measure
#' @param tx_start_var_name String, variable name of the pretreatment scores
#' @param tx_end_var_name String, variable name of the postreatment scores
#' @param reliability Numeric between 0 and 1 indicating reliability of the scale, function not implemented yet
#' @return A list with all calculated variables using modified formula for RCI including cut-off
#' @export

define_crit1_cutoff <- function(data_sessions, tx_start_var_name, tx_end_var_name, data_item = NULL, reliability = NULL) {

  base::message("This function calculates a cut-off value that represents a clinically meaningful change based on the Reliable Change Index (RCI; Jacobson & Truax, 1991).\nThe RCI formula was modified so that all statistics can be computed from the data of an individual study following suggestions by Stiles et al. (2003).\n\nSee these references for further details:\nJacobson, N. S., & Truax, P. A. (1991). Clinical significance: A statistical approach to defining meaningful change in psychotherapy research. Journal of Consulting and Clinical Psychology, 59 (1), 12-19. doi:10.1037/0022-006X.59.1.12\nStiles et al. (2003). Early sudden gains in psychotherapy under routine clinic conditions: Practice-based evidence. Journal of Consulting and Clinical Psychology, 71 (1), 14-21. doi:10.1037/0022-006X.71.1.14")

  if (base::is.null(data_item) == TRUE & base::is.null(reliability) == TRUE) {
    stop("No information about reliability given. \n
         One of the two arguments must be used: \n
         1. 'data_item', provide item by item data of baseline questionnaire to calculate Cronbach's alpha \n
         2. 'reliability' set the reliability manually.", call. = FALSE)
  }

  if (base::is.null(data_item) == FALSE & base::is.null(reliability) == FALSE) {
    stop("You can only use one argument to define the reliability that will be used to calculate the cut off. \n
         Set either 'data_item or the 'reliability' argument to NULL.", call. = FALSE)
  }

  # if (base::is.null(data_item) == TRUE & reliability > 1 | reliability < 0) {
  #   stop("Reliability has to be between 0 and 1!")
  # }

  # TODO ADD ARGUMENT TO SPECIFY RELIABILITY OF SCALE, so that this doesnt have to be calculated on item by item data

  # Create vectors of variables used in this function
  pre_scores <- dplyr::pull(data_sessions, tx_start_var_name)
  post_scores <- dplyr::pull(data_sessions, tx_end_var_name)

  # Calculate mean pds change score
  mean_change_score <- base::mean(pre_scores, na.rm = TRUE) - base::mean(post_scores, na.rm = TRUE)

  # Calculate RCI ----
  # Calculate the standard deviation of the sum scores at baseline

  # What is the start of treatment value here
  standard_deviation_pre <- stats::sd(pre_scores, na.rm = TRUE)

  # Calculate Cronbach's alpha at baseline using psych package
  if (base::is.null(reliability) == FALSE) {
      base::message("The reliability of the measure used to identify sudden gains was specified in the 'reliability' argument.")
      reliability <- reliability
  } else if (base::is.null(reliability) == TRUE) {
      base::message("The reliability was calculated using the item-by-item data specified in the 'data_item' argument.")
      reliability <- psych::alpha(data_item)[[1]]$raw_alpha
  }

  # Calculate standard error of measurement
  standard_error_measurement <- standard_deviation_pre * base::sqrt(1 - reliability)

  # Calculate the standard error of the differences between two test scores
  sdiff <- base::sqrt(2 * (standard_error_measurement ^ 2))

  # Calculate RCI using mean change
  sg_crit1_cutoff <- (mean_change_score / sdiff) * 1.96

  output <- base::list(mean_change_score = mean_change_score,
                 standard_deviation_pre = standard_deviation_pre,
                 reliability = reliability,
                 standard_error_measurement = standard_error_measurement,
                 sdiff = sdiff,
                 sg_crit1_cutoff = sg_crit1_cutoff)

  # Return output as list in console
  output
}
