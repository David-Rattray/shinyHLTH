# Module UI

#' @title mod_test_page_ui and mod_test_page_server
#' @description A shiny module.

cohortUI <- function(id, label = "Cohort") {
  sidebarLayout( # Layout for slicers and other info panels
    sidebarPanel(
      selectInput(NS(id, "gender"),
                  "Select Patient Sex",
                  choices = c("All", "F", "M"),
                  selected = "All",
                  width = '100%'),
      selectInput(NS(id, "age_group"),
                  "Select Age Group",
                  choices = c("All", "Senior", "non-Senior"),
                  selected = "All",
                  width = '100%'),
      p("Assumptions For Modeling", style = "color:black;text-align:center"),
      p("We identified a test cohort of patients:",
        style = "color:black;text-align:center"),
      p("1. This data is fully randomized.",
        br(),
        "2. Like completely generated out of thin air.",
        br(),
        "3. Well there was some handy funcions I used.",
        br(),
        "4. But still totally random.",
        style = "color:black;text-align:center;background-color:white;padding:15px;border:1px solid black"
      ),
      width = 2 # sidebarlayout and mainPanel widths must add up to 12
    ),
    mainPanel( # main section of the module
      fluidRow(
        column(4, style = 'padding:0px',
               wellPanel(class = "dashbox",
                         valueBoxOutput(NS(id, "count_patient"), width = NULL))),
        column(4, style = 'padding:0px',
               wellPanel(class = "dashbox",
                         valueBoxOutput(NS(id, "count_code"), width = NULL))),
        column(4, style = 'padding:0px',
               wellPanel(class = "dashbox",
                         valueBoxOutput(NS(id, "median_age"), width = NULL)))
      )
      , width = 10 # sidebarlayout and mainPanel widths must add up to 12
    ) # end of mainPanel()
  ) # End of sidebarLayout()
}

# Module Server

cohortServer <- function(id) {
  moduleServer(id, function(input, output, session) {

      cohort_data <- reactive({
        selected_gender <- if("All" %in% input$gender) unique(Cohort_data$gender) else input$gender
        selected_age <- if("All" %in% input$age_group) unique(Cohort_data$age_group) else input$age_group

        Cohort_data %>%
          filter(gender %in% selected_gender, age_group %in% selected_age)
      })

      output$count_patient <- renderValueBox({
        req(cohort_data())
        patient_count <- cohort_data() %>%
          distinct(id)
        valueBox(
          value = format(nrow(patient_count), big.mark = ",", scientific = FALSE),
          subtitle = "Total Number of Unique Patients",
          icon = icon("users"),
          color = "blue",
          width = NULL
        )
      })

      output$count_code <- renderValueBox({
        req(cohort_data())
        code_count <- cohort_data() %>%
          summarise(n=n()) %>%
          pull(n)

        valueBox(
          value = code_count,
          subtitle = "Most Common Age at Heart Failure",
          icon = icon("virus"),
          color = "blue",
          width = NULL
        )
      })

      output$median_age <- renderValueBox({
        req(cohort_data())
        age_count <- cohort_data() %>%
          select(id, age, age_group) %>%
          distinct(id, .keep_all = TRUE)
        median_val <- median(age_count$age, na.rm = TRUE)
        # Seems to need na.rm = TRUE to work, but dunno why
        valueBox(
          value =  median_val,
          subtitle = "Median Age of All Patients",
          icon = icon("cake-candles"),
          color = "navy",
          width = NULL
        )
      })
    }
  )
}
## copy to body.R
# mod_foo_ui("foo_ui_1")

## copy to app_server.R
# callModule(mod_foo_server, "foo_ui_1")

## copy to sidebar.R
# menuItem("displayName",tabName = "foo",icon = icon("user"))
