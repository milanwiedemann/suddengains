#' Plot average change in variables around the sudden gain
#'
#' @description Generates a plot of the mean values around the sudden gain using \code{\link[ggplot2]{ggplot}}.
#' This can be used to plot the primary outcome or secondary measures.
#' The parameters starting with "group" allow to plot the average gain magnitude by group.
#' Further ggplot2 components can be added using + following this function.
#' @param data A \code{bysg} or \code{byperson} dataset created using the function \code{\link{create_bysg}} or \code{\link{create_byperson}}.
#' @param id_var_name String, specifying the name of the ID variable.
#' @param tx_start_var_name String, specifying the variable name of the first measurement point of the intervention.
#' @param tx_end_var_name String, specifying the variable name of the last measurement point of the intervention.
#' @param sg_pre_post_var_list Vector, specifying the variable names of the 3 measurement points before,
#' and the 3 after the sudden gain, for the measure being plotted.
#' @param colour_single String, specifying the colour of the plot for one group.
#' @param colour_group String, specifying the discrete colour palette to be used for the groups.
#' @param viridis_option String specifying the colour option for discrete viridis palette, see \code{\link[ggplot2]{scale_fill_viridis_d}}.
#' @param viridis_begin Numeric, specifying hue between 0 and 1 at which the viridis colormap begins, see \code{\link[ggplot2]{scale_fill_viridis_d}}.
#' @param viridis_end Numeric, specifying hue between 0 and 1 at which the viridis colormap ends, see \code{\link[ggplot2]{scale_fill_viridis_d}}.
#' @param group_var_name String, specifying the variable name of the group variable.
#' @param group_levels Vector, specifying the levels as numeric for the groups in \code{group_var_name}.
#' @param group_labels Vector, specifying the label names as strings for the groups in \code{group_var_name}.
#' @param group_title String, specifying the title that will be used for the groups specified in \code{group_labels}.
#' @param ylab String, specifying the label for the y axis i.e. the name of the measure being plotted.
#' @param xlab String, specifying the label for the x axis, e.g. \code{"Session"}.
#' @param apaish Logical, make plot APA publishable.
#' @return A plot of the mean values around the sudden gain, for the measure specified.
#' @export
#' @examples # First create a bysg (or byperson) dataset
#' bysg <- create_bysg(data = sgdata,
#'                     sg_crit1_cutoff = 7,
#'                     id_var_name = "id",
#'                     tx_start_var_name = "bdi_s1",
#'                     tx_end_var_name = "bdi_s12",
#'                     sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3",
#'                                     "bdi_s4", "bdi_s5", "bdi_s6",
#'                                     "bdi_s7", "bdi_s8", "bdi_s9",
#'                                     "bdi_s10", "bdi_s11", "bdi_s12"),
#'                     sg_measure_name = "bdi")
#'
#' # Plot average change of BDI values around the period of the sudden gain
#' plot_sg(data = bysg,
#'         id_var_name = "id",
#'         tx_start_var_name = "bdi_s1",
#'         tx_end_var_name = "bdi_s12",
#'         sg_pre_post_var_list = c("sg_bdi_2n", "sg_bdi_1n", "sg_bdi_n",
#'                                  "sg_bdi_n1", "sg_bdi_n2", "sg_bdi_n3"),
#'         ylab = "BDI", xlab = "Session")

plot_sg <- function(data, id_var_name, tx_start_var_name, tx_end_var_name, sg_pre_post_var_list,
                    ylab, xlab = "Session",
                    colour_single = "#239b89ff",
                    colour_group = c("viridis", "ggplot", "grey"),
                    viridis_option = c("D", "A", "B", "C"), viridis_begin = 0, viridis_end = 1,
                    group_var_name = NULL, group_levels = NULL, group_labels = NULL, group_title = NULL,
                    apaish = TRUE) {

    # Check arguments
    colour_group <- base::match.arg(colour_group)
    viridis_option <- base::match.arg(viridis_option)

    # Create individual objects for pre post variable names
    pre3 <- sg_pre_post_var_list[1]
    pre2 <- sg_pre_post_var_list[2]
    pre1 <- sg_pre_post_var_list[3]
    post1 <- sg_pre_post_var_list[4]
    post2 <- sg_pre_post_var_list[5]
    post3 <- sg_pre_post_var_list[6]

    # Check group variables ----
    # If not specified create data for single sg plot
    if (base::is.null(group_var_name) && base::is.null(group_levels) && base::is.null(group_labels)) {

        # Create data for single sg plot ----

        # Set values for group variables
        group_var_name <- 1

        # Create start-end data frame
        # Only use unique values for start and end, otherwise these will be included multiple times in case of multiple gains if data is bysg
        plot_data_start_end <- data %>%
            dplyr::select(id_var_name, id_sg, sg_crit123, start_fun = tx_start_var_name, end_fun = tx_end_var_name) %>%
            dplyr::filter(sg_crit123 == 1) %>%
            dplyr::distinct(!! rlang::sym(id_var_name), .keep_all = TRUE) %>%
            dplyr::select(-sg_crit123)

        # Create pre-post data frame
        # Use all available data here, all multiple gains are included here if data is bysg
        plot_data_pre_post <- data %>%
            dplyr::select(id_var_name, id_sg,
                          pre3_fun = pre3, pre2_fun = pre2, pre1_fun = pre1,
                          post1_fun = post1, post2_fun = post2, post3_fun = post3)

        # Join start-end and pre-post data frames
        plot_data_start_end_pre_post <- dplyr::left_join(plot_data_pre_post, plot_data_start_end, by = c("id_sg", id_var_name))

        # Create long data for plotting
        # Order pre-post variable factor for plot
        plot_data <- plot_data_start_end_pre_post %>%
            dplyr::select(start_fun,
                          pre3_fun, pre2_fun, pre1_fun,
                          post1_fun, post2_fun, post3_fun,
                          end_fun) %>%
            tidyr::gather(variable, value) %>%
            dplyr::mutate(variable = base::factor(variable, levels = c("start_fun", "pre3_fun", "pre2_fun", "pre1_fun",
                                                                       "post1_fun", "post2_fun", "post3_fun", "end_fun")))

        # Create plot
        sg_plot_start <- ggplot2::ggplot(data = plot_data,
                                         ggplot2::aes(x = variable,
                                                      y = value))

        plot_temp <- sg_plot_start +
            # Add means
            ggplot2::stat_summary(fun.y = mean,
                                  geom = "point",
                                  colour = colour_single,
                                  position = ggplot2::position_dodge(width = 0.2)) +

            # Add 95pct CIs
            ggplot2::stat_summary(fun.data = ggplot2::mean_cl_normal,
                                  geom = "errorbar",
                                  fun.args = base::list(mult = 1.96),
                                  width = 0.1,
                                  colour = colour_single,
                                  position = ggplot2::position_dodge(width = 0.2)) +

            # Add dotted line from start value to pre-pre-pre gain value
            ggplot2::stat_summary(data = dplyr::filter(plot_data, variable %in% base::c("start_fun", "pre3_fun")),
                                  ggplot2::aes(y = value, group = 1),
                                  fun.y = mean,
                                  geom = "line",
                                  linetype = 3,
                                  colour = colour_single,
                                  position = ggplot2::position_dodge(width = 0.2)) +

            ggplot2::stat_summary(data = dplyr::filter(plot_data, variable %in% base::c("pre3_fun", "pre2_fun", "pre1_fun",
                                                                                        "post1_fun", "post2_fun", "post3_fun")),
                                  ggplot2::aes(y = value, group = 1),
                                  fun.y = mean,
                                  geom = "line",
                                  linetype = 1,
                                  colour = colour_single,
                                  position = ggplot2::position_dodge(width = 0.2)) +

            # Add dotted line from post-post-post gain value to end value
            ggplot2::stat_summary(data = dplyr::filter(plot_data, variable %in% base::c("post3_fun", "end_fun")),
                                  ggplot2::aes(y = value, group = 1),
                                  fun.y = mean,
                                  geom = "line",
                                  linetype = 3,
                                  colour = colour_single,
                                  position = ggplot2::position_dodge(width = 0.2)) +

            # Add scale for x axis
            ggplot2::scale_x_discrete(labels = base::c("Start", "N-2", "N-1", "N",
                                                       "N+1", "N+2", "N+3", "End")) +

            # Add x and y axis labels
            ggplot2::labs(x = xlab,
                          y = ylab,
                          colour = NULL,
                          shape = group_title)

        if (apaish == TRUE) {
            # Make plot look apaish
            plot_out <- plot_temp +
                ggplot2::theme_classic() +
                ggplot2::theme(text = ggplot2::element_text(size = 12))

        } else {
            # Return plot with ggplot2 default background
            plot_out <-  plot_temp
        }

        plot_out

    } else if (!base::is.null(group_var_name) && !base::is.null(group_levels) && !base::is.null(group_labels)) {

        # Create data for group plot ----
        # Create start-end tx data
        # Only use unique values for start and end, otherwise these will be included multiple times in case of multiple gains if data is bysg
        plot_data_start_end <- data %>%
            dplyr::select(id_var_name, id_sg, sg_crit123, start_fun = tx_start_var_name, end_fun = tx_end_var_name) %>%
            dplyr::filter(sg_crit123 == 1) %>%
            dplyr::distinct(!! rlang::sym(id_var_name), .keep_all = TRUE) %>%
            dplyr::select(-sg_crit123)

        # Create pre-post data frame
        # Use all available data here, all multiple gains are included here if data is bysg
        plot_data_pre_post <- data %>%
            dplyr::select(id_var_name, id_sg,
                          pre3_fun = pre3, pre2_fun = pre2, pre1_fun = pre1,
                          post1_fun = post1, post2_fun = post2, post3_fun = post3)

        # Join start-end and pre-post data frames
        plot_data_start_end_pre_post <- dplyr::left_join(plot_data_pre_post, plot_data_start_end, by = c("id_sg", id_var_name))

        # Create dataframe with goup and id variables
        id_group <- dplyr::select(data, "id_sg", id_var_name, group_var_name)

        # Join data and group data frames
        plot_data_start_end_pre_post_group <- dplyr::left_join(plot_data_start_end_pre_post, id_group, by = c("id_sg", id_var_name))

        # Wide to long format and order factors for plot
        plot_data <- plot_data_start_end_pre_post_group %>%
            dplyr::select(start_fun,
                          pre3_fun, pre2_fun, pre1_fun,
                          post1_fun, post2_fun, post3_fun,
                          end_fun,
                          group_var_name) %>%
            tidyr::gather(variable, value, -group_var_name) %>%
            dplyr::mutate(variable = base::factor(variable, levels = c("start_fun", "pre3_fun", "pre2_fun", "pre1_fun",
                                                                       "post1_fun", "post2_fun", "post3_fun", "end_fun"))) %>%
            dplyr::mutate(!! group_var_name := base::factor(!! rlang::sym(group_var_name),
                                                            levels = group_levels,
                                                            labels = group_labels))

        # Create plot
        sg_plot_start <- ggplot2::ggplot(data = plot_data,
                                         ggplot2::aes(x = variable,
                                                      y = value,
                                                      colour = !! rlang::sym(group_var_name),
                                                      shape = !! rlang::sym(group_var_name)))
        # Create plot
        plot_temp <- sg_plot_start +
            # Add means
            ggplot2::stat_summary(fun.y = mean,
                                  geom = "point",
                                  position = ggplot2::position_dodge(width = 0.2)) +

            # Add 95pct CIs
            ggplot2::stat_summary(fun.data = ggplot2::mean_cl_normal,
                                  geom = "errorbar",
                                  fun.args = base::list(mult = 1.96),
                                  width = 0.1,
                                  position = ggplot2::position_dodge(width = 0.2)) +

            # Add dotted line from start value to pre-pre-pre gain value
            ggplot2::stat_summary(data = dplyr::filter(plot_data, variable %in% base::c("start_fun", "pre3_fun")),
                                  ggplot2::aes(y = value, group = !! rlang::sym(group_var_name)),
                                  fun.y = mean,
                                  geom = "line",
                                  linetype = 3,
                                  position = ggplot2::position_dodge(width = 0.2)) +

            ggplot2::stat_summary(data = dplyr::filter(plot_data, variable %in% base::c("pre3_fun", "pre2_fun", "pre1_fun",
                                                                                        "post1_fun", "post2_fun", "post3_fun")),
                                  ggplot2::aes(y = value, group = !! rlang::sym(group_var_name)),
                                  fun.y = mean,
                                  geom = "line",
                                  linetype = 1,
                                  position = ggplot2::position_dodge(width = 0.2)) +

            # Add dotted line from post-post-post gain value to end value
            ggplot2::stat_summary(data = dplyr::filter(plot_data, variable %in% base::c("post3_fun", "end_fun")),
                                  ggplot2::aes(y = value, group = !! rlang::sym(group_var_name)),
                                  fun.y = mean,
                                  geom = "line",
                                  linetype = 3,
                                  position = ggplot2::position_dodge(width = 0.2)) +

            # Add scale for x axis
            ggplot2::scale_x_discrete(labels = base::c("Start", "N-2", "N-1", "N",
                                                       "N+1", "N+2", "N+3", "End")) +

            # Add x and y axis labels
            ggplot2::labs(x = xlab,
                          y = ylab,
                          colour = group_title) +

            ggplot2::scale_shape_discrete(name = group_title)

        if (apaish == TRUE) {
            # Make plot look apaish
            plot_temp <- plot_temp +
                ggplot2::theme_classic() +
                ggplot2::theme(text = ggplot2::element_text(size = 12))

        } else {
            # Return plot with ggplot2 default background
            plot_temp <- plot_temp
        }

        # Now sort out group colours
        if (colour_group == "viridis") {
            plot_out <- plot_temp +
                ggplot2::scale_color_viridis_d(begin = viridis_begin, end = viridis_end, option = viridis_option)
        } else if (colour_group == "ggplot") {
            plot_out <- plot_temp +
                ggplot2::scale_color_discrete()
        } else if (colour_group == "grey") {
            plot_out <- plot_temp +
                ggplot2::scale_color_grey()
        }

        # Return final plot
        plot_out
    }
}
