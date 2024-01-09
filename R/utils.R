#' updateFilenames
#'
#' 
#' 
#'
updateFilenames <- function(path_to_dir, pkg_name) {
  files_to_change <- c("R/app_config.R", "inst/golem-config.yml")
  for (f in files_to_change) {
    copied_file <- file.path(path_to_dir, f)
    tx <- readLines(copied_file)
    tx2 <- gsub(
      pattern = "demodashboard",
      replacement = pkg_name,
      x = tx)
    writeLines(
      tx2,
      con = copied_file
    )
  }
}

#' Project Hook
#'
#' Project hooks allow to define a function run just after `{golem}`
#' project creation.
#'
#' @inheritParams create_dashboard 
#' @param ... Arguments passed from `create_dashboard()`, unused in the default
#' function.
#'
#' @return Used for side effects
#' @export
#'
#' @examples
#' if (interactive()) {
#'   my_proj <- function(...) {
#'     unlink("dev/", TRUE, TRUE)
#'   }
#'   create_golem("ici", project_template = my_proj)
#' }
project_hook <- function(path, package_name, ...) {
  message("Welcome")
  # options <- (golem.wd = path)
  # rstudioapi::navigateToFile(file.path(path, "dev/run_dev.R"))
  return(TRUE)
}
# 
# 
# check_dev_deps_are_installed()
# 
# 
# if (isTRUE(open)) {
#   if (
#     rlang::is_installed("rstudioapi") &&
#     rstudioapi::isAvailable() &&
#     rstudioapi::hasFun("openProject")
#   ) {
#     rstudioapi::openProject(path = path)
#   } else {
#     setwd(path)
#   }
# }
# 
# return(
#   invisible(
#     path_to_golem
#   )
# )
# }