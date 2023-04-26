# load packages -----

library(tidyverse)
library(here)
library(skimr)

# read in data ----

beaches <- read_csv(here("data","sydneybeaches.csv"))

# exploring the data ----

View(beaches)

dim(beaches)

str(beaches)

glimpse(beaches)

head(beaches)

tail(beaches)

summary(beaches)

skim(beaches)


# read in my own data ----

dogs <- read_csv(here("data","dogs_LA_data.csv.csv")) # dogs looking for forever homes in LA (via Petfinder.com)

# exploring the data ----

skim(dogs)

View(dogs)

summary(dogs)
