# Figure out how to build this out and whether/how to include scss styles 

# bslib::bs_add_rules()

dashboard_theme <- bslib::bs_theme(
  version = 5) %>% 
  bs_add_rules(sass::sass_file("www/styles.scss"))
  
# background #f5f5f5
# border #e3e3e3

# https://shiny.posit.co/blog/posts/weather-lookup-bslib/