#' Creates module of the specified name
#'
#' @export

create_module <- function(name, pkg = getwd(), open = TRUE, dir_create = TRUE){
  library(golem)
  library(cli)
  
  mod_name <- tolower(name)
  label_name <- paste(toupper(substring(name, 1, 1)),
                      tolower(substring(name, 2, nchar(name))),
                      sep = "")
  
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))

  dir_created <- create_dir_if_needed("R", dir_create)

  if (!dir_created) {
    cat_red_bullet("File not added (needs a valid directory)")
    return(invisible(FALSE))
  }

  where <- file.path("R", paste0("mod_", mod_name, ".R"))

  if (!check_file_exist(where)) {
    return(invisible(FALSE))
  }

  file.create(where)

  write_there <- function(...) {
    write(..., file = where, append = TRUE)
  }

  glue <- function(...) {
    glue::glue(..., .open = "%", .close = "%")
  }

  write_there("# Module UI")
  write_there(" ")
  write_there(glue("#' @title %mod_name%UI and %mod_name%Server"))
  write_there("#' @description A shiny module.")
  write_there(" ")
  write_there(glue('%mod_name%UI <- function(id, label = "%label_name%") {'))
  write_there("\tsidebarLayout(")
  write_there("\t\tsidebarPanel(")
  write_there('\t\t\tp("put sidebar items here")')
  write_there("\t\t\t, width = 2 # sidebarlayout and mainPanel widths must add up to 12")
  write_there("\t\t),")
  write_there("\tmainPanel(")
  write_there("\t, width = 10")
  write_there("\t\t)")
  write_there("\t)")
  write_there("}")
  write_there(" ")
  write_there("# Module Server")
  write_there(" ")
  write_there(glue("%mod_name%Server <- function(id) {"))
  write_there("\tmoduleServer(id, function(input, output, session) {")
  write_there("\t}")
  write_there("\t)")
  write_there("}")
  write_there(" ")
  write_there("## copy to body.R")
  write_there(glue("# nav_panel(%label_name%,
                   %mod_name%UI(\"%mod_name%\")"))
  write_there(" ")
  write_there("## copy to app_server.R")
  write_there(glue("# %mod_name%Server, (\"%mod_name%\")"))
  write_there(" ")

  golem::add_fct("display", module = mod_name)

  cat_green_tick(glue("Files created at %where%"))

  if (rstudioapi::isAvailable() & open) {
    rstudioapi::navigateToFile(where)
  } else {
    cat_bullet(glue("Go to %where%"), bullet = "square_small_filled", bullet_col = "red")
  }
}
