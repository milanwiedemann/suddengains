#' Plot summary of available data per time point and analysed session to session intervals
#'
#' @param data A data set in wide format including an ID variable and variables for each measurement point.
#' @param id_var_name String, specifying the name of the ID variable. Each row should have a unique value.
#' @param sg_var_list Vector, specifying the variable names of each measurement point sequentially.
#' @param identify_sg_1to2 Logical, indicating whether to identify sudden losses from measurement point 1 to 2.
#' If set to TRUE, this implies that the first variable specified in \code{sg_var_list} represents a baseline measurement point, e.g. pre-intervention assessment.
#' @return Plot showing percentage of available data per time point and percentage of session to session intervals that wer analysed for sudden gains.
#' @export
#' @import patchwork
#' @examples # Create plot
#' plot_sg_intervals(data = sgdata,
#'                   id_var_name = "id",
#'                   sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3",
#'                                   "bdi_s4", "bdi_s5", "bdi_s6",
#'                                   "bdi_s7", "bdi_s8", "bdi_s9",
#'                                   "bdi_s10", "bdi_s11", "bdi_s12"))
#'
plot_sg_intervals <- function(data, id_var_name, sg_var_list, identify_sg_1to2 = FALSE) {

    # Select data
    sgdata_miss <- data %>%
        dplyr::select(id_var_name, sg_var_list)

    # Calculate data for first plot
    data_missing <- naniar::miss_var_summary(sgdata_miss) %>%
        dplyr::mutate(pct_miss = pct_miss / 100,
               pct_available = 1 - pct_miss,
               variable = forcats::fct_rev(factor(variable, levels = sg_var_list))) %>%
        tidyr::pivot_longer(cols = c("pct_miss", "pct_available")) %>%
        dplyr::mutate(name = factor(name, levels = c("pct_miss", "pct_available"), labels = c("Missing Data", "Available Data")))

    # Create first plot
    plot_sg_miss_pct <- data_missing %>%
        dplyr::filter(variable != "id") %>%
        ggplot2::ggplot(ggplot2::aes(x = variable, y = value, fill = name)) +
        ggplot2::geom_bar(position = "fill",stat = "identity") +
        # or:
        # geom_bar(position = position_fill(), stat = "identity")
        ggplot2::scale_y_continuous(labels = scales::percent_format()) +
        # scale_fill_manual(values = c("red", "yellow"))
        ggplot2::scale_fill_viridis_d(name = "", direction = -1, alpha = .8) +
        # papaja::theme_apa() +
        ggplot2::labs(title = "Percentage of available data per time point", x = "", y = "") +
        ggplot2::theme(legend.position = "right")+
        ggplot2::theme(legend.key = ggplot2::element_rect(color = NA, fill = NA),
              legend.key.size = ggplot2::unit(0.9, "cm")) +
        ggplot2::theme(legend.title.align = 1.5) +
        ggplot2::coord_flip()


    # Now create date for second plot
    count_intervals_data <- suddengains::count_intervals(data = data,
                                                         id_var_name = id_var_name,
                                                         sg_var_list = sg_var_list)

    plot_count_intervals_data_temp <- tibble::tibble(total = count_intervals_data[[1]],
                                             total_not_available_sg = count_intervals_data[[1]] - count_intervals_data[[2]],
                                             total_between_sess_sg = count_intervals_data[[2]],
                                             available_between_sess_sg = count_intervals_data[[3]],
                                             not_available_between_sess_sg = count_intervals_data[[4]]) %>%
        dplyr::select(total_not_available_sg, available_between_sess_sg, not_available_between_sess_sg) %>%
        tidyr::pivot_longer(cols = 1:3) %>%
        dplyr::mutate(pct = value / count_intervals_data[[1]])


    # More data stuff here get things ready for labels legend etc, adding numbers
    plot_count_intervals_data <- plot_count_intervals_data_temp %>%
        dplyr::mutate(id = "count_intervals",
               name = factor(name,
                             levels = c("not_available_between_sess_sg", "total_not_available_sg", "available_between_sess_sg"),
                             labels = c(paste0("Not Analysed Type 1\n(n = ", plot_count_intervals_data_temp$value[3],", ", round(plot_count_intervals_data_temp$pct[3] * 100, 0), "%)"),
                                        paste0("Not Analysed Type 2\n(n = ", plot_count_intervals_data_temp$value[1] ,", ", round(plot_count_intervals_data_temp$pct[1] * 100, 0), "%)"),
                                        paste0("Analysed\n(n = ", plot_count_intervals_data_temp$value[2] ,", ", round(plot_count_intervals_data_temp$pct[2] * 100, 0), "%)"))))

    # Create second plot
    plot_sg_intervals <- plot_count_intervals_data %>%
        ggplot2::ggplot(ggplot2::aes(x = id, y = value, fill = name)) +
        ggplot2::geom_bar(position = "fill", stat = "identity") +
        ggplot2::scale_fill_viridis_d(name = "", direction = -1, alpha = .8) +
        ggplot2::labs(title = "Percentage of session to session intervals analysed",
                      subtitle = paste0("Total number of intervals, n = ", sum(plot_count_intervals_data_temp$value) ,")")) +
        ggplot2::theme(legend.position = "right") +
        ggplot2::labs(x = "", y = "", caption = "Not Analysed Type 1: The total number of session to session intervals that can not be analysed for sudden gains due to the pattern of missing data.\n\nNot Analysed Type 2: The total number of session to session intervals from the first to the second and the second last to the last session.") +
        ggplot2::theme(legend.key = ggplot2::element_rect(color = NA, fill = NA),
              legend.key.size = ggplot2::unit(0.9, "cm")) +
        ggplot2::theme(legend.title.align = 1.5) +
        ggplot2::scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
        ggplot2::theme(axis.text.y = ggplot2::element_blank(),
              axis.ticks.y = ggplot2::element_blank(),
              plot.caption = ggplot2::element_text(hjust = 0)) +
        ggplot2::coord_flip()


    # Combine Plots

    plot_return <-  patchwork::wrap_plots(plot_sg_miss_pct, plot_sg_intervals) +
        patchwork::plot_layout(heights = c(4, 1)) + patchwork::plot_annotation(tag_levels = 'A')

    # Return plot
    return(plot_return)

}

