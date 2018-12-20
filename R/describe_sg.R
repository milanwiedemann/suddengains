#' Show descriptives for the sudden gains datasets
#'
#' Some numbers (percentages) will be different depending wich dataset is selected, because if multiple gains in bysg only one will be selected for further analyses.
#' @param data A \code{bysg} or \code{byperson} dataset.
#' @param sg_data_structure String indicating whether the provided data is a \code{bysg} or \code{byperson} dataset.
#' @export

describe_sg <- function(data, sg_data_structure) {

    results <- list()

    if (sg_data_structure == "bysg") {

        # Total n ----
        results$total_n <- summarise(data, n())[[1]]

        # Number of gains ----
        # results$sg_total_n <- summarise(data, sum(sg_freq_byperson, na.rm = TRUE)) %>% .[[1]]
        results$sg_total_n <- summarise(data, sum(sg_crit123, na.rm = TRUE))[[1]]
        results$sg_pct <- round(summarise(data, sum(sg_crit123, na.rm = TRUE) / summarise(data, n())) * 100, 2) %>% .[[1]]


        # Multiple gains ----
        # results$sg_multiple_n <- summarise(data, sum(sg_freq_byperson > 1, na.rm = TRUE))[[1]]
        results$sg_multiple_pct <- round(summarise(data, sum(sg_freq_byperson > 1, na.rm = TRUE)) / summarise(data, n()) * 100, 2) %>% .[[1]]

        # Reversals ----
        results$sg_reversal_n <- summarise(data, sum(sg_reversal, na.rm = TRUE))[[1]]
        results$sg_reversal_pct <- round(summarise(data, sum(sg_reversal, na.rm = TRUE))[[1]] / summarise(data, sum(sg_crit123, na.rm = TRUE))[[1]] * 100, 2)

        # Magnitude ----
        results$sg_magnitude_m <- round(summarise(data, mean(sg_magnitude, na.rm = TRUE)), 2)[[1]]
        results$sg_magnitude_sd <- round(summarise(data, sd(sg_magnitude, na.rm = TRUE)), 2)[[1]]

    } else if (sg_data_structure == "byperson") {

        # Total n ----
        results$total_n <- summarise(data, n())[[1]]

        # Number of gains ----
        results$sg_total_n <- summarise(data, sum(sg_freq_byperson, na.rm = TRUE)) %>% .[[1]]
        results$sg_n <- summarise(data, sum(sg_crit123, na.rm = TRUE))[[1]]
        results$sg_pct <- round(summarise(data, sum(sg_crit123, na.rm = TRUE) / summarise(data, n())) * 100, 2) %>% .[[1]]


        # Multiple gains ----
        results$sg_multiple_n <- summarise(data, sum(sg_freq_byperson > 1, na.rm = TRUE))[[1]]
        results$sg_multiple_pct <- round(summarise(data, sum(sg_freq_byperson > 1, na.rm = TRUE)) / summarise(data, n()) * 100, 2) %>% .[[1]]

        # Reversals ----
        results$sg_reversal_n <- summarise(data, sum(sg_reversal, na.rm = TRUE))[[1]]
        results$sg_reversal_pct <- round(summarise(data, sum(sg_reversal, na.rm = TRUE))[[1]] / summarise(data, sum(sg_crit123, na.rm = TRUE))[[1]] * 100, 2)

        # Magnitude ----
        results$sg_magnitude_m <- round(summarise(data, mean(sg_magnitude, na.rm = TRUE)), 2)[[1]]
        results$sg_magnitude_sd <- round(summarise(data, sd(sg_magnitude, na.rm = TRUE)), 2)[[1]]

    }



    print(results)
}
