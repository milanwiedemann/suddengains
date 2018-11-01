#' Create a dataset with one gain per person (at the moment this selects the earliest gain), referred to as \code{byperson} dataset
#'
#' @param data A dataset in wide format with an id variable and the sudden gains variables.
#' @param bysg_data A \code{bysg} dataset.
#' @param multiple_sg_select String indicating whether to select the \code{earliest} or \code{largest} sudden gain if multiple gains per person.

#' @return A full dataset with all participants, the earliest gain per person
#' @export

create_byperson <- function(data, bysg_data, multiple_sg_select) {

  # TODO ADD IF ELSE TO ADD OPTION FOR SELECTING "EARLIEST" OR "LARGEST" GAINS

data_byperson_sgonly <- bysg_data %>%
  dplyr::group_by(id) %>%
  dplyr::rename(sg_reversal_byperson = sg_reversal) %>%
  dplyr::mutate(sg_reversal_byperson = ifelse(sg_reversal_byperson > 0, 1, 0)) %>%
  dplyr::filter(sg_session_n == min(sg_session_n)) %>%
  dplyr::group_by(id) %>%
  dplyr::filter(sg_session_n == min(sg_session_n)) %>%
  dplyr::ungroup() %>%
  dplyr::select(id, id_sg, sg_crit123, sg_freq_byperson, sg_session_n,
         sg_pds_pre3, sg_pds_pre2, sg_pds_pre1, sg_pds_post1, sg_pds_post2, sg_pds_post3,
         sg_magnitude, pds_change_total, sg_change_proportion, sg_reversal_value, sg_reversal_byperson)

data_byperson <- data %>%
  dplyr::left_join(data_byperson_sgonly)

data_byperson$sg_crit123[is.na(data_byperson$sg_crit123)] <- 0

data_byperson <- data_byperson %>%
  dplyr::select(id, id_sg, sg_crit123, sg_freq_byperson, sg_session_n,
         sg_pds_pre3, sg_pds_pre2, sg_pds_pre1, sg_pds_post1, sg_pds_post2, sg_pds_post3,
         sg_magnitude, pds_change_total, sg_change_proportion, sg_reversal_value, sg_reversal_byperson)

data_byperson
}
