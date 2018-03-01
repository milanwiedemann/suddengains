#' Extract variables around the sudden gain
#'
#' @param data A \code{bysg} or \code{byperson} dataset.
#' @param var_name A string of the variable name which numbers numbers need to get extracted around the sudden gain.

#' @return A wide dataset with values for \code{var_name} around the sudden gain.
#' @export

extract_scores <- function(data, var_name){
  data_extract <- dplyr::mutate(data,
                          !!base::sprintf("sg_%s_pre3", var_name) := NA,
                          !!base::sprintf("sg_%s_pre2", var_name) := NA,
                          !!base::sprintf("sg_%s_pre1", var_name) := NA,
                          !!base::sprintf("sg_%s_post1", var_name) := NA,
                          !!base::sprintf("sg_%s_post2", var_name) := NA,
                          !!base::sprintf("sg_%s_post3", var_name) := NA,

                          !!base::sprintf("sg_%s_pre3", var_name) := base::ifelse(sg_session_n == 1, NA, NA),
                          !!base::sprintf("sg_%s_pre3", var_name) := base::ifelse(sg_session_n == 2, !!rlang::sym(base::sprintf("%s_s0", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre3", var_name))),
                          !!base::sprintf("sg_%s_pre3", var_name) := base::ifelse(sg_session_n == 3, !!rlang::sym(base::sprintf("%s_s1", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre3", var_name))),
                          !!base::sprintf("sg_%s_pre3", var_name) := base::ifelse(sg_session_n == 4, !!rlang::sym(base::sprintf("%s_s2", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre3", var_name))),
                          !!base::sprintf("sg_%s_pre3", var_name) := base::ifelse(sg_session_n == 5, !!rlang::sym(base::sprintf("%s_s3", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre3", var_name))),
                          !!base::sprintf("sg_%s_pre3", var_name) := base::ifelse(sg_session_n == 6, !!rlang::sym(base::sprintf("%s_s4", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre3", var_name))),
                          !!base::sprintf("sg_%s_pre3", var_name) := base::ifelse(sg_session_n == 7, !!rlang::sym(base::sprintf("%s_s5", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre3", var_name))),
                          !!base::sprintf("sg_%s_pre3", var_name) := base::ifelse(sg_session_n == 8, !!rlang::sym(base::sprintf("%s_s6", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre3", var_name))),
                          !!base::sprintf("sg_%s_pre3", var_name) := base::ifelse(sg_session_n == 9, !!rlang::sym(base::sprintf("%s_s7", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre3", var_name))),
                          !!base::sprintf("sg_%s_pre3", var_name) := base::ifelse(sg_session_n == 10, !!rlang::sym(base::sprintf("%s_s8", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre3", var_name))),

                          !!base::sprintf("sg_%s_pre2", var_name) := base::ifelse(sg_session_n == 1, !!rlang::sym(base::sprintf("%s_s0", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre3", var_name))),
                          !!base::sprintf("sg_%s_pre2", var_name) := base::ifelse(sg_session_n == 2, !!rlang::sym(base::sprintf("%s_s1", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre2", var_name))),
                          !!base::sprintf("sg_%s_pre2", var_name) := base::ifelse(sg_session_n == 3, !!rlang::sym(base::sprintf("%s_s2", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre2", var_name))),
                          !!base::sprintf("sg_%s_pre2", var_name) := base::ifelse(sg_session_n == 4, !!rlang::sym(base::sprintf("%s_s3", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre2", var_name))),
                          !!base::sprintf("sg_%s_pre2", var_name) := base::ifelse(sg_session_n == 5, !!rlang::sym(base::sprintf("%s_s4", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre2", var_name))),
                          !!base::sprintf("sg_%s_pre2", var_name) := base::ifelse(sg_session_n == 6, !!rlang::sym(base::sprintf("%s_s5", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre2", var_name))),
                          !!base::sprintf("sg_%s_pre2", var_name) := base::ifelse(sg_session_n == 7, !!rlang::sym(base::sprintf("%s_s6", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre2", var_name))),
                          !!base::sprintf("sg_%s_pre2", var_name) := base::ifelse(sg_session_n == 8, !!rlang::sym(base::sprintf("%s_s7", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre2", var_name))),
                          !!base::sprintf("sg_%s_pre2", var_name) := base::ifelse(sg_session_n == 9, !!rlang::sym(base::sprintf("%s_s8", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre2", var_name))),
                          !!base::sprintf("sg_%s_pre2", var_name) := base::ifelse(sg_session_n == 10, !!rlang::sym(base::sprintf("%s_s9", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre2", var_name))),

                          !!base::sprintf("sg_%s_pre1", var_name) := base::ifelse(sg_session_n == 1, !!rlang::sym(base::sprintf("%s_s1", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre1", var_name))),
                          !!base::sprintf("sg_%s_pre1", var_name) := base::ifelse(sg_session_n == 2, !!rlang::sym(base::sprintf("%s_s2", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre1", var_name))),
                          !!base::sprintf("sg_%s_pre1", var_name) := base::ifelse(sg_session_n == 3, !!rlang::sym(base::sprintf("%s_s3", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre1", var_name))),
                          !!base::sprintf("sg_%s_pre1", var_name) := base::ifelse(sg_session_n == 4, !!rlang::sym(base::sprintf("%s_s4", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre1", var_name))),
                          !!base::sprintf("sg_%s_pre1", var_name) := base::ifelse(sg_session_n == 5, !!rlang::sym(base::sprintf("%s_s5", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre1", var_name))),
                          !!base::sprintf("sg_%s_pre1", var_name) := base::ifelse(sg_session_n == 6, !!rlang::sym(base::sprintf("%s_s6", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre1", var_name))),
                          !!base::sprintf("sg_%s_pre1", var_name) := base::ifelse(sg_session_n == 7, !!rlang::sym(base::sprintf("%s_s7", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre1", var_name))),
                          !!base::sprintf("sg_%s_pre1", var_name) := base::ifelse(sg_session_n == 8, !!rlang::sym(base::sprintf("%s_s8", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre1", var_name))),
                          !!base::sprintf("sg_%s_pre1", var_name) := base::ifelse(sg_session_n == 9, !!rlang::sym(base::sprintf("%s_s9", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre1", var_name))),
                          !!base::sprintf("sg_%s_pre1", var_name) := base::ifelse(sg_session_n == 10, !!rlang::sym(base::sprintf("%s_s10", var_name)), !!rlang::sym(base::sprintf("sg_%s_pre1", var_name))),

                          !!base::sprintf("sg_%s_post1", var_name) := base::ifelse(sg_session_n == 1, !!rlang::sym(base::sprintf("%s_s2", var_name)), !!rlang::sym(base::sprintf("sg_%s_post1", var_name))),
                          !!base::sprintf("sg_%s_post1", var_name) := base::ifelse(sg_session_n == 2, !!rlang::sym(base::sprintf("%s_s3", var_name)), !!rlang::sym(base::sprintf("sg_%s_post1", var_name))),
                          !!base::sprintf("sg_%s_post1", var_name) := base::ifelse(sg_session_n == 3, !!rlang::sym(base::sprintf("%s_s4", var_name)), !!rlang::sym(base::sprintf("sg_%s_post1", var_name))),
                          !!base::sprintf("sg_%s_post1", var_name) := base::ifelse(sg_session_n == 4, !!rlang::sym(base::sprintf("%s_s5", var_name)), !!rlang::sym(base::sprintf("sg_%s_post1", var_name))),
                          !!base::sprintf("sg_%s_post1", var_name) := base::ifelse(sg_session_n == 5, !!rlang::sym(base::sprintf("%s_s6", var_name)), !!rlang::sym(base::sprintf("sg_%s_post1", var_name))),
                          !!base::sprintf("sg_%s_post1", var_name) := base::ifelse(sg_session_n == 6, !!rlang::sym(base::sprintf("%s_s7", var_name)), !!rlang::sym(base::sprintf("sg_%s_post1", var_name))),
                          !!base::sprintf("sg_%s_post1", var_name) := base::ifelse(sg_session_n == 7, !!rlang::sym(base::sprintf("%s_s8", var_name)), !!rlang::sym(base::sprintf("sg_%s_post1", var_name))),
                          !!base::sprintf("sg_%s_post1", var_name) := base::ifelse(sg_session_n == 8, !!rlang::sym(base::sprintf("%s_s9", var_name)), !!rlang::sym(base::sprintf("sg_%s_post1", var_name))),
                          !!base::sprintf("sg_%s_post1", var_name) := base::ifelse(sg_session_n == 9, !!rlang::sym(base::sprintf("%s_s10", var_name)), !!rlang::sym(base::sprintf("sg_%s_post1", var_name))),
                          !!base::sprintf("sg_%s_post1", var_name) := base::ifelse(sg_session_n == 10, !!rlang::sym(base::sprintf("%s_s11", var_name)), !!rlang::sym(base::sprintf("sg_%s_post1", var_name))),

                          !!base::sprintf("sg_%s_post2", var_name) := base::ifelse(sg_session_n == 1, !!rlang::sym(base::sprintf("%s_s3", var_name)), !!rlang::sym(base::sprintf("sg_%s_post2", var_name))),
                          !!base::sprintf("sg_%s_post2", var_name) := base::ifelse(sg_session_n == 2, !!rlang::sym(base::sprintf("%s_s4", var_name)), !!rlang::sym(base::sprintf("sg_%s_post2", var_name))),
                          !!base::sprintf("sg_%s_post2", var_name) := base::ifelse(sg_session_n == 3, !!rlang::sym(base::sprintf("%s_s5", var_name)), !!rlang::sym(base::sprintf("sg_%s_post2", var_name))),
                          !!base::sprintf("sg_%s_post2", var_name) := base::ifelse(sg_session_n == 4, !!rlang::sym(base::sprintf("%s_s6", var_name)), !!rlang::sym(base::sprintf("sg_%s_post2", var_name))),
                          !!base::sprintf("sg_%s_post2", var_name) := base::ifelse(sg_session_n == 5, !!rlang::sym(base::sprintf("%s_s7", var_name)), !!rlang::sym(base::sprintf("sg_%s_post2", var_name))),
                          !!base::sprintf("sg_%s_post2", var_name) := base::ifelse(sg_session_n == 6, !!rlang::sym(base::sprintf("%s_s8", var_name)), !!rlang::sym(base::sprintf("sg_%s_post2", var_name))),
                          !!base::sprintf("sg_%s_post2", var_name) := base::ifelse(sg_session_n == 7, !!rlang::sym(base::sprintf("%s_s9", var_name)), !!rlang::sym(base::sprintf("sg_%s_post2", var_name))),
                          !!base::sprintf("sg_%s_post2", var_name) := base::ifelse(sg_session_n == 8, !!rlang::sym(base::sprintf("%s_s10", var_name)), !!rlang::sym(base::sprintf("sg_%s_post2", var_name))),
                          !!base::sprintf("sg_%s_post2", var_name) := base::ifelse(sg_session_n == 9, !!rlang::sym(base::sprintf("%s_s11", var_name)), !!rlang::sym(base::sprintf("sg_%s_post2", var_name))),
                          !!base::sprintf("sg_%s_post2", var_name) := base::ifelse(sg_session_n == 10, !!rlang::sym(base::sprintf("%s_s12", var_name)), !!rlang::sym(base::sprintf("sg_%s_post2", var_name))),

                          !!base::sprintf("sg_%s_post3", var_name) := base::ifelse(sg_session_n == 1, !!rlang::sym(base::sprintf("%s_s4", var_name)), !!rlang::sym(base::sprintf("sg_%s_post3", var_name))),
                          !!base::sprintf("sg_%s_post3", var_name) := base::ifelse(sg_session_n == 2, !!rlang::sym(base::sprintf("%s_s5", var_name)), !!rlang::sym(base::sprintf("sg_%s_post3", var_name))),
                          !!base::sprintf("sg_%s_post3", var_name) := base::ifelse(sg_session_n == 3, !!rlang::sym(base::sprintf("%s_s6", var_name)), !!rlang::sym(base::sprintf("sg_%s_post3", var_name))),
                          !!base::sprintf("sg_%s_post3", var_name) := base::ifelse(sg_session_n == 4, !!rlang::sym(base::sprintf("%s_s7", var_name)), !!rlang::sym(base::sprintf("sg_%s_post3", var_name))),
                          !!base::sprintf("sg_%s_post3", var_name) := base::ifelse(sg_session_n == 5, !!rlang::sym(base::sprintf("%s_s8", var_name)), !!rlang::sym(base::sprintf("sg_%s_post3", var_name))),
                          !!base::sprintf("sg_%s_post3", var_name) := base::ifelse(sg_session_n == 6, !!rlang::sym(base::sprintf("%s_s9", var_name)), !!rlang::sym(base::sprintf("sg_%s_post3", var_name))),
                          !!base::sprintf("sg_%s_post3", var_name) := base::ifelse(sg_session_n == 7, !!rlang::sym(base::sprintf("%s_s10", var_name)), !!rlang::sym(base::sprintf("sg_%s_post3", var_name))),
                          !!base::sprintf("sg_%s_post3", var_name) := base::ifelse(sg_session_n == 8, !!rlang::sym(base::sprintf("%s_s11", var_name)), !!rlang::sym(base::sprintf("sg_%s_post3", var_name))),
                          !!base::sprintf("sg_%s_post3", var_name) := base::ifelse(sg_session_n == 9, !!rlang::sym(base::sprintf("%s_s12", var_name)), !!rlang::sym(base::sprintf("sg_%s_post3", var_name)))
  )
}
