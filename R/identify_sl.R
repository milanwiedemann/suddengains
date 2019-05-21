#' @title Identify sudden losses.
#'
#' @description Function to identify sudden losses in longitudinal data structured in wide format.
#'
#' @param data A data set in wide format including an ID variable and variables for each measurement point.
#' @param id_var_name String, specifying the name of the ID variable. Each row should have a unique value.
#' @param sg_var_list Vector, specifying the variable names of each measurement point sequentially.
#' @param sg_crit1_cutoff Numeric, specifying the negative cut-off value to be used for the first sudden losses criterion (see Examples below).
#' @param sg_crit2_pct Numeric, specifying the percentage change to be used for the second sudden losses criterion.
#' @param sg_crit3 Logical, if set to \code{TRUE} the third criteria will be applied automatically adjusting the critical value for missingness.
#' If set to \code{FALSE} the third criterion wont be applied.
#' @param sg_crit3_alpha Numeric, alpha for the student t-test (two-tailed) to determine the critical value to be used for the third criterion.
#' Degrees of freedom are based on the number of available data in the three sessions preceding the loss and the three sessions following the loss.
#' @param identify_sg_1to2 Logical, indicating whether to identify sudden losses from measurement point 1 to 2.
#' If set to TRUE, this implies that the first variable specified in \code{sg_var_list} represents a baseline measurement point, e.g. pre-intervention assessment.
#' @param crit123_details Logical, if set to \code{TRUE} this function returns information about which of the three criteria (e.g. "sg_crit1_2to3", "sg_crit2_2to3", and "sg_crit3_2to3") are met for each session to session interval for all cases.
#' Variables named "sg_2to3", "sg_3to4" summarise all criteria that were selected to identify sudden gains.
#' @return A wide data set indicating whether sudden losses are present for each session to session interval for all cases in \code{data}.
#' @references Tang, T. Z., & DeRubeis, R. J. (1999). Sudden gains and critical sessions in cognitive-behavioral therapy for depression. Journal of Consulting and Clinical Psychology, 67(6), 894–904. \url{https://doi.org/10.1037/0022-006X.67.6.894}.
#' @examples # Identify sudden losses
#' identify_sl(data = sgdata,
#'             # Negative cut-off value to identify sudden losses
#'             sg_crit1_cutoff = -7,
#'             id_var_name = "id",
#'             sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3",
#'                             "bdi_s4", "bdi_s5", "bdi_s6",
#'                             "bdi_s7", "bdi_s8", "bdi_s9",
#'                             "bdi_s10", "bdi_s11", "bdi_s12"))
#' @export

identify_sl <- function(data, id_var_name, sg_var_list, sg_crit1_cutoff, sg_crit2_pct = .25, sg_crit3 = TRUE, sg_crit3_alpha = .05, identify_sg_1to2 = FALSE, crit123_details = FALSE) {

    if (base::is.null(sg_crit1_cutoff) == TRUE & base::is.null(sg_crit2_pct) == TRUE & sg_crit3 == FALSE) {
        stop("Please specify at least one of the three sudden gains criteria using the following arguments: sg_crit1_cutoff, sg_crit2_pct, sg_crit3.", call. = FALSE)
    }

    if (sg_crit1_cutoff > 0) {
        stop("The cut-off value specified in 'sg_crit1_cutoff' needs to be negative to identify sudden losses.", call. = FALSE)
    }

    # Set p for qt function needed for 3rd criterion
    sg_crit3_alpha_critical_value <- sg_crit3_alpha

        # Select data for identifying sudden losses
        # Only ID variable and sudden losses variables needed
        data_select <- data %>%
            dplyr::arrange(!!rlang::sym(id_var_name)) %>%
            dplyr::select(!!rlang::sym(id_var_name), sg_var_list)

        # Remove ID from dataframe for loop
        data_loop <- data_select %>%
            dplyr::arrange(!!rlang::sym(id_var_name)) %>%
            dplyr::select(2:base::ncol(data_select))

        # Create one empty dataframe for each sudden losses criterion
        crit1 <- base::data.frame(base::matrix(NA,
                                               nrow = base::nrow(data_loop),
                                               ncol = base::ncol(data_loop) - 3))

        crit2 <- base::data.frame(base::matrix(NA,
                                               nrow = base::nrow(data_loop),
                                               ncol = base::ncol(data_loop) - 3))

        crit3 <- base::data.frame(base::matrix(NA,
                                               nrow = base::nrow(data_loop),
                                               ncol = base::ncol(data_loop) - 3))

        # Iterate through all rows
        for (row_i in 1:base::nrow(data_loop)) {

            # Iterate through all columns
            for (col_j in 3:(base::ncol(data_loop) - 1)) {

                # Check 1st sudden losses criterion ----
                if (base::is.null(sg_crit1_cutoff) == TRUE) {
                    crit1[row_i, col_j - 2] <- NA
                } else {
                crit1[row_i, col_j - 2] <- (data_loop[row_i, col_j - 1] - data_loop[row_i, col_j] <= sg_crit1_cutoff)
                }

                # Check 2nd sudden losses criterion ----
                if (base::is.null(sg_crit2_pct) == TRUE) {
                    crit2[row_i, col_j - 2] <- NA
                } else {
                crit2[row_i, col_j - 2] <- (data_loop[row_i, col_j - 1] - data_loop[row_i, col_j] <= sg_crit2_pct * data_loop[row_i, col_j - 1])
                }

                # Check 3rd sudden losses criterion ----
                if (sg_crit3 == FALSE) {
                    crit3[row_i, col_j - 2] <- NA
                } else {
                # First, create pre and post indices for 3rd criterion
                pre_indices <- base::max(1, col_j - 3):(col_j - 1) # Create index for pregain
                post_indices <- col_j:min(base::ncol(data_loop), col_j + 2) # Create index for postgain

                # Define pre and post mean, sdn and number of available data points for 3rd criterion
                mean_pre <- base::mean(base::as.matrix(data_loop[row_i, base::c(pre_indices)]), na.rm = T)
                mean_post <- base::mean(base::as.matrix(data_loop[row_i, base::c(post_indices)]), na.rm = T)

                sd_pre <- stats::sd(base::as.matrix(data_loop[row_i, base::c(pre_indices)]), na.rm = T)
                sd_post <- stats::sd(base::as.matrix(data_loop[row_i, base::c(post_indices)]), na.rm = T)

                sum_n_pre <- base::sum(!is.na(data_loop[row_i, base::c(pre_indices)]), na.rm = T)
                sum_n_post <- base::sum(!is.na(data_loop[row_i, base::c(post_indices)]), na.rm = T)
                sum_n_pre_post <- sum_n_pre + sum_n_post

                # Check 3rd criterion for two or more values at both pre and post
                if (sum_n_pre >= 2 & sum_n_post >= 2) {
                    # Calculate critical value to be used based on how many pre and postgain sessions are available
                    sg_crit3_critical_value <- base::abs(stats::qt(p = (sg_crit3_alpha_critical_value / 2), df = (sum_n_pre_post - 2)))

                    # Test for third criterion using adjusted critical value
                    crit3[row_i, col_j - 2] <- mean_post - mean_pre > sg_crit3_critical_value * base::sqrt((((sum_n_pre - 1) * (sd_pre ^ 2)) + ((sum_n_post - 1) * (sd_post ^ 2))) / (sum_n_pre + sum_n_post - 2))

                    # Add missing value if less than two pregain or postgain sessions are available
                } else if (sum_n_pre < 2 | sum_n_post < 2) {
                    crit3[row_i, col_j - 2] <- NA
                }
                } # Close loop that applies 3rg criterion
            } # Close loop that iterates through columns
        } # Close loop that iterates through rows

        # Multiply dataframes with information on whether sudden losses criteria 1, 2, and 3 are met
        # 1 = criterion is met, 0 = criterion is not met, NA = not enough data to identify sudden losses

        if (base::is.null(sg_crit1_cutoff) == FALSE & base::is.null(sg_crit2_pct) == TRUE & sg_crit3 == FALSE) {
            crit123 <- crit1 * TRUE
            base::message("First sudden gains criterion was applied.")
        } else if (base::is.null(sg_crit1_cutoff) == TRUE & base::is.null(sg_crit2_pct) == FALSE & sg_crit3 == FALSE) {
            crit123 <- crit2 * TRUE
            base::message("Second sudden gains criterion was applied.")
        } else if (base::is.null(sg_crit1_cutoff) == TRUE & base::is.null(sg_crit2_pct) == TRUE & sg_crit3 == TRUE) {
            crit123 <- crit3 * TRUE
            base::message("Third sudden gains criterion was applied.")
        } else if (base::is.null(sg_crit1_cutoff) == FALSE & base::is.null(sg_crit2_pct) == FALSE & sg_crit3 == FALSE) {
            crit123 <- crit1 * crit2
            base::message("First and second sudden gains criteria were applied.")
        } else if (base::is.null(sg_crit1_cutoff) == TRUE & base::is.null(sg_crit2_pct) == FALSE & sg_crit3 == TRUE) {
            crit123 <- crit2 * crit3
            base::message("Second and third sudden gains criteria were applied.")
        } else if (base::is.null(sg_crit1_cutoff) == FALSE & base::is.null(sg_crit2_pct) == TRUE & sg_crit3 == TRUE) {
            crit123 <- crit1 * crit3
            base::message("First and third sudden gains criteria were applied.")
        } else if (base::is.null(sg_crit1_cutoff) == FALSE & base::is.null(sg_crit2_pct) == FALSE & sg_crit3 == TRUE) {
            crit123 <- crit1 * crit2 * crit3
            base::message("First, second, and third sudden gains criteria were applied.")
        }

        # Create empty list for renaming variables
        sg_col_names <- base::c()
        sg_col_names_crit1 <- base::c()
        sg_col_names_crit2 <- base::c()
        sg_col_names_crit3 <- base::c()

        # Create new variable names for sudden losses variables
        # If identify_sg_1to2 is TRUE, sg variables will start with "sg_1to2"
        if (identify_sg_1to2 == FALSE) {
            for (i in 1:(base::ncol(data_loop) - 3)) {
                sg_col_names[i] <- base::paste0("sl_", i + 1, "to", i + 2)

                sg_col_names_crit1[i] <- base::paste0("sl_crit1_", i + 1, "to", i + 2)
                sg_col_names_crit2[i] <- base::paste0("sl_crit2_", i + 1, "to", i + 2)
                sg_col_names_crit3[i] <- base::paste0("sl_crit3_", i + 1, "to", i + 2)
            }

            # If identify_sg_1to2 is FALSE, sg variables will start with "sg_2to3"
        } else if (identify_sg_1to2 == TRUE) {
            # base::message("The argument identify_sg_1to2 is set to TRUE, this implies that the first variable specified in the argument 'sg_var_list' represents a baseline measurement point, e.g. pre-intervention assessment.")
            for (i in 1:(base::ncol(data_loop) - 3)) {
                sg_col_names[i] <- base::paste0("sl_", i, "to", i + 1)

                sg_col_names_crit1[i] <- base::paste0("sl_crit1_", i, "to", i + 1)
                sg_col_names_crit2[i] <- base::paste0("sl_crit2_", i, "to", i + 1)
                sg_col_names_crit3[i] <- base::paste0("sl_crit3_", i, "to", i + 1)
            }
        }

        # Name sudden losses variables of main datafile
        names(crit123) <- sg_col_names

        # Name sudden losses variables individual datafiles with criteria 1, 2, 3
        names(crit1) <- sg_col_names_crit1
        names(crit2) <- sg_col_names_crit2
        names(crit3) <- sg_col_names_crit3

        # Calculate number of sudden losses
        sg_sum <- base::sum(crit123, na.rm = T)

        # Return message if no sudden losses were identified
        # Have this down here so it's the last message and more visible
        if (sg_sum == 0) {
            base::warning("No sudden losses were identified.", call. = FALSE)
        }

        # Export dataframe with information whether individual criteria were met
        if (crit123_details == TRUE) {
            data_crit123_details <- base::cbind(data_select[, 1], crit1, crit2, crit3, crit123)

            # Return dataframe with details about each criteria instead of combined crit123
            data_crit123_details %>%
                dplyr::arrange(!! rlang::sym(id_var_name)) %>%
                tibble::as.tibble()

        } else if (crit123_details == FALSE) {

            # Combine ID with results from identify sudden gains loop
            data_crit123 <- base::cbind(data_select[, 1], crit123)

            # Combine data with variables used to identify sudden gains
            data_select %>%
                dplyr::left_join(data_crit123, by = id_var_name) %>%
                dplyr::arrange(!! rlang::sym(id_var_name)) %>%
                tibble::as.tibble()
        }
}
