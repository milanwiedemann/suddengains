#' This shiny application illustrates the main functions of this package
#'
#' @return
#' @export
#'
#' @examples
#' shinygains()
shinygains <- function() {
    shiny::runApp(appDir = system.file("shinygains", package = "suddengains"))
}
