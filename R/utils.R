replace_package_name <- function(
    copied_files,
    package_name,
    path_to_golem
) {
  # Going through copied files to replace package name
  for (f in copied_files) {
    copied_file <- file.path(path_to_dir, f)
    
    if (grepl("^REMOVEME", f)) {
      file.rename(
        from = copied_file,
        to = file.path(path_to_dir, gsub("REMOVEME", "", f))
      )
      copied_file <- file.path(path_to_dir, gsub("REMOVEME", "", f))
    }
    
    if (!grepl("ico$", copied_file)) {
      try(
        {
          replace_word(
            file = copied_file,
            pattern = "demodashboard",
            replace = package_name
          )
        },
        silent = TRUE
      )
    }
  }
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