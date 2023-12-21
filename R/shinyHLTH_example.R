#' @title Launch an example dashboard
#'
#' @description A gallery of widgets available in the package.
#'
#' @importFrom shiny shinyAppDir
#' @export
#'
#' @examples
#' if (interactive()) {
#'
#'  shinyHLTH_example()
#'
#' }
# shinyHLTH_example <- function() { # nocov start
#   if (!requireNamespace(package = "shinydashboard"))
#     message("Package 'shinydashboard' is required to run this function")
#   shiny::shinyAppDir(system.file("examples/demo_dash", package = "shinyHLTH", mustWork = TRUE))
# }
# nocov end
shinyHLTH_example <- function(example = "demo_dash") { # nocov start
  if (!requireNamespace(package = "shinydashboard"))
    message("Package 'shinydashboard' is required to run this function")
  choice <- paste0("examples/", example)
  shiny::shinyAppDir(system.file(choice, package = "shinyHLTH", mustWork = TRUE))
}