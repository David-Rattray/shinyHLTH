## code to prepare `map_data` dataset goes here
library(bcmaps)
library(sf)
library(ggplot2)
library(dplyr)

map_data <- health_ha() %>% tibble() %>%
  select(HLTH_AUTHORITY_CODE, HLTH_AUTHORITY_NAME) %>%
  left_join(.,
            health_hsda() %>% tibble() %>%
              select(HLTH_SERVICE_DLVR_AREA_CODE, HLTH_SERVICE_DLVR_AREA_NAME, HLTH_AUTHORITY_CODE),
            by = join_by(HLTH_AUTHORITY_CODE == HLTH_AUTHORITY_CODE)) %>%
  left_join(.,
            health_lha() %>% tibble() %>%
              select(LOCAL_HLTH_AREA_CODE, LOCAL_HLTH_AREA_NAME, HLTH_SERVICE_DLVR_AREA_CODE),
            by = join_by(HLTH_SERVICE_DLVR_AREA_CODE == HLTH_SERVICE_DLVR_AREA_CODE)) %>%
  left_join(.,
            health_chsa() %>% tibble() %>%
              select(CMNTY_HLTH_SERV_AREA_CODE, CMNTY_HLTH_SERV_AREA_NAME, LOCAL_HLTH_AREA_CODE),
            by = join_by(LOCAL_HLTH_AREA_CODE == LOCAL_HLTH_AREA_CODE)) %>%
  mutate(var1 = sample(1:100, size = nrow(.), replace = TRUE),
         var2 = sample(1:100, size = nrow(.), replace = TRUE)) %>%
  full_join(.,
        {.} %>%
          group_by(LOCAL_HLTH_AREA_CODE, LOCAL_HLTH_AREA_NAME) %>%
          summarise(var1 = sum(var1),
                    var2 = sum(var2)) %>%
          ungroup() %>%
          mutate(CMNTY_HLTH_SERV_AREA_NAME = "All"),
        #by = c("LOCAL_HLTH_AREA_NAME", "LOCAL_HLTH_AREA_CODE", "var1", "var2"),
        keep = NULL) %>%
  full_join(.,
        {.} %>%
          filter(is.na(HLTH_AUTHORITY_NAME) == FALSE) %>%
          group_by(HLTH_SERVICE_DLVR_AREA_CODE, HLTH_SERVICE_DLVR_AREA_NAME) %>%
          summarise(var1 = sum(var1),
                    var2 = sum(var2)) %>%
          ungroup() %>%
          mutate(LOCAL_HLTH_AREA_NAME = "All"),
        keep = NULL) %>%
  full_join(.,
            {.} %>%
              filter(is.na(HLTH_AUTHORITY_NAME) == FALSE) %>%
              group_by(HLTH_AUTHORITY_CODE, HLTH_AUTHORITY_NAME) %>%
              summarise(var1 = sum(var1),
                        var2 = sum(var2)) %>%
              ungroup() %>%
              mutate(HLTH_SERVICE_DLVR_AREA_NAME = "All"),
            keep = NULL) %>%
  group_by(LOCAL_HLTH_AREA_CODE) %>%
  tidyr::fill(HLTH_AUTHORITY_CODE:HLTH_SERVICE_DLVR_AREA_NAME, .direction = "down") %>%
  group_by(HLTH_SERVICE_DLVR_AREA_CODE)%>%
  tidyr::fill(HLTH_AUTHORITY_CODE:HLTH_AUTHORITY_NAME, .direction = "down") %>%
  rename_with(tolower, everything()) %>%
  # rename("HA" = hlth_authority_name,
  #        "HSDA" = hlth_service_dlvr_area_name,
  #        "LHA" = local_hlth_area_name,
  #        "CHSA" = cmnty_hlth_serv_area_name
  #        ) %>%
  ungroup()

save(map_data, file = "./data/map_data.rda")
