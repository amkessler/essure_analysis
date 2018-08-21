#NOTE: ingestion scripts to generate the rds files here found in companion file 01_...)

library(tidyverse)

bayer2017 <- readRDS("processed_data/bayer2017.rds")
bayer2016 <- readRDS("processed_data/bayer2016.rds")
bayer2015 <- readRDS("processed_data/bayer2015.rds")
bayer2014 <- readRDS("processed_data/bayer2014.rds")
bayer2013 <- readRDS("processed_data/bayer2013.rds")



#----------------------------
####combine 2013 to 2015 ####
bayer_1315_combo <- rbind(bayer2013, bayer2014, bayer2015)

#checking shows Essure only appears in Med Supply 1 field
bayer_1315_combo %>% 
  group_by(Name_of_Associated_Covered_Device_or_Medical_Supply1) %>% 
  tally()

#pull out just essure records
bayer_1315_essure <- bayer_1315_combo %>% 
  filter(Name_of_Associated_Covered_Device_or_Medical_Supply1 %in% c("Essure", "ESSURE") &
          Physician_Profile_ID > 0
         )




#--------------------------------
##### combine 2016 and 2017 #####
bayer_1617_combo <- rbind(bayer2016, bayer2017)

names(bayer_1617_combo)

#essure appears in medical device 1 through 4 fields
bayer_1617_combo %>% 
  filter(Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 == "Device") %>% 
  group_by(Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_1) %>% 
  tally() 

#pull out only records with Essure referenced
bayer_1617_essure <- bayer_1617_combo %>% 
  filter(Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_1 %in% c("Essure", "ESSURE") |
         Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_2 %in% c("Essure", "ESSURE") |
         Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_3 %in% c("Essure", "ESSURE") |
         Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_4 %in% c("Essure", "ESSURE") &
           Physician_Profile_ID > 0) 



#check grand totals
sum(bayer_1315_essure$Total_Amount_of_Payment_USDollars) 
sum(bayer_1617_essure$Total_Amount_of_Payment_USDollars)



#----------------------------------------------------
### SELECT FIELDS AND MERGE 2013-15 WITH 2016-17 ####



temp1 <- bayer_1315_essure %>% 
  select(Covered_Recipient_Type,
         Physician_Profile_ID,
         Physician_First_Name,
         Physician_Middle_Name,
         Physician_Last_Name,
         Physician_Name_Suffix,
         Recipient_Primary_Business_Street_Address_Line1,
         Recipient_Primary_Business_Street_Address_Line2,
         Recipient_City,
         Recipient_State,
         Recipient_Zip_Code,
         Physician_Primary_Type,
         Physician_Specialty,
         Physician_License_State_code1,
         Physician_License_State_code2,
         Physician_License_State_code3,
         Physician_License_State_code4,
         Physician_License_State_code5,
         Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name,
         Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID,
         Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name,
         Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State,
         Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Country,
         Total_Amount_of_Payment_USDollars,
         Date_of_Payment,
         Number_of_Payments_Included_in_Total_Amount,
         Form_of_Payment_or_Transfer_of_Value,
         Nature_of_Payment_or_Transfer_of_Value,
         City_of_Travel,
         State_of_Travel,
         Country_of_Travel,
         Physician_Ownership_Indicator,
         Third_Party_Payment_Recipient_Indicator,
         Name_of_Third_Party_Entity_Receiving_Payment_or_Transfer_of_Value,
         Charity_Indicator,
         Third_Party_Equals_Covered_Recipient_Indicator,
         Contextual_Information,
         Delay_in_Publication_Indicator,
         Record_ID,
         Program_Year,
         Payment_Publication_Date
        )


temp2 <- bayer_1617_essure %>% 
  select(Covered_Recipient_Type,
         Physician_Profile_ID,
         Physician_First_Name,
         Physician_Middle_Name,
         Physician_Last_Name,
         Physician_Name_Suffix,
         Recipient_Primary_Business_Street_Address_Line1,
         Recipient_Primary_Business_Street_Address_Line2,
         Recipient_City,
         Recipient_State,
         Recipient_Zip_Code,
         Physician_Primary_Type,
         Physician_Specialty,
         Physician_License_State_code1,
         Physician_License_State_code2,
         Physician_License_State_code3,
         Physician_License_State_code4,
         Physician_License_State_code5,
         Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name,
         Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID,
         Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name,
         Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State,
         Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Country,
         Total_Amount_of_Payment_USDollars,
         Date_of_Payment,
         Number_of_Payments_Included_in_Total_Amount,
         Form_of_Payment_or_Transfer_of_Value,
         Nature_of_Payment_or_Transfer_of_Value,
         City_of_Travel,
         State_of_Travel,
         Country_of_Travel,
         Physician_Ownership_Indicator,
         Third_Party_Payment_Recipient_Indicator,
         Name_of_Third_Party_Entity_Receiving_Payment_or_Transfer_of_Value,
         Charity_Indicator,
         Third_Party_Equals_Covered_Recipient_Indicator,
         Contextual_Information,
         Delay_in_Publication_Indicator,
         Record_ID,
         Program_Year,
         Payment_Publication_Date
  )


#combine into final table for analysis
essure_allyears <- rbind(temp1, temp2)

#clean up objects
rm(bayer2017,
   bayer2016,
   bayer2015,
   bayer2014,
   bayer2013,
   temp1,
   temp2
   )







##########################################################################
####  END OF GENERAL PAYMENT FILES IMPORT -- START OF RESEARCH FILES #####
##########################################################################



bayer2017_RESEARCH <- readRDS("processed_data/bayer2017_RESEARCH.rds")
bayer2016_RESEARCH <- readRDS("processed_data/bayer2016_RESEARCH.rds")
bayer2015_RESEARCH <- readRDS("processed_data/bayer2015_RESEARCH.rds")
bayer2014_RESEARCH <- readRDS("processed_data/bayer2014_RESEARCH.rds")
bayer2013_RESEARCH <- readRDS("processed_data/bayer2013_RESEARCH.rds")



#----------------------------
####combine 2013 to 2015 ####
bayer_RESEARCH_1315_combo <- rbind(bayer2013_RESEARCH, bayer2014_RESEARCH, bayer2015_RESEARCH)

#checking shows Essure only appears in Med Supply 1 field
bayer_RESEARCH_1315_combo %>% 
  group_by(Name_of_Associated_Covered_Device_or_Medical_Supply1) %>% 
  tally()

#pull out just essure records
bayer_RESEARCH_1315_essure <- bayer_RESEARCH_1315_combo %>% 
  filter(Name_of_Associated_Covered_Device_or_Medical_Supply1 %in% c("Essure", "ESSURE") 
        )


#--------------------------------
##### combine 2016 and 2017 #####
bayer_RESEARCH_1617_combo <- rbind(bayer2016_RESEARCH, bayer2017_RESEARCH)

names(bayer_RESEARCH_1617_combo)

#essure appears in medical device 1 field
bayer_RESEARCH_1617_combo %>% 
  filter(Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1 == "Device") %>% 
  group_by(Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_1) %>% 
  tally() 


#pull out only records with Essure referenced
bayer_RESEARCH_1617_essure <- bayer_RESEARCH_1617_combo %>% 
  filter(Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_1 %in% c("Essure", "ESSURE") |
           Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_2 %in% c("Essure", "ESSURE") |
           Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_3 %in% c("Essure", "ESSURE") |
           Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_4 %in% c("Essure", "ESSURE") )



#check grand totals
sum(bayer_RESEARCH_1315_essure$Total_Amount_of_Payment_USDollars) 
sum(bayer_RESEARCH_1617_essure$Total_Amount_of_Payment_USDollars)


#calculate totals for research and general for essure
sum(bayer_RESEARCH_1315_essure$Total_Amount_of_Payment_USDollars) +
sum(bayer_RESEARCH_1617_essure$Total_Amount_of_Payment_USDollars)

sum(bayer_1315_essure$Total_Amount_of_Payment_USDollars) +
sum(bayer_1617_essure$Total_Amount_of_Payment_USDollars)


sum(bayer_RESEARCH_1315_essure$Total_Amount_of_Payment_USDollars) +
sum(bayer_RESEARCH_1617_essure$Total_Amount_of_Payment_USDollars) +
sum(bayer_1315_essure$Total_Amount_of_Payment_USDollars) +
sum(bayer_1617_essure$Total_Amount_of_Payment_USDollars)


#remove unneeded tables
rm(bayer2013_RESEARCH)
rm(bayer2014_RESEARCH)
rm(bayer2015_RESEARCH)
rm(bayer2016_RESEARCH)
rm(bayer2017_RESEARCH)



#---------------------------group_by()-----
#Build grouped doctor tables by ID for all bayer research #####

b0 <- bayer_RESEARCH_1315_combo %>%
  group_by(id = Physician_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

b1 <- bayer_RESEARCH_1315_combo %>%
  group_by(id = Principal_Investigator_1_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

b2 <- bayer_RESEARCH_1315_combo %>%
  group_by(id =Principal_Investigator_2_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

b3 <- bayer_RESEARCH_1315_combo %>%
  group_by(id = Principal_Investigator_3_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

b4 <- bayer_RESEARCH_1315_combo %>%
  group_by(id = Principal_Investigator_4_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

b5 <- bayer_RESEARCH_1315_combo %>%
  group_by(id= Principal_Investigator_5_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

#2016-17
b0b <- bayer_RESEARCH_1617_combo %>%
  group_by(id = Physician_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

b1b <- bayer_RESEARCH_1617_combo %>%
  group_by(id = Principal_Investigator_1_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

b2b <- bayer_RESEARCH_1617_combo %>%
  group_by(id =Principal_Investigator_2_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

b3b <- bayer_RESEARCH_1617_combo %>%
  group_by(id = Principal_Investigator_3_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

b4b <- bayer_RESEARCH_1617_combo %>%
  group_by(id = Principal_Investigator_4_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

b5b <- bayer_RESEARCH_1617_combo %>%
  group_by(id= Principal_Investigator_5_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

b_comb <- rbind(b0, b1, b2, b3, b4, b5, b0b, b1b, b2b, b3b, b4b, b5b)

rm(b0, b1, b2, b3, b4, b5, b0b, b1b, b2b, b3b, b4b, b5b)

#final variable grouped by id
researchtotal_bayer_byid <- b_comb %>% 
  group_by(id) %>% 
  summarise(sum(`sum(Total_Amount_of_Payment_USDollars)`))

colnames(researchtotal_bayer_byid) <- c("Physician_Profile_ID", "total_research_bayer_payments")
researchtotal_bayer_byid$Physician_Profile_ID <- as.integer(researchtotal_bayer_byid$Physician_Profile_ID)


#Build grouped doctor tables by ID for all ESSURE research #####

e0 <- bayer_RESEARCH_1315_essure %>%
  group_by(id = Physician_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

e1 <- bayer_RESEARCH_1315_essure %>%
  group_by(id = Principal_Investigator_1_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

e2 <- bayer_RESEARCH_1315_essure %>%
  group_by(id =Principal_Investigator_2_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

e3 <- bayer_RESEARCH_1315_essure %>%
  group_by(id = Principal_Investigator_3_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

e4 <- bayer_RESEARCH_1315_essure %>%
  group_by(id = Principal_Investigator_4_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

e5 <- bayer_RESEARCH_1315_essure %>%
  group_by(id= Principal_Investigator_5_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

#2016-17
e0b <- bayer_RESEARCH_1617_essure %>%
  group_by(id = Physician_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

e1b <- bayer_RESEARCH_1617_essure %>%
  group_by(id = Principal_Investigator_1_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

e2b <- bayer_RESEARCH_1617_essure %>%
  group_by(id =Principal_Investigator_2_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

e3b <- bayer_RESEARCH_1617_essure %>%
  group_by(id = Principal_Investigator_3_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

e4b <- bayer_RESEARCH_1617_essure %>%
  group_by(id = Principal_Investigator_4_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

e5b <- bayer_RESEARCH_1617_essure %>%
  group_by(id= Principal_Investigator_5_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))

e_comb <- rbind(e0, e1, e2, e3, e4, e5, e0b, e1b, e2b, e3b, e4b, e5b)

rm(e0, e1, e2, e3, e4, e5, e0b, e1b, e2b, e3b, e4b, e5b)

#final variable grouped by id
researchtotal_essure_byid <- e_comb %>% 
  group_by(id) %>% 
  summarise(sum(`sum(Total_Amount_of_Payment_USDollars)`))

colnames(researchtotal_essure_byid) <- c("Physician_Profile_ID", "total_research_essure_payments")
researchtotal_essure_byid$Physician_Profile_ID <- as.integer(researchtotal_essure_byid$Physician_Profile_ID)


rm(b_comb, e_comb)
