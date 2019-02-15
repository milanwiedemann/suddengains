#' Plot average magnitude of sudden gain or another variable around the sudden gain
#'
#' @description Generates a plot of the mean values around the sudden gain.
#' This can be used to plot the primary outcome or secondary measures.
#' The parameters starting with "group" allow to plot the average gain magnitude by group.
#'
#' @param data A \code{bysg} or \code{byperson} dataset.
#' @param tx_start_var_name String, specifying the variable name of the first measurement point of the intervention.
#' @param tx_end_var_name String, specifying the variable name of the last measurement point of the intervention.
#' @param sg_pre_post_var_list Vector, specifying the variable names of the 3 measurement points before,
#' and the 3 after the sudden gain, for the measure being plotted.
#' @param group_var_name String, specifying the variable name of the group variable.
#' @param colour String, specifying the colour(s) of the plot. Default is ...
#' @param group_levels Vector, specifying the levels as numeric for the groups in \code{group_var_name}.
#' @param group_labels Vector, specifying the label names as strings for the groups in \code{group_var_name}.
#' @param ylab String, specifying the label for the y axis i.e. the name of the measure being plotted.
#' @param xlab String, specifying the label for the x axis, e.g. \code{"Session"}.
#' @return A plot of the mean values around the sudden gain, for the measure specified.
#' @export

plot_sg <- function(data, tx_start_var_name, tx_end_var_name, sg_pre_post_var_list, ylab, xlab, colour = NULL, group_var_name = NULL, group_levels = NULL, group_labels = NULL) {

        # Save variable names to individual objects
        pre3 <- sg_pre_post_var_list[1]
        pre2 <- sg_pre_post_var_list[2]
        pre1 <- sg_pre_post_var_list[3]
        post1 <- sg_pre_post_var_list[4]
        post2 <- sg_pre_post_var_list[5]
        post3 <- sg_pre_post_var_list[6]

        # Check if group vars are specified
        if (is.null(group_var_name) && is.null(group_levels) && is.null(group_labels)) {

            group <- 0

            group_var_name <- 1

            # Prepare data for plotting without group
            plot_data <- data %>%
                dplyr::select(start_fun = tx_start_var_name,
                              pre3_fun = pre3,
                              pre2_fun = pre2,
                              pre1_fun = pre1,
                              post1_fun = post1,
                              post2_fun = post2,
                              post3_fun = post3,
                              end_fun = tx_end_var_name) %>%
                tidyr::gather(variable, value) %>%
                dplyr::mutate(variable = factor(variable,
                                                levels = c("start_fun", "pre3_fun", "pre2_fun", "pre1_fun",
                                                           "post1_fun", "post2_fun", "post3_fun", "end_fun")))

            sg_plot_start <- ggplot2::ggplot(data = plot_data,
                                             aes(x = variable,
                                                 y = value))

        } else if (!is.null(group_var_name) && !is.null(group_levels) && !is.null(group_labels)) {

            group <- 1

            # Prepare data for plotting groups
            plot_data <- data %>%
                dplyr::select(start_fun = tx_start_var_name,
                              pre3_fun = pre3,
                              pre2_fun = pre2,
                              pre1_fun = pre1,
                              post1_fun = post1,
                              post2_fun = post2,
                              post3_fun = post3,
                              end_fun = tx_end_var_name,
                              group_var_name) %>%
                tidyr::gather(variable, value, -group_var_name) %>%
                dplyr::mutate(variable = factor(variable,
                                                levels = c("start_fun", "pre3_fun", "pre2_fun", "pre1_fun",
                                                           "post1_fun", "post2_fun", "post3_fun", "end_fun"))) %>%
                dplyr::mutate(group_var_name = factor(!!rlang::sym(group_var_name)))


            # Add levels and labels to group factor
            plot_data$group_var_name <- factor(plot_data$group_var_name,
                                               levels = group_levels,
                                               labels = group_labels)

            sg_plot_start <- ggplot2::ggplot(data = plot_data,
                                             aes(x = variable,
                                                 y = value,
                                                 colour = group_var_name,
                                                 shape = group_var_name))
        }

        # Create plot ----

        sg_plot_start +

        # Add means
        ggplot2::stat_summary(fun.y = mean,
                              geom = "point",
                              colour = colour,
                              position = position_dodge(width = 0.2)) +

        # Add 95pct CIs
        ggplot2::stat_summary(fun.data = mean_cl_normal,
                              geom = "errorbar",
                              fun.args = list(mult = 1.96),
                              width = 0.1,
                              colour = colour,
                              position = position_dodge(width = 0.2)) +

        # Add dotted line from start value to pre-pre-pre gain value
        ggplot2::stat_summary(data = dplyr::filter(plot_data, variable %in% c("start_fun", "pre3_fun")),
                              aes(y = value, group = group_var_name),
                              fun.y = mean,
                              geom = "line",
                              linetype = 3,
                              colour = colour,
                              position = position_dodge(width = 0.2)) +

        ggplot2::stat_summary(data = dplyr::filter(plot_data, variable %in% c("pre3_fun", "pre2_fun", "pre1_fun",
                                                                              "post1_fun", "post2_fun", "post3_fun")),
                              aes(y = value, group = group_var_name),
                              fun.y = mean,
                              geom = "line",
                              linetype = 1,
                              colour = colour,
                              position = position_dodge(width = 0.2)) +

        # Add dotted line from post-post-post gain value to end value
        ggplot2::stat_summary(data = dplyr::filter(plot_data, variable %in% c("post3_fun", "end_fun")),
                              aes(y = value, group = group_var_name),
                              fun.y = mean,
                              geom = "line",
                              linetype = 3,
                              colour = colour,
                              position = position_dodge(width = 0.2)) +

        # Add scale for x axis
        ggplot2::scale_x_discrete(labels = c("Start", "N-2", "N-1", "N",
                                             "N+1", "N+2", "N+3", "End")) +

        # Add x and y axis labels
        ggplot2::labs(x = xlab,
                      y = ylab,
                      colour = "",
                      shape = ""
                      ) +

        # Make plot look APAish
        ggplot2::theme_classic() +
        ggplot2::theme(text = element_text(size = 12))
    }
