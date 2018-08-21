# NOTE: need to run 02_clean_and_combine_bayer to generate the dataframe
#       essure_allyears used in this file

library(tidyverse)
library(janitor)
options(scipen = 999)

source("02_clean_and_combine_bayer.R")

physicians_lookup <- readRDS("processed_data/physicians_lookup.rds")



#start off with grouping essure payments by year
essure_allyears %>% 
  group_by(Program_Year) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars))


##group by doctors #####

#group by top doctors
topdocs <- essure_allyears %>% 
  group_by(Physician_Profile_ID) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars)) %>% 
  arrange(desc(`sum(Total_Amount_of_Payment_USDollars)`))
head(topdocs)

#join to physician lookup info
topdocs <- inner_join(topdocs, physicians_lookup)
head(topdocs)
names(topdocs)

#remove unneeded columns
topdocs <- topdocs %>% 
  select(-c(Physician_Profile_Alternate_First_Name,
            Physician_Profile_Alternate_Middle_Name,
            Physician_Profile_Alternate_Last_Name,   
            Physician_Profile_Alternate_Suffix,     
            Physician_Profile_Country_Name,         
            Physician_Profile_Province_Name,           
            Physician_Profile_OPS_Taxonomy_1,        
            Physician_Profile_OPS_Taxonomy_2,       
            Physician_Profile_OPS_Taxonomy_3,
            Physician_Profile_OPS_Taxonomy_4,       
            Physician_Profile_OPS_Taxonomy_5,
            Physician_Profile_License_State_Code_3, 
            Physician_Profile_License_State_Code_4,  
            Physician_Profile_License_State_Code_5)
            ) 

#rename
topdocs$Total_Payments <- topdocs$`sum(Total_Amount_of_Payment_USDollars)`
topdocs$`sum(Total_Amount_of_Payment_USDollars)` <- NULL

#export result to csv
write.csv(topdocs, "output/topdocs.csv", na="")


topdocs %>% 
  group_by(Physician_Profile_State) %>% 
  summarise(totpay=sum(Total_Payments)) %>% 
  arrange(desc(totpay))



### creating table with individual years for each doc ####

docs_byyear <- essure_allyears %>% 
  group_by(Physician_Profile_ID, Program_Year) %>% 
  summarise(sum(Total_Amount_of_Payment_USDollars)) 


#spread out data
docs_byyear_wide <- docs_byyear %>% 
  spread(Program_Year, `sum(Total_Amount_of_Payment_USDollars)`)


#join to physician lookup info
docs_byyear_wide <- inner_join(docs_byyear_wide, physicians_lookup)
head(docs_byyear_wide)
names(docs_byyear_wide)

#remove unneeded columns
docs_byyear_wide <- docs_byyear_wide %>% 
  select(-c(Physician_Profile_Alternate_First_Name,
            Physician_Profile_Alternate_Middle_Name,
            Physician_Profile_Alternate_Last_Name,   
            Physician_Profile_Alternate_Suffix,     
            Physician_Profile_Country_Name,         
            Physician_Profile_Province_Name,           
            Physician_Profile_OPS_Taxonomy_1,        
            Physician_Profile_OPS_Taxonomy_2,       
            Physician_Profile_OPS_Taxonomy_3,
            Physician_Profile_OPS_Taxonomy_4,       
            Physician_Profile_OPS_Taxonomy_5,
            Physician_Profile_License_State_Code_3, 
            Physician_Profile_License_State_Code_4,  
            Physician_Profile_License_State_Code_5)
  ) 

head(docs_byyear_wide)

#create total for all years column
df1 <- docs_byyear_wide[,2:6]

df1 <- df1 %>%
  replace(is.na(.), 0) %>%
  mutate(totpayments = rowSums(.[1:5]))

tots <- df1[ ,6]

docs_byyear_wide$totpayments <- tots$totpayments

#reorder columns
names(docs_byyear_wide)

docs_byyear_wide <- docs_byyear_wide %>% 
  select(Physician_Profile_ID,
         `2013`,
         `2014`,
         `2015`,
         `2016`,
         `2017`,
         totpayments,
         everything()) 


### CREATING AND ADDING VARIABLE FOR ALL BAYER PAYMENTS PER DOCTOR ####
bayall1 <- bayer_1315_combo %>% 
  group_by(Physician_Profile_ID) %>% 
  summarise(allbayerpayments = sum(Total_Amount_of_Payment_USDollars))

bayall2 <- bayer_1617_combo %>% 
  group_by(Physician_Profile_ID) %>% 
  summarise(allbayerpayments = sum(Total_Amount_of_Payment_USDollars))

bayall3 <- rbind(bayall1, bayall2)

#unique phys IDs with total bayer payments all years
bayall4 <- bayall3 %>% 
  group_by(Physician_Profile_ID) %>% 
  summarise(allbayerpayments = sum(allbayerpayments))

head(docs_byyear_wide)

#join
tempjoin <- left_join(docs_byyear_wide, bayall4)

#add pct column
tempjoin$essure_pctof_bayer <- round((tempjoin$totpayments / tempjoin$allbayerpayments), 3)

#add difference to calculate non-essure bayer payments
tempjoin$extrabayerpay <- round((tempjoin$allbayerpayments-tempjoin$totpayments),3)


### JOINING PAYMENTS FROM RESEARCH FILES ####
#join
tempjoin1 <- left_join(tempjoin, researchtotal_bayer_byid)

#join
tempjoin2 <- left_join(tempjoin1, researchtotal_essure_byid)



### FINISHING UP #####

#rename and sort
topdocs_byyear <- tempjoin2 %>% 
  arrange(desc(totpayments))

#clean up column names of final table w/ janitor
# topdocs_byyear <- clean_names(topdocs_byyear)

head(topdocs_byyear)  

#export result to csv
write.csv(topdocs_byyear, "output/topdocs_byyear.csv", na="")


### QUESTIONS FROM E & J ####

sum(topdocs_byyear$totpayments, na.rm = TRUE)
sum(topdocs_byyear$total_research_essure_payments, na.rm = TRUE)


#research study names
bayer_RESEARCH_1617_essure %>%
  group_by(Name_of_Study) %>%
  summarize(sum(Total_Amount_of_Payment_USDollars)) %>%
  arrange(desc(`sum(Total_Amount_of_Payment_USDollars)`))

bayer_RESEARCH_1315_essure %>%
  group_by(Name_of_Study) %>%
  summarize(sum(Total_Amount_of_Payment_USDollars)) %>%
  arrange(desc(`sum(Total_Amount_of_Payment_USDollars)`))


##Calculating how many doctors Bayer is paying doctors nationwide for Essure
t1 <- topdocs_byyear %>%
  filter(totpayments>0) %>%
  group_by(Physician_Profile_ID) %>%
  summarise(sum=sum(totpayments))

t2 <- topdocs_byyear %>%
  filter(total_research_essure_payments>0) %>%
  group_by(Physician_Profile_ID) %>%
  summarise(sum=sum(total_research_essure_payments))

t3 <- rbind(t1,t2)

t4 <- t3%>%
  group_by(Physician_Profile_ID) %>%
  summarise(tot=sum(sum))

sum(t4$tot)


## final slices for J for Basinski interview ####
basinski1315 <- bayer_1315_essure %>% 
  filter(Physician_Last_Name == "BASINSKI",
         Physician_First_Name == "CINDY")


basinski1617 <- bayer_1617_essure %>% 
  filter(Physician_Last_Name == "BASINSKI",
         Physician_First_Name == "CINDY")

write.csv(basinski1315, "output/basinski1315_gen.csv")
write.csv(basinski1617, "output/basinski1617_gen.csv")


#grouped by state
topdocs_byyear %>% 
  filter(totpayments > 0)



essure_allyears %>% 
  group_by(Physician_Profile_ID) %>% 
  tally()

write.csv(docs_byyear_wide, "output/temp.csv")



#pulling out just MDs and osteopaths #####
justdocs <- docs_byyear_wide %>% 
  filter(str_detect(Physician_Profile_Primary_Specialty,"Physicians"))

sum(justdocs$totpayments)

justdocs %>% 
  tally()
  
temp1 <- justdocs %>% 
  group_by(Physician_Profile_Primary_Specialty) %>% 
  tally()

# write.csv(temp1, "temp1.csv")


# ## DENTISTS ####
# 
# #pull out dentists
# 
# dentists_byyear_wide <- docs_byyear_wide %>% 
#   filter(str_detect(Physician_Profile_Primary_Specialty,"Dental"))
# 
# dentists_allessurerecords <- inner_join(dentists_byyear_wide, essure_allyears)
# 
# dentists_allessurerecords <- dentists_allessurerecords %>% 
#   select(-c('2013', '2014', '2015', '2016', '2017', 'totpayments'))
# 
# bayer_dental_1315_essure <- bayer_1315_essure %>% 
#   filter(str_detect(Physician_Specialty,"Dental"))
# 
# bayer_dental_1617_essure <- bayer_1617_essure %>% 
#   filter(str_detect(Physician_Specialty,"Dental"))
# 
# # #output dentist results
# # 
# # write.csv(bayer_dental_1315_essure, "output/dental_rawrecords_2013_thru_2015.csv")
# # write.csv(bayer_dental_1617_essure, "output/dental_rawrecords_2016_thru_2017.csv")
# # write.csv(dentists_byyear_wide, "output/dental_summarybyyear.csv")




#cleanup objects ####
rm(df1)
rm(tots)
rm(topdocs)
rm(docs_byyear)
rm(bayall1)
rm(bayall2)
rm(bayall3)
rm(bayall4)
rm(tempjoin)
rm(tempjoin1)
rm(tempjoin2)
rm(t1)
rm(t2)
rm(t3)
rm(t4)