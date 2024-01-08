header <- function() {
  card(id = "main-header",
       card_header(id = "main-header-card",
                   card_image("www/HSIAR-Logo.png",
                              border_radius = "none",
                              class = "header-image",
                              fill = TRUE,
                              width = 200,
                              container = htmltools::span),
                   card_title(id = "header-text",
                              "Demonstration Dashboard",
                              container = htmltools::span)
       )
  )
}
