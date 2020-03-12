#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# Load packages ----
# library(shiny)
# library(tidyverse)
# library(patchwork)
# library(suddengains)
# devtools::install_github("milanwiedemann/suddengains")
# library(ggplot2)
# library(dplyr)
# library(tidyr)
# library(readr)
# library(DT)
# library(naniar)
options(htmlwidgets.TOJSON_ARGS = list(na = 'string'))
# devtools::install_github("hadley/emo")
# library(emo)

# Define UI ----
ui <- tagList(tags$head(
  # 0. GA ----
  HTML(
    "<script>
      (function(i,s,o,g,r,a,m){
        i['GoogleAnalyticsObject']=r;i[r]=i[r]||
        function(){
          (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();
          a=s.createElement(o), m=s.getElementsByTagName(o)[0];
          a.async=1;
          a.src=g;m.parentNode.insertBefore(a,m)
        })
      (window, document, 'script',
        '//www.google-analytics.com/analytics.js','ga');

        ga('create', 'UA-113145816-3', 'auto');
        ga('send', 'pageview');
      </script>"
  )
),

# 1. UI Navigation Bar ----
navbarPage(
  "shinygains",
  # 1. UI Sudden Gains Panel ----
  tabPanel(
    paste0("Identify Sudden Gains ", emo::ji("star")),
    column(
      width = 3,
      helpText(),
      # 1. UI Data Characteristics ----
      h4("Data Characteristics:"),
      tabsetPanel(
        tabPanel(
          "Select Data",
          helpText(),
          wellPanel(
            helpText(),
            selectInput(
              "data",
              label = h5("Select Input Data Set:"),
              choices = list("Example Data Set 1" = "sgdata",
                             "Example Data Set 2" = "sgdata_no_na"),
              selected = "sgdata"
            ),
            selectInput(
              "sg_var_list",
              h5("Select Repeated Measures:"),
              choices = c(
                "bdi_s1",
                "bdi_s2",
                "bdi_s3",
                "bdi_s4",
                "bdi_s5",
                "bdi_s6",
                "bdi_s7",
                "bdi_s8",
                "bdi_s9",
                "bdi_s10",
                "bdi_s11",
                "bdi_s12"
              ),
              selected = c(
                "bdi_s1",
                "bdi_s2",
                "bdi_s3",
                "bdi_s4",
                "bdi_s5",
                "bdi_s6",
                "bdi_s7",
                "bdi_s8",
                "bdi_s9",
                "bdi_s10",
                "bdi_s11",
                "bdi_s12"
              ),
              multiple = TRUE
            ),
            helpText(
              "Select variables in the order that reflects the time points that were measured.
               Example Data Set 1 has 14% missing values to illustrate special cases of identifying sudden gains.
               Example Data Set 2 has complete data."
            )
          )
        ),
        tabPanel(
          "Define Missingness",
          helpText(),
          wellPanel(
            sliderInput(
              "na_pct",
              h5("Missingness in % in Repeated Measures:"),
              min = 0,
              max = 100,
              value = 0,
              step = 1
            ),
            helpText(
              "Note: To explore the impact of missing data we recommend using example dataset 2, which has complete data (Dataset 1 has 14% missing data)."
            )
          )
        )
      ),
      # 1. UI Select Crit123 ----
      h4("Select Criteria:"),
      tabsetPanel(
        tabPanel("Identify",
                 helpText(),
                 wellPanel(
                   selectInput(
                     "sgsl",
                     label = h5("Identify Sudden Gains or Losses:"),
                     choices = list("Sudden Gains" = "sg",
                                    "Sudden Losses" = "sl"),
                     selected = "sg"
                   )
                 )),
        tabPanel(
          "Crit 1",
          helpText(),
          wellPanel(
            checkboxInput("sg_crit1",
                          label = "Apply Criterion 1",
                          value = TRUE),
            numericInput(
              inputId = "sg_crit1_cutoff",
              h5("Cut-off value:"),
              value = 7,
              step = .1,
            ),
            helpText(
              "Note: The cut-off value for Crit 1 needs to be positive to identify sudden gains and negative to identify sudden losses."
            )
          )
        ),
        tabPanel(
          "Crit 2",
          helpText(),
          wellPanel(
            checkboxInput("sg_crit2",
                          label = "Apply Criterion 2",
                          value = TRUE),
            sliderInput(
              "sg_crit2_pct",
              "Percentage:",
              min = 0,
              max = 100,
              value = 25,
              step = 1
            ),
            helpText(
              "Note: Percentage change threshold to be used for the second sudden gains criterion."
            )
          )
        ),
        tabPanel(
          "Crit 3",
          helpText(),
          wellPanel(
            checkboxInput("sg_crit3",
                          label = "Apply criterion 3",
                          value = TRUE),
            checkboxInput("sg_crit3_adjust",
                          label = "Adjust critical value for missing data",
                          value = TRUE),
            selectInput(
              "sg_crit3_alpha",
              label = h5("Select alpha:"),
              choices = list(
                ".05" = 0.05,
                ".01" = 0.01,
                ".001" = 0.001
              ),
              selected = 0.05
            ),
            numericInput(
              "sg_crit3_critical_value",
              "Critical value:",
              value = NA,
              step = .1
            ),
            helpText(
              "Note: For discussions about the third criterion see for example Tang et al.",
              # Just some random code about hoe to include a link in UI
              a("(2005",
                href = "https://doi.org/10.1037/0022-006X.73.1.168",
                target = "_blank"),
              ", ",
              a("2015)",
                href = "https://doi.org/10.1002/9781118625392.wbecp378",
                target = "_blank"),
              ", Vittengl et al." ,
              a("(2005",
                href = "https://doi.org/10.1037/0022-006X.73.1.173",
                target = "_blank"),
              ", ",
              a("2015)",
                href = "https://doi.org/10.2174/1573400510666140929195441",
                target = "_blank"),
              ", and Lutz et al.",
              a("(2013)",
                href = "https://doi.org/10.1080/10503307.2012.693837",
                target = "_blank"),
              "."
            )
          )
        )
      )
      # ,
      # hr(),
      # actionButton("citation1", "How do I cite this App?"),
    ),
    # 1. UI Results ----
    column(
      9,
      h4("Results:"),
      tabsetPanel(
        # 1. UI Summary ----
        tabPanel("Summary",
                 helpText(),
                 tabsetPanel(
                   # 1. UI Descriptives ----
                   tabPanel("Descriptives",
                            helpText(),
                            fixedRow(
                              column(
                                12,
                                helpText(),
                                selectInput(
                                  "describe_bysg_or_byperson",
                                  label = h5("Specify which data set to describe:"),
                                  choices = list(
                                    "All gains/losses (bysg)" = "bysg",
                                    "One gain/loss per person (byperson)" = "byperson"
                                  ),
                                  selected = "bysg"
                                ),
                                fixedRow(column(12,
                                                fixedRow(
                                                  column(
                                                    6,
                                                    h5("Sudden Gains Criteria Applied:"),
                                                    verbatimTextOutput("descriptives_sg_crit123")
                                                  ),
                                                  column(
                                                    6,
                                                    h5("Descriptives of Sudden Gains:"),
                                                    verbatimTextOutput("descriptives_sg")
                                                  )
                                                ))),
                                hr(),
                                fixedRow(column(12,
                                                fixedRow(
                                                  column(
                                                    6,
                                                    h5("Distribution of Pregain Session Numbers:"),
                                                    plotOutput("plot_sg_session_n")
                                                  ),
                                                  column(
                                                    6,
                                                    h5("Average Sudden Gain Magnitude:"),
                                                    plotOutput("plot_average_sg")
                                                  )
                                                ))),
                                helpText(
                                  "Note: To change the selected gain for the byperson data set, go to the 'Output byperson Data Set' panel at the top."
                                )
                              )
                            )),
                   # 1. UI Longotudinal Plot ----
                   tabPanel("Longitudinal Plot",
                            helpText(),
                            fixedRow(
                              column(
                                5,
                                selectInput(
                                  "select_ids_list",
                                  h5("Select IDs:"),
                                  choices = c(
                                    "1",
                                    "2",
                                    "3",
                                    "4",
                                    "5",
                                    "6",
                                    "7",
                                    "8",
                                    "9",
                                    "10",
                                    "11",
                                    "12",
                                    "13",
                                    "14",
                                    "15",
                                    "16",
                                    "17",
                                    "18",
                                    "19",
                                    "20",
                                    "21",
                                    "22",
                                    "23",
                                    "24",
                                    "25",
                                    "26",
                                    "27",
                                    "28",
                                    "29",
                                    "30",
                                    "31",
                                    "32",
                                    "33",
                                    "34",
                                    "35",
                                    "36",
                                    "37",
                                    "38",
                                    "39",
                                    "40",
                                    "41",
                                    "42",
                                    "43"
                                  ),
                                  selected = c("2", "4", "5", "9"),
                                  multiple = TRUE
                                )),
                              column(
                                5,
                                h5("Formatting Options:"),
                                checkboxInput("plot_long_connect_missing",
                                              label = "Connect Missing Values",
                                              value = TRUE)),
                              fixedRow(
                                column(
                                  10,
                                hr(),
                                h5("Trajectories of BDI scores for a selection of participants:"),
                                plotOutput("plot_sg_longitudinal")
                              ))
                            ))
                 )),
        # 1. UI Input Data Set ----
        tabPanel(
          "Input Data Set",
          helpText(),
          DT::dataTableOutput("sgdata_table")
        ),
        # 1. UI bysg Data Set ----
        tabPanel(
          HTML("Output <I>bysg</I> Data Set"),
          helpText(),
          DT::dataTableOutput("bysg_table")
        ),
        # 1. UI byperson Data Set ----
        tabPanel(
          HTML("Output <I>byperson</I> Data Set"),
          helpText(),
          selectInput(
            "multiple_sg_select",
            label = h5("Specify which sudden gain/loss to select in cases where there is more than one sudden gain per persoin:"),
            choices = list(
              "first gain/loss" = "first",
              "last gain/loss" = "last",
              "smallest gain/loss" = "smallest",
              "largest gain/loss" = "largest"
            ),
            selected = "first"
          ),
          helpText(),
          DT::dataTableOutput("byperson_table")
        )
      )
    )
  ),
  # 2. UI Check Interval ----
  tabPanel(
    paste0("Check Interval ", emo::ji("monocle")),
    column(
      width = 3,
      helpText(),
      # 2. UI Enter Values ----
      h4("Enter Values:"),
      wellPanel(
        h5("Pregain Values:"),
        fixedRow(
          column(4,
                 numericInput(
                   "sg_2n_check",
                   h5("N-2:"),
                   value = 28,
                   step = 1
                 )),
          column(4,
                 numericInput(
                   "sg_1n_check",
                   h5("N-1:"),
                   value = 19,
                   step = 1
                 )),
          column(4,
                 numericInput(
                   "sg_n_check",
                   h5("N:"),
                   value = 23,
                   step = 1
                 ))
        ),
        h5("Postgain Values:"),
        fixedRow(
          column(4,
                 numericInput(
                   "sg_n1_check",
                   h5("N+1:"),
                   value = 12,
                   step = 1
                 )),
          column(4,
                 numericInput(
                   "sg_n2_check",
                   h5("N+2:"),
                   value = 13,
                   step = 1
                 )),
          column(4,
                 numericInput(
                   "sg_n3_check",
                   h5("N+3:"),
                   value = NA,
                   step = 1
                 ))
        ),
        helpText(
          "Note: To enter missing values leave the box blank. Missing values will be visualised as red points sligtly below all available data points."
        )
      ),
      # 2. UI Select Criteria ----
      h4("Select Criteria:"),
      tabsetPanel(
        tabPanel("Identify",
                 helpText(),
                 wellPanel(
                   selectInput(
                     "sgsl_check",
                     label = h5("Identify:"),
                     choices = list("Sudden Gains" = "sg",
                                    "Sudden Losses" = "sl"),
                     selected = "sg"
                   )
                 )),
        tabPanel(
          "Crit 1",
          helpText(),
          wellPanel(
            checkboxInput("sg_crit1_check",
                          label = "Apply Criterion 1",
                          value = TRUE),
            numericInput(
              "sg_crit1_cutoff_check",
              h5("Cut-off value:"),
              value = 7,
              step = .1,
            ),
            helpText(
              "Note: The cut-off value for Crit 1 needs to be positive to identify sudden gains and negative to identify sudden losses."
            )
          )
        ),
        tabPanel(
          "Crit 2",
          helpText(),
          wellPanel(
            checkboxInput("sg_crit2_check",
                          label = "Apply Criterion 2",
                          value = TRUE),
            sliderInput(
              "sg_crit2_pct_check",
              "Percentage:",
              min = 0,
              max = 100,
              value = 25,
              step = 1
            ),
            helpText(
              "Note: Percentage change threshold to be used for the second sudden gains criterion."
            )
          )
        ),
        tabPanel(
          "Crit 3",
          helpText(),
          wellPanel(
            checkboxInput("sg_crit3_check",
                          label = "Apply criterion 3",
                          value = TRUE),
            checkboxInput("sg_crit3_adjust_check",
                          label = "Adjust critical value for missing data",
                          value = TRUE),
            selectInput(
              "sg_crit3_alpha_check",
              label = h5("Select alpha:"),
              choices = list(
                ".05" = 0.05,
                ".01" = 0.01,
                ".001" = 0.001
              ),
              selected = 0.05
            ),
            numericInput(
              "sg_crit3_critical_value_check",
              "Critical value:",
              value = NA,
              step = .1
            ),
            helpText(
              "Note: For discussions about the third criterion see for example Tang et al.",
              # Just some random code about hoe to include a link in UI
              a("(2005",
                href = "https://doi.org/10.1037/0022-006X.73.1.168",
                target = "_blank"),
              ", ",
              a("2015)",
                href = "https://doi.org/10.1002/9781118625392.wbecp378",
                target = "_blank"),
              ", Vittengl et al." ,
              a("(2005",
                href = "https://doi.org/10.1037/0022-006X.73.1.173",
                target = "_blank"),
              ", ",
              a("2015)",
                href = "https://doi.org/10.2174/1573400510666140929195441",
                target = "_blank"),
              ", and Lutz et al.",
              a("(2013)",
                href = "https://doi.org/10.1080/10503307.2012.693837",
                target = "_blank"),
              "."
            )

          )
        )
      )
      # , hr(),
      # actionButton("citation2", "How do I cite this App?"),
    ),
    column(9,
           fixedRow(
             # 2. UI Summary ----
             column(6,
                    h4("Summary:"),
                    verbatimTextOutput("check_interval_txt")),
             # 2. UI Visualiation of Values ----
             column(
               6,
               h4("Visualiation of Values:"),
               plotOutput("plot_sg_average_check")
             )
           ))
  ),
  tabPanel(
    paste0("Resources ", emo::ji("books")),
    tabsetPanel(
      tabPanel(
        "Variable Descriptions",
        helpText(),
        # just a placeholder for a little bit top margin
        DT::dataTableOutput("sg_var_names_labels")
      ),
      tabPanel(title = "suddengains Tutorial Vignette",
               helpText(),
               htmlOutput("suddengains_tutorial_html")
      ),
      tabPanel(
        "suddengains Tutorial Paper (PDF)",
        helpText(),
        htmlOutput("suddengains_paper_pdf")
      ),
      tabPanel(
        "suddengains Reference Manual (PDF)",
        helpText(),
        htmlOutput("suddengains_cran_pdf")
      ),
      tabPanel(
        "References",
        helpText(),
        htmlOutput("suddengains_zotero_references_bibbase")
      ),

      tags$footer(
        actionButton("citation1", "How do I cite this App?"),
        style = "text-align:center; align: center;
              position:fixed;
              bottom:0;
              width:100%;
              height:50px;
              color: white;
              padding: 10px;
              background-color: white;
              z-index: 1000;"
      )
    )
  )
))

# Define server ----
server <- function(input, output, session) {
  # Select  -----

  ## MAKE SG CRIT 1 POSITIVE AND SL NEGATIVE ----
  observe({
    if (input$sgsl == "sl") {

      if (input$sg_crit1_cutoff > 0) {

        updateNumericInput(session,
                           "sg_crit1_cutoff",
                           value = -1 * abs(input$sg_crit1_cutoff) )

      }
    }
  })


  observe({
    if (input$sgsl == "sg") {

      if (input$sg_crit1_cutoff < 0) {

        updateNumericInput(session,
                           "sg_crit1_cutoff",
                           value = abs(input$sg_crit1_cutoff) )

      }
    }
  })



  # Create dataset with option to add missing values
  sgdata_reactive <- reactive({
    if (input$data == "sgdata_no_na") {
      sgdata_temp <- readr::read_csv("data/sgdata_bdi_no_na.csv")

    } else if (input$data == "sgdata") {
      sgdata_temp <- suddengains::sgdata
    }


    sgdata_weekly_temp <- sgdata_temp %>%
      select("id", input$sg_var_list)

    sgdata_weekly_temp_na <- sgdata_weekly_temp %>%
      tidyr::gather(vars, value,-id) %>%
      dplyr::mutate(vars = base::factor(vars, levels =  input$sg_var_list)) %>%
      dplyr::mutate(
        random_num = runif(nrow(.)),
        value = base::ifelse(
          vars %in% input$sg_var_list &
            random_num <= (input$na_pct / 100),
          NA,
          value
        )
      ) %>%
      dplyr::select(-random_num) %>%
      tidyr::spread(vars, value)

    sgdata_weekly_temp_na
  })

  # Create table of raw data set
  output$sgdata_table <-
    DT::renderDataTable(DT::datatable(
      sgdata_reactive(),
      caption = paste0(
        "Table: Example data set with n = ",
        nrow(sgdata_reactive()),
        " participants and ",
        length(input$sg_var_list),
        " weekly measures."
      ),
      options = list(
        pageLength = 10,
        scrollX = TRUE,
        fixedColumns = TRUE,
        searching = FALSE
      ),
      rownames = FALSE
    ))






  # # update missing ----
  # not including this, jsut have a note sying this somewhere ... too complez ti implement
  # observe({
  #   # sgdata_bdi_long <- suddengains::sgdata %>%
  #   #   select(bdi_s1:bdi_s12) %>%
  #   #   pivot_longer(cols = bdi_s1:bdi_s12)
  #   #
  #   #
  #   # sgdata_bdi1to12_na_pct <- 1 - mean(complete.cases(sgdata_long$value))
  #   # 0.1375969 missing ins sgdata
  #
  #   if (input$data == "sgdata") {
  #
  #     updateSliderInput(session = session,
  #                       inputId = "na_pct",
  #                       # label = h5("Missingness in % in Repeated Measures:"),
  #       min = 0,
  #       max = 100,
  #       value = 14,
  #       step = 1
  #     )
  #   } else if (input$data == "sgdata_no_na") {
  #
  #     updateSliderInput(session = session,
  #                       inputId = "na_pct",
  #                       # label = h5("Missingness in % in Repeated Measures:"),
  #                       min = 0,
  #                       max = 100,
  #                       value = 0,
  #                       step = 1
  #     )
  #   }
  # })

  # sort out options for 3rd crit
  # depending on whether adjusted is ticked, other input options change
  observe({
    if (input$sg_crit3_adjust == TRUE) {
      updateNumericInput(session,
                         "sg_crit3_critical_value",
                         value = NA)
      updateSelectInput(
        session,
        "sg_crit3_alpha",
        choices = list(
          ".05" = 0.05,
          ".01" = 0.01,
          ".001" = 0.001
        ),
        selected = 0.05
      )
    } else if (input$sg_crit3_adjust == FALSE) {
      updateNumericInput(session,
                         "sg_crit3_critical_value",
                         value = 2.776)

      updateSelectInput(
        session,
        "sg_crit3_alpha",
        choices = list("NA" = "NA"),
        selected = "NA"
      )
    }
  })




  # Create bysg data
  bysg_reactive <- reactive({
    if (input$sg_crit1 == TRUE) {
      sg_crit1_cutoff <- input$sg_crit1_cutoff
    } else if (input$sg_crit1 == FALSE) {
      sg_crit1_cutoff <- NULL
    }

    if (input$sg_crit2 == TRUE) {
      sg_crit2_pct <- input$sg_crit2_pct / 100
    } else if (input$sg_crit2 == FALSE) {
      sg_crit2_pct <- NULL
    }



    create_bysg(
      data = sgdata_reactive(),
      identify = input$sgsl,
      sg_crit1_cutoff = sg_crit1_cutoff,
      sg_crit2_pct = sg_crit2_pct,
      sg_crit3 = input$sg_crit3,
      sg_crit3_alpha = as.numeric(input$sg_crit3_alpha),
      sg_crit3_adjust = input$sg_crit3_adjust,
      sg_crit3_critical_value = input$sg_crit3_critical_value,
      id_var_name = "id",
      tx_start_var_name = input$sg_var_list[1],
      tx_end_var_name = last(input$sg_var_list),
      sg_var_list = input$sg_var_list,
      sg_measure_name = "bdi"
    )
  })



  # Create bysg data
  byperson_reactive <- reactive({
    if (input$sg_crit1 == TRUE) {
      sg_crit1_cutoff <- input$sg_crit1_cutoff
    } else if (input$sg_crit1 == FALSE) {
      sg_crit1_cutoff <- NULL
    }

    if (input$sg_crit2 == TRUE) {
      sg_crit2_pct <- input$sg_crit2_pct / 100
    } else if (input$sg_crit2 == FALSE) {
      sg_crit2_pct <- NULL
    }

    create_byperson(
      data = sgdata_reactive(),
      identify = input$sgsl,
      multiple_sg_select = input$multiple_sg_select,
      sg_crit1_cutoff = sg_crit1_cutoff,
      sg_crit2_pct = sg_crit2_pct,
      sg_crit3 = input$sg_crit3,
      sg_crit3_alpha = as.numeric(input$sg_crit3_alpha),
      sg_crit3_adjust = input$sg_crit3_adjust,
      sg_crit3_critical_value = input$sg_crit3_critical_value,
      id_var_name = "id",
      tx_start_var_name = input$sg_var_list[1],
      tx_end_var_name = last(input$sg_var_list),
      sg_var_list = input$sg_var_list,
      sg_measure_name = "bdi"
    )
  })

  #     # Create bysg data table
  output$bysg_table <-
    DT::renderDataTable(
      DT::datatable(
        bysg_reactive(),
        caption = paste0(
          "Table: Data set with one row for each sudden gain (n = ",
          nrow(bysg_reactive()),
          ") experienced by a total number of n = ",
          length(unique(bysg_reactive()$id)),
          " participants."
        ),
        options = list(
          pageLength = 10,
          scrollX = TRUE,
          fixedColumns = TRUE,
          searching = FALSE
        ),
        rownames = FALSE
      ) %>%
        formatRound('sg_change_proportion', 2)
    )

  # Create bysg data table
  output$byperson_table <-
    DT::renderDataTable(
      DT::datatable(
        byperson_reactive(),
        caption = paste0(
          "Table: Data set showing participants with (n = ",
          summarise(byperson_reactive(), sum(sg_crit123 == 1, na.rm = TRUE))[[1]],
          ") and without (n = ",
          summarise(byperson_reactive(), sum(sg_crit123 == 0, na.rm = TRUE))[[1]],
          ") a sudden gain.",
          " In cases where there is more than one sudden gain, the ",
          input$multiple_sg_select,
          " was selected."
        ),
        options = list(
          pageLength = 10,
          scrollX = TRUE,
          fixedColumns = TRUE,
          searching = FALSE
        ),
        rownames = FALSE
      ) %>%
        formatRound('sg_change_proportion', 2)
    )

  #  plot ----
  output$plot_average_sg <- renderPlot({
    # y_limit <- bysg_reactive() %>%
    #   select(sg_session_n) %>%
    #   group_by(sg_session_n) %>%
    #   count() %>%
    #   drop_na() %>%
    #   max(.$n)

    if (input$describe_bysg_or_byperson == "bysg") {
      # plot_bysg_sg_session_n <- bysg_reactive() %>%
      #   select(sg_session_n) %>%
      #   ggplot(aes(sg_session_n)) +
      #   geom_bar() +
      #   labs(x = "Pregain Session Number", y = "Count", fill = "") +
      #   scale_x_continuous(breaks = seq(2, (length(
      #     input$sg_var_list
      #   ) - 2), by = 1)) +
      #   scale_y_continuous(breaks = seq(0, 35, by = 2)) +
      #   coord_cartesian(ylim = c(0, y_limit), xlim = c(2, (length(
      #     input$sg_var_list
      #   ) - 2))) +
      #   ggtitle('Fig. A.1: bysg (all gains)') +
      #   theme_gray()

      plot_bysg_average_sg <- plot_sg(
        data = bysg_reactive(),
        id_var_name = "id",
        tx_start_var_name = input$sg_var_list[1],
        tx_end_var_name = last(input$sg_var_list),
        sg_pre_post_var_list = c(
          "sg_bdi_2n",
          "sg_bdi_1n",
          "sg_bdi_n",
          "sg_bdi_n1",
          "sg_bdi_n2",
          "sg_bdi_n3"
        ),
        ylab = "BDI",
        xlab = "Session"
      ) +
        theme_gray() +
        theme(text = element_text(size = 18)) +
        labs(title = paste0("Source: Based on 'bysg' data set (all gains)")) +
        theme(plot.title = element_text(
          size = 12,
          face = "plain",
          colour = "grey40"
        ))

      plot_bysg_average_sg

    } else if (input$describe_bysg_or_byperson == "byperson") {
      plot_byperson_average_sg <-
        plot_sg(
          data = byperson_reactive(),
          colour_single = "#481567FF",
          id_var_name = "id",
          tx_start_var_name = input$sg_var_list[1],
          tx_end_var_name = last(input$sg_var_list),
          sg_pre_post_var_list = c(
            "sg_bdi_2n",
            "sg_bdi_1n",
            "sg_bdi_n",
            "sg_bdi_n1",
            "sg_bdi_n2",
            "sg_bdi_n3"
          ),
          ylab = "BDI",
          xlab = "Session"
        ) +
        labs(
          title = paste0(
            "Source: Based on 'byperson' data set (",
            input$multiple_sg_select  ,
            " gain)"
          )
        ) +
        theme_gray() +
        theme(text = element_text(size = 18)) +
        theme(plot.title = element_text(
          size = 12,
          face = "plain",
          colour = "grey40"
        ))

      plot_byperson_average_sg

    }
  })

  #  plot ----
  output$plot_sg_session_n <- renderPlot({
    y_limit <- bysg_reactive() %>%
      select(sg_session_n) %>%
      group_by(sg_session_n) %>%
      count() %>%
      drop_na() %>%
      max(.$n)

    if (input$describe_bysg_or_byperson == "bysg") {
      plot_bysg_sg_session_n <- bysg_reactive() %>%
        select(sg_session_n) %>%
        ggplot(aes(sg_session_n)) +
        geom_histogram(binwidth = .5, fill = "#239b89ff") +
        labs(x = "Pregain Session Number", y = "Count", fill = "") +
        scale_x_continuous(breaks = seq(2, (length(
          input$sg_var_list
        ) - 2), by = 1)) +
        scale_y_continuous(breaks = seq(0, 35, by = 2)) +
        coord_cartesian(ylim = c(0, y_limit), xlim = c(2, (length(
          input$sg_var_list
        ) - 2))) +
        labs(title = paste0("Source: Based on 'bysg' data set (all gains)")) +
        theme_gray() +
        theme(text = element_text(size = 18)) +
        theme(plot.title = element_text(
          size = 12,
          face = "plain",
          colour = "grey40"
        ))

      plot_bysg_sg_session_n

    } else if (input$describe_bysg_or_byperson == "byperson") {
      plot_byperson_sg_session_n <- byperson_reactive() %>%
        select(sg_session_n) %>%
        ggplot(aes(sg_session_n)) +
        geom_histogram(binwidth = .5, fill = "#481567FF") +
        labs(x = "Pregain Session Number", y = "Count", fill = "") +
        scale_x_continuous(breaks = seq(2, (length(
          input$sg_var_list
        ) - 2), by = 1)) +
        scale_y_continuous(breaks = seq(0, 35, by = 2)) +
        coord_cartesian(ylim = c(0, y_limit), xlim = c(2, (length(
          input$sg_var_list
        ) - 2))) +
        labs(title = paste0(
          "Source: Based on 'byperson' (",
          input$multiple_sg_select  ,
          " gain)"
        )) +
        theme_gray() +
        theme(plot.title = element_text(
          size = 12,
          face = "plain",
          colour = "grey40"
        )) +
        theme(text = element_text(size = 18))

      plot_byperson_sg_session_n

    }
  })


  output$plot_sg_longitudinal <-   renderPlot({
    plot_sg_trajectories(
      data = sgdata_reactive(),
      id_var = "id",
      select_id_list = input$select_ids_list,
      var_list = input$sg_var_list,
      show_id = TRUE,
      id_label_size = 6,
      label.padding = .2,
      show_legend = TRUE,
      colour = "viridis",
      viridis_option = "D",
      viridis_begin = 0,
      viridis_end = 1,
      connect_missing = input$plot_long_connect_missing,
      scale_x_num = TRUE,
      scale_x_num_start = 1,
      apaish = FALSE,
      xlab = "Session",
      ylab = "BDI"
    ) +
      theme_gray() +
      theme(text = element_text(size = 18))
  })


  output$descriptives_sg_crit123 <- renderText({
    paste0(
      "Crit 1: ",
      ifelse(input$sg_crit1 == TRUE, "YES", "NO"),
      ", Cut-off: ",
      input$sg_crit1_cutoff,
      "\n",
      "Crit 2: ",
      ifelse(input$sg_crit2 == TRUE, "YES", "NO"),
      ", Pct: ",
      input$sg_crit2_pct,
      "%",
      "\n",
      "Crit 3: ",
      ifelse(input$sg_crit3 == TRUE, "YES", "NO"),
      ', Critical Value(s): ',
      if (input$sg_crit3_adjust == FALSE) {
        input$sg_crit3_critical_value

      } else if (input$sg_crit3_adjust == TRUE) {
        sg_crit3_critical_value_complete <-
          round(base::abs(stats::qt(
            p = (as.numeric(input$sg_crit3_alpha) / 2), df = (6 - 2)
          )), 3)
        sg_crit3_critical_value_1missing <-
          round(base::abs(stats::qt(
            p = (as.numeric(input$sg_crit3_alpha) / 2), df = (5 - 2)
          )), 3)
        sg_crit3_critical_value_2missing <-
          round(base::abs(stats::qt(
            p = (as.numeric(input$sg_crit3_alpha) / 2), df = (4 - 2)
          )), 3)

        paste(
          sg_crit3_critical_value_complete,
          sg_crit3_critical_value_1missing,
          sg_crit3_critical_value_2missing,
          sep = ", "
        )
      }
    )
  })

  output$descriptives_sg <- renderText({
    descriptives_byperson <-
      describe_sg(byperson_reactive(), sg_data_structure = "byperson")

    descriptives_bysg <-
      describe_sg(bysg_reactive(), sg_data_structure = "bysg")

    paste0(
      "- ",
      descriptives_byperson$sg_total_n,
      " sudden gains were identified in total",
      "\n- ",
      descriptives_byperson$sg_n,
      " out of ",
      descriptives_byperson$total_n,
      " participants (",
      descriptives_byperson$sg_pct,
      "%) experienced sudden gains",
      "\n- ",
      descriptives_byperson$sg_multiple_n,
      " participants experienced more than one SG",
      "\n- ",
      "Average SG magnitude, M = ",

      if (input$describe_bysg_or_byperson == "bysg") {
        descriptives_byperson$sg_magnitude_m
      } else if (input$describe_bysg_or_byperson == "byperson") {
        descriptives_bysg$sg_magnitude_m
      },

      ", SD = ",

      if (input$describe_bysg_or_byperson == "bysg") {
        descriptives_byperson$sg_magnitude_sd
      } else if (input$describe_bysg_or_byperson == "byperson") {
        descriptives_bysg$sg_magnitude_sd
      }
    )
  })

  # Check interval ----

  # sort out options for 3rd crit
  # depending on whether adjusted is ticked, other input options change
  observe({
    if (input$sg_crit3_adjust_check == TRUE) {
      updateNumericInput(session,
                         "sg_crit3_critical_value_check",
                         value = NA)
      updateSelectInput(
        session,
        "sg_crit3_alpha_check",
        choices = list(
          ".05" = 0.05,
          ".01" = 0.01,
          ".001" = 0.001
        ),
        selected = 0.05
      )
    } else if (input$sg_crit3_adjust_check == FALSE) {
      updateNumericInput(session,
                         "sg_crit3_critical_value_check",
                         value = 2.776)

      updateSelectInput(
        session,
        "sg_crit3_alpha_check",
        choices = list("NA" = "NA"),
        selected = "NA"
      )
    }
  })

  output$check_interval_txt <- renderPrint({
    if (input$sg_crit1_check == TRUE) {
      sg_crit1_cutoff_check <- input$sg_crit1_cutoff_check
    } else if (input$sg_crit1_check == FALSE) {
      sg_crit1_cutoff_check <- NULL
    }

    if (input$sg_crit2_check == TRUE) {
      sg_crit2_pct_check <- input$sg_crit2_pct_check / 100
    } else if (input$sg_crit2_check == FALSE) {
      sg_crit2_pct_check <- NULL
    }

    check_interval(
      pre_values = c(input$sg_2n_check, input$sg_1n_check, input$sg_n_check),
      post_values = c(input$sg_n1_check, input$sg_n2_check, input$sg_n3_check),
      sg_crit1_cutoff = sg_crit1_cutoff_check,
      sg_crit2_pct = sg_crit2_pct_check,
      sg_crit3 = input$sg_crit3_check,
      sg_crit3_critical_value = input$sg_crit3_critical_value_check,
      sg_crit3_adjust = input$sg_crit3_adjust_check,
      sg_crit3_alpha = as.numeric(input$sg_crit3_alpha_check),

      identify = input$sgsl_check
    )
  })

  output$plot_sg_average_check <- renderPlot({
    data_check_interval <- tibble(
      time = factor(
        x = c(
          "sg_2n_check",
          "sg_1n_check",
          "sg_n_check",
          "sg_n1_check",
          "sg_n2_check",
          "sg_n3_check"
        ),
        levels = c(
          "sg_2n_check",
          "sg_1n_check",
          "sg_n_check",
          "sg_n1_check",
          "sg_n2_check",
          "sg_n3_check"
        )
      ),
      score = c(
        input$sg_2n_check,
        input$sg_1n_check,
        input$sg_n_check,
        input$sg_n1_check,
        input$sg_n2_check,
        input$sg_n3_check
      )
    )

    plot_check_interval <-
      ggplot(data = data_check_interval, aes(x = time, y = score, group = 1)) +
      geom_point(colour = "#239b89ff", size = 3) +
      geom_line(data = data_check_interval[!is.na(data_check_interval$score),],
                colour = "#239b89ff",
                alpha = .4) +
      ggplot2::scale_x_discrete(labels = base::c("N-2", "N-1", "N",
                                                 "N+1", "N+2", "N+3")) +
      ggplot2::theme(text = ggplot2::element_text(size = 18)) +
      labs(
        color = "",
        x = "Session",
        y = "Value",
        title = paste0("Source: Based on values entered in the left panel.")
      ) +
      theme(
        plot.title = element_text(
          size = 12,
          face = "plain",
          colour = "grey40"
        ),
        legend.position = "bottom"
      )

    if (all(!is.na(data_check_interval$score)) == FALSE) {
      plot_check_interval <- plot_check_interval +
        geom_miss_point(size = 3, prop_below = .2)
    }

    plot_check_interval

  })



  output$suddengains_tutorial_html <- renderUI({
    suddengains_tutorial_html <-
      tags$iframe(frameborder = "0",
                  style = "height:90vh; width:100%; scrolling=yes",
                  src = "https://cran.r-project.org/web/packages/suddengains/vignettes/suddengains-tutorial.html")
    print(suddengains_tutorial_html)
    suddengains_tutorial_html
  })

  output$suddengains_paper_pdf <- renderUI({
    suddengains_cran_pdf <-
      tags$iframe(
        frameborder = "0",
        type = "application/pdf",
        style = "height:90vh; width:100%; scrolling=yes",
        src = "https://milanwiedemann.github.io/shinygains/r-suddengains-plosone-v3-accepted.pdf"
      )
    print(suddengains_cran_pdf)
    suddengains_cran_pdf



    # suddengains_cran_pdf <-
    #   tags$iframe(frameborder = "0",
    #               type="application/pdf",
    #               style = "height:100vh; width:100%; scrolling=yes",
    #               src = "https://docs.google.com/viewerng/viewer?url=https://milanwiedemann.github.io/shinygains/r-suddengains.pdf&embedded=true")
    # print(suddengains_cran_pdf)
    # suddengains_cran_pdf
  })

  output$suddengains_cran_pdf <- renderUI({
    suddengains_cran_pdf <-
      tags$iframe(frameborder = "0",
                  # type="application/pdf",
                  style = "height:90vh; width:100%; scrolling=yes",
                  src = "https://cran.r-project.org/web/packages/suddengains/suddengains.pdf")
    print(suddengains_cran_pdf)
    suddengains_cran_pdf
  })

  output$suddengains_zotero_references_bibbase <- renderUI({
    suddengains_zotero_references_bibbase <-
      tags$iframe(frameborder = "0",
                  style = "height:90vh; width:100%; scrolling=yes",
                  src = "https://bibbase.org/show?bib=https%3A%2F%2Fapi.zotero.org%2Fgroups%2F2280342%2Fitems%3Fkey%3DIDng9wgu628dYdU2FyH7gwwh%26format%3Dbibtex%26limit%3D100")
    print(suddengains_zotero_references_bibbase)
    suddengains_zotero_references_bibbase
  })

  # 999 Variable Names ----
  # Well this is super confusing, change to tibble at some point
  data_sg_var_names_labels <- tibble::tribble(
    ~ var_name,
    ~ var_label,
    "id_sg",
    "Unique ID variable for ever sudden gain",
    "sg_crit123",
    "Indicate sudden gain TRUE / FALSE",
    "sg_session_n",
    "Pregain session",
    "sg_freq_byperson",
    "Frequency of sudden gains / losses per person",
    "sg_bdi_2n",
    "Pre-pre-pre gain session",
    "sg_bdi_1n",
    "Pre-pre gain session",
    "sg_bdi_n",
    "Pre-gain session",
    "sg_bdi_n1",
    "Post-gain session",
    "sg_bdi_n2",
    "Post-post gain session",
    "sg_bdi_n3",
    "Post-post-post gain session",
    "sg_magnitude",
    "Raw magnitude of sudden gain",
    "sg_bdi_tx_change",
    "Total change during treatment",
    "sg_change_proportion",
    "Proportion of change represented by the sudden gain",
    "sg_reversal_value",
    "Reversal value",
    "sg_reversal",
    "Reversal TRUE / FALSE",
  )

  output$sg_var_names_labels <-
    DT::renderDataTable(
      DT::datatable(
        data_sg_var_names_labels,
        caption = "Table: New Variables created by create_bysg() and create_byperson() functions.",
        colnames = c("Variable Name", "Variable Label"),
        options = list(
          pageLength = 15,
          paging = FALSE,
          scrollX = TRUE,
          fixedColumns = TRUE,
          searching = FALSE,
          dom = 't',
          ordering = FALSE
        ),
        rownames = FALSE
      )
    )


  # CITATION ----
  observeEvent(input$citation1, {
    showModal(modalDialog(
      title = "Citation",
      HTML("Please cite this Shiny App or the R package if you've used it for your work.
      <br><br>
      Wiedemann, M., Thew, G. R., Stott, R., & Ehlers, A. (2020).
      suddengains: An R package to identify sudden gains in longitudinal data.
      PLOS ONE. doi:
      <a href='https://doi.org/10.1371/journal.pone.0230276'>https://doi.org/10.1371/journal.pone.0230276</a>
      <br><br>
      <center><p style='font-size:40px'>  &#128156;</p></center>
           "
      ),
      easyClose = TRUE
    ))
  })


}
# Run the application
shinyApp(ui = ui, server = server)
