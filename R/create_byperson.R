#' Create a data set with one gain per person
#'
#' @description This function produces a wide data set with one row for each case in \code{data}.
#' The data set includes variables indicating whether each case experienced a sudden gain/loss or not,
#' values around the period of each gain/loss, and descriptives.
#' For cases with no sudden gain/loss the descriptive variables are coded as missing (\code{NA}).
#'
#' @param data A data set in wide format including an ID variable and variables for each measurement point.
#' @param sg_crit1_cutoff Numeric, specifying the cut-off value to be used for the first sudden gains criterion.
#' @param id_var_name String, specifying the name of the ID variable. Each row should have a unique value.
#' @param sg_var_list Vector, specifying the variable names of each measurement point sequentially.
#' @param tx_start_var_name String, specifying the variable name of the first measurement point of the intervention.
#' @param tx_end_var_name String, specifying the variable name of the last measurement point of the intervention.
#' @param sg_var_name String, specifying the name of the measure used to identify sudden gains/losses.
#' @param sg_crit2_pct Numeric, specifying the percentage change to be used for the second sudden gains/losses criterion.
#' @param identify_sg_1to2 Logical, indicating whether to identify sudden losses from measurement point 1 to 2.
#' If set to TRUE, this implies that the first variable specified in \code{sg_var_list} represents a baseline measurement point, e.g. pre-intervention assessment.
#' @param identify String, specifying whether to identify sudden gains (\code{"sg"}) or sudden losses (\code{"sl"}).
#' TODO, AT THE MOMENT THIS DOES NOT AFFECT THE VARIABLE NAMES THAT GET CREATED IN THIS FUNCTION.
#' @param multiple_sg_select String, specifying which sudden gain/loss to select for this data set if more than one gain/loss was identified per case.
#' Options are: \code{"first"}, \code{"last"}, \code{"smallest"}, or \code{"largest"}.

#' @return  A wide data set with one row per case in \code{data}.
#' @export
#'
#' @examples create_byperson(data = sgdata,
#'                 sg_crit1_cutoff = 7,
#'                 id_var_name = "id",
#'                 tx_start_var_name = "bdi_s1",
#'                 tx_end_var_name = "bdi_s12",
#'                 sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3",
#'                                 "bdi_s4", "bdi_s5", "bdi_s6",
#'                                 "bdi_s7", "bdi_s8", "bdi_s9",
#'                                 "bdi_s10", "bdi_s11", "bdi_s12"),
#'                 sg_var_name = "bdi",
#'                 multiple_sg_select = "largest")
create_byperson <- function(data, sg_crit1_cutoff, id_var_name, sg_var_list, tx_start_var_name, tx_end_var_name, sg_var_name, multiple_sg_select, identify = "sg", sg_crit2_pct = .25, identify_sg_1to2 = FALSE) {

    # Check arguments
    identify <- match.arg(identify)

    data_bysg <- create_bysg(data = data,
                           sg_crit1_cutoff = sg_crit1_cutoff,
                           id_var_name = id_var_name,
                           tx_start_var_name = tx_start_var_name,
                           tx_end_var_name = tx_end_var_name,
                           sg_var_list = sg_var_list,
                           sg_var_name = sg_var_name,
                           sg_crit2_pct = sg_crit2_pct,
                           identify_sg_1to2 = identify_sg_1to2,
                           identify = identify)



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
