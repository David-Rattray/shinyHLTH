
pkgs <- c(
  "bcmaps",
  "bslib",
  "bsicons",
  "datasets", #for mtcars and other example data
  "devtools",
  "dplyr",
  "lubridate",
  "ggplot2",
  "golem",
  "pins",
  "plotly",
  "sass",
  "shiny"
  )

for (i in pkgs) {
  library(i, character.only = TRUE)
}
