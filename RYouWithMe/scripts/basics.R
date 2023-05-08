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

# exploring my own data ----

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
  rename(beachbugs = enterococci_cfu_100ml)

write_csv(cleanbeaches, "cleanbeaches.csv")

#  tying columns in my own data ----

tidydogs <- dogs %>% 
  clean_names() %>%  # since the column names were already very good, it just changed a few (.) to (_) Careful with the autopredict in the next lines, because column names might change
  rename(house_trained = attributes_house_trained,
         spayed_neutered = attributes_spayed_neutered,
         declawed = attributes_declawed,
         spatial_needs = attributes_special_needs) %>% 
  select(id, age, gender, type, species, name, breeds_primary, breeds_secondary, breeds_mixed, breeds_unknown, status, description, contact_address_address1)


write_csv(dogs, "tidydogs.csv")

# Asking questions about the data -----

# Which beach has the most extreme levels of bugs

worstbugs <- cleanbeaches %>% 
  arrange(desc(beachbugs))

worstcoogee <- cleanbeaches %>% 
  filter(site == "Coogee Beach") %>% 
  arrange(-beachbugs)

# lets compare max bug values across different beaches

coogee_bondi <- cleanbeaches %>% 
  filter(site %in% c("Coogee Beach", "Bondi Beach")) %>% 
  arrange(-beachbugs)

cleanbeaches %>% 
 # filter(site %in% c("Coogee Beach", "Bondi Beach")) %>% 
  group_by(site) %>% 
  summarise(maxbug = max(beachbugs, na.rm = TRUE),
            meanbugs = mean(beachbugs, na.rm = TRUE),
            medianbugs = median(beachbugs, na.rm = TRUE),
            sdbugs = sd(beachbugs, na.rm = TRUE))


# lets compare councils

cleanbeaches %>% 
  distinct(council)

councilbysite <- cleanbeaches %>% 
  group_by(council, site) %>% 
  summarise(meanbugs = mean(beachbugs, na.rm = TRUE),
            medianbugs = median(beachbugs, na.rm =TRUE))


# Asking questions about my own data -----

# total number of dogs by breed
countbybreed <- dogs %>% 
  filter(species == "Dog") %>% 
  group_by(breeds.primary, breeds.secondary) %>% 
  count()

# total number of dogs by breed
countbybreedandgenger <- dogs %>% 
  filter(species == "Dog") %>% 
  group_by(breeds.primary, breeds.secondary) %>% 
  count(gender)

# total number of German Shepherd Dogs by primary-secondary breed, age, and gender
gsd <- dogs %>% 
  filter(species == "Dog", breeds.primary == "German Shepherd Dog" | breeds.secondary == "German Shepherd Dog") %>% 
  group_by(breeds.primary, breeds.secondary, age, gender) %>% 
  count()


# compute new variables ----

glimpse(cleanbeaches) 

testdate <- cleanbeaches %>% 
  separate(date, into = c("day", "month", "year"), remove = FALSE)

cleanbeaches %>% 
  unite(council_site, council:site, remove = FALSE)

# use mutate to transform the beachbugs data

summary(cleanbeaches)

cleanbeaches %>% 
  mutate(logbeachbugs = log(beachbugs))

# use mutate to compute numeric variable

cleanbeaches %>% 
  mutate(beachbugsdiff = beachbugs - lag(beachbugs))

# use mutate to compute new logical variable

cleanbeaches %>% 
  mutate(buggier =  beachbugs > mean(beachbugs, na.rm = TRUE))

meanbugs <- mean(cleanbeaches$beachbugs, na.rm = TRUE)

cleanbeaches_new <- cleanbeaches %>% 
  separate(date, c("day", "month","year"), remove = FALSE) %>% 
  mutate(logbeachbugs = log(beachbugs)) %>% 
  mutate(beachbugsdiff = beachbugs - lag(beachbugs)) %>% 
  mutate(buggier_all = beachbugs > mean(beachbugs, na.rm = TRUE)) %>% 
  group_by(site) %>% 
  mutate(buggier_site = beachbugs > mean(beachbugs, na.rm = TRUE))


# compute new variables in my own dataset----

# just checking how many records have a second address
dogs_in_search %>% 
  filter(!is.na(contact.address.address2)) %>% 
  count()

# piping to create a more readable dataset
dogs_in_search <- dogs %>% 
  unite(d_color, colors.primary:colors.secondary:colors.tertiary, sep = " / ") %>% 
  filter(!is.na(contact.address.address1)) %>% 
  select(-contact.address.address2) %>% 
  unite(address, contact.address.address1:contact.address.city:contact.address.state, sep = " ,") %>% 
  mutate(close_distance = distance < 50) %>% # This is unnecessary but just to demonstrate the function mutate
  filter(close_distance == TRUE & type == "Dog") %>% 
  group_by(breeds.primary, age, gender, size) %>% 
  count() %>% 
  rename(count = n, breed = breeds.primary) 

# how many German Shepherds dogs and Shepherds are looking for a forever home?
gsds <- dogs_in_search %>% 
  filter(breed == "German Shepherd Dog" | breed == "Shepherd")
