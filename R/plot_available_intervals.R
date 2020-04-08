sgdata
library(tidyverse)
library(naniar)
library(patchwork)

sgdata_miss <- sgdata %>%
    select(id, c("bdi_s1", "bdi_s2", "bdi_s3",
             "bdi_s4", "bdi_s5", "bdi_s6",
             "bdi_s7", "bdi_s8", "bdi_s9",
             "bdi_s10", "bdi_s11", "bdi_s12"))

vis_miss(sgdata_miss)

gg_miss_upset(sgdata_miss)


gg_miss_case(sgdata_miss)
gg_miss_fct(x = sgdata_miss, fct = "id")

data_missing <- miss_var_summary(sgdata_miss) %>%
    mutate(pct_miss = pct_miss / 100,
           pct_available = 1 - pct_miss,
           variable = factor(variable, levels = c("bdi_s1", "bdi_s2", "bdi_s3",
                                                  "bdi_s4", "bdi_s5", "bdi_s6",
                                                  "bdi_s7", "bdi_s8", "bdi_s9",
                                                  "bdi_s10", "bdi_s11", "bdi_s12"))) %>%
    pivot_longer(cols = c("pct_miss", "pct_available")) %>%
    mutate(name = factor(name, levels = c("pct_miss", "pct_available"), labels = c("Missing", "Available")))

p1 <- data_missing %>%
    filter(variable != "id") %>%
ggplot(aes(x = variable, y = value, fill = name)) +
               geom_bar(position = "fill",stat = "identity") +
               # or:
               # geom_bar(position = position_fill(), stat = "identity")
               scale_y_continuous(labels = scales::percent_format()) +
    # scale_fill_manual(values = c("red", "yellow"))
    scale_fill_viridis_d(name = "", direction = -1) +
    # papaja::theme_apa() +
    labs(title = "Percentage of available data per time point") +
    theme(legend.position = "top")

p1

count_intervals_data <- suddengains::count_intervals(data = sgdata, id_var_name = "id", sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3",
                                                                                "bdi_s4", "bdi_s5", "bdi_s6",
                                                                                "bdi_s7", "bdi_s8", "bdi_s9",
                                                                                "bdi_s10", "bdi_s11", "bdi_s12"))
plot_count_intervals_data <- tibble(total = count_intervals_data[[1]],
       total_not_available_sg = count_intervals_data[[1]] - count_intervals_data[[2]],
       total_between_sess_sg = count_intervals_data[[2]],
       available_between_sess_sg = count_intervals_data[[3]],
       not_available_between_sess_sg = count_intervals_data[[4]]) %>%
    select(total_not_available_sg, available_between_sess_sg, not_available_between_sess_sg) %>%
    pivot_longer(cols = 1:3) %>%
    mutate(pct = value / count_intervals_data[[1]],
           id = "count_intervals")

p2 <- plot_count_intervals_data %>%
    ggplot(aes(x = id, y = value, fill = factor(name, labels = c("Available", "Not available 1", "Not available 2")))) +
    geom_bar(position = "fill", stat = "identity") +
    # or:
    # geom_bar(position = position_fill(), stat = "identity")
    # scale_y_continuous(labels = scales::percent_format()) +
    scale_fill_viridis_d(name = "", direction = 1) +
    coord_polar(theta = "y") +
    labs(title = "Percentage of available between session intervals") +
    theme(legend.position = "top") +
    theme_minimal() + labs(x="", y="")




