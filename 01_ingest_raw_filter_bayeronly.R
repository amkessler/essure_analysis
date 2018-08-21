# NOTE: OPENPAYMENTS GENERAL PAYMENTS FOR EACH YEAR CAN BE DOWNLOADED HERE:
# https://www.cms.gov/OpenPayments/Explore-the-Data/Dataset-Downloads.html

# The downloaded zip files contain several CSVs - the general payments and research payments
# files are what's used here, and each year has a separate file
# The physicians lookup file is also used to join details of physicians 


library(tidyverse)


#### 2017 IMPORT AND SLICE ####

generalpayments_2017 <- read_csv("raw_data/OP_DTL_GNRL_PGYR2017_P06292018.csv")

names(generalpayments_2017)

#pull out just Bayer records
bayer2017 <- generalpayments_2017 %>% 
  filter(str_detect(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name, "Bayer")) 

#check names
bayer2017 %>% 
  group_by(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name) %>% 
  tally()

#save result as RDS
saveRDS(bayer2017, file = "bayer2017.rds")



#### 2016 IMPORT AND SLICE ####

generalpayments_2016 <- read_csv("raw_data/OP_DTL_GNRL_PGYR2016_P06292018.csv")

names(generalpayments_2016)

#pull out just Bayer records
bayer2016 <- generalpayments_2016 %>% 
  filter(str_detect(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name, "Bayer")) 

#check names
bayer2016 %>% 
  group_by(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name) %>% 
  tally()

#save result as RDS
saveRDS(bayer2016, file = "bayer2016.rds")



#### 2015 IMPORT AND SLICE ####
##note: is a different field structure from 2015 prior, compared to 2016-17

generalpayments_2015 <- read_csv("raw_data/OP_DTL_GNRL_PGYR2015_P06292018.csv")

names(generalpayments_2015)

#pull out just Bayer records
bayer2015 <- generalpayments_2015 %>% 
  filter(str_detect(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name, "Bayer")) 

#check names
bayer2015 %>% 
  group_by(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name) %>% 
  tally()

#save result as RDS
saveRDS(bayer2015, file = "bayer2015.rds")



#### 2014 IMPORT AND SLICE ####

generalpayments_2014 <- read_csv("raw_data/OP_DTL_GNRL_PGYR2014_P06292018.csv")

names(generalpayments_2014)

#pull out just Bayer records
bayer2014 <- generalpayments_2014 %>% 
  filter(str_detect(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name, "Bayer")) 

#check names
bayer2014 %>% 
  group_by(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name) %>% 
  tally()

#save result as RDS
saveRDS(bayer2014, file = "bayer2014.rds")





#### 2013 IMPORT AND SLICE ####

generalpayments_2013 <- read_csv("raw_data/OP_DTL_GNRL_PGYR2013_P06292018.csv")

names(generalpayments_2013)

#pull out just Bayer records
bayer2013 <- generalpayments_2013 %>% 
  filter(str_detect(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name, "Bayer")) 

#check names
bayer2013 %>% 
  group_by(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name) %>% 
  tally()

#save result as RDS
saveRDS(bayer2013, file = "bayer2013.rds")



#### physician profile table #####
physicians_lookup <- read_csv("raw_data/OP_PH_PRFL_SPLMTL_P06292018.csv")
saveRDS(physicians_lookup, file = "physicians_lookup.rds")




##########################################################################
####  END OF GENERAL PAYMENT FILES IMPORT -- START OF RESEARCH FILES #####
##########################################################################



#2017

researchpayments_2017 <- read_csv("raw_data/OP_DTL_RSRCH_PGYR2017_P06292018.csv")

#pull out just Bayer records
bayer2017_RESEARCH <- researchpayments_2017 %>% 
  filter(str_detect(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name, "Bayer")) 

#check names
bayer2017_RESEARCH %>% 
  group_by(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name) %>% 
  tally()

#save result as RDS
saveRDS(bayer2017_RESEARCH, file = "processed_data/bayer2017_RESEARCH.rds")


#2016

researchpayments_2016 <- read_csv("raw_data/OP_DTL_RSRCH_PGYR2016_P06292018.csv")

names(researchpayments_2016)

#pull out just Bayer records
bayer2016_RESEARCH <- researchpayments_2016 %>% 
  filter(str_detect(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name, "Bayer")) 

#check names
bayer2016_RESEARCH %>% 
  group_by(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name) %>% 
  tally()

#save result as RDS
saveRDS(bayer2016_RESEARCH, file = "processed_data/bayer2016_RESEARCH.rds")



#### 2015 
##note: is a different field structure from 2015 prior, compared to 2016-17

researchpayments_2015 <- read_csv("raw_data/OP_DTL_RSRCH_PGYR2015_P06292018.csv")

names(researchpayments_2015)

#pull out just Bayer records
bayer2015_RESEARCH <- researchpayments_2015 %>% 
  filter(str_detect(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name, "Bayer")) 

#check names
bayer2015_RESEARCH %>% 
  group_by(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name) %>% 
  tally()

#save result as RDS
saveRDS(bayer2015_RESEARCH, file = "processed_data/bayer2015_RESEARCH.rds")


#### 2014 

researchpayments_2014 <- read_csv("raw_data/OP_DTL_RSRCH_PGYR2014_P06292018.csv")

names(researchpayments_2014)

#pull out just Bayer records
bayer2014_RESEARCH <- researchpayments_2014 %>% 
  filter(str_detect(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name, "Bayer")) 

#check names
bayer2014_RESEARCH %>% 
  group_by(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name) %>% 
  tally()

#save result as RDS
saveRDS(bayer2014_RESEARCH, file = "processed_data/bayer2014_RESEARCH.rds")


#### 2013 

researchpayments_2013 <- read_csv("raw_data/OP_DTL_RSRCH_PGYR2013_P06292018.csv")

names(researchpayments_2013)

#pull out just Bayer records
bayer2013_RESEARCH <- researchpayments_2013 %>% 
  filter(str_detect(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name, "Bayer")) 

#check names
bayer2013_RESEARCH %>% 
  group_by(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name) %>% 
  tally()

#save result as RDS
saveRDS(bayer2013_RESEARCH, file = "processed_data/bayer2013_RESEARCH.rds")
