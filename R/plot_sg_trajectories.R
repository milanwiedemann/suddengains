#' Plot individual trajectories
#' @description Plot individual trajectories of selected cases. This function can be combined with a filter command to explore specific trajectories.
#' @param data Dataset in wide format.
#' @param id_var String, specifying id variable.
#' @param var_list Vector, specifying variable names to be plotted in sequential order.
#' @param select_id_list asd
#' @param select_n Numberic, number of randomly selected cases to be plotted.
#' @param show_id Logical, specifying whether or not to show ID variables inside the plot near the first measurement point.
#' @param id_label_size Numeric, if 'show_id' = TRUE specifying the size of the label inside the plot.
#' @param show_legend Logical, specifying whether or not a legend of all ids outside of the plot.
#' @param legend_title String, specifying the title of legend,b y default the variable name of 'id_var' will be shown.
#' @param connect_missing Logical, speciying whether to connect points by \code{id_var} across missing values.
#' @param colour String, specifying the discrete colour palette to be used.
#' @param viridis_option String specifying the colour option for discrete viridis palette, see ggplot2::scale_fill_viridis_d().
#' @param viridis_begin Numeric, specifying hue between 0 and 1 at which the viridis colormap begins, see ggplot2::scale_fill_viridis_d().
#' @param viridis_end Numeric, specifying hue between 0 and 1 at which the viridis colormap ends, see ggplot2::scale_fill_viridis_d().
#' @param line_alpha Numeric, specifying alpha of lines.
#' @param point_alpha Numeric, specifying alpha of points.
#' @param xlab String for x axis label.
#' @param ylab String for y axis label.
#' @param scale_x_num Logical, if \code{TRUE} print sequential numbers starting from 1 as x axis labels, if \code{FALSE} use variable names.
#' @param scale_x_num_start Numeric, if \code{scale_x_num == TRUE} this is the starting value of the x axis.
#' @param apaish Logical, make plot APA publishable.
#' @param ... Arguments to be passed on to ggrepel::geom_label_repel()
#' @return ggplot2 object
#' @examples # Plot individual trajectories of IDs 2, 4, 5, and 9
#' plot_sg_trajectories(data = sgdata,
#'                      id_var = "id",
#'                      select_id_list = c("2", "4", "5", "9"),
#'                      var_list = c("bdi_s1", "bdi_s2", "bdi_s3", "bdi_s4",
#'                                   "bdi_s5", "bdi_s6", "bdi_s7", "bdi_s8",
#'                                   "bdi_s9", "bdi_s10", "bdi_s11", "bdi_s12"),
#'                      show_id = TRUE,
#'                      id_label_size = 4,
#'                      label.padding = .2,
#'                      show_legend = FALSE,
#'                      colour = "viridis",
#'                      viridis_option = "D",
#'                      viridis_begin = 0,
#'                      viridis_end = .8,
#'                      connect_missing = FALSE,
#'                      scale_x_num = TRUE,
#'                      scale_x_num_start = 1,
#'                      apaish = TRUE,
#'                      xlab = "Session",
#'                      ylab = "BDI")
#' @export

plot_sg_trajectories <- function(data, id_var, var_list, select_id_list = NULL, select_n = NULL, show_id = TRUE, show_legend = TRUE, legend_title = "ID", id_label_size = 2, connect_missing = TRUE, colour = c("viridis", "ggplot", "grey"), viridis_option = "B", viridis_begin = 0.2, viridis_end = 0.8, line_alpha = 1, point_alpha = 1, xlab = "X", ylab = "Y", scale_x_num = FALSE, scale_x_num_start = 1, apaish = TRUE, ...) {

    # Check arguments
    colour <- base::match.arg(colour)

    # Create list with all ids
    id_list <- data %>% dplyr::select(id_var) %>% base::unlist()

    # Set select_n
    if (base::is.null(select_n) == TRUE) {
        select_n <- base::length(id_list)
    }

    # Select random number of ids if select_id_list not specifyied
    if (base::is.null(select_id_list) == TRUE) {
        if (select_n > base::length(id_list)) {
            base::warning(paste0("'select_n' = ", select_n, " is greater than to total number if cases in 'data' = ", base::length(id_list), ".\n'select_n' was set to = ", base::length(id_list), "."), call. = FALSE)
            select_n <- base::length(id_list)
        }
        select_id_list <- base::sample(id_list, select_n, replace = FALSE)
    }

    # Select data
    data_select <- dplyr::filter(data, !! rlang::sym(id_var) %in% select_id_list)

    # Create data for plot
    data_plot <- data_select %>%
        dplyr::select(id_var, var_list) %>%
        tidyr::gather(variable, value, -id_var) %>%
        dplyr::mutate(variable = factor(variable, var_list),
                      !! id_var := as.factor(!! rlang::sym(id_var)))

    # Start plot
    plot <- data_plot %>%
        ggplot2::ggplot(ggplot2::aes(variable, value, label = !! rlang::sym(id_var), colour = !! rlang::sym(id_var))) +
        ggplot2::labs(x = xlab, y = ylab) +
        ggplot2::geom_point(alpha = point_alpha, size = 1.5)

    # Connect missing values or not
    if (connect_missing == TRUE) {
        plot <- plot + ggplot2::geom_line(data = data_plot[!is.na(data_plot$value), ], ggplot2::aes(group = !!rlang::sym(id_var)), alpha = line_alpha)
    } else if (connect_missing == FALSE) {
        plot <- plot + ggplot2::geom_line(data = data_plot, ggplot2::aes(group = !!rlang::sym(id_var)), alpha = line_alpha)
    }

    # Scale x axis
    if (scale_x_num == FALSE) {
        plot <- plot + ggplot2::scale_x_discrete(labels = var_list)
    } else if (scale_x_num == TRUE) {
        plot <- plot + ggplot2::scale_x_discrete(labels = scale_x_num_start:(length(var_list) + scale_x_num_start - 1))
    }

    # Show id labels in plot
    if (show_id == TRUE) {
        plot <- plot + ggrepel::geom_label_repel(ggplot2::aes(label = ifelse(variable == var_list[1], as.character(!!rlang::sym(id_var)), "")), show.legend = FALSE, segment.color = NA, size = id_label_size, ...)
    }

    # Make plot look apaish
    if (apaish == TRUE) {
        plot <- plot + ggplot2::theme_classic() +
                       ggplot2::theme(text = ggplot2::element_text(size = 12))
    }

    # Show legend, this needs to come after apaish so labs() works as intended
    if (show_legend == TRUE) {
        plot <- plot + ggplot2::labs(colour = legend_title)
    } else if (show_legend == FALSE) {
        plot <- plot + ggplot2::theme(legend.position = "none")
    }

    # Now sort out colours
    if (colour == "viridis") {
        plot_out <- plot + ggplot2::scale_colour_viridis_d(begin = viridis_begin, end = viridis_end, option = viridis_option)
    } else if (colour == "ggplot") {
        plot_out <- plot + ggplot2::scale_color_discrete()
    } else if (colour == "grey") {
        plot_out <- plot + ggplot2::scale_color_grey()
    }

    # Return final plot
    plot_out
}
