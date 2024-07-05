# Adapted from https://towardsdatascience.com/create-animated-bar-charts-using-r-31d09e5841da
if(!require(gifski)){install.packages(c("gifski", "png"))}
library(tidyverse)
library(gapminder)
library(gganimate)
library(gifski)
library(png)

anim <- gapminder %>%
    group_by(country, year) %>% 
    summarize(avg_life = mean(lifeExp) %>% round(2)) %>%
    group_by(year) %>%
    mutate(life_rank = rank(-avg_life)) %>%
    filter(life_rank <= 10) %>% 
    arrange(year, life_rank) %>%
    ungroup() %>% 
    ggplot(aes(x = life_rank, group = country, fill = country, color = country)) + 
    geom_tile(aes(y = avg_life / 2, height = avg_life, width = 0.7)) + 
    geom_text(aes(y = 0, label = paste(country, " ")), vjust = 0.2, hjust = 1) +
    geom_text(aes(y = avg_life, label = avg_life, hjust=-0.5)) +
    coord_flip(clip = "off", expand = FALSE) + 
    guides(color = FALSE, fill = FALSE) +
    scale_y_continuous(labels = scales::comma) +
    scale_x_reverse() +
    theme(axis.line=element_blank(),
          axis.text.x=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks=element_blank(),
          axis.title.x=element_blank(),
          axis.title.y=element_blank(),
          legend.position="none",
          panel.background=element_blank(),
          panel.border=element_blank(),
          panel.grid.major=element_blank(),
          panel.grid.minor=element_blank(),
          plot.background=element_blank(),
          plot.margin = margin(2,2, 2, 4, "cm")) +
    transition_states(year, transition_length = 4, state_length = 3) +
    labs(title = 'Life expectancy per Year : {closest_state}',  
         subtitle  =  "Top 10 Countries",
         caption  = "Source: gapminder") +
    view_follow(fixed_x = TRUE)

animate(anim, renderer = gifski_renderer(), fps = 5)
