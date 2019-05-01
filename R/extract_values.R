#' Extract variables around the sudden gain
#'
#' @param data A \code{bysg} or \code{byperson} dataset in wide format with the variable sg_session_n and all variables to extract.
#' @param id_var_name String, specifying the name of the ID variable. Each row should have a unique value.
#' @param extract_var_list Vector, specifying the variable names of session to session scores to extract from.
#' @param extract_measure_name String, specifying the name of the measure being used to extract values from.
#' @param start_numbering Numeric, set to by default 1.
#' Change to 0 if a pre-treatment (e.g. baseline assessment) measurement point is included in \code{extract_var_list}.
#' @param add_to_data Logical, if set to \code{TRUE}, the extracted values are added as new variables to the input dataset.
#' If set to false, only the ID variable and all extracted values will be returned.
#' @return A wide dataset with values for \code{extract_measure_name} around the sudden gain.
#' @export
#' @examples # Create bysg dataset
#' bysg <- create_bysg(data = sgdata,
#'                     sg_crit1_cutoff = 7,
#'                     id_var_name = "id",
#'                     tx_start_var_name = "bdi_s1",
#'                     tx_end_var_name = "bdi_s12",
#'                     sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3",
#'                                     "bdi_s4", "bdi_s5", "bdi_s6",
#'                                     "bdi_s7", "bdi_s8", "bdi_s9",
#'                                     "bdi_s10", "bdi_s11", "bdi_s12"),
#'                     sg_measure_name = "bdi")
#'
#' # For bysg dataset select "id" and "rq" variables first
#' sgdata_rq <- sgdata %>%
#'   dplyr::select(id, rq_s0:rq_s12)
#'
#' # Join them with the sudden gains data set, here "bysg"
#' bysg_rq <- bysg %>%
#'   dplyr::left_join(sgdata_rq, by = "id")
#'
#' # Extract "rq" scores around sudden gains on "bdi" in the bysg dataset
#' bysg_rq <- extract_values(data = bysg_rq,
#'                           id_var_name = "id_sg",
#'                           extract_var_list = c("rq_s1", "rq_s2", "rq_s3", "rq_s4",
#'                                                "rq_s5", "rq_s6", "rq_s7", "rq_s8",
#'                                                "rq_s9", "rq_s10", "rq_s11", "rq_s12"),
#'                           extract_measure_name = "rq",
#'                           add_to_data = TRUE)

extract_values <- function(data, id_var_name, extract_var_list, extract_measure_name, start_numbering = 1, add_to_data = TRUE) {

  # Store all IDs in an object
  # This is needed at the end to add IDs for which no scores could be extracted
  id_list <- dplyr::select(data, id_var_name)

  # Select only variables needed to extract scores around sudden gain
  data_in <- data %>%
      dplyr::select(id_var_name, sg_session_n, extract_var_list)

  # Rename variables so I can use my extract approach
  data_extract <- rename_sg_vars(data = data_in, rename_var_list = extract_var_list, start_numbering = start_numbering)

  data_extract <- data_extract %>%
    tidyr::gather(key = "time_str", value = "value", -!! rlang::sym(id_var_name), -sg_session_n) %>%
    dplyr::mutate(time_num = as.numeric(stringr::str_extract(time_str, "\\d+"))) %>%
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
    base::names(data_extract)[base::names(data_extract) == "x_n_pre2"] <- paste0("sg_", extract_measure_name, "_2n")
    base::names(data_extract)[base::names(data_extract) == "x_n_pre1"] <- paste0("sg_", extract_measure_name, "_1n")
    base::names(data_extract)[base::names(data_extract) == "x_n"] <- paste0("sg_", extract_measure_name, "_n")
    base::names(data_extract)[base::names(data_extract) == "x_n_post1"] <- paste0("sg_", extract_measure_name, "_n1")
    base::names(data_extract)[base::names(data_extract) == "x_n_post2"] <- paste0("sg_", extract_measure_name, "_n2")
    base::names(data_extract)[base::names(data_extract) == "x_n_post3"] <- paste0("sg_", extract_measure_name, "_n3")

    # # making sure that all implicitly missing values are explicit
    data_extract_join <- data_extract %>%
      tidyr::complete(id_var_name = id_list)

    if (add_to_data == TRUE) {
        data %>%
            dplyr::left_join(data_extract_join, by = id_var_name)

    } else if (add_to_data == FALSE) {
        data_extract_join
        }
    }
