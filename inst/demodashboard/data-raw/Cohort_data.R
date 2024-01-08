## code to prepare `Cohort_data` dataset goes here
library(tidyverse)

Cohort_data <- tibble::tibble(
  id = seq(1:10000),
  gender = sample(c("M", "F"), size = 10000, replace = TRUE, prob = c(.6, .4)),
  age = rnorm(10000, mean = 65, sd = 10)
)

Cohort_data <- Cohort_data %>%
  mutate(age = round(age, digits = 0)) %>%
  mutate(age_group = case_when(age >= 65 ~ "Senior",
                               age <=64 ~ "non-Senior"))

#usethis::use_data(Cohort_data, overwrite = TRUE)

save("Cohort_data", file = "./data/Cohort_data.rda")


