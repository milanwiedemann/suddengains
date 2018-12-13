#' Rename variables for extracting variables in sudden gians package
#'
#' @param data Dataframe in wide format
#' @param rename_var_list List of variables measuring first construct
#' @return Dataframe in wide format with renamed variables
#' @export

rename_sg_vars <- function(data, rename_var_list, new_var_str = "temp_var_", start_numbering = 1){

  if (start_numbering == 1) {
    for (i in base::seq_along(rename_var_list)) {
      base::names(data)[base::names(data) == rename_var_list[i]] <- base::paste0(new_var_str, i)
    }
  } else if (start_numbering == 0) {
    for (i in base::seq_along(rename_var_list)) {
      base::names(data)[base::names(data) == rename_var_list[i]] <- base::paste0(new_var_str, i - 1)
    }
  }

    # Return dataframe with renamed variables
    data
}
