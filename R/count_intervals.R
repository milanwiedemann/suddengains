#' Number of between session intervals analysed for sudden gains
#'
#' @param data A dataset in wide format with an id variable and the sudden gains variables.
#' @param cutoff A number specifying the cut-off for criterion 1.
#' @param id_var_name A string of the id variable name.
#' @param sg_var_list TODO.
#' @param analysed Logical, indicating whether sum of analysed or not analysed intervals should be reported. Analysed referrs to whether all three sudden gains criteria could be applied to a certain interval.
#' @param identify_sg_1to2 Logical, indicating whether first session gains should be included, this is only possible if baseline scores are included in \code{sg_var_list}.

#' @return Count of how many intervals were analysed for all three sudden gains criteria.
#' @export

count_intervals <-
    function(data,
             cutoff,
             id_var_name,
             sg_var_list,
             analysed = TRUE,
             identify_sg_1to2 = FALSE) {

        # First, run identify_sg() function to identify sudden gains and store results
        data_sg <- suddengains::identify_sg(
            data = data,
            cutoff = cutoff,
            id_var_name = id_var_name,
            sg_var_list = sg_var_list,
            identify_sg_1to2 = identify_sg_1to2
        )

        # Count number of analysed between session intervals
        # This function only counts intervals where it was possible to identify sudden gains:
        # If not all three criteria can be applied to an interval because of too many missing scores before or after the interval this function returns NA
        # Therefore this functions is not a simple count of between session intervals in the data but is more closely linked to sudden gains analysis
        if (analysed == TRUE) {
            sg_sess_sum <-
                base::sum(!is.na(dplyr::select(data_sg, dplyr::starts_with("sg_"))))
        }

        # Count number of between session intervals where the three sudden gains criteria could not be applied
        if (analysed == FALSE) {
            sg_sess_sum <-
                base::sum(is.na(dplyr::select(data_sg, dplyr::starts_with("sg_"))))
        }

        # Return number of between session intervals that were analysed / not analysed for sudden gains
        sg_sess_sum
    }
