
app_server <- function(input, output, session) {
  # pins::board_register() # connect to pin board if needed
  cohortServer("cohort")
  geographyServer("geography")
  informationServer("information")

}
