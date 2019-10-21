#' Create a data set with one gain per person
#'
#' @description This function returns a wide data set with one row for each case in \code{data}.
#' The data set includes variables indicating whether each case experienced a sudden gain/loss or not,
#' values around the period of each gain/loss, and descriptives.
#' For cases with no sudden gain/loss the descriptive variables are coded as missing (\code{NA}).
#' @param data A data set in wide format including an ID variable and variables for each measurement point.
#' @param sg_crit1_cutoff Numeric, specifying the cut-off value to be used for the first sudden gains criterion.
#' The function \code{\link{define_crit1_cutoff}} can be used to calcualate a cutoff value based on the Reliable Change Index (RCI; Jacobson & Truax, 1991).
#' If set to \code{NULL} the first criterion wont be applied.
#' @param sg_crit2_pct Numeric, specifying the percentage change to be used for the second sudden gains/losses criterion.
#' If set to \code{NULL} the second criterion wont be applied.
#' @param sg_crit3 If set to \code{TRUE} the third criterion will be applied automatically adjusting the critical value for missingness.
#' If set to \code{FALSE} the third criterion wont be applied.
#' @param sg_crit3_alpha Numeric, alpha for the student t-test (two-tailed) to determine the critical value to be used for the third criterion.
#' Degrees of freedom are based on the number of available data in the three sessions preceding the gain and the three sessions following the gain.
#' @param id_var_name String, specifying the name of the ID variable. Each row should have a unique value.
#' @param sg_var_list Vector, specifying the variable names of each measurement point sequentially.
#' @param tx_start_var_name String, specifying the variable name of the first measurement point of the intervention.
#' @param tx_end_var_name String, specifying the variable name of the last measurement point of the intervention.
#' @param sg_measure_name String, specifying the name of the measure used to identify sudden gains/losses.
#' @param identify_sg_1to2 Logical, indicating whether to identify sudden losses from measurement point 1 to 2.
#' If set to TRUE, this implies that the first variable specified in \code{sg_var_list} represents a baseline measurement point, e.g. pre-intervention assessment.
#' @param identify String, specifying whether to identify sudden gains (\code{"sg"}) using \code{\link{identify_sg}} or sudden losses (\code{"sl"}) using \code{\link{identify_sl}}.
#' The default is to identify sudden gains (\code{"sg"}).
#' @param multiple_sg_select String, specifying which sudden gain/loss to select for this data set if more than one gain/loss was identified per case.
#' Options are: \code{"first"}, \code{"last"}, \code{"smallest"}, or \code{"largest"}.
#' The default is to select the first sudden gain (\code{"first"}) if someone experienced multiple gains.
#' @param data_is_bysg Logical, specifying whether the data set in the \code{data} argument is a bysg datasets created using the \code{\link{create_bysg}} function.
#' @return  A wide data set with one row per case (\code{id_var_name}) in \code{data}.
#' @references Tang, T. Z., & DeRubeis, R. J. (1999). Sudden gains and critical sessions in cognitive-behavioral therapy for depression. Journal of Consulting and Clinical Psychology, 67(6), 894–904. \url{https://doi.org/10.1037/0022-006X.67.6.894}.
#' @export
#' @examples # Create byperson data set, selecting the largest gain in case of muliple gains
#' create_byperson(data = sgdata,
#'                 sg_crit1_cutoff = 7,
#'                 id_var_name = "id",
#'                 tx_start_var_name = "bdi_s1",
#'                 tx_end_var_name = "bdi_s12",
#'                 sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3",
#'                                 "bdi_s4", "bdi_s5", "bdi_s6",
#'                                 "bdi_s7", "bdi_s8", "bdi_s9",
#'                                 "bdi_s10", "bdi_s11", "bdi_s12"),
#'                 sg_measure_name = "bdi",
#'                 multiple_sg_select = "largest")

create_byperson <- function(data, sg_crit1_cutoff, id_var_name, sg_var_list, tx_start_var_name, tx_end_var_name, sg_measure_name, multiple_sg_select = c("first", "last", "smalles", "largest"), data_is_bysg = FALSE, identify = c("sg", "sl"), sg_crit2_pct = .25, sg_crit3 = TRUE, sg_crit3_alpha = .05, identify_sg_1to2 = FALSE) {

  # Check arguments
  multiple_sg_select <- base::match.arg(multiple_sg_select)
  identify <- base::match.arg(identify)

  # If data_is_bysg arguement is FALSE run the create_bysg function
  # If data_is_bysg arguement is TRUE dont run the create_bysg function and assume that the data already is in the right format
  # to create the byperson dataset
  if (data_is_bysg == FALSE) {
    data_bysg <- create_bysg(data = data,
                             id_var_name = id_var_name,
                             sg_var_list = sg_var_list,
                             sg_crit1_cutoff = sg_crit1_cutoff,
                             sg_crit2_pct = sg_crit2_pct,
                             sg_crit3 = sg_crit3,
                             sg_crit3_alpha = sg_crit3_alpha,
                             tx_start_var_name = tx_start_var_name,
                             tx_end_var_name = tx_end_var_name,
                             sg_measure_name = sg_measure_name,
                             identify_sg_1to2 = identify_sg_1to2,
                             identify = identify)
  } else if (data_is_bysg == TRUE) {
    # Implement checks that test whether specific variables are present in the data set, e.g. "sg_session_n", "sg_magnitude" ...
    data_bysg <- data
  }

  if (multiple_sg_select == "first") {

    base::message("The first gain/loss was selected in case of multiple gains/losses.")

    bysg_data_select <- data_bysg %>%
      dplyr::select(id_var_name, id_sg, dplyr::starts_with("sg_")) %>%
      dplyr::group_by(!! rlang::sym(id_var_name)) %>%
      dplyr::filter(sg_session_n == base::min(sg_session_n)) %>%
      dplyr::ungroup()

  } else if (multiple_sg_select == "last") {

    base::message("The last gain/loss was selected in case of multiple gains/losses.")

    bysg_data_select <- data_bysg %>%
      dplyr::select(id_var_name, id_sg, dplyr::starts_with("sg_")) %>%
      dplyr::group_by(!! rlang::sym(id_var_name)) %>%
      dplyr::filter(sg_session_n == base::max(sg_session_n)) %>%
      dplyr::ungroup()

  } else if (multiple_sg_select == "smallest") {

    base::message("The smallest gain/loss was selected in case of multiple gains/losses.")

    bysg_data_select <- data_bysg %>%
      dplyr::select(id_var_name, id_sg, dplyr::starts_with("sg_")) %>%
      dplyr::group_by(!! rlang::sym(id_var_name)) %>%
      dplyr::filter(sg_magnitude == base::min(sg_magnitude)) %>%
      dplyr::filter(sg_session_n == base::min(sg_session_n)) %>%
      dplyr::ungroup()

  } else if (multiple_sg_select == "largest") {

    base::message("The largest gain/loss was selected in case of multiple gains/losses.")

    bysg_data_select <- data_bysg %>%
      dplyr::select(id_var_name, id_sg, dplyr::starts_with("sg_")) %>%
      dplyr::group_by(!! rlang::sym(id_var_name)) %>%
      dplyr::filter(sg_magnitude == base::max(sg_magnitude)) %>%
      dplyr::filter(sg_session_n == base::min(sg_session_n)) %>%
      dplyr::ungroup()
  }

  # Join datasets
  data_byperson <- bysg_data_select %>%
    dplyr::full_join(data, by = id_var_name) %>%
    tidyr::replace_na(list(sg_crit123 = 0, sg_freq_byperson = 0))

  # Return dataset
  data_byperson %>%
    dplyr::arrange(!! rlang::sym(id_var_name))
}
