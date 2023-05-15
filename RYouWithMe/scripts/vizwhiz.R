#load packages ------

library(tidyverse)
library(here)
library(ggbeeswarm)


#read in cleanbeaches_new_data----
plotbeaches <- read_csv(here("data","cleanbeaches_new.csv"))

#plot buglevels by year----
plotbeaches %>% 
  ggplot(aes(x = year, y = beachbugs)) +
  geom_point()

# summarising how many obs per year
plotbeaches %>% 
  group_by(year) %>% 
  summarise(obs = n())

#replotting bug levels by year using jitter
plotbeaches %>% 
  ggplot(aes(x = year, y = beachbugs)) +
  geom_jitter()

#replotting bug levels by year trying quasirandom ("smiley" and "frowney"). 
# These methods didn't work because of the data
plotbeaches %>% 
  ggplot(aes(x = year, y = beachbugs)) +
  geom_quasirandom(method = "smiley")

plotbeaches %>% 
  ggplot(aes(x = year, y = beachbugs)) +
  geom_quasirandom(method = "frowney")

#replotting bug levels by year trying geom_beeswarm
plotbeaches %>% 
  ggplot(aes(x = year, y = beachbugs)) +
  geom_beeswarm()

# plot bug levels by site-----
plotbeaches %>% 
  na.omit() %>% 
  ggplot(aes(x = site,  y = beachbugs, color = year)) +
    geom_jitter() +
    coord_flip()

# checking year format
class(plotbeaches$year)
glimpse(plotbeaches)

#coerce year to be factor rather than integer
plotbeaches$year <- as.factor(plotbeaches$year)

# coloring the points by another variable: month
plotbeaches %>% 
  na.omit() %>% 
  ggplot(aes(x = site,  y = beachbugs, color = month)) +
  geom_jitter() +
  coord_flip()

#facet wrap -----
plotbeaches %>% 
  na.omit() %>% 
  ggplot(aes(x = year,  y = beachbugs, color = site)) +
  geom_jitter() +
  facet_wrap(~ site)

#combine filter and ggplot
plotbeaches %>% 
  na.omit() %>% 
  filter(beachbugs < 1000) %>% 
  ggplot(aes(x = year, y = beachbugs, color = site)) +
  geom_jitter() +
  facet_wrap(~site)

#compare data for two beaches. Combining filter and ggplot
plotbeaches %>% 
  na.omit() %>% 
  filter(beachbugs < 1000) %>% 
  filter(site %in% c("Coogee Beach", "Bondi Beach")) %>% 
  ggplot(aes(x = year, y = beachbugs, color = site)) +
  geom_jitter() +
  facet_wrap(~site)

# get ggplot out of R ----
ggsave(here("output", "coogeebondi.png"))
  