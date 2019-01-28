#' Select sample with enough available data to identify sudden gains
#'
#' @param data A dataset in wide format with an id variable and the sudden gains variables.
#' @return A wide dataset a new variable \code{sg_select} indicating whether there is enough data available to identify sudden gains.
#' @export

select_cases <- function(data, id_var_name, sg_var_list, method, min_sess_num, return_id_lgl = FALSE) {

  data_select <- data %>%
    dplyr::select(id_var_name, sg_var_list) %>%
    dplyr::arrange(!! rlang::sym(id_var_name))



  if (method == "pattern") {

    # Return matrix indicating whether values are missing (FALSE) or available (TRUE)
    data_pattern <- !is.na(data_select[ , 2:(length(sg_var_list) + 1)])

    # Get list of IDs
    id_list <- dplyr::select(data_select, id_var_name)

    # Combine IDs with data pattern
    data_pattern <- base::cbind(id_list, data_pattern)



    # LALALA test this
    data_out <- data_pattern %>%
        tibble::as.tibble() %>%
        tidyr::unite("pattern", sg_var_list, sep = " ") %>%
        dplyr::mutate(sg_pattern_1 = stringr::str_detect(pattern, "TRUE TRUE TRUE TRUE"),
             sg_pattern_2 = stringr::str_detect(pattern, "TRUE TRUE TRUE FALSE TRUE"),
             sg_pattern_3 = stringr::str_detect(pattern, "TRUE FALSE TRUE TRUE TRUE"),
             sg_pattern_4 = stringr::str_detect(pattern, "TRUE FALSE TRUE TRUE FALSE TRUE"),

             sg_select = dplyr::if_else(condition = (sg_pattern_1 == TRUE | sg_pattern_2 == TRUE | sg_pattern_3 == TRUE | sg_pattern_4 == TRUE), TRUE, FALSE)) %>%
      # Only
        dplyr::select(id_var_name, sg_select)

    } else if (method == "min_sess") {

    # LALALA test this

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
