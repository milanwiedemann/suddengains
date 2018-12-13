#' @title Identify sudden gains in a wide dataset.
#'
#' @description Function identify sudden gains in a wide dataset. automatically checks whether first session gains are calculated by analysing the variable names looking for session with 0 (intake) before a letter.
#'
#' @param data A dataset in wide format with an id variable and the sudden gains variables.
#' @param cutoff A number specifying the cut-off for criterion 1.
#' @param id_var_name A string of the id variable name.
#' @param sg_var_list A LIST of the variable names for sudden gains analysis, if first session gains should be analysed simply add session 0 at the beginning of the list.
#' @param identify_sg_1to2 Logical value to indicate whether first session gains should be in dataset,
#' simply include s0 before before all the other variables in sg_var_list, it will simply change the way
#' variables are named but this is super important for calculating which session sudden gain is in and also for extracting stuff later
#' @param crit123_details Logical, if crit123_details = TRUE a dataframe will be written to global environment


#' @return A wide dataset indicating at which between session interval a sudden gain occured for each person in \code{data}.
#' @export

identify_sg <- function(data, cutoff, id_var_name, sg_var_list, identify_sg_1to2 = FALSE, crit123_details = FALSE, name_crit123_details = "data_crit123_details") {

  # Load data ----
  # data object is the dataframe with id as a unique identifier and all session to session variables
  # df object is the dataframe without id that will go into the loop

  # Order by id here because after loop id will be binded back together by using base::cbind()

  # Number of variables used to identify sudden gains
  sg_var_num <- length(sg_var_list)

  data <- data %>%
      dplyr::arrange(!! rlang::sym(id_var_name)) %>%
      dplyr::select(!! rlang::sym(id_var_name), sg_var_list)

  # identify_sg <- function(data)
  # Order by id here for safety as well because after loop id will be binded back together by using base::cbind()
  df <- data %>%
    dplyr::arrange(!! rlang::sym(id_var_name)) %>%
    dplyr::select(2:base::ncol(data)) # Remove id from dataframe for loop

  # Create one empty data frame for each sudden gains criterion ----
  # Data will be written in these in the for loop
  crit1 <- base::data.frame(base::matrix(NA, nrow = base::nrow(df), ncol = base::ncol(df) - 3))
  crit2 <- base::data.frame(base::matrix(NA, nrow = base::nrow(df), ncol = base::ncol(df) - 3))
  crit3 <- base::data.frame(base::matrix(NA, nrow = base::nrow(df), ncol = base::ncol(df) - 3))

  # Start iterating through dataframe ----
  for (row_i in 1:base::nrow(df)) {
    # Iterate through all rows
    # print(base::paste("---------- ROW", row_i, "----------"))
    for (col_j in 3:(base::ncol(df) - 1)) {
      # Iterate through all columns

      # Calculate 1st sudden gains criterion
      crit1[row_i, col_j - 2] <- (df[row_i, col_j - 1] - df[row_i, col_j] >= cutoff)

      # Calculate 2nd sudden gains criterion
      crit2[row_i, col_j - 2] <-
        (df[row_i, col_j - 1] - df[row_i, col_j] >= .25 * df[row_i, col_j - 1])

      # Calculate 3rd sudden gains criterion
      # Create pre and post indices for 3rd criterion
      pre_indices <- base::max(1, col_j - 3):(col_j - 1) # Create index for pregain
      post_indices <- col_j:min(base::ncol(df), col_j + 2) # Create index for postgain

      # print(base::paste("iPRE", pre_indices)) # Check pre indices
      # print(base::paste("iPOST", post_indices)) # Check post indices

      # Define pre and post mean and sd for 3rd criterion
      mean_pre <- base::mean(base::as.matrix(df[row_i, base::c(pre_indices)]), na.rm = T)
      mean_post <- base::mean(base::as.matrix(df[row_i, base::c(post_indices)]), na.rm = T)
      sd_pre <- stats::sd(base::as.matrix(df[row_i, base::c(pre_indices)]), na.rm = T)
      sd_post <- stats::sd(base::as.matrix(df[row_i, base::c(post_indices)]), na.rm = T)
      sum_n_pre <- base::sum(!is.na(df[row_i, base::c(pre_indices)]), na.rm = T)
      sum_n_post <- base::sum(!is.na(df[row_i, base::c(post_indices)]), na.rm = T)

      # Calculate 3rd criterion for no missing at pre or post
      if (sum_n_pre == 3 & sum_n_post == 3) {
        crit3[row_i, col_j - 2] <-
          mean_pre - mean_post > 2.776 * base::sqrt(((2 * sd_pre ^ 2) + (2 * sd_post ^ 2)) / (3 + 3 - 2))
      } else if (sum_n_pre == 2 &
                 sum_n_post == 3) {
        # Adjusting critical value for missing value in pregain mean
        crit3[row_i, col_j - 2] <-
          mean_pre - mean_post > 3.182 * base::sqrt(((2 * sd_pre ^ 2) + (2 * sd_post ^ 2)) / (2 + 3 - 2))
      } else if (sum_n_pre == 3 &
                 sum_n_post == 2) {
        # Adjusting critical value for one missing value in postgain mean
        crit3[row_i, col_j - 2] <-
          mean_pre - mean_post > 3.182 * base::sqrt(((2 * sd_pre ^ 2) + (2 * sd_post ^ 2))  / (3 + 2 - 2))
      } else if (sum_n_pre == 2 &
                 sum_n_post == 2) {
        # Adjusting critical value for one missing value in pregain and postgain mean each
        crit3[row_i, col_j - 2] <-
          mean_pre - mean_post > 4.303 * base::sqrt(((2 * sd_pre ^ 2) + (2 * sd_post ^ 2))  / (2 + 2 - 2))
      } else if (sum_n_pre < 2 | sum_n_post < 2) {
        crit3[row_i, col_j - 2] <- NA
      }
    }
  }

  # Multiply dataframes with information on whether sudden gains criteria are met
  # 1 = Criterion is met, 0 = criterion is not met,  NA = not enough data to perform calculation
  crit123 <- crit1 * crit2 * crit3

  # Create empty list for renaming variables
  sg_col_names <- base::c()
  sg_col_names_crit1 <- base::c()
  sg_col_names_crit2 <- base::c()
  sg_col_names_crit3 <- base::c()

  # Create new variable names for sudden gains variables
  # If identify_sg_1to2 is true, sg variables will start with sg_1to2
  if (identify_sg_1to2 == FALSE) {

    for (i in 1:(base::ncol(df) - 3)) {
      sg_col_names[i] <- base::paste0("sg_", i + 1, "to", i + 2)

      sg_col_names_crit1[i] <- base::paste0("sg_crit1_", i + 1, "to", i + 2)
      sg_col_names_crit2[i] <- base::paste0("sg_crit2_", i + 1, "to", i + 2)
      sg_col_names_crit3[i] <- base::paste0("sg_crit3_", i + 1, "to", i + 2)
    }

  # If identify_sg_1to2 is FALSE, sg variables will start with sg_2to3
  } else if (identify_sg_1to2 == TRUE) {

    for (i in 1:(base::ncol(df) - 3)) {
      sg_col_names[i] <- base::paste0("sg_", i, "to", i + 1)

      sg_col_names_crit1[i] <- base::paste0("sg_crit1_", i, "to", i + 1)
      sg_col_names_crit2[i] <- base::paste0("sg_crit2_", i, "to", i + 1)
      sg_col_names_crit3[i] <- base::paste0("sg_crit3_", i, "to", i + 1)
    }

  }

  # Name main datafile with all three criteria
  names(crit123) <- sg_col_names

  # Name individual datafiles with criteria 1, 2, 3
  names(crit1) <- sg_col_names_crit1
  names(crit2) <- sg_col_names_crit2
  names(crit3) <- sg_col_names_crit3

  # Bind information about each sudden gain criterion from loop with id number
  # The following three dataframe are only needed to check the individual criteria for each id

  # Export model ----
  if (crit123_details == TRUE) {
    data_crit123_details <- base::cbind(data[ , 1], crit1, crit2, crit3)

    # The name for the exported dataframe can be changed in the function
    assign(name_crit123_details, data_crit123_details, envir = .GlobalEnv)
  }

  # Bind information about sudden gain from loop with id number
  data_crit123 <- base::cbind(data[ , 1], crit123)

  data_col_number <- base::max(base::ncol(data))

  data %>%
    dplyr::left_join(data_crit123, by = id_var_name) %>%
      tibble::as.tibble()

  }

