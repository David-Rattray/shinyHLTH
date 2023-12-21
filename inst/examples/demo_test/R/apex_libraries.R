
pkgs <- c(
  "bslib",
  "visNetwork",
  "tidyverse",
  "datasets", #for mtcars and other example data
  "devtools",
  "dplyr",
  "lubridate",
  "ggplot2",
  "golem",
  "pins",
  "plotly",
  "sass",
  "shiny",
  "shinyjs",
  "shinyWidgets",
  "shinydashboard",
  "shinydashboardPlus"
)

for (i in pkgs) {
  library(i, character.only = TRUE)
}
