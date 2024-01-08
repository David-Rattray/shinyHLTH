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
      p("Nice Title for Descriptive Info", style = "color:black;text-align:center"),
      p("We identified a test cohort of patients:",
        style = "color:black;text-align:center"),
      p("1. This data is completely fabricated from thin air.",
        br(),
        "2. Like it was sampled randomly from a normal distribution...",
        br(),
        "3. Well well maybe not perfectly random.",
        br(),
        "4. But still totally random.",
        style = "color:black;text-align:center;background-color:white;padding:15px;border:1px solid black"
      ),
      width = 2 # sidebarlayout and mainPanel widths must add up to 12
    ),
    mainPanel( # main section of the module
      # fluidRow(
      #   column(4, style = 'padding:0px',
      #          wellPanel(class = "dashbox",
      #                    valueBoxOutput(NS(id, "count_patient"), width = NULL))),
      #   column(4, style = 'padding:0px',
      #          wellPanel(class = "dashbox",
      #                    valueBoxOutput(NS(id, "count_code"), width = NULL))),
      #   column(4, style = 'padding:0px',
      #          wellPanel(class = "dashbox",
      #                    valueBoxOutput(NS(id, "median_age"), width = NULL)))
      # ),
      fluidRow(
        layout_columns(
          value_box(
            title = "Patient Count",
            value = textOutput(NS(id, "count_patient")),
            showcase = bs_icon("calculator")
          ),
          value_box(
            title = "Another Count",
            value = textOutput(NS(id, "count_code")),
            showcase = bs_icon("calculator")
          ),
          value_box(
            title = "Median Age",
            value = textOutput(NS(id, "median_age")),
            showcase = bs_icon("calculator")
          )
        )
      ),
      fluidRow(
        plotOutput(NS(id, "gender_plot"))
      )
      , width = 10 # sidebarlayout and mainPanel widths must add up to 12
    ) # end of mainPanel()

    # value_box(
    #   title = "The current time",
    #   value = textOutput("time"),
    #   showcase = bs_icon("clock")
    # )
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

      # output$count_patient <- renderValueBox({
      #   req(cohort_data())
      #   patient_count <- cohort_data() %>%
      #     distinct(id)
      #   value_box(
      #     title = "Total Number of Unique Patients",
      #     value = format(nrow(patient_count), big.mark = ",", scientific = FALSE),
      #     showcase = bs_icon("people-fill")
      #   )
      # })

      output$count_patient <- renderText({
        patient_count <- cohort_data() %>%
          distinct(id)
        format(nrow(patient_count), big.mark = ",", scientific = FALSE)
      })

      # output$count_code <- renderValueBox({
      #   req(cohort_data())
      #   code_count <- cohort_data() %>%
      #     summarise(n=n()) %>%
      #     pull(n)
      #
      #   value_box(
      #     title = "Most Common Age at Heart Failure",
      #     value = format(code_count, big.mark = ",", scientific = FALSE),
      #     showcase = bs_icon("virus2")
      #   )
      # })

      output$count_code <- renderText({
        req(cohort_data())
        code_count <- cohort_data() %>%
          summarise(n=n()) %>%
          pull(n)
        format(code_count, big.mark = ",", scientific = FALSE)
      })

      # output$median_age <- renderValueBox({
      #   req(cohort_data())
      #   age_count <- cohort_data() %>%
      #     select(age)
      #   median_val <- median(age_count$age, na.rm = TRUE)
      #   # Seems to need na.rm = TRUE to work, but dunno why
      #   value_box(
      #     title = "Median Age of All Patients",
      #     value =  median_val,
      #     showcase = bs_icon("cake2") #https://icons.getbootstrap.com/
      #   )
      # })

      output$median_age <- renderText({
        req(cohort_data())
        age_count <- cohort_data() %>%
          select(age)
        median_val <- median(age_count$age, na.rm = TRUE)
      })

      output$gender_plot <- renderPlot({
        req(cohort_data())
        ggplot(cohort_data()) +
          geom_density(aes(x = age, fill = gender), alpha = 0.2) +
          theme_minimal(base_size = 16) +
          theme(axis.title = element_blank())
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
