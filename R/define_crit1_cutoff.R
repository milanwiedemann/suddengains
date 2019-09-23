#' Define cut-off value for first SG criterion
#'
#' @description Define the cut-off value for first sudden gains criterion using a modified reliable change index (RCI) formula.
#' \deqn{Cut-off value = 1.96 \times \sqrt{2 \times \sqrt{1-\alpha_pre}}}
#' @param data A dataset in wide format with values for
#' @param data_item A dataset in wide format including only the item-by-item scores of the SG measure, no ID variable
#' @param tx_start_var_name String, variable name of the pretreatment scores
#' @param sd_pre Standard deviation at baseline
#' @param reliability Numeric, between 0 and 1 indicating reliability of the scale.
#' @return A list with all calculated variables using modified formula for RCI including cut-off
#' @references Jacobson, N. S., & Truax, P. A. (1991). Clinical significance: A statistical approach to defining meaningful change in psychotherapy research. Journal of Consulting and Clinical Psychology, 59 (1), 12-19. \url{https://doi.org/10.1037/0022-006X.59.1.12}.
#'
#' Stiles et al. (2003). Early sudden gains in psychotherapy under routine clinic conditions: Practice-based evidence. Journal of Consulting and Clinical Psychology, 71 (1), 14-21. \url{https://doi.org/10.1037/0022-006X.71.1.14}.
#' @export
#' @examples # Define cut-off value for first SG criterion
#' # In this example the reliability is specified and not calculated from item-by-item data
#' define_crit1_cutoff(data = sgdata,
#'                     data_item = NULL,
#'                     tx_start_var_name = "bdi_s0",
#'                     reliability = 0.931)

define_crit1_cutoff <- function(data = NULL, sd_pre = NULL, tx_start_var_name = NULL, data_item = NULL, reliability = NULL) {

  if (base::is.null(data_item) == TRUE & base::is.null(reliability) == TRUE) {
    stop("No information about reliability given.\n
         One of the two arguments must be used:\n
         1. 'data_item', provide item by item data of baseline questionnaire to calculate Cronbach's alpha\n
         2. 'reliability' set the reliability manually.", call. = FALSE)
  }

  if (base::is.null(data_item) == FALSE & base::is.null(reliability) == FALSE) {
    stop("You can only use one argument to define the reliability that will be used to calculate the cut off.\n
         Set either 'data_item or the 'reliability' argument to NULL.", call. = FALSE)
  }

  # TODO Write check
  if (base::is.null(data_item) == TRUE & reliability > 1 | reliability < 0) {
    stop("Reliability has to be between 0 and 1.", call. = FALSE)
  }

  # Calculate RCI ----
  # Calculate the standard deviation of the sum scores at baseline

  # Standard deviation at baseline
  # Define or calculate here
  if (base::is.null(data) == TRUE & base::is.null(tx_start_var_name) == TRUE) {
    standard_deviation_pre <- sd_pre
  } else if (base::is.null(data) == FALSE & base::is.null(tx_start_var_name) == FALSE) {
    # Create vectors of variables used in this function
    pre_scores <- dplyr::pull(data_sessions, tx_start_var_name)
    standard_deviation_pre <- stats::sd(pre_scores, na.rm = TRUE)
  }

  # Reliability
  # Define reliability or calculate Cronbach's alpha at baseline using psych package
  if (base::is.null(reliability) == FALSE) {
      base::message("The reliability of the measure used to identify sudden gains was specified in the arguement 'reliability = ", reliability, "'.")
      reliability <- reliability
  } else if (base::is.null(reliability) == TRUE) {
      base::message("The reliability was calculated using the item-by-item data specified in the 'data_item' argument.")
      reliability <- psych::alpha(data_item)[[1]]$raw_alpha
  }

  # Calculate standard error of measurement
  standard_error_measurement <- standard_deviation_pre * base::sqrt(1 - reliability)

  # Calculate the standard error of the differences between two test scores
  sdiff <- base::sqrt(2 * (standard_error_measurement ^ 2))

  # Calculate RCI using mean change
  sg_crit1_cutoff <- sdiff * 1.96

  output <- base::list(standard_deviation_pre = standard_deviation_pre,
                       reliability = reliability,
                       standard_error_measurement = standard_error_measurement,
                       sdiff = sdiff,
                       sg_crit1_cutoff = sg_crit1_cutoff)

  # General info message:
  base::message(paste0("This function calculates a cut-off value that represents reliable change based on the Reliable Change Index (RCI; Jacobson & Truax, 1991)."))

  # Return output as list in console
  return(output)
}


