library(tidyverse)
library(readxl)
library(janitor)


overall_birth_audit <- read_csv("overall_birth_audit.csv")
successful_vbac <- read_excel("successful_vbac.xlsx")
attempted_vbac <- read_excel("attempted_vbac.xlsx")
vbac_rates <- read_excel("vbac_rates.xlsx")


##the last 3 have same column names as each other and long form column names


vbac_rates %>%  clean_names() -> vbac_rates
attempted_vbac <- attempted_vbac %>% clean_names()
successful_vbac <- successful_vbac %>% clean_names()
overall_birth <- overall_birth_audit %>% clean_names()

vbac_rates %>% colnames()
vbac_rates <- vbac_rates %>% rename(vbac_numerator = numerator, vbac_denominator = denominator, vbac_unadjusted = unadjusted_rate, vbac_adjusted = adjusted_rate)
attempted_rates <- attempted_vbac %>% rename(attempted_numerator = numerator, attempted_denominator = denominator, attempted_unadjusted = unadjusted_rate, attempted_adjusted = adjusted_rate)
successful_vbac <- successful_vbac %>% rename(successful_numerator = numerator, successful_denominator = denominator, successful_unadjusted = unadjusted_rate, successful_adjusted = adjusted_rate)

vbac_rates %>% 
    select(site_name, vbac_numerator, vbac_denominator, vbac_unadjusted) %>% 
  drop_na() %>% 
  ggplot(aes(x=vbac_denominator, y = vbac_unadjusted)) + geom_point()

vbac_simple %>% inner_join(vbac_rates)  
