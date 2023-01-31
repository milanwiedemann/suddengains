#' Define cut-off value for first SG criterion
#'
#' @description Define a cut-off value for the first sudden gains criterion based on the Reliable Change Index (RCI; Jacobson & Truax, 1991) using an estimate for the standard deviation (sd) of the normal population and the reliability of the scale.
#' These values can be entered manually using the arguments \code{sd} and \code{reliability} or extracted from data using the arguments \code{data_sd} and \code{data_reliability}.
#' This function calculates the standard error of measurement (se), the standard error of the difference (sdiff) and a value that classifies as reliable change (reliable_change_value) based on the Reliable Change Index (RCI; Jacobson & Truax, 1991).
#' \deqn{se = sd * \sqrt{(1 - reliability)}}
#' \deqn{sdiff = \sqrt{(2 * se^2)}}
#' \deqn{reliable change value = 1.96 * sdiff}
#' @param sd Numeric, standard deviation of normal population or standard deviation at baseline.
#' This argument is not needed if a vector with pretreatment scores is specified in the \code{data_sd} argument.
#' @param reliability Numeric, between 0 and 1 indicating reliability of the scale.
#' This argument is not needed if item-by-item data is specified in the \code{data_reliability} argument.
#' @param data_sd A vector with pretreatment values.
#' This argument is not needed if the standard deviation is specified in the \code{sd} argument.
#' @param data_reliability A dataset in wide format (one row for each individual and one column for each item) including only the item-by-item scores of the SG measure (no ID variable).
#' According to Jacobson & Truax (1991) the test-retest reliability should be used.
#' Martinovich et al. (1996) suggest that the internal consistency (Cronbach's alpha) can be used instead of the test-retest reliability and may be more appropriate for estimating the standard error in some cases.
#' This argument is not needed if the reliability is specified in the \code{reliability} argument.
#' @return A list with estimates the for standard error of measurement (se), the standard error of the difference (sdiff) and a value that classifies as reliable change (reliable_change_value).
#' @references Jacobson, N. S., & Truax, P. A. (1991). Clinical significance: A statistical approach to defining meaningful change in psychotherapy research. Journal of Consulting and Clinical Psychology, 59 (1), 12-19. <doi:10.1037/0022-006X.59.1.12>.
#'
#' Martinovich, Z., Saunders, S., & Howard, K. (1996). Some Comments on “Assessing Clinical Significance”. Psychotherapy Research, 6(2), 124–132. <doi:10.1080/10503309612331331648>.
#'
#' Stiles et al. (2003). Early sudden gains in psychotherapy under routine clinic conditions: Practice-based evidence. Journal of Consulting and Clinical Psychology, 71 (1), 14-21. <doi:doi.org/10.1037/0022-006X.71.1.14>.
#' @export
#' @examples # Define cut-off value for first SG criterion
#' # In this example the standard deviation and the reliability are specified manually
#' define_crit1_cutoff(sd = 10.5,
#'                     reliability = 0.931)
#'
#' # In this example the reliability is specified manually
#' # The standard deviation of the variable "bdi_s0" in the dataset "sgdata" gets calculated
#' define_crit1_cutoff(data_sd = sgdata$bdi_s0,
#'                     reliability = 0.931)

define_crit1_cutoff <- function(sd = NULL, reliability = NULL, data_sd = NULL, data_reliability = NULL) {

  # Reliability ----
  # Check that only one argument for reliability is defined
  if (base::is.null(data_reliability) == TRUE & base::is.null(reliability) == TRUE) {
    stop("Information about reliability missing, use one of the following options:\n1. Specify the reliability manually using the 'reliability' argument.\n 2. Provide a data set with item-by-item to calculate Cronbach's alpha.", call. = FALSE)
  } else if (base::is.null(data_reliability) == FALSE & base::is.null(reliability) == FALSE) {
    stop("Only one argument can be used to define the reliability.\nSet either 'data_reliability' or the 'reliability' argument to NULL.", call. = FALSE)
  }

  # Get reliability for further calculations
  if (base::is.null(reliability) == FALSE) {
    base::message("The reliability of the measure used to identify sudden gains was specified in the arguement 'reliability = ", reliability, "'.")
    reliability <- reliability
  } else if (base::is.null(reliability) == TRUE) {
    reliability <- psych::alpha(data_reliability)[[1]]$raw_alpha
    base::message("The reliability (", round(reliability, 3),") was calculated using the item-by-item data specified in the 'data_reliability' argument.")
  }

  # Check that reliability is between 0 and 1
  if (reliability > 1 | reliability < 0) {
    stop("Reliability has to be between 0 and 1.", call. = FALSE)
  }

  # Calculate RCI ----
  # Calculate the standard deviation of the sum scores at baseline

  # Standard deviation at baseline
  if (base::is.null(data_sd) == FALSE & base::is.null(sd) == FALSE) {
    stop("Multiple arguments used to define standard deviation, select one of the following arguments:\n1. Specify the standard deviation manually using 'sd'.\n2. Provide a vector with pre-treatment values using the argument 'data_sd'.", call. = FALSE)
  }

  # Define or calculate here
  if (base::is.null(data_sd) == TRUE & base::is.null(sd) == TRUE) {
    stop("No information about standard deviation given.\nChoose one of the two options below:\n1. Specify the standard deviation manually using 'sd'.\n2. Provide a vector with pre-treatment values using the argument 'data_sd'.", call. = FALSE)
  } else if (base::is.null(data_sd) == TRUE & base::is.null(sd) == FALSE) {
    sd_pre <- sd
  } else if (base::is.null(data_sd) == FALSE & base::is.null(sd) == TRUE) {
    # Create vectors of variables used in this function
    sd_pre <- stats::sd(data_sd, na.rm = TRUE)
  }

  # Calculate standard error of measurement
  standard_error_measurement <- sd_pre * base::sqrt(1 - reliability)

  # Calculate the standard error of the differences between two test scores
  sdiff <- base::sqrt(2 * (standard_error_measurement ^ 2))

  # Calculate RCI using mean change
  reliable_change <- sdiff * 1.96

  output <- base::list(sd = sd_pre,
                       reliability = reliability,
                       standard_error_measurement = standard_error_measurement,
                       standard_error_difference = sdiff,
                       reliable_change_value = reliable_change)

  # General info message:
  # base::message(paste0("This function calculates the standard error of the difference and value that represents reliable change based on the Reliable Change Index (RCI; Jacobson & Truax, 1991)."))

  # Return output as list in console
  return(output)
}
