#' Identify sudden gains in randomised data sets
#'
#' @description This function shuffles the session by session scores specified in \code{sg_var_list} wither within columns or rows before identifying sudden gains.
#' The data set includes variables indicating whether each case experienced a sudden gain/loss or not,
#' values around the period of each gain/loss, and descriptives.
#' For cases with no sudden gain/loss the descriptive variables are coded as missing (\code{NA}).
#' @param data A data set in wide format including an ID variable and variables for each measurement point.
#' @param sg_crit1_cutoff Numeric, specifying the cut-off value to be used for the first sudden gains criterion.
#' The function \code{\link{define_crit1_cutoff}} can be used to calculate a cutoff value based on the Reliable Change Index (RCI; Jacobson & Truax, 1991).
#' If set to \code{NULL} the first criterion wont be applied.
#' @param sg_crit2_pct Numeric, specifying the percentage change to be used for the second sudden gains/losses criterion.
#' If set to \code{NULL} the second criterion wont be applied.
#' @param sg_crit3 If set to \code{TRUE} the third criterion will be applied automatically adjusting the critical value for missingness.
#' If set to \code{FALSE} the third criterion wont be applied.
#' @param sg_crit3_alpha Numeric, alpha for the student t-test (two-tailed) to determine the critical value to be used for the third criterion.
#' Degrees of freedom are based on the number of available data in the three sessions preceding the gain and the three sessions following the gain.
#' @param sg_crit3_adjust Logical, specify whether critical value gets adjusted for missingness, see Lutz et al. (2013) and the documentation of this R package for further details.
#' This argument is set to \code{TRUE} by default adjusting the critical value for missingness as described in the package documentation and Lutz et al. (2013):
#' A critical value of 2.776 is used when all three data points before and after a potential gain are available,
#' where one datapoint is missing either before or after a potential gain a critical value of 3.182 is used,
#' and where one datapoint is missing both before and after the gain a critical value of 4.303 is used (for sg_crit3_alpha = 0.05).
#' If set to \code{FALSE} the critical value specified in \code{sg_crit3_critical_value} will instead be used for all comparisons, regardless of missingnes in the sequence of data points that are investigated for potential sudden gains.
#' @param sg_crit3_critical_value Numeric, specifying the critical value to instead be used for all comparisons, regardless of missingnes in the sequence of data points that are investigated for potential sudden gains.
#' @param id_var_name String, specifying the name of the ID variable.
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
#' @param create_data String, specify whether to create bysg or byperson data set.
#' @param shuffle_data String, specify whether session by session data is randomised within session ("within_cols") or participants ("within_rows")
#' @param n_reps Numeric, number of random data sets. The returned data frame will also contain the original data, therefore n_reps + 1 data sets will be returned.
#' @param seed Set seed
#'
#' @return
#' @export
#'
#' @examples # Identify sudden gains in 5 random data sets where session by session scores are randomised within each session
#' identify_sg_random(data = sgdata,
#'                    sg_crit1_cutoff = 7,
#'                    id_var_name = "id",
#'                    tx_start_var_name = "bdi_s1",
#'                    tx_end_var_name = "bdi_s12",
#'                    sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3",
#'                                    "bdi_s4", "bdi_s5", "bdi_s6",
#'                                    "bdi_s7", "bdi_s8", "bdi_s9",
#'                                    "bdi_s10", "bdi_s11", "bdi_s12"),
#'                    shuffle_data = "within_cols",
#'                    sg_measure_name = "bdi",
#'                    multiple_sg_select = "first",
#'                    n_reps = 5)
identify_sg_random <- function(data,
                               sg_crit1_cutoff,
                               id_var_name,
                               sg_var_list,
                               tx_start_var_name,
                               tx_end_var_name,
                               sg_measure_name,
                               sg_crit2_pct = 0.25,
                               sg_crit3 = TRUE,
                               sg_crit3_alpha = 0.05,
                               sg_crit3_adjust = TRUE,
                               sg_crit3_critical_value = 2.776,
                               identify = c("sg", "sl"),
                               identify_sg_1to2 = FALSE,
                               multiple_sg_select = c("first", "last", "smallest", "largest"),
                               create_data = c("bysg", "byperson"),
                               shuffle_data = c("within_cols", "within_rows"),
                               n_reps,
                               seed = 1234) {

    # Add progress bar
    set.seed(seed = seed)
    # FUCK THIS PROGRESS BAR, STARTS TOO LATE AND ENDS TOO SOON!
    # BETTER THAN NOTHING SO KEEPING IT
    total <- n_reps + 1
    pb <- progress::progress_bar$new(format = "[:bar] :current/:total (:percent)", total = total)
    pb$tick(0)

    n_reps_mhm <- n_reps

    # Check input arguments
    multiple_sg_select <- base::match.arg(multiple_sg_select)
    identify <- base::match.arg(identify)
    create_data <- base::match.arg(create_data)
    shuffle_data <- base::match.arg(shuffle_data)
    message(paste0("Shuffling data ", shuffle_data, "."))

    # Create empty vectors and lists for loop
    data_random_list <- list()
    data_sg_random_list <- list()

    # Repeat as many times as specified in argument "n_reps" plus one
    for (i in 1:total) {
        # This is for the progress bar
        pb$tick(1)

        if (i == 1) {

            # For the first run use the normal data set
            data_random <- data

        }

        if (i > 1) {

            if (shuffle_data == "within_cols") {

                # Create new random dataset for each n_reps
                data_random <- data %>%
                    dplyr::select(dplyr::all_of(id_var_name), dplyr::all_of(sg_var_list)) %>%
                    dplyr::mutate_at(sg_var_list, sample, replace = FALSE)

            }

            if (shuffle_data == "within_rows") {

                data_random <- data %>%
                    dplyr::select(dplyr::all_of(id_var_name), dplyr::all_of(sg_var_list)) %>%
                    tidyr::pivot_longer(cols = all_of(sg_var_list), names_to = "measure_time") %>%
                    dplyr::group_by(!! rlang::sym(id_var_name)) %>%
                    dplyr::mutate(value = base::sample(value)) %>%
                    tidyr::pivot_wider(names_from = "measure_time", values_from = "value")

            }
        }

        # Save the input data
        data_random_list[[i]] <- data_random

        if (create_data == "bysg") {

            # Supress messages and show status bar instead
            bysg_data_loop_temp <-
                try(
                    suppressMessages(
                        create_bysg(
                            data = data_random,
                            sg_crit1_cutoff = sg_crit1_cutoff,
                            id_var_name = id_var_name,
                            sg_var_list = sg_var_list,
                            tx_start_var_name = tx_start_var_name,
                            tx_end_var_name = tx_end_var_name,
                            sg_measure_name = sg_measure_name,
                            sg_crit2_pct = sg_crit2_pct,
                            sg_crit3 = sg_crit3,
                            sg_crit3_alpha = sg_crit3_alpha,
                            sg_crit3_adjust = sg_crit3_adjust,
                            sg_crit3_critical_value = sg_crit3_critical_value,
                            identify = identify,
                            identify_sg_1to2 = identify_sg_1to2
                        )
                    )
                )



            # Identify sudden gains in the random data set
            # Save a copy of this temp bysg data set
            data_sg_random_list[[i]] <- bysg_data_loop_temp

        } else if (create_data == "byperson") {

            # Identify sudden gains in the random data set
            # Suppress messages and show status bar instead
            # use try() in case no sudden gains identified
            byperson_data_loop_temp <-
                try(
                    suppressMessages(
                        create_byperson(
                            data = data_random,
                            sg_crit1_cutoff = sg_crit1_cutoff,
                            id_var_name = id_var_name,
                            sg_var_list = sg_var_list,
                            tx_start_var_name = tx_start_var_name,
                            tx_end_var_name = tx_end_var_name,
                            sg_measure_name = sg_measure_name,
                            sg_crit2_pct = sg_crit2_pct,
                            sg_crit3 = sg_crit3,
                            sg_crit3_alpha = sg_crit3_alpha,
                            sg_crit3_adjust = sg_crit3_adjust,
                            sg_crit3_critical_value = sg_crit3_critical_value,
                            multiple_sg_select = multiple_sg_select,
                            identify = identify,
                            identify_sg_1to2 = identify_sg_1to2
                        )
                    )
                )

            # Save a copy of this temp 'byperson' data set
            data_sg_random_list[[i]] <- byperson_data_loop_temp
        }
    }

    # Create output
    tibble::tibble(
        n_reps = 1:(n_reps_mhm + 1),
        method = c("original", rep("randomised", times = n_reps_mhm)),
        data_input = data_random_list,
        data_sg_output = data_sg_random_list

    )
}
