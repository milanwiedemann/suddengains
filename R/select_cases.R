#' Select sample with enough available data to identify sudden gains
#'
#' @param data A dataset in wide format with an id variable and the sudden gains variables.
#' @param id_var_name TODO
#' @param sg_var_list TODO
#' @param method String, select method  \code{pattern} or  \code{min_sess}
#' @param min_sess_num Numberic, minimum of avalable sessions
#' @param return_id_lgl Logical, if ture return ids with variable indicating whether case meets the selection method
#' @return A wide dataset a new variable \code{sg_select} indicating whether there is enough data available to identify sudden gains.
#' @export

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

      # Return matrix indicating whether values are missing (FALSE) or available (TRUE)
      data_pattern <- !is.na(data_select[ , 2:(length(sg_var_list) + 1)])

      # Get list of IDs
      id_list <- dplyr::select(data_select, id_var_name)

      # Combine IDs with data pattern
      data_pattern <- base::cbind(id_list, data_pattern)

      data_out <- data_pattern %>%
          tibble::as.tibble() %>%
          tidyr::unite("pattern", sg_var_list, sep = " ") %>%
          dplyr::mutate(sg_pattern_1 = stringr::str_detect(pattern, "TRUE TRUE TRUE TRUE"),
               sg_pattern_2 = stringr::str_detect(pattern, "TRUE TRUE TRUE FALSE TRUE"),
               sg_pattern_3 = stringr::str_detect(pattern, "TRUE FALSE TRUE TRUE TRUE"),
               sg_pattern_4 = stringr::str_detect(pattern, "TRUE FALSE TRUE TRUE FALSE TRUE"),
               sg_select = dplyr::if_else(condition = (sg_pattern_1 == TRUE | sg_pattern_2 == TRUE | sg_pattern_3 == TRUE | sg_pattern_4 == TRUE), TRUE, FALSE)) %>%
          dplyr::select(id_var_name, sg_select)

      } else if (method == "min_sess") {

        if (!is.numeric(min_sess_num)) {
            stop("`min_sess_num` argument should be numeric", call. = FALSE)
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
