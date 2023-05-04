# load packages -----

library(tidyverse)
library(here)
library(skimr)
library(janitor)

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

# tying columns ----

glimpse(beaches)

select_all(beaches, toupper)
select_all(beaches, tolower)

cleanbeaches <- clean_names(beaches)

names(beaches)

# for rename use newname = oldname
cleanbeaches <- rename(cleanbeaches, beachbugs = enterococci_cfu_100ml)

names(cleanbeaches)
