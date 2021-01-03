library(tidyverse)
library(readxl)
library(janitor)

getwd()
overall_birth_audit <- read_csv("overall_birth_audit.csv")
successful_vbac <- read_excel("successful_vbac.xlsx")
attempted_vbac <- read_excel("attempted_vbac.xlsx")
vbac_rates <- read_excel("vbac_rates.xlsx")
overall_birth_audit

##the last 3 have same column names as each other and long form column names


vbac_rates %>%  clean_names() -> vbac_rates
attempted_vbac <- attempted_vbac %>% clean_names()
successful_vbac <- successful_vbac %>% clean_names()
overall_birth <- overall_birth_audit %>% clean_names()

vbac_rates %>% colnames()
vbac_rates <- vbac_rates %>% rename(vbac_numerator = numerator, vbac_denominator = denominator, vbac_unadjusted = unadjusted_rate, vbac_adjusted = adjusted_rate)
attempted_rates <- attempted_vbac %>% rename(attempted_numerator = numerator, attempted_denominator = denominator, attempted_unadjusted = unadjusted_rate, attempted_adjusted = adjusted_rate)
successful_vbac <- successful_vbac %>% rename(successful_numerator = numerator, successful_denominator = denominator, successful_unadjusted = unadjusted_rate, successful_adjusted = adjusted_rate)


successful_vbac %>% 
  drop_na() %>% 
  ggplot(aes(y=successful_unadjusted)) + geom_boxplot()
  


vbac_rates %>% 
    select(site_name, vbac_numerator, vbac_denominator, vbac_unadjusted) %>% 
  drop_na() %>% 
  ggplot(aes(x=vbac_denominator, y = vbac_unadjusted)) + geom_point()

##i want one datatable with sitename and unadjusted for each

attempted_compact <- attempted_rates %>% select(site_name, attempted_unadjusted)
vbac_compact <- vbac_rates %>% select(site_name, vbac_unadjusted)
successful_compact <- successful_vbac %>% select(site_name,successful_unadjusted)

successful_compact %>% inner_join(vbac_compact) %>% inner_join(attempted_compact) %>% drop_na() -> vbac_attempted_success
vbac_attempted_success %>% rename(success_rate = successful_unadjusted, attempt_rate = attempted_unadjusted, vbac_rate = vbac_unadjusted) -> attempted_success_vbac

## this is that file
attempted_success_vbac

attempted_success_vbac %>% ggplot(aes(x=attempt_rate, y = vbac_rate)) + geom_point()
##expect to see good correlation - more you try, the more you do
##does trying more increase the success however of each attempt
attempted_success_vbac %>% ggplot(aes(x=attempt_rate, y=success_rate)) +geom_point() + geom_smooth()
#no

##export my dataset as a csv then load it against the sentiments
write.csv(attempted_success_vbac, "attempted_success_vbac.csv")
getwd()

