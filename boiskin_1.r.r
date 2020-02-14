library(tidyverse)
library(gridExtra)

vehicles <- read_csv("https://s3.amazonaws.com/itao-30230/vehicles.csv",
                     col_types="inincicccici")

vehicles <- vehicles %>%
  mutate(class=as.factor(class), drive=as.factor(drive), make=as.factor(make),
         transmissiontype=as.factor(transmissiontype))

college <- read_csv("https://s3.amazonaws.com/itao-30230/college.csv")

college$state <- as.factor(college$state)
college$region <- as.factor(college$region)
college$highest_degree <- as.factor(college$highest_degree)
college$control <- as.factor(college$control)
college$gender <- as.factor(college$gender)
college$loan_default_rate <- as.numeric(college$loan_default_rate)

#Problem 1
#Part A
ggplot(data=vehicles) +
  geom_point(mapping = aes(x=citympg, y=co2emissions))

#Part B
ggplot(data=vehicles) +
  geom_point(mapping = aes(x=citympg, y=co2emissions, color=drive))

#Part C
ggplot(data=vehicles) +
  geom_bar(mapping = aes(x=year, fill=class))

#Part D
ggplot(data=vehicles) +
  geom_histogram(mapping = aes(x=citympg)) + 
  facet_wrap(~transmissiontype)

#Problem 2
#Part A
vehicles %>%
  group_by(vehicles$class) %>% 
  summarize(min=as.integer(min(citympg)),
            max=as.integer(max(citympg)),
            mean=as.integer(round(mean(citympg))),
            median=as.integer(median(citympg)))
#Part B
vehicles %>% 
  group_by(year) %>% 
  summarize(citympg = mean(citympg),
            highwaympg = mean(highwaympg)) %>% 
ggplot() +
  geom_line(mapping=aes(x=year, y=citympg), color="red") +
  geom_line(mapping=aes(x=year, y=highwaympg), color="blue") +
  ylab("MPG")

#Part C
vehicles2 <- vehicles %>%
  mutate(avg_mpg=(citympg+highwaympg)/2)
  
vehicles2 %>% 
  group_by(year) %>% 
  summarize(citympg = mean(citympg),
            highwaympg = mean(highwaympg),
            avg_mpg = mean(avg_mpg)) %>% 
ggplot() +
  geom_line(mapping=aes(x=year, y=citympg), color="red") +
  geom_line(mapping=aes(x=year, y=highwaympg), color="blue") +
  geom_line(mapping=aes(x=year, y=avg_mpg), color="green") +
  ylab("MPG")

#Part D 
vehicles2 %>% 
  group_by(year,drive) %>% 
  summarize(citympg = mean(citympg),
            highwaympg = mean(highwaympg),
            avg_mpg = mean(avg_mpg)) %>% 
ggplot() +
  geom_line(mapping=aes(x=year, y=citympg), color='red') +
  geom_line(mapping=aes(x=year, y=highwaympg), color='blue') +
  geom_line(mapping=aes(x=year, y=avg_mpg), color='green') +
  facet_wrap(~drive) +
  ylab("MPG")

#Problem 3

#Visualization 1
#comparing manual vs automatic SUVs, comparing #of gears to mpg
SUV <- filter(vehicles2, class=="Sport Utility")

#creating new df
SUV_by_gear <- SUV %>%
  select(transmissionspeeds,year)

#adding elements to new SUV by gear df
SUV_by_gear <- SUV_by_gear %>% 
  group_by(year)  %>%
  summarize(transmissionspeeds=mean(transmissionspeeds))

#plot of new SUV by gear
plot1 <- ggplot(data=SUV_by_gear) +
  geom_line(mapping = aes(x=year, y=transmissionspeeds), color="deepskyblue1") +
  geom_point(mapping = aes(x=year, y=transmissionspeeds), color="red") +
  ylab("# of Transmission Speeds") +
  xlab("Year") +
  theme(panel.background = element_rect(fill="black")) +
  theme(panel.grid.major.y = element_blank()) +
  theme(panel.grid.minor = element_blank())

#creating second df SUV emission df
SUV_emission <- SUV %>% 
  group_by(year,transmissionspeeds) %>% 
  summarize(co2emissions=mean(co2emissions))

#plot of df SUV emission  
plot2 <- ggplot(SUV_emission) + 
  geom_point(mapping = aes(x=year, y=co2emissions), color="red") +
  geom_smooth(mapping = aes(x=year, y=co2emissions)) +
  facet_wrap(~transmissionspeeds) +
  theme(panel.background = element_rect(fill="black")) +
  theme(panel.grid.major.y = element_blank()) +
  theme(panel.grid.minor = element_blank()) +
  ylab("Co2 Emissions") +
  xlab("")

#splitting output to put both graphs in same grid
grid.arrange(plot2, plot1, nrow=2, heights= c(2,1))

#In the top portion we can see that Co2 emissions have been going down over time with the largest amount of movement in the 4-6 speed engines.
#The second portion we can see that the amount of higher speed vehicles become available increases rapidly beginning in 2005.
#By seeing that more gears leads to lower emissions and the result of that is that vehicles with higher speeds are becoming more widely used.

#Visualization 2
#California UCs vs CSU student debt

#creating california map
california_mapdata <- map_data("county", region = "california")

#filtering df with only california public colleges
california_colleges <- filter(college, state=="CA" & control=="Public")

#adding column with logic if If the name contains the word 'state' mark as CSU and if not, mark as UC
california_colleges <- california_colleges %>% 
  mutate(State_UC = if_else(grepl("State", name), "CSU", "UC"))

#Visualization
ggplot() +
  geom_polygon(data = california_mapdata, mapping = aes(x=long, y=lat, group=group),
               color="white", fill="grey40") +
  coord_map() +
  geom_point(data=california_colleges, mapping=aes(x=lon, y=lat, color=State_UC, size=median_debt),
               alpha=.9) +
theme(panel.grid=element_blank(), panel.background=element_blank()) +
theme(axis.title = element_blank(), axis.text=element_blank(),axis.ticks = element_blank()) +
theme(legend.key=element_blank()) +  
  ggtitle("California State and UC Universities") +
  scale_color_discrete(name="State or UC") 
  scale_size_continuous("Median Debt")
  
#Even though UC schools are typically more expensive regarding tuition and usually have more rigoruos criteria for admission, students
#tend to come out from either school with a similar amount of debt. THis can be seen by the relative uniformity of the bubble size.
  