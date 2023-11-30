#' @title Launch a small graveler example
#'
#' @description A gallery of widgets available in the package.
#'
#' @importFrom shiny shinyAppDir
#' @export
#'
#' @examples
#' if (interactive()) {
#'
#'  geodude_example()
#'
#' }
shinyHLTH_example <- function() { # nocov start
  if (!requireNamespace(package = "shinydashboard"))
    message("Package 'shinydashboard' is required to run this function")
  shiny::shinyAppDir(system.file("examples/demo_dash", package = "shinyHLTH", mustWork = TRUE))
}
# nocov end
