#' @title Identify sudden gains.
#'
#' @description Function to identify sudden gains in longitudinal data structured in wide format.
#'
#' @param data A data set in wide format including an ID variable and variables for each measurement point.
#' @param id_var_name String, specifying the name of the ID variable. Each row should have a unique value.
#' @param sg_var_list Vector, specifying the variable names of each measurement point sequentially.
#' @param sg_crit1_cutoff Numeric, specifying the cut-off value to be used for the first sudden gains criterion.
#' @param sg_crit2_pct Numeric, specifying the percentage change to be used for the second sudden gains criterion.
#' @param identify_sg_1to2 Logical, indicating whether to identify sudden gains from measurement point 1 to 2.
#' If set to TRUE, this implies that the first variable specified in \code{sg_var_list} represents a baseline measurement point, e.g. pre-intervention assessment.
#' @param crit123_details Logical, if set to \code{TRUE} a dataframe will be wriiten to the global environment with information about which of the three criteria are met for each session to session interval for all cases.
#' @param name_crit123_details String, specifying the name of the dataframe produced if \code{crit123_details} is set to \code{TRUE}.

#' @return A wide data set indicating whether sudden gains are present for each session to session interval for all cases in \code{data}.
#' @examples identify_sg(data = sgdata,
#'             sg_crit1_cutoff = 7,
#'             id_var_name = "id",
#'             sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3",
#'                             "bdi_s4", "bdi_s5", "bdi_s6",
#'                             "bdi_s7", "bdi_s8", "bdi_s9",
#'                             "bdi_s10", "bdi_s11", "bdi_s12"),
#'            identify_sg_1to2 = FALSE)
#' @export

identify_sg <- function(data, id_var_name, sg_var_list, sg_crit1_cutoff, sg_crit2_pct = .25, identify_sg_1to2 = FALSE, crit123_details = FALSE, name_crit123_details = "data_crit123_details") {

        # Select data for identifying sudden gains
        # Only ID variable and sudden gains variables needed
        data_select <- data %>%
            dplyr::arrange(!!rlang::sym(id_var_name)) %>%
            dplyr::select(!!rlang::sym(id_var_name), sg_var_list)

        # Remove ID from dataframe for loop
        data_loop <- data_select %>%
            dplyr::arrange(!!rlang::sym(id_var_name)) %>%
            dplyr::select(2:base::ncol(data_select))

        # Create one empty dataframe for each sudden gains criterion
        crit1 <- base::data.frame(base::matrix(NA,
                                               nrow = base::nrow(data_loop),
                                               ncol = base::ncol(data_loop) - 3)
                                  )

        crit2 <- base::data.frame(base::matrix(NA,
                                               nrow = base::nrow(data_loop),
                                               ncol = base::ncol(data_loop) - 3)
                                  )

        crit3 <- base::data.frame(base::matrix(NA,
                                               nrow = base::nrow(data_loop),
                                               ncol = base::ncol(data_loop) - 3)
                                  )

        # Iterate through all rows
        for (row_i in 1:base::nrow(data_loop)) {

            # Iterate through all columns
            for (col_j in 3:(base::ncol(data_loop) - 1)) {

                # Check 1st sudden gains criterion
                crit1[row_i, col_j - 2] <- (data_loop[row_i, col_j - 1] - data_loop[row_i, col_j] >= sg_crit1_cutoff)

                # Check 2nd sudden gains criterion
                crit2[row_i, col_j - 2] <- (data_loop[row_i, col_j - 1] - data_loop[row_i, col_j] >= sg_crit2_pct * data_loop[row_i, col_j - 1])

                # Check 3rd sudden gains criterion

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

                # Check 3rd criterion for no missing at pre or post

                if (sum_n_pre == 3 & sum_n_post == 3) {
                    crit3[row_i, col_j - 2] <- mean_pre - mean_post > 2.776 * base::sqrt(((2 * sd_pre ^ 2) + (2 * sd_post ^ 2)) / (3 + 3 - 2))

                    # Adjust critical value for 1 missing value in pregain mean
                } else if (sum_n_pre == 2 & sum_n_post == 3) {
                    crit3[row_i, col_j - 2] <- mean_pre - mean_post > 3.182 * base::sqrt(((2 * sd_pre ^ 2) + (2 * sd_post ^ 2)) / (2 + 3 - 2))

                    # Adjust critical value for 1 missing value in postgain mean
                } else if (sum_n_pre == 3 & sum_n_post == 2) {
                    crit3[row_i, col_j - 2] <- mean_pre - mean_post > 3.182 * base::sqrt(((2 * sd_pre ^ 2) + (2 * sd_post ^ 2))  / (3 + 2 - 2))

                    # Adjust critical value for 1 missing value pregain and 1 missing value postgain
                } else if (sum_n_pre == 2 & sum_n_post == 2) {
                    crit3[row_i, col_j - 2] <- mean_pre - mean_post > 4.303 * base::sqrt(((2 * sd_pre ^ 2) + (2 * sd_post ^ 2))  / (2 + 2 - 2))
                } else if (sum_n_pre < 2 | sum_n_post < 2) {
                    crit3[row_i, col_j - 2] <- NA
                }
            }
        }

        # Multiply dataframes with information on whether sudden gains criteria 1, 2, and 3 are met
        # 1 = criterion is met, 0 = criterion is not met, NA = not enough data to identify sudden gains
        crit123 <- crit1 * crit2 * crit3

        # Create empty list for renaming variables
        sg_col_names <- base::c()
        sg_col_names_crit1 <- base::c()
        sg_col_names_crit2 <- base::c()
        sg_col_names_crit3 <- base::c()

        # Create new variable names for sudden gains variables
        # If identify_sg_1to2 is TRUE, sg variables will start with "sg_1to2"
        if (identify_sg_1to2 == FALSE) {
            for (i in 1:(base::ncol(data_loop) - 3)) {
                sg_col_names[i] <- base::paste0("sg_", i + 1, "to", i + 2)

                sg_col_names_crit1[i] <- base::paste0("sg_crit1_", i + 1, "to", i + 2)
                sg_col_names_crit2[i] <- base::paste0("sg_crit2_", i + 1, "to", i + 2)
                sg_col_names_crit3[i] <- base::paste0("sg_crit3_", i + 1, "to", i + 2)
            }

            # If identify_sg_1to2 is FALSE, sg variables will start with "sg_2to3"
        } else if (identify_sg_1to2 == TRUE) {
            for (i in 1:(base::ncol(data_loop) - 3)) {
                sg_col_names[i] <- base::paste0("sg_", i, "to", i + 1)

                sg_col_names_crit1[i] <- base::paste0("sg_crit1_", i, "to", i + 1)
                sg_col_names_crit2[i] <- base::paste0("sg_crit2_", i, "to", i + 1)
                sg_col_names_crit3[i] <- base::paste0("sg_crit3_", i, "to", i + 1)
            }
        }

        # Name sudden gains variables of main datafile
        names(crit123) <- sg_col_names

        # Name sudden gains variables individual datafiles with criteria 1, 2, 3
        names(crit1) <- sg_col_names_crit1
        names(crit2) <- sg_col_names_crit2
        names(crit3) <- sg_col_names_crit3

        # Export dataframe with information whether individual criteria were met
        if (crit123_details == TRUE) {
            data_crit123_details <- base::cbind(data_select[, 1], crit1, crit2, crit3)

            # The name for the exported dataframe can be changed in the function
            assign(name_crit123_details, data_crit123_details, envir = .GlobalEnv)
        }

        # Combine ID with results from identify sudden gains loop
        data_crit123 <- base::cbind(data_select[, 1], crit123)

        # Combine data with variables used to identify sudden gains
        data_select %>%
            dplyr::left_join(data_crit123, by = id_var_name) %>%
            dplyr::arrange(!! rlang::sym(id_var_name)) %>%
            tibble::as.tibble()
    }

