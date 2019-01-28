#' Extract variables around the sudden gain
#'
#' @param data A \code{bysg} or \code{byperson} dataset in wide format with the variable sg_session_n and all variables to extract.
#' @param id_var_name ID string, this is either normal id (for byperson datasets) or sg_id (for bysg datasets)
#' @param sg_var_list A string of the variable name which numbers numbers need to get extracted around the sudden gain.
#' @param include_s0_extract A string of the variable name which numbers numbers need to get extracted around the sudden gain.

#' @return A wide dataset with values for \code{var_name} around the sudden gain.
#' @export

extract_values <- function(data, id_var_name, extract_var_list, extract_var_name, start_numbering = 1, add_to_data = TRUE) {

  # Store all IDs in an object
  # This is needed at the end to add IDs for which no scores could be extracted
  id_list <- select(data, id_var_name)

  # Select only variables needed to extract scores around sudden gain
  data_in <- data %>%
    select(id_var_name, sg_session_n, extract_var_list)

  # Rename variables so I can use my extract approach
  data_extract <- rename_sg_vars(data = data_in, rename_var_list = extract_var_list, start_numbering = start_numbering)


  data_extract <- data_extract %>%
    tidyr::gather(key = "time_str", value = "value", -!! rlang::sym(id_var_name), -sg_session_n) %>%
    dplyr::mutate(time_num = as.numeric(str_extract(time_str, "\\d+"))) %>%
    dplyr::mutate(index = time_num - sg_session_n) %>%
    dplyr::filter(index >= -2, index <= 3) %>%
    dplyr::mutate(name = dplyr::case_when(
      index == -2 ~ "x_n_pre2",
      index == -1 ~ "x_n_pre1",
      index == 0  ~ "x_n",
      index == 1  ~ "x_n_post1",
      index == 2  ~ "x_n_post2",
      index == 3  ~ "x_n_post3"
    )) %>%
    #
    # # keeping only relevant columns and converting back to the form you need
    dplyr::select(id_var_name, name, value) %>%
    tidyr::spread(key = name, value = value) %>%
    dplyr::select(id_var_name, x_n_pre2, x_n_pre1, x_n, x_n_post1, x_n_post2, x_n_post3)

    # Rename variables
    base::names(data_extract)[base::names(data_extract) == "x_n_pre2"] <- paste0("sg_", extract_var_name, "_2n")
    base::names(data_extract)[base::names(data_extract) == "x_n_pre1"] <- paste0("sg_", extract_var_name, "_1n")
    base::names(data_extract)[base::names(data_extract) == "x_n"] <- paste0("sg_", extract_var_name, "_n")
    base::names(data_extract)[base::names(data_extract) == "x_n_post1"] <- paste0("sg_", extract_var_name, "_n1")
    base::names(data_extract)[base::names(data_extract) == "x_n_post2"] <- paste0("sg_", extract_var_name, "_n2")
    base::names(data_extract)[base::names(data_extract) == "x_n_post3"] <- paste0("sg_", extract_var_name, "_n3")

    # # making sure that all implicitly missing values are explicit
    data_extract_join <- data_extract %>%
      tidyr::complete(id_var_name = id_list)

    if (add_to_data == TRUE) {
        data %>%
            left_join(data_extract_join, by = id_var_name)

    } else if (add_to_data == FALSE) {
        data_extract_join
    }



    }
