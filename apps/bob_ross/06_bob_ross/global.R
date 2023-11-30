library(dplyr)
library(tidyr)
library(readr)
library(ggplot2)
library(forcats)
library(stringr)

# Tidy the data
elements <- read_csv("data/elements-by-episode.csv") %>% 
  separate(EPISODE, c("season", "episode"), sep = c(3,6)) %>%
  pivot_longer(cols = c(-season, -episode, -TITLE), names_to = "element", values_to = "exists") %>%  
  mutate(
    season = parse_number(season),
    episode = parse_number(episode),
    element = str_to_sentence(str_replace_all(element, "_", " ")),
    TITLE = str_to_sentence(TITLE),
    exists = as.logical(exists)
  ) %>% 
  rename(title = TITLE)
