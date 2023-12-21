#' Golem dashboard backend
#'
#' Creates golem directory and header from template info
#'
#' @export
start_dashboard <- function(path,...) {
  # ensure path exists
  dir.create(path, recursive = TRUE, showWarnings = FALSE)

  file.copy( # copies shinyHLTH folder
    system.file("extdata/.", package = "shinyHLTH", mustWork = TRUE),
    path,
    recursive = TRUE
  )

  # https://stackoverflow.com/questions/26126027/script-for-creating-a-new-project-in-rstudio
  usethis::create_project(path,
                          check_name = FALSE)
  
  message("Adding RStudio project file to ", path)
  
  dots <- list(...)

  text_list <- list()

  for (i in seq_along(dots)) {
    text_list[[i]] <- dots[[i]]
  }

  names(text_list) <- names(dots)

  contents <- c(
    paste("Package:", text_list$pkg_name),
    paste("Title:", text_list$title),
    "Version: 0.0.0",
    paste("Author:", text_list$username),
    "Description: Your Description Here",
    "Encoding: UTF-8",
    "LazyData: true"
  )

  writeLines(contents, con = file.path(path, "DESCRIPTION"))

  url <- "https://www.rstudio.com/products/connect/"

  # edit this for MoH / HSPP guidelines
  header <- c(
    "header <- function() {",
    "\tdashboardHeader(",
    "\t\ttitle = tagList(",
    paste0("\t\t\tspan(class = 'logo-lg',a(\"", text_list$title, "\",style=\"color:white !important\",href='", url, "')),"),
    paste0("\t\t\ta(style = \"margin: -15px\", href='", url ,"', img(src = \"www/HSIAR-Logo-1_big.png\", width=\"225%\"))"),
    "\t\t),",
    "\t\tcontrolbarIcon = \"gear\"",
    "\t)",
    "}"
  )

  writeLines(header, con = file.path(paste0(path, "/R"), "header.R"))

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
