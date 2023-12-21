header <- function() {
  fluidRow(
    column(width = 2,
           img(src = "C:/Projects/shinyHLTH_templates/www/logo-banner.png")),
    column(width = 10,
           h1(id = "dashboard-title", "Example Dashboard"))
  )
  #titlePanel("Example Dashboard")
  # titlePanel(
  #   h1(
  #     id = "title-panel", "Example Dashboard"
  #     # leave "title-panel, change Example Dashboard to your actual title
  #   )
  # )
}
# background-color: #FFF; z-index: 1; top: -20px;
# preserve the original
# header <- function() {
#   fluidRow(
#     column(width = 12,
#            style = "background-color:#003366; border-bottom:2px solid #fcba19; position:fixed; z-index:10000",
#            tags$header(class="header", 
#                        style="padding:0 0px 0 0px; display:flex; height:80px; width:100%;",
#                        tags$div(class="banner", 
#                                 style="display:flex; justify-content:flex-start; align-items:center; margin: 0 10px 0 10px",
#                                 a(img(src = "www/logo.svg")),
#                                 h1("Disease Trajectory", style="font-weight:400; color:white; margin: 5px 5px 0 18px;")
#                        )
#            )
#     ),
#   )
# }

# Add in the image position on the left, fit title, get sizing right, move as much as possible into the scss or theme.R files