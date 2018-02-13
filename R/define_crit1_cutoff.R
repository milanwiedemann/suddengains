#' Define the Cut-off for SG Criterion 1 using the RCI Formula
#'
#' @param data_sessions A dataset in wide format with values for pre _s0 and post treatment _end
#' @param data_item A dataset in item-by-item scores for the SG measure

#' @return A list with all calculated variables using formulate for RCI including cut-off
#' @export

define_crit1_cutoff <- function(data_sessions, data_item) {
  # Calculate mean pds change score
  # mean_change = 18.88347
  mean_change <- mean(data_sessions$pds_s0, na.rm = TRUE) - mean(data_sessions$pds_end, na.rm = TRUE)
  # mean_change <- mean(audit2_sg_pds$pds_s0 - audit2_sg_pds$pds_weekly_end, na.rm = TRUE)


  # Calculate RCI for PDS ----
  # Calculate the standard deviation of the sum scores at baseline
  # sd_pds_s0 = 9.604964
  sd <- sd(data_sessions$pds_s0, na.rm = TRUE)

  # Calculate Cronbach's alpha for PDS at baseline using psych package
  # raw_alpha_pds_s0 = 0.8906648
  alpha <- psych::alpha(data_item)[[1]]$raw_alpha

  # Calculate standard error of measurement
  # se_pds_s0 = 3.175965
  se <- sd * sqrt(1 - alpha)

  # Calculate the standard error of the differences between two test scores
  # sdiff_pds_s0 = 4.491493
  sdiff <- sqrt(2 * (se ^ 2))

  # Calculate RCI using mean change pds
  # rci_cutoff_mean_change = 8.24038
  crit1_cutoff <- (mean_change / sdiff) * 1.96

  output <- list(mean_change_score = mean_change, standard_deviation_at_pretreatment = sd, chronbachs_alpha_at_pretreatment = alpha, standard_error_of_measurement = se, sdiff = sdiff, crit1_cutoff = crit1_cutoff)
  print(output)

}
