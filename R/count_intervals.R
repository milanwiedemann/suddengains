#' Number of between session intervals analysed for sudden gains
#'
#' @description I want  this to be different fomr title. Number of between session intervals analysed for sudden gains
#'
#' @param data A dataset in wide format with an id variable and the sudden gains variables.
#' @param sg_crit1_cutoff A number specifying the cut-off for criterion 1.
#' @param id_var_name A string of the id variable name.
#' @param sg_var_list TODO.
#' @param identify_sg_1to2 Logical, indicating whether first session gains should be included, this is only possible if baseline scores are included in \code{sg_var_list}.

#' @return List with values for:
#' total_between_sess_intervals,
#' total_between_sess_intervals_sg,
#' sg_sess_sum_analysed,
#' sg_sess_sum_not_analysed
#' @export

count_intervals <- function(data, sg_crit1_cutoff, id_var_name, sg_var_list, identify_sg_1to2 = FALSE) {

    # First, run identify_sg() function to identify sudden gains and store results
    data_sg <- suddengains::identify_sg(data = data,
                                        sg_crit1_cutoff = sg_crit1_cutoff,
                                        id_var_name = id_var_name,
                                        sg_var_list = sg_var_list,
                                        identify_sg_1to2 = identify_sg_1to2
                                        )

    total_between_sess_intervals <- (base::length(sg_var_list) - 1) * base::nrow(data)

    if (identify_sg_1to2 == TRUE) {
      total_between_sess_intervals_sg <- total_between_sess_intervals - 1 * base::nrow(data)
    } else if (identify_sg_1to2 == FALSE) {
        total_between_sess_intervals_sg <- total_between_sess_intervals - 2 * base::nrow(data)
    }

    # Count number of analysed between session intervals
    # This function only counts intervals where it was possible to identify sudden gains:
    # If not all three criteria can be applied to an interval because of too many missing scores before or after the interval this function returns NA
    # Therefore this functions is not a simple count of between session intervals in the data but is more closely linked to sudden gains analysis
    sg_sess_sum_analysed <- base::sum(!is.na(dplyr::select(data_sg, dplyr::starts_with("sg_"))))

    # Count number of between session intervals where the three sudden gains criteria could not be applied
    sg_sess_sum_not_analysed <- base::sum(is.na(dplyr::select(data_sg, dplyr::starts_with("sg_"))))

    sg_sess_list <- list(total_between_sess_intervals = total_between_sess_intervals,
                         total_between_sess_intervals_sg = total_between_sess_intervals_sg,
                         sg_sess_sum_analysed = sg_sess_sum_analysed,
                         sg_sess_sum_not_analysed = sg_sess_sum_not_analysed)


    # Return number of between session intervals that were analysed / not analysed for sudden gains
    return(sg_sess_list)
    }
