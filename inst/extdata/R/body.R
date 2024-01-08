body <- function() {
  tags$div(
    navset_card_tab(id = "main_tabs",
                    nav_panel("Cohort",
                              cohortUI("cohort")),
                    nav_panel("Geography",
                              geographyUI("geography")),
                    nav_panel("Information",
                              informationUI("information"))
    )
    , class = "main-page")
}
