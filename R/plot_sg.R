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

plot_sg <- function(data, ylabel, start, pre3, pre2, pre1, post1, post2, post3, end){

plot_data <- data %>%
  filter(sg_crit123 == 1) %>%
    select(
      id,
      start_fun = start,
      pre3_fun = pre3,
      pre2_fun = pre2,
      pre1_fun = pre1,
      post1_fun = post1,
      post2_fun = post2,
      post3_fun = post3,
      end_fun = end) %>%
    melt(id = c("id"), na.rm = FALSE)

ggplot(data = plot_data, aes(x = variable,
                        y = value)) +
    stat_summary(fun.y = mean, geom = "point", colour = "#00BFC4") +
    stat_summary(fun.data = mean_cl_normal, geom = "errorbar", fun.args = list(mult = 1.96), width = 0.1, colour = "#00BFC4") +
    stat_summary(data=filter(plot_data, variable %in% c("start_fun", "pre3_fun")), aes(y = value, group = 1), fun.y = mean, geom = "line", linetype = 3, colour = "#00BFC4") +
    stat_summary(data=filter(plot_data, variable %in% c("pre3_fun", "pre2_fun", "pre1_fun", "post1_fun", "post2_fun", "post3_fun")), aes(y = value, group = 1), fun.y = mean, geom = "line",linetype = 1, colour = "#00BFC4") +
    stat_summary(data=filter(plot_data, variable %in% c("post3_fun", "end_fun")), aes(y = value, group = 1), fun.y = mean, geom = "line",linetype = 3, colour = "#00BFC4") +
    theme_classic() +
    theme(text = element_text(size=14)) +
    scale_x_discrete(labels = c("Start", "n-2", "n-1", "n", "n+1", "n+2", "n+3", "End")) +
    xlab("Session") + ylab(ylabel)
}






