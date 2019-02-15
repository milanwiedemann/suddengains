#' Show descriptives for the sudden gains datasets
#'
#' Some numbers (percentages) will be different depending wich dataset is selected, because if multiple gains in bysg only one will be selected for further analyses.
#' @param data A \code{bysg} or \code{byperson} dataset.
#' @param sg_data_structure String, indicating whether the input data is a \code{bysg} or \code{byperson} dataset.
#' @return A list, showing basic descriptive statistics for sudden gains within the dataset specified.
#' Note that some numbers (e.g. percentages) will be different depending which dataset is selected, because where a participant has multiple gains, only one is selected for the \code{byperson} dataset.
#' The list includes values for:
#'   \itemize{
#'     \item{total_n}{: number of rows in input dataset}
#'     \item{sg_total_n}{: total number of sudden gains}
#'     \item{sg_n}{: number of people who experienced a sudden gain (byperson dataset only)}
#'     \item{sg_pct}{: percentage of people in the input dataset who experienced a sudden gain}
#'     \item{sg_multiple_n}{: number of people who experienced a sudden gain (byperson dataset only)}
#'     \item{sg_multiple_pct}{: percentage of people in the input dataset who experienced more than one sudden gain}
#'     \item{sg_reversal_n}{: number of sudden gains that later meets criteria for a reversal}
#'     \item{sg_reversal_pct}{: percentage of sudden gains that later meets criteria for a reversal}
#'     \item{sg_magnitude_m}{: mean magnitude of the sudden gains observed}
#'     \item{sg_magnitude_sd}{: standard deviation of the magnitude of the sudden gains observed}
#'     }
#' @export

describe_sg <- function(data, sg_data_structure = c("bysg", "byperson")) {

    # Check arguments for sg_data_structure
    sg_data_structure <- match.arg(sg_data_structure)

    # Create list to write results
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

    # Return descriptives
    print(results)
}
