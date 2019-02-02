#' Number of between session intervals analysed for sudden gains
#'
#' @description Calculates the number of between-session intervals present in the data set, the number that could feasibly be analysed for sudden gains (given the pattern of any missing data), and the number of gain intervals found.
#'
#' @param data A data set in wide format including an ID variable and variables for each measurement point.
#' @param id_var_name String, specifying the name of the ID variable. Each row should have a unique value.
#' @param sg_var_list List, specifying the variable names of each measurement point sequentially.
#' @param identify_sg_1to2 Logical, indicating whether to identify sudden losses from measurement point 1 to 2.
#' If set to TRUE, this implies that the first variable specified in \code{sg_var_list} represents a baseline measurement point, e.g. pre-intervention assessment.
#' @return List with values for:
#'   \describe{
#'     \item{total_between_sess_intervals}{: The total number of between-session intervals present in the data set}
#'     \item{total_between_sess_intervals_sg}{: The total number of gain intervals (i.e. sudden gains) present in the data set}
#'     \item{sg_sess_sum_analysed}{: The total number of between-session intervals that could be analysed for sudden gains}
#'     \item{sg_sess_sum_not_analysed}{: The total number of between-session intervals that could not be analysed for sudden gains (due to missing data)}
#'     }
#' @export

count_intervals <- function(data, id_var_name, sg_var_list, identify_sg_1to2 = FALSE) {

    # First, run identify_sg() function to identify sudden gains and store results
    data_sg <- suddengains::identify_sg(data = data,
                                        sg_crit1_cutoff = 1,
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
