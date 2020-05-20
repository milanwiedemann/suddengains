#' Select sample providing enough data to identify sudden gains
#'
#' @description Select sample for further sudden gains analyses depending on specified methods.
#'
#' The following table shows the different data patterns that get selected when \code{method = "pattern"}.
#' This function goes through the data and selects all cases with at least one of the following data patterns.
#' \tabular{lrrrrrr}{
#' \strong{Pattern} \tab \strong{x1} \tab \strong{x2} \tab \strong{x3} \tab \strong{x4} \tab \strong{x5} \tab \strong{x6} \cr
#' \strong{1.}       \tab x           \tab \strong{N}  \tab x           \tab x           \tab .         \tab .           \cr
#' \strong{2.}       \tab x           \tab \strong{N}  \tab x           \tab .          \tab x          \tab .           \cr
#' \strong{3.}       \tab x           \tab .          \tab \strong{N}  \tab x           \tab x          \tab .           \cr
#' \strong{4.}       \tab x           \tab .          \tab \strong{N}  \tab x           \tab .          \tab x
#' }
#' \emph{Note}. x1 to x6 are consecutive data points of the primary outcome measure. 'x' = Available data; '.' = Missing data. '\strong{N}' represents available data to be examined as a possible pregain session.
#' @param data A dataset in wide format with an id variable and the sudden gains variables.
#' @param id_var_name String, specifying the name of the ID variable. Each row should have a unique value.
#' @param sg_var_list Vector, specifying the variable names of each measurement point sequentially.
#' @param method String, specifying the method used to select cases: \code{pattern} or \code{min_sess}.
#' @param min_sess_num Numeric, minimum number of available sessions to be selected.
#' This argument needs to be specified if \code{method = min_sess}.
#' @param return_id_lgl Logical, if \code{TRUE} the function returns the ID variable and a new variable \code{sg_select} indicating whether there is enough data available to identify sudden gains.
#' If set to \code{FALSE} this function returns the input data together with the new variable \code{sg_select}.
#' @return A wide dataset indicating with all cases and a variable indicating whether each cases provides enough data to identify sudden gains.
#' @export
#' @examples # 1. method = "pattern"
#' select_cases(data = sgdata,
#'              id_var_name = "id",
#'              sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3", "bdi_s4",
#'                              "bdi_s5", "bdi_s6", "bdi_s7", "bdi_s8",
#'                              "bdi_s9", "bdi_s10", "bdi_s11", "bdi_s12"),
#'              method = "pattern",
#'              return_id_lgl = FALSE)
#'
#' # 2. method = "min_sess"
#' select_cases(data = sgdata,
#'              id_var_name = "id",
#'              sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3", "bdi_s4",
#'                              "bdi_s5", "bdi_s6", "bdi_s7", "bdi_s8",
#'                              "bdi_s9", "bdi_s10", "bdi_s11", "bdi_s12"),
#'              method = "min_sess",
#'              min_sess_num = 9,
#'              return_id_lgl = TRUE)

select_cases <- function(data, id_var_name, sg_var_list, method = c("pattern", "min_sess"), min_sess_num = NULL, return_id_lgl = FALSE) {

    # Check arguments
    if (!is.data.frame(data)) {
        stop("`data` argument should be a dataframe", call. = FALSE)
    }

    if (!is.character(id_var_name)) {
        stop("`id_var_name` argument should be a character", call. = FALSE)
    }

    if (!is.character(sg_var_list)) {
        stop("`sg_var_list` argument should be character", call. = FALSE)
    }

    if (!is.character(method)) {
        stop("`method` argument should be a character", call. = FALSE)
    }

    if (!is.logical(return_id_lgl)) {
        stop("`return_id_lgl` argument should be logical", call. = FALSE)
    }

    # Select variables and arrange by id
    data_select <- data %>%
      dplyr::select(id_var_name, sg_var_list) %>%
      dplyr::arrange(!! rlang::sym(id_var_name))

    method <- match.arg(method)

    if (method == "pattern") {

      base::message("The method 'pattern' was used to select cases.\nSee help('select_cases') for more information.")

      # Return matrix indicating whether values are missing (FALSE) or available (TRUE)
      data_pattern <- !is.na(data_select[ , 2:(length(sg_var_list) + 1)])

      # Get list of IDs
      id_list <- dplyr::select(data_select, id_var_name)

      # Combine IDs with data pattern
      data_pattern <- base::cbind(id_list, data_pattern)

      data_out <- data_pattern %>%
          tibble::as_tibble() %>%
          tidyr::unite("pattern", sg_var_list, sep = " ") %>%
          dplyr::mutate(sg_pattern_1 = stringr::str_detect(pattern, "TRUE TRUE TRUE TRUE"),
               sg_pattern_2 = stringr::str_detect(pattern, "TRUE TRUE TRUE FALSE TRUE"),
               sg_pattern_3 = stringr::str_detect(pattern, "TRUE FALSE TRUE TRUE TRUE"),
               sg_pattern_4 = stringr::str_detect(pattern, "TRUE FALSE TRUE TRUE FALSE TRUE"),
               sg_select = dplyr::if_else(condition = (sg_pattern_1 == TRUE | sg_pattern_2 == TRUE | sg_pattern_3 == TRUE | sg_pattern_4 == TRUE), TRUE, FALSE)) %>%
          dplyr::select(id_var_name, sg_select)

      } else if (method == "min_sess") {

        base::message("The method 'min_sess' was used to select cases.")

        if (!is.numeric(min_sess_num)) {
            stop("`min_sess_num` argument should be numeric", call. = FALSE)
        }

        if (min_sess_num > length(sg_var_list)) {
          stop("The minimum number of sessions 'min_sess' is greater than the number of sessions in 'sg_var_list'.", call. = FALSE)
        }

      data_select$nvalid <- base::rowSums(!is.na(data_select[ , 2:(length(sg_var_list) + 1)]))

      data_out <- data_select %>%
          dplyr::mutate(sg_select = dplyr::if_else(nvalid >= min_sess_num, TRUE, FALSE)) %>%
          dplyr::select(id_var_name, sg_select)
      }

    if (return_id_lgl == TRUE) {
    # Return data out, only id with TRUE or FALSE
    return(data_out)

      } else if (return_id_lgl == FALSE) {

        data_out <- data %>%
            dplyr::left_join(data_out, by = id_var_name)

        # Return data out, with all input variables from data and lgl select variabl
        return(data_out)
      }
    }
