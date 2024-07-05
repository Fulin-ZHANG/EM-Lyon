# https://juba.github.io/robservable/articles/gallery.html#bar-chart-race-1
# Available for Shiny!!!!
if(!require(robservable)){remotes::install_github("juba/robservable")}
library(tidyverse)
library(gapminder)
library(robservable)
data("gapminder")

d <- gapminder %>%
    rename(id = country,
           date = year,
           value = lifeExp)

robservable(
    "https://observablehq.com/@juba/bar-chart-race",
    include = c("viewof date", "chart", "draw", "styles"),
    hide = "draw",
    input = list(
        data = d,
        title = "Life expectancy through time",
        subtitle = "Evolution of country's life expectancy between 1952 and 2007",
        source = "Source : Gapminder"
    )
)


d <- read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")
d <- d %>%
    select(-`Province/State`, -Lat, -Long) %>%
    rename(id = `Country/Region`) %>%
    group_by(id) %>%
    summarise(across(everything(), sum)) %>%
    pivot_longer(-id, names_to = "date") %>%
    mutate(date = as.character(lubridate::mdy(date)))

robservable(
    "https://observablehq.com/@juba/bar-chart-race",
    include = c("viewof date", "chart", "draw", "styles"),
    hide = "draw",
    input = list(
        data = d,
        title = "COVID-19 deaths",
        subtitle = "Cumulative number of COVID-19 deaths by country",
        source = "Source : Johns Hopkins University"
    )
)
