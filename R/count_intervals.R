#' Number of between session intervals analysed for sudden gains
#'
#' @description Calculates the number of between-session intervals present in the data set, the number that could feasibly be analysed for sudden gains (given the pattern of any missing data), and the number of gain intervals found.
#'
#' @param data A data set in wide format including an ID variable and variables for each measurement point.
#' @param id_var_name String, specifying the name of the ID variable. Each row should have a unique value.
#' @param sg_var_list Vector, specifying the variable names of each measurement point sequentially.
#' @param identify_sg_1to2 Logical, indicating whether to identify sudden losses from measurement point 1 to 2.
#' If set to TRUE, this implies that the first variable specified in \code{sg_var_list} represents a baseline measurement point, e.g. pre-intervention assessment.
#' @return List with values for:
#'   \itemize{
#'     \item{total_between_sess_intervals}{: The total number of between-session intervals present in the data set.}
#'     \item{total_between_sess_intervals_sg}{: The total number of gain intervals (i.e. sudden gains) present in the data set.}
#'     \item{analysed_between_sess_intervals_sg}{: The total number of between-session intervals that could be analysed for sudden gains.}
#'     \item{not_analysed_between_sess_intervals_sg}{: The total number of between-session intervals that could not be analysed for sudden gains (due to missing data).}
#'     }
#' @export
#' @examples # Count between session intervals in "sgdata"
#' count_intervals(data = sgdata,
#'                 id_var_name = "id",
#'                 sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3", "bdi_s4",
#'                                 "bdi_s5", "bdi_s6", "bdi_s7", "bdi_s8",
#'                                 "bdi_s9", "bdi_s10", "bdi_s11", "bdi_s12"))

count_intervals <- function(data, id_var_name, sg_var_list, identify_sg_1to2 = FALSE) {

    # First, run identify_sg() function to identify sudden gains and store results
    data_sg <- suppressMessages(suddengains::identify_sg(data = data,
                                        # Set this to 1 as it doesnt matter for counting, between session intervals
                                        # I just need to know where all three criteria can be applied
                                        sg_crit1_cutoff = 1,
                                        sg_crit2_pct = .25,
                                        sg_crit3 = TRUE,
                                        id_var_name = id_var_name,
                                        sg_var_list = sg_var_list,
                                        identify_sg_1to2 = identify_sg_1to2
                                        ))

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
    analysed_between_sess_intervals_sg <- base::sum(!is.na(dplyr::select(data_sg, dplyr::starts_with("sg_"))))

    # Count number of between session intervals where the three sudden gains criteria could not be applied
    not_analysed_between_sess_intervals_sg <- base::sum(is.na(dplyr::select(data_sg, dplyr::starts_with("sg_"))))

    sg_sess_list <- base::list(total_between_sess_intervals = total_between_sess_intervals,
                         total_between_sess_intervals_sg = total_between_sess_intervals_sg,
                         analysed_between_sess_intervals_sg = analysed_between_sess_intervals_sg,
                         not_analysed_between_sess_intervals_sg = not_analysed_between_sess_intervals_sg)


    # Return number of between session intervals that were analysed / not analysed for sudden gains
    base::return(sg_sess_list)
    }
