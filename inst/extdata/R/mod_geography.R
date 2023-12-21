# Module UI

#' @title mod_maps_ui and mod_maps_server
#' @description A shiny module.


geographyUI <- function(id, label = "Geography") {
  ns <- NS(id)
  ns("Maps")
  sidebarLayout( # Layout for slicers and other info panels
    sidebarPanel(
      selectInput(ns("var_choice"),
                  "Select Variable of Interest",
                  choices = c("var1", "var2"),
                  selected = "var1",
                  width = '100%'),
      selectInput(ns("geography"), 
                  "Select Geography Level", 
                  choices = c("HA" = "hlth_authority_name", 
                              "HSDA" = "hlth_service_dlvr_area_name", 
                              "LHA" = "local_hlth_area_name", 
                              "CHSA" = "cmnty_hlth_serv_area_name"), 
                  selected = "HA", 
                  width = '100%'),
      uiOutput(ns("region_select")),
      width = 3),
    mainPanel(
      plotOutput(ns("plot")),
      # tableOutput(ns("plot_data")),
      # tableOutput(ns("map_data")),
      width = 9)
  )
}

geographyServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns
      map_data <- map_data 
      geo_selection <- reactive(map_data %>% 
                                  select(all_of(input$geography)) %>% 
                                  distinct() %>% 
                                  filter(is.na(.data[[input$geography]]) == FALSE))
      
      output$region_select <- renderUI({
        selectInput(ns("region_select"), 
                    label = "Select Region(s)", 
                    choices = geo_selection(),
                    multiple = TRUE)
      })
      
      bcmaps_data <- reactive({
        if (input$geography == "hlth_authority_name"){
          bcmaps_data <- bcmaps::health_ha() %>%
            rename_with(tolower, everything())
        }
        if (input$geography == "hlth_service_dlvr_area_name"){
          bcmaps_data <- bcmaps::health_hsda() %>%
            rename_with(tolower, everything())
        }
        if (input$geography == "local_hlth_area_name"){
          bcmaps_data <- bcmaps::health_lha() %>%
            rename_with(tolower, everything())
        }
        if (input$geography == "cmnty_hlth_serv_area_name"){
          bcmaps_data <- bcmaps::health_chsa() %>%
            rename_with(tolower, everything())
        }
        return(bcmaps_data)
      })
      
      # bcmaps_data <- reactive({
      #   if (input$geography == "hlth_authority_name"){
      #     bcmaps_data <- bcmaps::health_ha() %>%
      #       tibble() %>%
      #       select(-c(geometry, SE_ANNO_CAD_DATA)) %>% 
      #       rename_with(tolower, everything())
      #   }
      #   if (input$geography == "hlth_service_dlvr_area_name"){
      #     bcmaps_data <- bcmaps::health_hsda() %>%
      #       tibble() %>%
      #       select(-c(geometry, SE_ANNO_CAD_DATA)) %>% 
      #       rename_with(tolower, everything())
      #   }
      #   if (input$geography == "local_hlth_area_name"){
      #     bcmaps_data <- bcmaps::health_lha() %>%
      #       tibble() %>%
      #       select(-c(geometry, SE_ANNO_CAD_DATA)) %>% 
      #       rename_with(tolower, everything())
      #   }
      #   if (input$geography == "cmnty_hlth_serv_area_name"){
      #     bcmaps_data <- bcmaps::health_chsa() %>%
      #       tibble() %>%
      #       select(-c(geometry, SE_ANNO_CAD_DATA)) %>% 
      #       rename_with(tolower, everything())
      #   }
      #   return(bcmaps_data)
      # }) # for plotting a table to see the reactive is working
      
      
      # plot_data <- map_data %>%
      #   group_by(hlth_authority_name) %>%
      #   top_n(1, var1) %>%
      #   select("hlth_authority_name", "var1")
      
      plot_data <- reactive(map_data %>%
                              group_by(.data[[input$geography]]) %>%
                              top_n(1, .data[[input$var_choice]]) %>%
                              select(all_of(input$geography), all_of(input$var_choice)) %>%
                              filter(.data[[input$geography]] != "All") %>%
                              left_join({bcmaps_data()} %>%
                                          select(all_of(input$geography), geometry),
                                        by = join_by(!!all_of(input$geography)))
                            # The double exclamation deals with the data masking issue
                            # https://stackoverflow.com/questions/77552333/join-by-data-masking-in-dplyr-in-r
      )
      
      # output$plot_data <- renderTable ({
      #   plot_data()
      # })
      # 
      # output$map_data <- renderTable ({
      #   bcmaps_data()
      # }) # to show what is being produced by the reactive dataset
      
      output$plot <- renderPlot({
        ggplot() +
          geom_sf(data = bcmaps::health_ha(), mapping = aes(color = HLTH_AUTHORITY_NAME)) +
          geom_sf(data = plot_data(),
                  mapping = aes(fill = .data[[input$var_choice]], geometry = geometry)) +
          viridis::scale_fill_viridis(direction = -1, option = "D", name = NULL) +
          # ggtitle(c("Plot of ", input$var_choice, " for ", input$geography)) +
          theme_minimal() +
          guides(color = "none", fill = "none") +
          coord_sf(datum = NA)
      })
    }
  )
}

# selectInput(ns("select_geo"),
# "Select Regions",
# choices = ,
# selected = "All",
# multiple = TRUE,
# selectize = TRUE)
# https://stackoverflow.com/questions/61584382/r-shiny-filtering-reactive-inputs
# uiOutput("test_select")
# filtered <- reactive({
#   min_date <- input$dates[1]
#   max_date <- input$dates[2]
#   
#   df %>% 
#     filter(date >= min_date & date <= max_date)
# })
# 
# output$test_select <- renderUI({
#   selectInput("test_select", label = "Select Test", choices = unique(filtered()$test))
# }) 
#https://stackoverflow.com/questions/69952571/shiny-r-filter-dataset-by-a-input-variable
#https://mastering-shiny.org/action-tidy.html
# num_vars <- c("carat", "depth", "table", "price", "x", "y", "z")
# ui <- fluidPage(
#   selectInput("var", "Variable", choices = num_vars),
#   numericInput("min", "Minimum", value = 1),
#   tableOutput("output")
# )
# server <- function(input, output, session) {
#   data <- reactive(diamonds %>% filter(.data[[input$var]] > .env$input$min))
#   output$output <- renderTable(head(data()))
# }

# ui <- fluidPage(
#   selectInput("x", "X variable", choices = names(iris)),
#   selectInput("y", "Y variable", choices = names(iris)),
#   plotOutput("plot")
# )
# server <- function(input, output, session) {
#   output$plot <- renderPlot({
#     ggplot(iris, aes(.data[[input$x]], .data[[input$y]])) +
#       geom_point(position = ggforce::position_auto())
#   }, res = 96)
# }

## copy to body.R
# mod_foo_ui("foo_ui_1")

## copy to app_server.R
# callModule(mod_foo_server, "foo_ui_1")

## copy to sidebar.R
# menuItem("displayName",tabName = "foo",icon = icon("user"))