#' Select sample with enough available data to identify sudden gains
#'
#' @param data A dataset in wide format with an id variable and the sudden gains variables.
#' @return A wide dataset a new variable \code{sg_select} indicating whether there is enough data available to identify sudden gains.
#' @export

select_sg_sample <- function(data) {

  data_sg_sample <- data %>%
    dplyr::mutate(sg_select = NA,
         sg_select = base::ifelse((!base::is.na(pds_s1 == TRUE)) & (!base::is.na(pds_s2 == TRUE)) & (!base::is.na(pds_s3 == TRUE)) & (!base::is.na(pds_s4 == TRUE)) |
                              (!base::is.na(pds_s1 == TRUE)) & (!base::is.na(pds_s2 == TRUE)) & (!base::is.na(pds_s3 == TRUE)) & (!base::is.na(pds_s5 == TRUE)) |
                              (!base::is.na(pds_s1 == TRUE)) & (!base::is.na(pds_s3 == TRUE)) & (!base::is.na(pds_s4 == TRUE)) & (!base::is.na(pds_s5 == TRUE)) |
                              (!base::is.na(pds_s1 == TRUE)) & (!base::is.na(pds_s3 == TRUE)) & (!base::is.na(pds_s4 == TRUE)) & (!base::is.na(pds_s6 == TRUE)),
                            1, sg_select),
         sg_select = base::ifelse((!base::is.na(pds_s2 == TRUE)) & (!base::is.na(pds_s3 == TRUE)) & (!base::is.na(pds_s4 == TRUE)) & (!base::is.na(pds_s5 == TRUE)) |
                              (!base::is.na(pds_s2 == TRUE)) & (!base::is.na(pds_s3 == TRUE)) & (!base::is.na(pds_s4 == TRUE)) & (!base::is.na(pds_s6 == TRUE)) |
                              (!base::is.na(pds_s2 == TRUE)) & (!base::is.na(pds_s4 == TRUE)) & (!base::is.na(pds_s5 == TRUE)) & (!base::is.na(pds_s6 == TRUE)) |
                              (!base::is.na(pds_s2 == TRUE)) & (!base::is.na(pds_s4 == TRUE)) & (!base::is.na(pds_s5 == TRUE)) & (!base::is.na(pds_s7 == TRUE)),
                            1, sg_select),
         sg_select = base::ifelse((!base::is.na(pds_s3 == TRUE)) & (!base::is.na(pds_s4 == TRUE)) & (!base::is.na(pds_s5 == TRUE)) & (!base::is.na(pds_s6 == TRUE)) |
                              (!base::is.na(pds_s3 == TRUE)) & (!base::is.na(pds_s4 == TRUE)) & (!base::is.na(pds_s5 == TRUE)) & (!base::is.na(pds_s7 == TRUE)) |
                              (!base::is.na(pds_s3 == TRUE)) & (!base::is.na(pds_s5 == TRUE)) & (!base::is.na(pds_s6 == TRUE)) & (!base::is.na(pds_s7 == TRUE)) |
                              (!base::is.na(pds_s3 == TRUE)) & (!base::is.na(pds_s5 == TRUE)) & (!base::is.na(pds_s6 == TRUE)) & (!base::is.na(pds_s8 == TRUE)),
                            1, sg_select),
         sg_select = base::ifelse((!base::is.na(pds_s4 == TRUE)) & (!base::is.na(pds_s5 == TRUE)) & (!base::is.na(pds_s6 == TRUE)) & (!base::is.na(pds_s7 == TRUE)) |
                              (!base::is.na(pds_s4 == TRUE)) & (!base::is.na(pds_s5 == TRUE)) & (!base::is.na(pds_s6 == TRUE)) & (!base::is.na(pds_s8 == TRUE)) |
                              (!base::is.na(pds_s4 == TRUE)) & (!base::is.na(pds_s6 == TRUE)) & (!base::is.na(pds_s7 == TRUE)) & (!base::is.na(pds_s8 == TRUE)) |
                              (!base::is.na(pds_s4 == TRUE)) & (!base::is.na(pds_s6 == TRUE)) & (!base::is.na(pds_s7 == TRUE)) & (!base::is.na(pds_s9 == TRUE)),
                            1, sg_select),
         sg_select = base::ifelse((!base::is.na(pds_s5 == TRUE)) & (!base::is.na(pds_s6 == TRUE)) & (!base::is.na(pds_s7 == TRUE)) & (!base::is.na(pds_s8 == TRUE)) |
                              (!base::is.na(pds_s5 == TRUE)) & (!base::is.na(pds_s6 == TRUE)) & (!base::is.na(pds_s7 == TRUE)) & (!base::is.na(pds_s9 == TRUE)) |
                              (!base::is.na(pds_s5 == TRUE)) & (!base::is.na(pds_s7 == TRUE)) & (!base::is.na(pds_s8 == TRUE)) & (!base::is.na(pds_s9 == TRUE)) |
                              (!base::is.na(pds_s5 == TRUE)) & (!base::is.na(pds_s7 == TRUE)) & (!base::is.na(pds_s8 == TRUE)) & (!base::is.na(pds_s10 == TRUE)),
                            1, sg_select),
         sg_select = base::ifelse((!base::is.na(pds_s6 == TRUE)) & (!base::is.na(pds_s7 == TRUE)) & (!base::is.na(pds_s8 == TRUE)) & (!base::is.na(pds_s9 == TRUE)) |
                              (!base::is.na(pds_s6 == TRUE)) & (!base::is.na(pds_s7 == TRUE)) & (!base::is.na(pds_s8 == TRUE)) & (!base::is.na(pds_s10 == TRUE)) |
                              (!base::is.na(pds_s6 == TRUE)) & (!base::is.na(pds_s8 == TRUE)) & (!base::is.na(pds_s9 == TRUE)) & (!base::is.na(pds_s10 == TRUE)) |
                              (!base::is.na(pds_s6 == TRUE)) & (!base::is.na(pds_s8 == TRUE)) & (!base::is.na(pds_s9 == TRUE)) & (!base::is.na(pds_s11 == TRUE)),
                            1, sg_select),
         sg_select = base::ifelse((!base::is.na(pds_s7 == TRUE)) & (!base::is.na(pds_s8 == TRUE)) & (!base::is.na(pds_s9 == TRUE)) & (!base::is.na(pds_s10 == TRUE)) |
                              (!base::is.na(pds_s7 == TRUE)) & (!base::is.na(pds_s8 == TRUE)) & (!base::is.na(pds_s9 == TRUE)) & (!base::is.na(pds_s11 == TRUE)) |
                              (!base::is.na(pds_s7 == TRUE)) & (!base::is.na(pds_s9 == TRUE)) & (!base::is.na(pds_s10 == TRUE)) & (!base::is.na(pds_s11 == TRUE)) |
                              (!base::is.na(pds_s7 == TRUE)) & (!base::is.na(pds_s9 == TRUE)) & (!base::is.na(pds_s10 == TRUE)) & (!base::is.na(pds_s12 == TRUE)),
                            1, sg_select),
         sg_select = base::ifelse((!base::is.na(pds_s8 == TRUE)) & (!base::is.na(pds_s9 == TRUE)) & (!base::is.na(pds_s10 == TRUE)) & (!base::is.na(pds_s11 == TRUE)) |
                              (!base::is.na(pds_s8 == TRUE)) & (!base::is.na(pds_s9 == TRUE)) & (!base::is.na(pds_s10 == TRUE)) & (!base::is.na(pds_s12 == TRUE)) |
                              (!base::is.na(pds_s8 == TRUE)) & (!base::is.na(pds_s10 == TRUE)) & (!base::is.na(pds_s11 == TRUE)) & (!base::is.na(pds_s12 == TRUE)),
                            1, sg_select)
  )

data_sg_sample$sg_select[base::is.na(data_sg_sample$sg_select)] <- 0

data_sg_sample

}
