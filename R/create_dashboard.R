#' Create a package for a Shiny App using `{golem}`
#'
#' @param path Name of the folder to create the package in.
#'     This will also be used as the package name.
#' @param check_name Should we check that the package name is
#'     correct according to CRAN requirements.
#' @param open Boolean. Open the created project?
#' @param overwrite Boolean. Should the already existing project be overwritten ?
#' @param package_name Package name to use. By default, {golem} uses
#'     `basename(path)`. If `path == '.'` & `package_name` is
#'     not explicitly set, then `basename(getwd())` will be used.
#' @param without_comments Boolean. Start project without golem comments
#' @param project_hook A function executed as a hook after project
#'     creation. Can be used to change the default `{golem}` structure.
#'     to override the files and content. This function is executed just
#'     after the project is created.
#' @param with_git Boolean. Initialize git repository
#' @param ... Arguments passed to the `project_hook()` function.
#'
#' @note
#' For compatibility issue, this function turns `options(shiny.autoload.r)`
#' to `FALSE`. See https://github.com/ThinkR-open/golem/issues/468 for more background.
#'
#' @importFrom utils getFromNamespace
#' @importFrom yaml write_yaml
#'
#' @export
#'
#' @return The path, invisibly.
#' 
# create_golem <- function(
#     path,
#     check_name = TRUE,
#     open = TRUE,
#     overwrite = FALSE,
#     package_name = basename(path),
#     without_comments = FALSE,
#     project_hook = golem::project_hook,
#     with_git = FALSE,
#     ...
# )
create_dashboard <- function(
    path,
    pkg_name = basename(path),
    project_hook = shinyHLTH::project_hook,
    open = TRUE,
    ...) {
  
  path_to_dir <- normalizePath(
    path,
    mustWork = FALSE
  )
  
  # put pkg_name into the function args, probably can remove this.
  # pkg_name <- tail(unlist(strsplit(path, "/")), 1)
  
  if(dir.exists(path_to_dir) == FALSE) {
    
    dir.create(path_to_dir, recursive = FALSE, showWarnings = FALSE)
    
    # Copies basic file structure to path
    file.copy(
      system.file("demodashboard/.", package = "shinyHLTH", mustWork = TRUE),
      path_to_dir,
      recursive = TRUE
    )
    
    updateFilenames(path_to_dir, pkg_name)
    
    usethis::create_project(
      path = path_to_dir,
      open = FALSE
    )
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
    
   
    # was hoping to make it open the run_dev script when the new project launches
    # rstudioapi::navigateToFile(file.path(path_to_dir, "dev/run_dev.R"))
    
    # opening project after creation. Maybe there will be options here to open the scripts
    
    if (isTRUE(open)) {
      if (
        rlang::is_installed("rstudioapi") &&
        rstudioapi::isAvailable() &&
        rstudioapi::hasFun("openProject")
      ) {
        rstudioapi::openProject(path = path_to_dir)
      } else {
        setwd(path_to_dir)
      }
    }
  # Not sure what the point is of this from golem just yet  
    return(
      invisible(
        path_to_dir
      )
    )
    
  } else {
    stop("Directory Specified Already Exists")
  }
  
}

#  https://github.com/ghcarlalan/graveler/blob/main/inst/rstudio/templates/project/graveler_dashboard.dcf
# https://rstudio.github.io/rstudio-extensions/rstudio_project_templates.html
# https://rstudio4edu.github.io/rstudio4edu-book/proj-templates.html

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
