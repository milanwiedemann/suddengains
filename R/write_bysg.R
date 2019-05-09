#' Write a sudden gains data frame (bysg) to CSV, SPSS, STATA or Excel files
#'
#' @description Writes a data frame as a specified file type.
#'
#' @param data A data set in wide format including an ID variable and variables for each measurement point.
#' @param sg_crit1_cutoff Numeric, specifying the cut-off value to be used for the first sudden gains criterion.
#' If set to \code{NULL} the first criterion wont be applied.
#' @param sg_crit2_pct Numeric, specifying the percentage change to be used for the second sudden gains/losses criterion.
#' If set to \code{NULL} the second criterion wont be applied.
#' @param sg_crit3 If set to \code{TRUE} the third criterion will be applied automatically adjusting the critical value for missingness.
#' If set to \code{FALSE} the third criterion wont be applied.
#' @param id_var_name String, specifying the name of the ID variable. Each row should have a unique value.
#' @param sg_var_list Vector, specifying the variable names of each measurement point sequentially.
#' @param tx_start_var_name String, specifying the variable name of the first measurement point of the intervention.
#' @param tx_end_var_name String, specifying the variable name of the last measurement point of the intervention.
#' @param sg_measure_name String, specifying the name of the measure used to identify sudden gains/losses.
#' @param identify String, specifying whether to identify sudden gains (\code{"sg"}) or sudden losses (\code{"sl"}).
#' @param identify_sg_1to2 Logical, indicating whether to identify sudden losses from measurement point 1 to 2.
#' @param format String, specifying the format of the data file, \code{"CSV"}, \code{"SPSS"}, \code{"STATA"} or \code{"Excel"}.
#' @param path String, specifying the file name ending with the matching file extension,
#' \code{".csv"}, \code{".sav"}, \code{".dta"} or \code{".xlsx"}.
#' @param ... Additional parameters to be passed on to the specified write function,
#' see \code{readr::write_csv} for \code{"CSV"}, \code{haven::write_sav} for \code{"SPSS"}, \code{haven::write_dta} for \code{"STATA"} or \code{writexl::write_xlsx} for \code{"Excel"}
#' for more information.
#' @param stata_version Numeric, specifying STATA version number.
#' @references Tang, T. Z., & DeRubeis, R. J. (1999). Sudden gains and critical sessions in cognitive-behavioral therapy for depression. Journal of Consulting and Clinical Psychology, 67(6), 894–904. \url{https://doi.org/10.1037/0022-006X.67.6.894}.
#' @export
#' @examples # Adjust "path" argument before running
#' # Create character string name for temporary "bysg.csv" file
#' temp <- tempfile(pattern = "bysg", fileext = ".csv")
#'
#' # Write bysg dataset (CSV file)
#' # To write a different format change the 'format' argument
#' # as well as the file extension in the 'path' argument
#' write_bysg(data = sgdata,
#'            sg_crit1_cutoff = 7,
#'            id_var_name = "id",
#'            tx_start_var_name = "bdi_s1",
#'            tx_end_var_name = "bdi_s12",
#'            sg_var_list = c("bdi_s1", "bdi_s2", "bdi_s3", "bdi_s4",
#'                            "bdi_s5", "bdi_s6", "bdi_s7", "bdi_s8",
#'                            "bdi_s9", "bdi_s10", "bdi_s11", "bdi_s12"),
#'            sg_measure_name = "bdi",
#'            identify_sg_1to2 = FALSE,
#'            format = "CSV",
#'            path = temp)

write_bysg <- function(data, sg_crit1_cutoff, id_var_name, sg_var_list, tx_start_var_name, tx_end_var_name, sg_measure_name,
                       sg_crit2_pct = .25, sg_crit3 = TRUE, identify = c("sg", "sl"), identify_sg_1to2 = FALSE,
                       format = c("CSV", "SPSS", "STATA", "Excel"), path, stata_version = 14, ...) {

    # Check arguments
    identify <- base::match.arg(identify)
    format <- base::match.arg(format)

    # Create bysg data object
    bysg_data <- create_bysg(data = data,
                             sg_crit1_cutoff = sg_crit1_cutoff,
                             sg_crit2_pct = sg_crit2_pct,
                             sg_crit3 = sg_crit3,
                             id_var_name = id_var_name,
                             tx_start_var_name = tx_start_var_name,
                             tx_end_var_name = tx_end_var_name,
                             sg_var_list = sg_var_list,
                             identify_sg_1to2 = identify_sg_1to2,
                             sg_measure_name = sg_measure_name,
                             identify = identify)

    # Write bysg data in the specified format
    if (format == "CSV") {
        readr::write_csv(x = bysg_data, path = path, ...)
    } else if (format == "SPSS") {
        haven::write_sav(data = bysg_data, path = path, ...)
    } else if (format == "Excel") {
        writexl::write_xlsx(x = bysg_data, path = path, ...)
    } else if (format == "STATA") {
        haven::write_dta(data = bysg_data, path = path, version = stata_version)
    }
}
