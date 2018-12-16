#' Create a dataset with one gain per row, referred to as \code{bysg} dataset
#'
#' @param data A dataset in wide format with an id variable and the sudden gains variables.
#' @param cutoff A number specifying the cut-off for criterion 1.
#' @param id_var_name A string of the id variable name.
#' @param sg_var_name A string of the sudden gains variable name.

#' @return A dataset with one row per sudden gain.
#' @export

create_bysg <- function(data, cutoff, id_var_name, sg_var_list, tx_start_var_name, tx_end_var_name, sg_var_name, identify_sg_1to2 = FALSE, include_s0_extract = FALSE) {

  # Before doing anything, save the raw data that was put in function as data argument
  data_in <- data

  # Run identify_sg function first to find positions of gain
  data_crit123 <- suddengains::identify_sg(data = data, id_var_name = id_var_name, cutoff = cutoff, sg_var_list = sg_var_list, identify_sg_1to2 = identify_sg_1to2)

  # Set missings to zero to calculate in next step
  data_crit123[base::is.na(data_crit123)] <- 0


  data_bysg <- data_crit123 %>%
    select(!! rlang::sym(id_var_name), matches("sg_\\d+to\\d+")) %>%
    gather(key = "session", value = "sg_crit123", -!! rlang::sym(id_var_name)) %>%
    mutate(session = as.numeric(str_extract(session, "(\\d+)")),
           sg_session_n = session) %>%
    arrange(!! rlang::sym(id_var_name)) %>%
    group_by(!! rlang::sym(id_var_name)) %>%
    mutate(sg_freq_byperson = sum(sg_crit123, na.rm = TRUE)) %>%
    arrange(desc(sg_freq_byperson)) %>%
    filter(sg_crit123 != 0) %>%
    select(-session) %>%
    mutate(id_sg = paste0(!! rlang::sym(id_var_name), "_sg_", sg_session_n)) %>%
    select(!! rlang::sym(id_var_name), id_sg, everything()) %>%
    ungroup()

  data_bysg <- data_bysg %>%
    left_join(select(data_in, id_var_name, sg_var_list), by = id_var_name)

  # Extract scores of the sudden gains measure around the sudden gain ----
  data_extract <- suddengains::extract_values(data_bysg,
                                              id_var_name = "id_sg",
                                              extract_var_list = sg_var_list,
                                              extract_var_name = sg_var_name,
                                              include_s0_extract = include_s0_extract
                                              )

  # Combine the extracted scores with the bysg dataset
  data_bysg <- data_bysg %>%
    left_join(data_extract, by = "id_sg")

  # Calculate descriptive sudden gains variables ----

  # Create varialbe names for mutate command here
  tx_change <- paste("sg", sg_var_name, "tx", "change", sep = "_")
  var_x_n <- paste("sg", sg_var_name, "n", sep = "_")
  var_x_n_post1 <- paste("sg", sg_var_name, "n1", sep = "_")

  data_bysg <- data_bysg %>%
    dplyr::mutate(sg_magnitude = !! rlang::sym(var_x_n) - !! rlang::sym(var_x_n_post1),
                  !! tx_change := !! rlang::sym(tx_start_var_name) - !! rlang::sym(tx_end_var_name),
                  sg_change_proportion = sg_magnitude / !! rlang::sym(tx_change),
                  sg_reversal_value = !! rlang::sym(var_x_n_post1) + (sg_magnitude / 2)
                  )

  # If pds_change_1to18 we get an Inf value for sg_change_proportion (devision by zero), therefore we replace Inf with NA
  # data_bysg$sg_change_proportion[data_bysg$sg_change_proportion == Inf] <- NA

  # Calculate sudden gain reversals ----
  # Create a reversal variable, and start with all values set to NA

  # Create lsit with all ids for each sudden gain
  id_sg_list <- data_bysg$id_sg

  sg_reversal <- data_bysg %>%
    select(id_sg, sg_session_n, sg_reversal_value, sg_var_list) %>%
    rename_sg_vars(sg_var_list, start_numbering = 0) %>%
    tidyr::gather(key = "time_str", value = "value", -id_sg, -sg_session_n, -sg_reversal_value) %>%
    dplyr::mutate(time_num = as.numeric(str_extract(time_str, "\\d+"))) %>%
    select(-time_str) %>%
    dplyr::mutate(index = time_num - sg_session_n) %>%
    dplyr::filter(index >= 2) %>%
    arrange(id_sg, time_num) %>%
    group_by(id_sg) %>%
    mutate(sg_reversal = if_else(value > sg_reversal_value, 1, 0),
           sg_reversal = if_else(sg_reversal == 1, 1, 0)) %>%
    dplyr::select(id_sg, sg_reversal) %>%
    filter(sg_reversal == 1) %>%
    unique() %>%
    ungroup() %>%
    tidyr::complete(id_sg = id_sg_list) %>%
    tidyr::replace_na(list(sg_reversal = 0))

  data_bysg <- data_bysg %>%
    left_join(sg_reversal, by = "id_sg")





  # Return tibble

  data_bysg %>%
      tibble::as.tibble() %>%
      dplyr::arrange(!! rlang::sym(id_var_name))
}
