#' Identify all sudden gains in a wide dataset.
#'
#' @param data A dataset in wide format with an id variable and the sudden gains variables.
#' @param cutoff A number specifying the cut-off for criterion 1.
#' @param id_var_name A string of the id variable name.
#' @param sg_var_name A string of the sudden gains variable name.

#' @return A wide dataset indicating at which between session interval a sudden gain occured for each person in \code{data}.
#' @export

identify_sg <- function(data, cutoff, id_var_name, sg_var_name) {

  # Load data ----
  # data object is the dataframe with id as a unique identifier and all session to session variables
  # df object is the dataframe without id that will go into the loop

  # Order by id here because after loop id will be binded back together by using cbind()
  data <- data %>%
    dplyr::arrange(!!rlang::sym(id_var_name)) %>%
    dplyr::select(!!rlang::sym(id_var_name), starts_with(sg_var_name))


  # identify_sg <- function(data)
  # Order by id here for safety as well because after loop id will be binded back together by using cbind()
  df <- data %>%
    dplyr::arrange(!!rlang::sym(id_var_name)) %>%
    dplyr::select(2:ncol(data)) # Remove id from dataframe for loop

  # Create one empty data frame for each sudden gains criterion ----
  # Data will be written in these in the for loop
  crit1 <- data.frame(matrix(NA, nrow = nrow(df), ncol = ncol(df) - 3))
  crit2 <- data.frame(matrix(NA, nrow = nrow(df), ncol = ncol(df) - 3))
  crit3 <- data.frame(matrix(NA, nrow = nrow(df), ncol = ncol(df) - 3))

  # Start iterating through dataframe ----
  for (i in 1:nrow(df)) {
    # Iterate through all rows
    # print(paste("---------- ROW", i, "----------"))
    for (j in 3:(ncol(df) - 1)) {
      # Iterate through all columns

      # Calculate 1st sudden gains criterion
      crit1[i, j - 2] <- (df[i, j - 1] - df[i, j] >= cutoff)

      # Calculate 2nd sudden gains criterion
      crit2[i, j - 2] <-
        (df[i, j - 1] - df[i, j] >= .25 * df[i, j - 1])

      # Calculate 3rd sudden gains criterion
      # Create pre and post indices for 3rd criterion
      pre_indices <-
        max(1, j - 3):(j - 1) # Create index for pregain
      post_indices <-
        j:min(ncol(df), j + 2) # Create index for postgain

      # print(paste("iPRE", pre_indices)) # Check pre indices
      # print(paste("iPOST", post_indices)) # Check post indices

      # Define pre and post mean and sd for 3rd criterion
      mean_pre <- mean(as.matrix(df[i, c(pre_indices)]), na.rm = T)
      mean_post <- mean(as.matrix(df[i, c(post_indices)]), na.rm = T)
      sd_pre <- sd(as.matrix(df[i, c(pre_indices)]), na.rm = T)
      sd_post <- sd(as.matrix(df[i, c(post_indices)]), na.rm = T)
      sum_n_pre <- sum(!is.na(df[i, c(pre_indices)]), na.rm = T)
      sum_n_post <- sum(!is.na(df[i, c(post_indices)]), na.rm = T)

      # Calculate 3rd criterion for no missing at pre or post
      if (sum_n_pre == 3 & sum_n_post == 3) {
        crit3[i, j - 2] <-
          mean_pre - mean_post > 2.776 * sqrt(((2 * sd_pre ^ 2) + (2 * sd_post ^ 2))  / (3 + 3 - 2))
      } else if (sum_n_pre == 2 &
                 sum_n_post == 3) {
        # Adjusting critical value for missing value in pregain mean
        crit3[i, j - 2] <-
          mean_pre - mean_post > 3.182 * sqrt(((2 * sd_pre ^ 2) + (2 * sd_post ^ 2))  / (2 + 3 - 2))
      } else if (sum_n_pre == 3 &
                 sum_n_post == 2) {
        # Adjusting critical value for one missing value in postgain mean
        crit3[i, j - 2] <-
          mean_pre - mean_post > 3.182 * sqrt(((2 * sd_pre ^ 2) + (2 * sd_post ^ 2))  / (3 + 2 - 2))
      } else if (sum_n_pre == 2 &
                 sum_n_post == 2) {
        # Adjusting critical value for one missing value in pregain and postgain mean each
        crit3[i, j - 2] <-
          mean_pre - mean_post > 4.303 * sqrt(((2 * sd_pre ^ 2) + (2 * sd_post ^ 2))  / (2 + 2 - 2))
      } else if (sum_n_pre < 2 | sum_n_post < 2) {
        crit3[i, j - 2] <- NA
      }
    }
  }

  # Multiply dataframes with information on whether sudden gains criteria are met
  # 1 = Criterion is met, 0 = criterion is not met,  NA = not enough data to be able to perform calculation
  crit123 <- crit1 * crit2 * crit3

  # Change the name of the dataframe
  sg_col_names <- c()
  for (i in 1:(ncol(df)-3)) {
    sg_col_names[i] <- paste("sg_",i,"to",i+1, sep = "")
  }

  names(crit123) <- sg_col_names

  # Bind information about each sudden gain criterion from loop with id number
  # The following three dataframe are only needed to check the individual criteria for each id
  data_crit1 <- cbind(data[ , 1], crit1)
  data_crit2 <- cbind(data[ , 1], crit2)
  data_crit3 <- cbind(data[ , 1], crit3)

  # Bind information about sudden gain from loop with id number
  data_crit123 <- cbind(data[ , 1], crit123)

  data_col_number <- max(ncol(data))

  data %>%
    dplyr::left_join(data_crit123, by = id_var_name)
}
