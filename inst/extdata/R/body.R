body <- function() {
  tabsetPanel(
    tabPanel("Cohort",
             cohortUI("cohort")),
    tabPanel("Geography",
             geographyUI("geography"))
  )
}
