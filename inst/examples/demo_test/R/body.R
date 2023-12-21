body <- function() {
  tabsetPanel(id = main_tabs,
    tabPanel("Cohort",
             cohortUI("cohort")),
    tabPanel("Geography",
             geographyUI("geography"))
  )
}
