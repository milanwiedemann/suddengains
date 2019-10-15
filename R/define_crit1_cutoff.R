#' Define cut-off value for first SG criterion
#'
#' @description Define the cut-off value for first sudden gains criterion using a modified reliable change index (RCI) formula.
#' \deqn{Cut-off value = 1.96 \times \sqrt{2 \times \sqrt{1-\alpha_pre}}}
#' @param data A dataset in wide format with values for
#' @param data_item A dataset in wide format including only the item-by-item scores of the SG measure, no ID variable
#' @param tx_start_var_name String, variable name of the pretreatment scores in the dataset specified in the \code{data} argument.
#' This argument is not needed if the standard deviation is specified in the \code{standard_deviation} argument.
#' @param standard_deviation Numeric, standard deviation of normal population or standard deviation at baseline.
#' @param reliability Numeric, between 0 and 1 indicating reliability of the scale.
#' According to Jacobson & Truax (1991) the test-retest reliability should be used.
#' Martinovich et al. (1996) suggest that the internal constitency (Cronbach's alpha) can be used insted of the test-retest reliability and may be a more appropriate for estimating the standard error in some cases.
#' @return A list with all calculated variables using modified formula for RCI including cut-off
#' @references Jacobson, N. S., & Truax, P. A. (1991). Clinical significance: A statistical approach to defining meaningful change in psychotherapy research. Journal of Consulting and Clinical Psychology, 59 (1), 12-19. \url{https://doi.org/10.1037/0022-006X.59.1.12}.
#'
#' Martinovich, Z., Saunders, S., & Howard, K. (1996). Some Comments on “Assessing Clinical Significance”. Psychotherapy Research, 6(2), 124–132. \url{https://doi.org/10.1080/10503309612331331648}.
#'
#' Stiles et al. (2003). Early sudden gains in psychotherapy under routine clinic conditions: Practice-based evidence. Journal of Consulting and Clinical Psychology, 71 (1), 14-21. \url{https://doi.org/10.1037/0022-006X.71.1.14}.
#' @export
#' @examples # Define cut-off value for first SG criterion
#' # In this example the reliability is specified and not calculated from item-by-item data
#' define_crit1_cutoff(data = sgdata,
#'                     data_item = NULL,
#'                     tx_start_var_name = "bdi_s0",
#'                     reliability = 0.931)

define_crit1_cutoff <- function(data = NULL, data_item = NULL, tx_start_var_name = NULL, standard_deviation = NULL, reliability = NULL) {

  # if (base::is.null(data_item) == TRUE & base::is.null(reliability) == TRUE) {
  #   stop("No information about reliability given.\nOne of the two arguments must be used:\n1. 'data_item'\n2. 'reliability'", call. = FALSE)
  # }

  # Reliability ----

  # Check that only one argument for reliability is defined
  if (base::is.null(data_item) == TRUE & base::is.null(reliability) == TRUE) {
    stop("Information about reliability missing, use one of the following arguments:\n- 'data_item'\n- 'reliability'", call. = FALSE)
  } else if (base::is.null(data_item) == FALSE & base::is.null(reliability) == FALSE) {
    stop("You can only use one argument to define the reliability that will be used to calculate the cut-off.\nSet either 'data_item or the 'reliability' argument to NULL.", call. = FALSE)
  }

  # Get reliability for further calculations
  if (base::is.null(reliability) == FALSE) {
    base::message("The reliability of the measure used to identify sudden gains was specified in the arguement 'reliability = ", reliability, "'.")
    reliability <- reliability
  } else if (base::is.null(reliability) == TRUE) {
    base::message("The reliability was calculated using the item-by-item data specified in the 'data_item' argument.")
    reliability <- psych::alpha(data_item)[[1]]$raw_alpha
  }

  # Check that reliability is between 0 and 1
  if (reliability > 1 | reliability < 0) {
    stop("Reliability has to be between 0 and 1.", call. = FALSE)
  }

  # Calculate RCI ----
  # Calculate the standard deviation of the sum scores at baseline

  # Standard deviation at baseline
  if (base::is.null(tx_start_var_name) == FALSE  & base::is.null(standard_deviation) == FALSE) {
    stop("Multiple arguments used to define  standard deviation, select one of the following:\n- Specify the standard deviation using 'standard_deviation'n- Use the arguments 'data' and 'tx_start_var_name'", call. = FALSE)
  }

  # Define or calculate here
  if (base::is.null(tx_start_var_name) == TRUE & base::is.null(standard_deviation) == TRUE) {
    stop("No information about standard deviation given.\nChoose one of the two options below:\n1. provide a data set (using the 'data' argument) including the pretretment scores with the variable name specified in 'tx_start_var_name'.\n2. manually enter the standard deviation using the 'standard_deviation' argument.", call. = FALSE)
  # } else if (base::is.null(data) == FALSE & base::is.null(standard_deviation) == FALSE) {
    stop("Multiple arguments specifying standard deviations used.", call. = FALSE)
  } else if (base::is.null(tx_start_var_name) == TRUE & base::is.null(standard_deviation) == FALSE) {
    standard_deviation_pre <- standard_deviation
  } else if (base::is.null(data) == FALSE & base::is.null(tx_start_var_name) == FALSE) {
    # Create vectors of variables used in this function
    pre_scores <- dplyr::pull(data, tx_start_var_name)
    standard_deviation_pre <- stats::sd(pre_scores, na.rm = TRUE)
  }



  # Calculate standard error of measurement
  standard_error_measurement <- standard_deviation_pre * base::sqrt(1 - reliability)

  # Calculate the standard error of the differences between two test scores
  sdiff <- base::sqrt(2 * (standard_error_measurement ^ 2))

  # Calculate RCI using mean change
  reliable_change <- sdiff * 1.96

  output <- base::list(standard_deviation_pre = standard_deviation_pre,
                       reliability = reliability,
                       standard_error_measurement = standard_error_measurement,
                       standard_error_difference = sdiff,
                       reliable_change = reliable_change)

  # General info message:
  base::message(paste0("This function calculates the standard error of the difference and value that represents reliable change based on the Reliable Change Index (RCI; Jacobson & Truax, 1991)."))

  # Return output as list in console
  return(output)
}
