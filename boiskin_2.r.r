#Zac Boiskin

library(tidyverse)

census <- read_csv("https://s3.amazonaws.com/itao-30230/aff_2012.csv")
colnames(census)

#removing first redundant row
census <- census[-1,]

#removing unwanted columns
census <- census %>% 
  select(-GEO.id,-GEO.id2,-NAICS.id,-ETH_GROUP.id,-RACE_GROUP.id,
         -YEAR.id,-FIRMALL,-RCPALL,-FIRMPDEMP,-RCPPDEMP,-FIRMNOPD,-RCPNOPD,-FIRMALL_S,-FIRMPDEMP_S,-FIRMNOPD_S,-RCPALL_S,
         -RCPPDEMP_S,-EMP_S,-PAYANN_S,-RCPNOPD_S)

#separating into county and state columns
census <- census %>%
  separate(`GEO.display-label`,c('County', 'State'),",", remove = TRUE)

#filtering firms held by races or ethnic groups as it is not applicible to assignment
census <- census %>% 
  filter(`ETH_GROUP.display-label`=="All firms")

census <- census %>% 
  filter(`RACE_GROUP.display-label`=="All firms")

#removing race and ethnic columns since they have been included only to filter with
census <- census %>% 
  select(-`ETH_GROUP.display-label`,-`RACE_GROUP.display-label`)

#filtering total sector rows to prevent double counting
census <- census %>% 
  filter(`NAICS.display-label`!="Total for all sectors")

#filtering sex to only include male owned, female owned or equally
census <- census %>% 
  filter(`SEX.display-label`=="Male-owned" | `SEX.display-label`=="Female-owned" | `SEX.display-label`=="Equally male-/female-owned")

#removing sex ID column
census <- census %>% 
  select(-SEX.id)

#renameing 
colnames(census) <- c("County", "State", "Sector", "Gender_Owned", "Number_of_Employees", "Annual_Pay")


#set S values = to NA
census[census =="S"] <- NA

#removing employees with 0 salary
census <- census %>% 
  filter(Number_of_Employees !=0)

#assign letter values appropriate ranges
census <- census %>% 
  mutate(Number_of_Employees=str_replace(Number_of_Employees,"a","10")) %>% 
  mutate(Number_of_Employees=str_replace(Number_of_Employees,"b","60")) %>% 
  mutate(Number_of_Employees=str_replace(Number_of_Employees,"c","175")) %>% 
  mutate(Number_of_Employees=str_replace(Number_of_Employees,"f","750")) %>% 
  mutate(Number_of_Employees=str_replace(Number_of_Employees,"e","375")) %>% 
  mutate(Number_of_Employees=str_replace(Number_of_Employees,"g","1750")) %>% 
  mutate(Number_of_Employees=str_replace(Number_of_Employees,"h","3750")) %>% 
  mutate(Number_of_Employees=str_replace(Number_of_Employees,"i","7500")) %>% 
  mutate(Number_of_Employees=str_replace(Number_of_Employees,"j","17500")) %>% 
  mutate(Number_of_Employees=str_replace(Number_of_Employees,"k","37500")) %>% 
  mutate(Number_of_Employees=str_replace(Number_of_Employees,"l","75000")) %>% 
  mutate(Number_of_Employees=as.numeric(Number_of_Employees))

#sorting by county, state then sector
census <- census %>% 
  arrange(County) %>% 
  arrange(State) %>% 
  arrange(Sector)


#multiplying annual income by 1000
#turning annual pay columm into numeric
census <- census %>% 
  mutate(Annual_Pay=as.numeric(Annual_Pay)) 

#multiplying each value by 1000 unless it is NA
census <- census %>% 
  mutate(Annual_Pay=ifelse((Annual_Pay=="NA"),Annual_Pay,Annual_Pay*1000))

#creating new column of average annual income
#turning number of employees into numberic
census <- census %>% 
  mutate(Number_of_Employees=as.numeric(Number_of_Employees)) 

#dividing annual income by number of employees
census <- census %>% 
  mutate(Average_Salary = Annual_Pay/Number_of_Employees)

#selecting new columns for datafram by dropping annual salary and number of employees and replacing with Average annual
census <- census %>% 
  select(-Annual_Pay,-Number_of_Employees)

#spreading ownership gender by salary value
census <- census %>% 
  spread(Gender_Owned,Average_Salary)

#reordering values
census <- census %>% 
  arrange(County) %>% 
  arrange(State) %>% 
  arrange(Sector)

#putting columns in required order
census <- census %>% 
  select(County,State,Sector,`Male-owned`,`Female-owned`,`Equally male-/female-owned`)

#filtering out the rows with 3 NAs
census<- census %>% 
  filter(is.na(`Equally male-/female-owned`)==FALSE | is.na(`Male-owned`)==FALSE | is.na(`Female-owned`)==FALSE)

#saving as CSV
write.csv(census,"C:\\Users\\zbois\\Desktop\\MS Program\\MSBA70200 Data Management\\Assignments.csv", row.names = FALSE)

#ending code
head(census)
summary(census)
dim(census)

