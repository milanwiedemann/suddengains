#' Plot average magnitude of sudden gain or another variable around the sudden gain
#'
#' @param data A \code{bysg} or \code{byperson} dataset.
#' @param ylabel A string as label for y-Axis.
#' @param start A string of the variable name with scores at the start of treatment.
#' @param pre3 A string of the pre3 variable name.
#' @param pre2 A string of the pre2 variable name.
#' @param pre1 A string of the pre1 variable name.
#' @param post1 A string of the post1 variable name.
#' @param post2 A string of the post2 variable name.
#' @param post3 A string of the post3 variable name.
#' @param end A string of the variable name with scores at the end of treatment.
#' @return A plot of the average gain around or changes in scores of another questionnaire around the sudden gain.
#' @export

plot_sg <- function(data, var_sg, ylabel, start, pre3, pre2, pre1, post1, post2, post3, end){

  plot_data <- data %>%
    dplyr::select(
      var_sg,
      start_fun = start,
      pre3_fun = pre3,
      pre2_fun = pre2,
      pre1_fun = pre1,
      post1_fun = post1,
      post2_fun = post2,
      post3_fun = post3,
      end_fun = end) %>%
    tidyr::gather(variable, value, -var_sg) %>%
    dplyr::mutate(variable = factor(variable,
                                    levels = c("start_fun", "pre3_fun", "pre2_fun", "pre1_fun", "post1_fun", "post2_fun", "post3_fun", "end_fun")))


  ggplot2::ggplot(data = plot_data, aes(x = variable,
                        y = value)) +
    stat_summary(fun.y = mean, geom = "point", colour = "#00BFC4") +
    stat_summary(fun.data = mean_cl_normal, geom = "errorbar", fun.args = list(mult = 1.96), width = 0.1, colour = "#00BFC4") +
    stat_summary(data = dplyr::filter(plot_data, variable %in% c("start_fun", "pre3_fun")), aes(y = value, group = 1), fun.y = mean, geom = "line", linetype = 3, colour = "#00BFC4") +
    stat_summary(data = dplyr::filter(plot_data, variable %in% c("pre3_fun", "pre2_fun", "pre1_fun", "post1_fun", "post2_fun", "post3_fun")), aes(y = value, group = 1), fun.y = mean, geom = "line", linetype = 1, colour = "#00BFC4") +
    stat_summary(data = dplyr::filter(plot_data, variable %in% c("post3_fun", "end_fun")), aes(y = value, group = 1), fun.y = mean, geom = "line",linetype = 3, colour = "#00BFC4") +
    theme_classic() +
    theme(text = element_text(size = 12)) +
    scale_x_discrete(labels = c("Start", "N-2", "N-1", "N", "N+1", "N+2", "N+3", "End")) +
    xlab("Session") + ylab(ylabel)
}




#' Plot average magnitude of sudden gain or another variable around the sudden gain
#'
#' @param data A matched \code{byperson} dataset with variable sg_crit123 (0,1) as group variable.
#' @param var_group Name of group variable.
#' @param group_labels A c() of string as labels for groups ordered consistent with numbering of group in variable.
#' @param ylabel A string as label for y-Axis.
#' @param start A string of the variable name with scores at the start of treatment.
#' @param pre3 A string of the pre3 variable name.
#' @param pre2 A string of the pre2 variable name.
#' @param pre1 A string of the pre1 variable name.
#' @param post1 A string of the post1 variable name.
#' @param post2 A string of the post2 variable name.
#' @param post3 A string of the post3 variable name.
#' @param end A string of the variable name with scores at the end of treatment.
#' @return A plot of the average gain around or changes in scores of another questionnaire around the sudden gain.
#' @export

plot_sg_group <- function(data, var_group, group_levels, group_labels, ylabel, start, pre3, pre2, pre1, post1, post2, post3, end){

  plot_sg_group <- data %>%
    dplyr::select(var_group,
                  start, pre3, pre2, pre1, post1, post2, post3, end) %>%
    tidyr::gather(variable, value, -var_group) %>%
    dplyr::mutate(variable = factor(variable, levels = c(start, pre3, pre2, pre1, post1, post2, post3, end))) %>%
    dplyr::mutate(var_group = factor(!!rlang::sym(var_group)))

  plot_sg_group$var_group <- factor(plot_sg_group$var_group, levels = group_levels, labels = group_labels)

  ggplot2::ggplot(plot_sg_group, aes(x = variable, y = value, colour = var_group, shape = var_group)) +
    stat_summary(data = plot_sg_group, fun.y = mean, geom = "point", position = position_dodge(width = 0.2)) +
    stat_summary(data = plot_sg_group, fun.data = mean_cl_normal, geom = "errorbar", width = 0.2, fun.args = list(mult = 1.96), position = position_dodge(width = 0.2)) +
    stat_summary(data = filter(plot_sg_group, variable %in% c(start, pre3)), aes(y = value, group = var_group), fun.y = mean, geom = "line",linetype = 3, position = position_dodge(width = 0.2)) +
    stat_summary(data = filter(plot_sg_group, variable %in% c(pre3, pre2, pre1, post1, post2, post3)), aes(y = value, group = var_group), fun.y = mean, geom = "line",linetype=1, position = position_dodge(width = 0.2)) +
    stat_summary(data = filter(plot_sg_group, variable %in% c(post3, end)), aes(y = value, group = var_group), fun.y = mean, geom = "line", linetype = 3, position=position_dodge(width = 0.2)) +
    theme_classic() +
    theme(text = element_text(size = 12)) +
    scale_x_discrete(labels = c("Start", "N-2", "N-1", "N", "N+1", "N+2", "N+3", "End")) +
    labs(x = "Session", y = ylabel, colour = "", shape = "")
}


