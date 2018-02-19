#' Plot average magnitude of sudden gain or another variable around the sudden gain
#'
#' @param data A matched \code{byperson} dataset with variable sg_crit123 (0,1) as group variable.
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

plot_sg_group <- function(data,ylabel, pre, post, start, pre3, pre2, pre1, post1, post2, post3, end){
  plot_sg_m_matched <- data %>%
    select(sg_crit123,
           start, starts_with(pre), starts_with(post), end) %>%
    mutate(sg_crit123 = factor(sg_crit123, levels = c(0,1), labels = c("Matched", "SG"))) %>%
    melt(id = c("sg_crit123"), na.rm = TRUE)

  ggplot(plot_sg_m_matched, aes(x=variable, y=value, colour = sg_crit123, shape = sg_crit123)) +
    stat_summary(data=plot_sg_m_matched, fun.y = mean, geom = "point", position = position_dodge(width = 0.2)) +
    stat_summary(data=plot_sg_m_matched, fun.data = mean_cl_normal, geom = "errorbar", width = 0.2, fun.args = list(mult = 1.96), position=position_dodge(width = 0.2)) +
    stat_summary(data=filter(plot_sg_m_matched, variable %in% c(start, pre3)), aes(y = value, group = sg_crit123), fun.y = mean, geom = "line",linetype=3, position=position_dodge(width = 0.2)) +
    stat_summary(data=filter(plot_sg_m_matched, variable %in% c(pre3, pre2, pre1, post1, post2, post3)), aes(y = value, group = sg_crit123), fun.y = mean, geom = "line",linetype=1, position=position_dodge(width = 0.2)) +
    stat_summary(data=filter(plot_sg_m_matched, variable %in% c(post3, end)), aes(y = value, group = sg_crit123), fun.y = mean, geom = "line",linetype=3, position=position_dodge(width = 0.2)) +
    theme_classic() +
    theme(text = element_text(size=14)) +
    scale_x_discrete(labels = c("Start", "n-2", "n-1", "n", "n+1", "n+2", "n+3", "End")) +
    labs(x = "Session", y = ylabel, colour = "", shape = "")
  }
