# Module UI

#' @title mod_maps_ui and mod_maps_server
#' @description A shiny module.


informationUI <- function(id, label = "Information") {
  layout_columns(
    # tags$style('div[data-value="Plot"]{
    #              height: 400px;
    #              background-image: url(https://cdn.pixabay.com/photo/2015/04/19/08/32/marguerite-729510_960_720.jpg);
    #            }'
    #            ),
    value_box(
      title = "How to cite this report?",
      value = textOutput(NS(id, "report_citation")),
      showcase = uiOutput(NS(id, "clip")),
      showcase_layout = "top right",
      max_height = "200px",
      class = "citation-box"
    )
  )
}


# Module Server
informationServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Add clipboard buttons
    # output$clip <- renderUI({
    #   rclipButton(
    #     inputId = NS(id, "clipbtn"),
    #     label = "rclipButton Copy",
    #     clipText = input$copytext,
    #     icon = icon("clipboard"),
    #     tooltip = "Click me... I dare you!",
    #     placement = "top",
    #     options = list(delay = list(show = 800, hide = 100), trigger = "hover")
    #   )
    # })
    citation <- paste0("Ministry of Health. Report ID: 42. Example Dashboard. Retreived from: www.example.ca. Last accessed on: ",
                       Sys.Date())
    output$report_citation <- renderText({
      citation
    })

    output$clip <- renderUI({
      rclipButton(
        inputId = NS(id, "clipbtn"),
        label = "",
        clipText = citation,
        icon = icon("copy"),
        tooltip = "Copy citation",
        placement = "top",
        options = list(delay = list(show = 800, hide = 100), trigger = "hover")
      )
    })
  })
}

## copy to body.R
# mod_foo_ui("foo_ui_1")

## copy to app_server.R
# callModule(mod_foo_server, "foo_ui_1")

## copy to sidebar.R
# menuItem("displayName",tabName = "foo",icon = icon("user"))
