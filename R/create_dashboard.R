#' Golem dashboard backend
#'
#' Creates golem directory and header from template info
#'
#' @export
create_dashboard <- function(path) {
  # ensure path exists
  dir.create(path, recursive = TRUE, showWarnings = FALSE)

  # Copies basic file structure to path
  file.copy(
    system.file("extdata/.", package = "shinyHLTH", mustWork = TRUE),
    path,
    recursive = TRUE
  )

  # Create Rproject in the specified path
  # https://stackoverflow.com/questions/26126027/script-for-creating-a-new-project-in-rstudio
  usethis::create_project(path)
  
  # Print message to console
  message("Adding RStudio project file to ", path)
  
  pkg_name <- tail(unlist(strsplit(path, "/")), 1)
  
  # Create basic DESCRIPTION file
  contents <- c(
    paste("Package:", pkg_name),
    paste("Title:"),
    "Version: 0.0.0",
    paste("Author:"),
    "Description: Your Description Here",
    "Encoding: UTF-8",
    "LazyData: true"
  )
  
  writeLines(contents, con = file.path(path, "DESCRIPTION"))

}
# 
# Version: 1.0
# 
# RestoreWorkspace: No
# SaveWorkspace: No
# AlwaysSaveHistory: Default
# 
# EnableCodeIndexing: Yes
# Encoding: UTF-8
