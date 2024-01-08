## code to prepare `map_data` dataset goes here
library(bcmaps)
library(sf)
library(ggplot2)
library(dplyr)

map_data2 <- health_ha() %>% tibble() %>%
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
  rename_with(tolower, everything()) %>%
  ungroup()

save(map_data2, file = "./data/map_data2.rda")
