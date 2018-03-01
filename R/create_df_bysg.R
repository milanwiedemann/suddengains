#' Create a dataset with one gain per row, referred to as \code{bysg} dataset
#'
#' @param data A dataset in wide format with an id variable and the sudden gains variables.
#' @param cutoff A number specifying the cut-off for criterion 1.
#' @param id_var_name A string of the id variable name.
#' @param sg_var_name A string of the sudden gains variable name.

#' @return A dataset with one row per sudden gain.
#' @export

create_df_bysg <- function(data, cutoff, id_var_name, sg_var_name){

  # Before doing anything, save the raw data that was put in function as data argument
  data_in <- data

  # Run identify_sg function first to find positions of gain
  data_crit123 <- suddengains::identify_sg(data, cutoff, id_var_name, sg_var_name)

  # data_crit123_sg_var_name <- data_crit123 %>%
  #   select(id, starts_with(sg_var_name))

  # Set missingsto zero to calculate in next step
  data_crit123[base::is.na(data_crit123)] <- 0

  # Calculate bysg dataset
  data_bysg <- data_crit123 %>%
    dplyr::mutate( # Sum up gains here to use in next step to replicate rows with multiple gains
      sg_freq_byperson =  sg_2to3 + sg_3to4 + sg_4to5 + sg_5to6 + sg_6to7 + sg_7to8 + sg_8to9 + sg_9to10 + sg_10to11
    ) %>%
    .[rep(1:base::nrow(.), .$sg_freq_byperson),] %>% # Replicate cases with multiple gains based in sg_freg variable
    dplyr::arrange(dplyr::desc(sg_freq_byperson), id)

  # Calculate bysg dataset
  data_bysg_multi <- data_crit123 %>%
    dplyr::mutate( # Sum up gains here to use in next step to replicate rows with multiple gains
      sg_freq_byperson =  sg_2to3 + sg_3to4 + sg_4to5 + sg_5to6 + sg_6to7 + sg_7to8 + sg_8to9 + sg_9to10 + sg_10to11
    ) %>%
    .[rep(1:base::nrow(.), .$sg_freq_byperson),] %>% # Replicate cases with multiple gains based in sg_freg variable
    dplyr::arrange(dplyr::desc(sg_freq_byperson), id) %>%
    dplyr::select(id, starts_with("sg_"))

  id_multiple <- data_bysg %>%
    dplyr::select(id, sg_freq_byperson) %>%
    dplyr::filter(sg_freq_byperson>1) %>%
    dplyr::arrange(dplyr::desc(sg_freq_byperson), id) %>%
    base::unique()



  # LOOOOOOOPPPPPPP TO SELECT 1 GAIN PER ROW
  # TODO This ONLY WORKS FOR 3 gains at the moment, need to write more else ifs...

  m <- 1
  n <- 1

  for (i in 1:base::nrow(id_multiple)) {
    if (id_multiple[[i, 2]] == 3) {
      # print("---- 3 GAINS ----")
      # print(paste("i:", i))
      # print(paste("m:", m))
      # print(paste("n:", n))
      data_bysg_multi[base::which(base::grepl(id_multiple[i, 1], data_bysg_multi$id))[1], base::which(data_bysg_multi[m, 1:(ncol(data_bysg_multi) - 1)] > 0)[4]] = 0
      data_bysg_multi[base::which(base::grepl(id_multiple[i, 1], data_bysg_multi$id))[1], base::which(data_bysg_multi[m, 1:(ncol(data_bysg_multi) - 1)] > 0)[3]] = 0
      data_bysg_multi[base::which(base::grepl(id_multiple[i, 1], data_bysg_multi$id))[2], base::which(data_bysg_multi[m + 1, 1:(ncol(data_bysg_multi) - 1)] > 0)[4]] = 0
      data_bysg_multi[base::which(base::grepl(id_multiple[i, 1], data_bysg_multi$id))[2], base::which(data_bysg_multi[m + 1, 1:(ncol(data_bysg_multi) - 1)] > 0)[2]] = 0
      data_bysg_multi[base::which(base::grepl(id_multiple[i, 1], data_bysg_multi$id))[3], base::which(data_bysg_multi[m + 2, 1:(ncol(data_bysg_multi) - 1)] > 0)[2]] = 0
      data_bysg_multi[base::which(base::grepl(id_multiple[i, 1], data_bysg_multi$id))[3], base::which(data_bysg_multi[m + 2, 1:(ncol(data_bysg_multi) - 1)] > 0)[2]] = 0
      m <- m + 3
      n <- m
    } else if (id_multiple[[i, 2]] == 2) {
      # print("---- 2 GAINS ----")
      # print(paste("i:", i))
      # print(paste("m:", m))
      # print(paste("n:", n))
      data_bysg_multi[base::which(base::grepl(id_multiple[i, 1], data_bysg_multi$id))[1], base::which(data_bysg_multi[n, 1:(ncol(data_bysg_multi) - 1)] > 0)[2]] = 0
      data_bysg_multi[base::which(base::grepl(id_multiple[i, 1], data_bysg_multi$id))[2], base::which(data_bysg_multi[n, 1:(ncol(data_bysg_multi) - 1)] > 0)[2]] = 0
      n <- n + 2
    }
  }

  # Continue with creating variables now
  data_bysg <- data_bysg %>%
    dplyr::select(-starts_with("sg_")) %>%
    base::cbind(data_bysg_multi[ , 2:ncol(data_bysg_multi)])

  # Not that I only have one gain per row I can multiply to get correct session number
  data_bysg <- data_bysg %>%
    dplyr::mutate(
      sg_crit123 = 1, # Assign value 1 to all for meeting gains criteria 1, 2 and 3
      sg_session_n = (2 * sg_2to3) + (3 * sg_3to4) + (4 * sg_4to5) +
        (5 * sg_5to6) + (6 * sg_6to7) + (7 * sg_7to8) + (8 * sg_8to9) +
        (9 * sg_9to10) + (10 * sg_10to11)
    ) %>%
    dplyr::mutate(id_sg = as.character(paste(.$id, "sg", .$sg_session_n, sep = "_"))) %>%
    select(id, id_sg, sg_crit123, sg_freq_byperson, sg_session_n)

  data_bysg <- data_bysg %>%
    dplyr::left_join(data_in, by = "id")

  data_bysg <- suddengains::extract_scores(data_bysg, "pds")


  data_bysg <- data_bysg %>%
    dplyr::mutate(sg_magnitude = sg_pds_pre1 - sg_pds_post1, # compute the magnitude of the gain
           pds_change_total = pds_s0 - pds_end,
           sg_change_proportion = sg_magnitude / pds_change_total, # compute the percentage drop in pds symptoms accounted for by the gain
           sg_reversal_value = sg_pds_post1 + (sg_magnitude / 2) # compute the critical value to calculate reversals in next step
    )

  # If pds_change_1to18 we get an Inf value for sg_change_proportion (devision by zero), therefore we replace Inf with NA
  data_bysg$sg_change_proportion[data_bysg$sg_change_proportion == Inf] <- NA

  # Calculate sudden gain reversals ----
  # Create a reversal variable, and start with all values set to NA

  # Now cycle through each session, to check whether the gain subsequently reversed
  # TODO: MAKE THIS A FUNCTION AT SOME POINT LATER
  # i.e. Does any session score from session n+2 onwards exceed the critical value for a reversal calculated above?
  # NOTE: The below code is for a 14 session intervention, and therefore runs up to cases where the pregain session = 12. This is because gains after this point
  # do not have subsequent weekly scores where a reversal is possible.
  # NOTE: If you are changing the number of sessions, each of the below commands will need updating by adding or removing conditional OR (|) statements.

  data_bysg <- data_bysg %>%
    dplyr::mutate(sg_reversal = NA,
           sg_reversal = base::ifelse(sg_session_n == 2 &
                                  (pds_s4 > sg_reversal_value | pds_s5 > sg_reversal_value |
                                     pds_s6 > sg_reversal_value | pds_s7 > sg_reversal_value |
                                     pds_s8 > sg_reversal_value | pds_s9 > sg_reversal_value |
                                     pds_s10 > sg_reversal_value | pds_s11 > sg_reversal_value |
                                     pds_s12 > sg_reversal_value),
                                1, sg_reversal),
           sg_reversal = base::ifelse(sg_session_n == 3 &
                                  (pds_s5 > sg_reversal_value |  pds_s6 > sg_reversal_value |
                                     pds_s7 > sg_reversal_value | pds_s8 > sg_reversal_value |
                                     pds_s9 > sg_reversal_value | pds_s10 > sg_reversal_value |
                                     pds_s11 > sg_reversal_value | pds_s12 > sg_reversal_value),
                                1, sg_reversal),
           sg_reversal = base::ifelse(sg_session_n == 4 &
                                  (pds_s6 > sg_reversal_value | pds_s7 > sg_reversal_value |
                                     pds_s8 > sg_reversal_value | pds_s9 > sg_reversal_value |
                                     pds_s10 > sg_reversal_value | pds_s11 > sg_reversal_value |
                                     pds_s12 > sg_reversal_value),
                                1, sg_reversal),
           sg_reversal = base::ifelse(sg_session_n == 5 &
                                  (pds_s7 > sg_reversal_value | pds_s8 > sg_reversal_value |
                                     pds_s9 > sg_reversal_value | pds_s10 > sg_reversal_value |
                                     pds_s11 > sg_reversal_value | pds_s12 > sg_reversal_value),
                                1, sg_reversal),
           sg_reversal = base::ifelse(sg_session_n == 6 &
                                  (pds_s8 > sg_reversal_value | pds_s9 > sg_reversal_value |
                                     pds_s10 > sg_reversal_value | pds_s11 > sg_reversal_value |
                                     pds_s12 > sg_reversal_value),
                                1, sg_reversal),
           sg_reversal = base::ifelse(sg_session_n == 7 &
                                  (pds_s9 > sg_reversal_value | pds_s10 > sg_reversal_value |
                                     pds_s11 > sg_reversal_value | pds_s12 > sg_reversal_value),
                                1, sg_reversal),
           sg_reversal = base::ifelse(sg_session_n == 8 &
                                  (pds_s10 > sg_reversal_value | pds_s11 > sg_reversal_value |
                                     pds_s12 > sg_reversal_value),
                                1, sg_reversal),
           sg_reversal = base::ifelse(sg_session_n == 9 &
                                  (pds_s11 > sg_reversal_value |
                                     pds_s12 > sg_reversal_value),
                                1, sg_reversal),
           sg_reversal = base::ifelse(sg_session_n == 10 &
                                  (pds_s12 > sg_reversal_value),
                                1, sg_reversal)
    )


  # The code above returns a NA if the critical value for reversal is not met and the case has missing values after the n+1 session
  # These are all sudden gains that have not reversed, therefore we replace NAs from the code above with 0

  data_bysg$sg_reversal[base::is.na(data_bysg$sg_reversal)] <- 0

  data_bysg
}
