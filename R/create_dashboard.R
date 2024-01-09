#' Golem dashboard backend
#'
#' Creates golem directory and header from template info
#'
#' @export
create_dashboard <- function(path) {
  
  path_to_dir <- normalizePath(
    path,
    mustWork = FALSE
  )
  
  pkg_name <- tail(unlist(strsplit(path, "/")), 1)
  
  if(dir.exists(path_to_dir) == FALSE) {
    
    dir.create(path_to_dir, recursive = FALSE, showWarnings = FALSE)
    
    # Copies basic file structure to path
    file.copy(
      system.file("demodashboard/.", package = "shinyHLTH", mustWork = TRUE),
      path_to_dir,
      recursive = TRUE
    )
    updateFilenames(path_to_dir, pkg_name)
    
    # Create basic DESCRIPTION file
    contents <- c(
      paste("Package:", pkg_name),
      paste("Title:"),
      "Version: 0.0.0",
      paste("Author:"),
      paste("Maintainer:"),
      "Description: Your Description Here",
      "Encoding: UTF-8",
      "LazyData: true"
    )
    writeLines(contents, con = file.path(path_to_dir, "DESCRIPTION"))
    
    usethis::create_project(
      path = path_to_dir,
      open = TRUE
    )
    
    rstudioapi::navigateToFile(paste0(path_to_dir, "dev/run_dev.R"))
    
  } else {
    stop("Directory Specified Already Exists")
  }
}

#   

#    
#     # Create Rproject in the specified path
#     # https://stackoverflow.com/questions/26126027/script-for-creating-a-new-project-in-rstudio
#     usethis::create_project(path,
#                             open = FALSE)
#     
#     # Print message to console
#     message("Adding RStudio project file to ", path)
#     
#     pkg_name <- tail(unlist(strsplit(path, "/")), 1)
#     
# Create basic DESCRIPTION file
#     
#     writeLines(contents, con = file.path(path, "DESCRIPTION"))
#   } else {
#     stop("Directory Specified Already Exists")
#   }
#   golem::set_golem_name(pkg_name)
#   
#   rstudioapi::navigateToFile("dev/run_dev.R")
# }
# 
# Version: 1.0
# 
# RestoreWorkspace: No
# SaveWorkspace: No
# AlwaysSaveHistory: Default
# 
# EnableCodeIndexing: Yes
# Encoding: UTF-8
