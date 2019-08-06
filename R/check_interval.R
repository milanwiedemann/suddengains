#' Checks if a given interval is a sudden gain/loss
#'
#' @param pre_values Vector, three pre gain/loss values to be checked for a sudden gain/loss (n-2, n-1, n)
#' @param post_values Vector, three post gain/loss values to be checked for a sudden gain/loss (n+1, n+2, n+3)
#' @param sg_crit1_cutoff Numeric, specifying the cut-off value to be used for the first sudden gains criterion.
#' If set to \code{NULL} the first criterion wont be applied.
#' @param sg_crit2_pct Numeric, specifying the percentage change to be used for the second sudden gains/losses criterion.
#' If set to \code{NULL} the second criterion wont be applied.
#' @param sg_crit3 If set to \code{TRUE} the third criterion will be applied automatically adjusting the critical value for missingness.
#' If set to \code{FALSE} the third criterion wont be applied.
#' @param sg_crit3_alpha Numeric, alpha for the student t-test (two-tailed) to determine the critical value to be used for the third criterion.
#' Degrees of freedom are based on the number of available data in the three sessions preceding the gain and the three sessions following the gain.
#' @param identify String, specifying whether to identify sudden gains (\code{"sg"}) or sudden losses (\code{"sl"}).
#'
#'
#' @return Information on whether a given interval is a sudden gain/loss
#' @export
#'
#' @examples # Check interval for sudden gain using all 3 criteria
#' # No missing data, alpha = 0.05
#' check_interval(pre_values = c(32, 31, 33),
#'                post_values = c(5, 6, 7),
#'                sg_crit1_cutoff = 7,
#'                sg_crit2_pct = .25,
#'                sg_crit3 = TRUE,
#'                sg_crit3_alpha = .05,
#'                identify = "sg")
#'
# Check interval for sudden gain using all 3 criteria
#' # No missing data, alpha = 0.01
#' check_interval(pre_values = c(32, 31, 33),
#'                post_values = c(5, 6, 7),
#'                sg_crit1_cutoff = 7,
#'                sg_crit2_pct = .25,
#'                sg_crit3 = TRUE,
#'                sg_crit3_alpha = .01,
#'                identify = "sg")
#'
#' # Check intervall for sudden gain using only third criterion
#' # Some missing data, alpha = 0.01
#' check_interval(pre_values = c(NA,31,33),
#'                post_values = c(5, NA, 7),
#'                sg_crit1_cutoff = NULL,
#'                sg_crit2_pct = NULL,
#'                sg_crit3 = TRUE,
#'                sg_crit3_alpha = .01,
#'                identify = "sg")
#'
#' # Check intervall for sudden loss using all three criteria
#' # Some missing data, alpha = 0.05
#' check_interval(pre_values = c(5, NA, 7),
#'                post_values = c(16, 12, 14),
#'                sg_crit1_cutoff = -7,
#'                sg_crit2_pct = .25,
#'                sg_crit3 = TRUE,
#'                sg_crit3_alpha = .05,
#'                identify = "sl")
#'
check_interval <- function(pre_values, post_values, sg_crit1_cutoff, sg_crit2_pct = .25, sg_crit3 = TRUE, sg_crit3_alpha = .05, identify = c("sg", "sl")) {


        # prepare some stuff for printing results lalala
        if (identify == "sg") {
        identify_string <- "# Sudden gain: "
        } else if (identify == "sl") {
            identify_string <- "# Sudden loss: "
        }

        # ADD CHECKS FOR PRE AND POST VALUE VECTORS
        # have to be length 3
        # last value in pre and first value in post have to be available
        # at least two available in pre and post

        # Check 1st sudden gains criterion ----
        if (base::is.null(sg_crit1_cutoff) == TRUE) {
            crit1 <- NA
        } else {
            if (identify == "sg") {
                crit1 <- (pre_values[3] - post_values[1] >= sg_crit1_cutoff)
            } else if (identify == "sl") {
                crit1 <- (pre_values[3] - post_values[1] <= sg_crit1_cutoff)
            }
        }

        # Check 2nd sudden gains criterion ----
        if (base::is.null(sg_crit2_pct) == TRUE) {
            crit2 <- NA
        } else {
            if (identify == "sg") {
                crit2 <- (pre_values[3] - post_values[1] >= sg_crit2_pct * pre_values[3])
            } else if (identify == "sl") {
                crit2 <- (pre_values[3] - post_values[1] <= sg_crit2_pct * pre_values[3])
            }
        }

        # Check 3rd sudden gains criterion ----
        if (sg_crit3 == FALSE) {
            sg_crit3_critical_value <- NA
            crit3 <- NA
        } else {
            # Define pre and post mean, sdn and number of available data points for 3rd criterion
            mean_pre <- base::mean(pre_values, na.rm = T)
            mean_post <- base::mean(post_values, na.rm = T)

            sd_pre <- stats::sd(pre_values, na.rm = T)
            sd_post <- stats::sd(post_values, na.rm = T)

            sum_n_pre <- base::sum(!is.na(pre_values))
            sum_n_post <- base::sum(!is.na(post_values))
            sum_n_pre_post <- sum_n_pre + sum_n_post

            # Check 3rd criterion for two or more values at both pre and post
            if (sum_n_pre >= 2 & sum_n_post >= 2) {
                # Calculate critical value to be used based on how many pre and postgain sessions are available
                sg_crit3_critical_value <- base::abs(stats::qt(p = (sg_crit3_alpha / 2), df = (sum_n_pre_post - 2)))

                # Test for third criterion using adjusted critical value
                if (identify == "sg") {
                    crit3 <- mean_pre - mean_post > sg_crit3_critical_value * base::sqrt((((sum_n_pre - 1) * (sd_pre ^ 2)) + ((sum_n_post - 1) * (sd_post ^ 2))) / (sum_n_pre + sum_n_post - 2))

                } else if (identify == "sl") {
                    crit3 <- mean_post - mean_pre > sg_crit3_critical_value * base::sqrt((((sum_n_pre - 1) * (sd_pre ^ 2)) + ((sum_n_post - 1) * (sd_post ^ 2))) / (sum_n_pre + sum_n_post - 2))
                }

                # Add missing value if less than two pregain or postgain sessions are available
            } else if (sum_n_pre < 2 | sum_n_post < 2) {

                crit3 <- NA
            }




            # Multiply dataframes with information on whether sudden gains criteria 1, 2, and 3 are met
            # 1 = criterion is met, 0 = criterion is not met, NA = not enough data to identify sudden gains

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
        }

        # return(as.logical(crit123))

        results <- paste("# Criterion 1: ", crit1, "\n",
                         "# Criterion 2: ", crit2, "\n",
                         "# Criterion 3, Critical value: ", round(sg_crit3_critical_value, 3), "\n",
                         "# Criterion 3: ", crit3, "\n",
                         identify_string, as.logical(crit123),
                         sep = "")

        cat(results)
    }
