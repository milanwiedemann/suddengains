#' Create a data set with one row for each sudden gain/loss
#'
#' @description This function produces a wide data set with one row for each sudden gain/loss and assigns a unique identifier to each.
#' The data set includes variables indicating values around the period of each gain/loss, and calculates descriptives of each gain/loss.
#'
#' @param data A data set in wide format including an ID variable and variables for each measurement point.
#' @param sg_crit1_cutoff Numeric, specifying the cut-off value to be used for the first sudden gains criterion.
#' @param id_var_name String, specifying the name of the ID variable. Each row should have a unique value.
#' @param sg_var_list Vector, specifying the variable names of each measurement point sequentially.
#' @param tx_start_var_name String, specifying the variable name of the first measurement point of the intervention.
#' @param tx_end_var_name String, specifying the variable name of the last measurement point of the intervention.
#' @param sg_measure_name String, specifying the name of the measure used to identify sudden gains/losses.
#' @param sg_crit2_pct Numeric, specifying the percentage change to be used for the second sudden gains/losses criterion.
#' @param identify String, specifying whether to identify sudden gains (\code{"sg"}) or sudden losses (\code{"sl"}).
#' @param identify_sg_1to2 Logical, indicating whether to identify sudden losses from measurement point 1 to 2.
#' If set to TRUE, this implies that the first variable specified in \code{sg_var_list} represents a baseline measurement point, e.g. pre-intervention assessment.
#'
#' @return A wide data set with one row per sudden gain/loss.
#' @export
#'
#' @examples create_bysg(data = sgdata,
#'             sg_crit1_cutoff = 7,
#'             id_var_name = "id",
#'             tx_start_var_name = "bdi_s1",
#'             tx_end_var_name = "bdi_s12",
#'             sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3",
#'                             "bdi_s4", "bdi_s5", "bdi_s6",
#'                             "bdi_s7", "bdi_s8", "bdi_s9",
#'                             "bdi_s10", "bdi_s11", "bdi_s12"),
#'             sg_measure_name = "bdi")
#'
create_bysg <- function(data, sg_crit1_cutoff, id_var_name, sg_var_list, tx_start_var_name, tx_end_var_name, sg_measure_name, sg_crit2_pct = .25, identify = c("sg", "sl"), identify_sg_1to2 = FALSE) {

    # Check arguments
    identify <- base::match.arg(identify)


  # Before doing anything, save the raw data that was put in function as data argument
  data_in <- data



  # Run identify_sg function first to find positions of gain
  if (identify == "sg") {
      data_crit123 <- suddengains::identify_sg(data = data,
                                               id_var_name = id_var_name,
                                               sg_crit1_cutoff = sg_crit1_cutoff,
                                               sg_var_list = sg_var_list,
                                               sg_crit2_pct = sg_crit2_pct,
                                               identify_sg_1to2 = identify_sg_1to2)
  } else if (identify == "sl") {
      data_crit123 <- suddengains::identify_sl(data = data,
                                               id_var_name = id_var_name,
                                               sg_crit1_cutoff = sg_crit1_cutoff,
                                               sg_var_list = sg_var_list,
                                               sg_crit2_pct = sg_crit2_pct,
                                               identify_sg_1to2 = identify_sg_1to2)
  }


  # Set missings to zero to calculate in next step
  data_crit123[base::is.na(data_crit123)] <- 0


  # Start creating bysg dataset
  data_bysg <- data_crit123 %>%
    dplyr::select(!! rlang::sym(id_var_name), dplyr::matches("sg_|sl_\\d+to\\d+")) %>%
    tidyr::gather(key = "session", value = "sg_crit123", -!! rlang::sym(id_var_name)) %>%
    dplyr::mutate(session = as.numeric(stringr::str_extract(session, "(\\d+)")),
           sg_session_n = session) %>%
    dplyr::arrange(!! rlang::sym(id_var_name)) %>%
    dplyr::group_by(!! rlang::sym(id_var_name)) %>%
    dplyr::mutate(sg_freq_byperson = sum(sg_crit123, na.rm = TRUE)) %>%
    dplyr::arrange(dplyr::desc(sg_freq_byperson)) %>%
    dplyr::filter(sg_crit123 != 0) %>%
    dplyr::select(-session) %>%
    dplyr::mutate(id_sg = paste0(!! rlang::sym(id_var_name), "_sg_", sg_session_n)) %>%
    dplyr::select(!! rlang::sym(id_var_name), id_sg, dplyr::everything()) %>%
    dplyr::ungroup()

  # Select variables for further calculations from data

  # First check if tx_start_var_name and tx_end_var_name are in sg_var_list, if not add them
  if (tx_start_var_name %in% sg_var_list == TRUE) {
      sg_var_select <- base::c(id_var_name, sg_var_list)
  } else if (tx_start_var_name %in% sg_var_list == FALSE) {
      sg_var_select <- base::c(id_var_name, tx_start_var_name, sg_var_list)
  }

  if (tx_end_var_name %in% sg_var_list == TRUE) {
      sg_var_select <- c(sg_var_select)
  } else if (tx_end_var_name %in% sg_var_list == FALSE) {
      sg_var_select <- c(sg_var_select, tx_end_var_name)
  }

  data_bysg <- data_bysg %>%
      dplyr::left_join(dplyr::select(data_in, sg_var_select), by = id_var_name)

  # Set start value for numbering to extract the correct values around the gain
  if (identify_sg_1to2 == TRUE) {
      start_numbering <- 0
  } else if (identify_sg_1to2 == FALSE) {
      start_numbering <- 1
  }

  # Extract scores of the sudden gains measure around the sudden gain ----
  data_extract <- suddengains::extract_values(data_bysg,
                                              id_var_name = "id_sg",
                                              extract_var_list = sg_var_list,
                                              extract_measure_name = sg_measure_name,
                                              start_numbering = start_numbering,
                                              add_to_data = FALSE
                                              )

  # Combine the extracted scores with the bysg dataset
  data_bysg <- data_bysg %>%
    dplyr::left_join(data_extract, by = "id_sg")

  # Calculate descriptive sudden gains variables ----
  # Create varialbe names for mutate command here
  tx_change <- base::paste("sg", sg_measure_name, "tx", "change", sep = "_")
  var_x_n <- base::paste("sg", sg_measure_name, "n", sep = "_")
  var_x_n_post1 <- base::paste("sg", sg_measure_name, "n1", sep = "_")

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
    dplyr::select(id_sg, sg_session_n, sg_reversal_value, sg_var_list) %>%
    rename_sg_vars(sg_var_list, start_numbering = 0) %>%
    tidyr::gather(key = "time_str", value = "value", -id_sg, -sg_session_n, -sg_reversal_value) %>%
    dplyr::mutate(time_num = as.numeric(stringr::str_extract(time_str, "\\d+"))) %>%
    dplyr::select(-time_str) %>%
    dplyr::mutate(index = time_num - sg_session_n) %>%
    dplyr::filter(index >= 2) %>%
    dplyr::arrange(id_sg, time_num) %>%
    dplyr::group_by(id_sg) %>%
    dplyr::mutate(sg_reversal = dplyr::if_else(value > sg_reversal_value, 1, 0),
           sg_reversal = dplyr::if_else(sg_reversal == 1, 1, 0)) %>%
    dplyr::select(id_sg, sg_reversal) %>%
    dplyr::filter(sg_reversal == 1) %>%
    base::unique() %>%
    dplyr::ungroup() %>%
    tidyr::complete(id_sg = id_sg_list) %>%
    tidyr::replace_na(base::list(sg_reversal = 0))

  data_bysg <- data_bysg %>%
    dplyr::left_join(sg_reversal, by = "id_sg")

  # Return tibble
  data_bysg %>%
      tibble::as.tibble() %>%
      dplyr::arrange(!! rlang::sym(id_var_name))
}
