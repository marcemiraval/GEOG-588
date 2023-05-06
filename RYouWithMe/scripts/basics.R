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

# select subset of columns
select(cleanbeaches, council, site, beachbugs, everything())

# pipe %>%

cleanbeaches <- beaches %>%
  clean_names() %>% 
  rename(beachbugs = enterococci_cfu_100ml) %>% 
  select(site, council, beachbugs)

write_csv(cleanbeaches, "cleanbeaches.csv")

# exploring my own data ----

tidydogs <- dogs %>% 
  clean_names() %>%  # since the column names were already very good, it just changed a few (.) to (_) Careful with the autopredict in the next lines, because column names might change
  rename(house_trained = attributes_house_trained,
         spayed_neutered = attributes_spayed_neutered,
         declawed = attributes_declawed,
         spatial_needs = attributes_special_needs) %>% 
  select(id, age, gender, type, species, name, breeds_primary, breeds_secondary, breeds_mixed, breeds_unknown, status, description, contact_address_address1)


write_csv(dogs, "tidydogs.csv")
