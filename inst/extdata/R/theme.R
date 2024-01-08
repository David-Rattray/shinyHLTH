# Figure out how to build this out and whether/how to include scss styles

# bslib::bs_add_rules()

dashboard_theme <- function(...) {
  style <- normalizePath("www/stylesheet.scss")
  theme <- bslib::bs_theme(
    version = 5,
    preset = "bootstrap"
  )
  theme <- bslib::bs_add_rules(theme, sass::sass_file(style))
  theme
}


# background #f5f5f5
# border #e3e3e3

# https://shiny.posit.co/blog/posts/weather-lookup-bslib/
