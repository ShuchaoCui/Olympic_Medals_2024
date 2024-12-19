library(targets)
library(dplyr)

# Define pipeline targets
tar_option_set(packages = c("dplyr", "readr"))

list(
  tar_target(
    raw_data,
    read_csv("medals_2024.csv")
  ),
  tar_target(
    processed_data,
    raw_data %>%
      filter(!is.na(country)) %>%
      mutate(medal_type = factor(medal_type, levels = c("Gold Medal", "Silver Medal", "Bronze Medal")))
  )
)
