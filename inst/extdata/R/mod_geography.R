# Module UI

#' @title mod_maps_ui and mod_maps_server
#' @description A shiny module.


geographyUI <- function(id, label = "Geography") {
  sidebarLayout( # Layout for slicers and other info panels
    sidebarPanel(
      selectInput(NS(id, "var_choice"),
                  "Select Variable of Interest",
                  choices = c("var1", "var2"),
                  selected = "var1",
                  width = '100%'),
      selectInput(NS(id, "geography"),
                  "Select Geography Level",
                  choices = c("HA" = "hlth_authority_name",
                              "HSDA" = "hlth_service_dlvr_area_name",
                              "LHA" = "local_hlth_area_name",
                              "CHSA" = "cmnty_hlth_serv_area_name"),
                  selected = "HA",
                  width = '100%'),
      uiOutput(NS(id, "region_select")), #hoping to do some kind of region of interest/zoom in/highlight region option eventually
      width = 3),
    mainPanel(
      plotOutput(NS(id, "plot"),
                 hover = hoverOpts("plot_hover", delay = 100, delayType = "debounce")),
      # tableOutput(NS(id, "plot_data")),
      # tableOutput(NS(id, "map_data")),
      # tableOutput(NS(id, "geo_table")),
      # The above are to check what is being created by the reactives so I can better troubleshoot
      # note that you can't return a list item, so geometry column has to be removed.
      width = 9)
  )
}



geographyServer <- function(id) {
  moduleServer(id, function(input, output, session) {
      map_data2 <- map_data2
      geo_selection <- reactive(map_data2 %>%
                                  select(all_of(input$geography)) %>%
                                  distinct() %>%
                                  filter(is.na(.data[[input$geography]]) == FALSE))

      output$region_select <- renderUI({
        selectInput(NS(id, "region_select"),
                    label = "Select Region(s)",
                    choices = geo_selection(),
                    multiple = TRUE)
      })
# I did the tibble and the select steps to reduce complications with sf types, and to reduce the number of columns
      # plus the geometry as a list item was tricky to deal with as it won't output to a table to check what is being returned in
      # the reactive
      bcmaps_data <- reactive({
        if (input$geography == "hlth_authority_name"){
          bcmaps_data <- bcmaps::health_ha() %>%
            rename_with(tolower, everything()) %>%
            tibble() %>%
            select(hlth_authority_name, geometry)
        }
        if (input$geography == "hlth_service_dlvr_area_name"){
          bcmaps_data <- bcmaps::health_hsda() %>%
            rename_with(tolower, everything()) %>%
            tibble() %>%
            select(hlth_service_dlvr_area_name, geometry)
        }
        if (input$geography == "local_hlth_area_name"){
          bcmaps_data <- bcmaps::health_lha() %>%
            rename_with(tolower, everything()) %>%
            tibble() %>%
            select(local_hlth_area_name, geometry)
        }
        if (input$geography == "cmnty_hlth_serv_area_name"){
          bcmaps_data <- bcmaps::health_chsa() %>%
            rename_with(tolower, everything()) %>%
            tibble() %>%
            select(cmnty_hlth_serv_area_name, geometry)
        }
        return(bcmaps_data)
      })

      plot_data <- reactive({map_data2 %>%
        group_by(across(all_of(as.character(input$geography)))) %>% #this mess deals with the overarching issue of datamasking
          # and tidyselect. In this case as.character converts the input item, then all_of and across team up to identify
          # matches in the data columns to feed into groupby (options around .data[[input$geography]] didn't work)
        summarise(var1 = sum(var1, na.rm = TRUE),
                  var2 = sum(var2, na.rm = TRUE)) %>%
          # would love to find a way to sub var1 for some kind of input$var_choice selector but couldn't get it working
        left_join(bcmaps_data())
      })
      output$plot <- renderPlot({
        ggplot() +
          geom_sf(data = bcmaps::health_ha(), mapping = aes(color = HLTH_AUTHORITY_NAME)) +
          geom_sf(data = plot_data(),
                  mapping = aes(fill = .data[[input$var_choice]], geometry = geometry)) + #.data[[input$var_choice]] solves datamasking
          viridis::scale_fill_viridis(direction = -1, option = "D", name = NULL) +
          # ggtitle(c("Plot of ", input$var_choice, " for ", input$geography)) +
          theme_minimal() +
          guides(color = "none", fill = "none") +
          coord_sf(datum = NA)
      })

      #earlier shenanigans that I'll eventually clear I think
      # plot_data <- reactive({map_data %>%
      #                         group_by(.data[[input$geography]]) %>%
      #                         top_n(1, .data[[input$var_choice]]) %>%
      #                         select(all_of(input$geography), all_of(input$var_choice)) %>%
      #                         filter(.data[[input$geography]] != "All") %>%
      #                         left_join({bcmaps_data()} %>%
      #                                     select(all_of(input$geography), geometry),
      #                                   by = join_by(!!all_of(input$geography)))
      #                       # The double exclamation deals with the data masking issue
      #                       # https://stackoverflow.com/questions/77552333/join-by-data-masking-in-dplyr-in-r
      # })

      # used to display the contents of reactive variables
      # output$plot_data <- renderTable ({
      #   plot_data() %>%  tibble() %>% select(-geometry)
      # })
      #
      # output$map_data <- renderTable ({
      #   bcmaps_data() %>% tibble() %>% select(contains("name"))
      # }) # to show what is being produced by the reactive dataset
      #
      # output$geo_table <- renderTable ({
      #   geo_selection()
      # })

    }
  )
}


# https://stackoverflow.com/questions/69952571/shiny-r-filter-dataset-by-a-input-variable
# https://mastering-shiny.org/action-tidy.html
# https://www.r-bloggers.com/2023/05/maps-with-shiny-pt-2/

## copy to body.R
# mod_foo_ui("foo_ui_1")

## copy to app_server.R
# callModule(mod_foo_server, "foo_ui_1")

## copy to sidebar.R
# menuItem("displayName",tabName = "foo",icon = icon("user"))
