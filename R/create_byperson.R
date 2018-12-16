#' Create a dataset with one gain per person (at the moment this selects the earliest gain), referred to as \code{byperson} dataset
#'
#' @param data A dataset in wide format with an id variable and the sudden gains variables.
#' @param bysg_data A \code{bysg} dataset.
#' @param multiple_sg_select String indicating whether to select the \code{earliest}, \code{latest} or \code{largest}  \code{smallest} sudden gain if multiple gains per person. when two sudden gains are the same size and smalles or largest is selcted then the first gain of the will be selected using a secon filter command

#' @return A full dataset with all participants, the earliest gain per person
#' @export

create_byperson <- function(data, cutoff, id_var_name, sg_var_list, tx_start_var_name, tx_end_var_name, sg_var_name, multiple_sg_select = "first", identify_sg_1to2 = FALSE, include_s0_extract = FALSE) {

  data_bysg <- create_bysg(data = data,
                           cutoff = cutoff,
                           id_var_name = id_var_name,
                           tx_start_var_name = tx_start_var_name,
                           tx_end_var_name = tx_end_var_name,
                           sg_var_list = sg_var_list,
                           sg_var_name = sg_var_name,
                           identify_sg_1to2 = identify_sg_1to2,
                           include_s0_extract = include_s0_extract)



  if (multiple_sg_select == "first") {

    bysg_data_select <- data_bysg %>%
      dplyr::select(id_var_name, id_sg, starts_with("sg_")) %>%
      dplyr::group_by(!! rlang::sym(id_var_name)) %>%
      dplyr::filter(sg_session_n == min(sg_session_n)) %>%
      dplyr::ungroup()

    } else if (multiple_sg_select == "last") {

      bysg_data_select <- data_bysg %>%
        dplyr::select(id_var_name, id_sg, starts_with("sg_")) %>%
        dplyr::group_by(!! rlang::sym(id_var_name)) %>%
        dplyr::filter(sg_session_n == max(sg_session_n)) %>%
        dplyr::ungroup()

      } else if (multiple_sg_select == "smallest") {

        bysg_data_select <- data_bysg %>%
          dplyr::select(id_var_name, id_sg, starts_with("sg_")) %>%
          dplyr::group_by(!! rlang::sym(id_var_name)) %>%
          dplyr::filter(sg_magnitude == min(sg_magnitude)) %>%
          dplyr::filter(sg_session_n == min(sg_session_n)) %>%
          dplyr::ungroup()

        } else if (multiple_sg_select == "largest") {

          bysg_data_select <- data_bysg %>%
            dplyr::select(id_var_name, id_sg, starts_with("sg_")) %>%
            dplyr::group_by(!! rlang::sym(id_var_name)) %>%
            dplyr::filter(sg_magnitude == max(sg_magnitude)) %>%
            dplyr::filter(sg_session_n == min(sg_session_n)) %>%
            dplyr::ungroup()

          }


  # Join dataset
  data_byperson <- bysg_data_select %>%
    dplyr::full_join(data, by = id_var_name) %>%
    tidyr::replace_na(list(sg_crit123 = 0, sg_freq_byperson = 0))

  # Return dataset
  data_byperson %>%
      dplyr::arrange(!! rlang::sym(id_var_name))
  }
