#' Define the Cut-off for SG Criterion 1 using the RCI Formula
#'
#' @param data_sessions A dataset in wide format with values for pre _s0 and post treatment _end
#' @param data_item A dataset in item-by-item scores for the SG measure

#' @return A list with all calculated variables using formulate for RCI including cut-off
#' @export

define_crit1_cutoff <- function(data_sessions, data_item) {
  # Calculate mean pds change score
  mean_change <- base::mean(data_sessions$pds_s0, na.rm = TRUE) - base::mean(data_sessions$pds_end, na.rm = TRUE)

  # Calculate RCI for PDS ----
  # Calculate the standard deviation of the sum scores at baseline
  sd <- stats::sd(data_sessions$pds_s0, na.rm = TRUE)

  # Calculate Cronbach's alpha for PDS at baseline using psych package
  alpha <- psych::alpha(data_item)[[1]]$raw_alpha

  # Calculate standard error of measurement
  se <- sd * base::sqrt(1 - alpha)

  # Calculate the standard error of the differences between two test scores
  sdiff <- base::sqrt(2 * (se ^ 2))

  # Calculate RCI using mean change pds
  crit1_cutoff <- (mean_change / sdiff) * 1.96

  output <- list(mean_change_score = mean_change, standard_deviation_at_pretreatment = sd, cronbachs_alpha_at_pretreatment = alpha, standard_error_of_measurement = se, sdiff = sdiff, crit1_cutoff = crit1_cutoff)
  print(output)

}
