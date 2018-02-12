#' Create a dataset with one gain per person (at the moment this selects the earliest gain), referred to as \code{byperson} dataset
#'
#' @param data A dataset in wide format with an id variable and the sudden gains variables.
#' @param bysg_data A \code{bysg} dataset.

#' @return A full dataset with all participants, the earliest gain per person

create_byperson_data <- function(data, bysg_data){

data_byperson_sgonly <- data_bysg %>%
  group_by(id) %>%
  rename(sg_reversal_byperson = sg_reversal) %>%
  mutate(sg_reversal_byperson = ifelse(sg_reversal_byperson > 0, 1, 0)) %>%
  filter(sg_session_n == min(sg_session_n)) %>%
  group_by(id) %>%
  filter(sg_session_n == min(sg_session_n)) %>%
  ungroup() %>%
  select(id, id_sg, sg_crit123, sg_freq_byperson, sg_session_n,
         sg_pds_pre3, sg_pds_pre2, sg_pds_pre1, sg_pds_post1, sg_pds_post2, sg_pds_post3,
         sg_magnitude, pds_change_total, sg_change_proportion, sg_reversal_value, sg_reversal_byperson)

data_byperson <- data %>%
  left_join(data_byperson_sgonly)

data_byperson$sg_crit123[is.na(data_byperson$sg_crit123)] <- 0

data_byperson
}
