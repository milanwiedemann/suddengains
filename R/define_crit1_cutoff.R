#' Define the Cut-off for SG Criterion 1 using modified RCI Formula
#'
#' @param data_sessions A dataset in wide format with values for pre _s0 and post treatment _end
#' @param data_item A dataset in item-by-item scores for the SG measure
#' @param pre_var_name String, variable name of the pretreatment scores
#' @param post_var_name String, variable name of the postreatment scores
#' @return A list with all calculated variables using modified formula for RCI including cut-off
#' @export

define_crit1_cutoff <- function(data_sessions, data_item, pre_var_name, post_var_name) {

  # TODO ADD ARGUMENT TO SPECIFY RELIABILITY OF SCALE, so that this doesnt have to be calculated on item by item data

  # Create vectors of variables used in this function
  pre_scores <- dplyr::pull(data_sessions, pre_var_name)
  post_scores <- dplyr::pull(data_sessions, post_var_name)

  # Calculate mean pds change score
  mean_change_score <- base::mean(pre_scores, na.rm = TRUE) - base::mean(post_scores, na.rm = TRUE)

  # Calculate RCI ----
  # Calculate the standard deviation of the sum scores at baseline

  # What is the start of treatment value here
  standard_deviation_pre <- stats::sd(pre_scores, na.rm = TRUE)

  # Calculate Cronbach's alpha at baseline using psych package
  alpha_pre <- psych::alpha(data_item)[[1]]$raw_alpha

  # Calculate standard error of measurement
  standard_error_measurement <- standard_deviation_pre * base::sqrt(1 - alpha_pre)

  # Calculate the standard error of the differences between two test scores
  sdiff <- base::sqrt(2 * (standard_error_measurement ^ 2))

  # Calculate RCI using mean change
  crit1_cutoff <- (mean_change_score / sdiff) * 1.96

  output <- list(mean_change_score = mean_change_score,
                 standard_deviation_pre = standard_deviation_pre,
                 alpha_pre = alpha_pre,
                 standard_error_measurement = standard_error_measurement,
                 sdiff = sdiff,
                 crit1_cutoff = crit1_cutoff)

  output
}
