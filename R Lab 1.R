#scatterplot with tuition on x axis and loan default rate on y axix
ggplot(data=college) + 
  geom_point(mapping = aes(x=tuition, y=loan_default_rate)) +
  
#adding trendline  
ggplot(data=college) + 
  geom_point(mapping = aes(x=tuition, y=loan_default_rate)) +
  geom_smooth(mapping = aes(x=tuition, y=loan_default_rate))

#changing color of the points to represent the regiom 
ggplot(data=college) + 
  geom_point(mapping = aes(x=tuition, y=loan_default_rate, color=region)) +
  geom_smooth(mapping = aes(x=tuition, y=loan_default_rate))

#create boxplot showing faculty salary broken out by the highest degree awarded by the institution, removing the nondegree institution
college %>% 
  filter(highest_degree != 'Nondegree') %>% 
  ggplot() + 
  geom_boxplot(mapping = aes(x=highest_degree, y=faculty_salary_avg))

#produce a summary of all schools w/loan default rate over 20%
college %>% 
  filter(loan_default_rate > .2) %>% 
  summary()

#create a tibble w/school's faculty salary over 10k/mo sorted descending order of salary. include school name, state and avg salary
high_salary <- college %>%
  filter(faculty_salary_avg > 10000) %>%
  arrange(desc(name)) %>%
  select(name, state, faculty_salary_avg)

#use tibble above that shows the count of the high salary schools in each state, with the highest count first
high_salary_by_state <- high_salary %>% 
  group_by(state) %>% 
  summarize(school_count=n()) %>% 
  arrange(desc(school_count))

#counting number of high salary schools by state
schools_by_state <- college %>% 
  group_by(state) %>% 
  summarize(school_count=n()) %>% 
  arrange(desc(school_count))

#joining two previous tables
augmented_state_data <- schools_by_state %>% 
  left_join(high_salary_by_state, by="state") %>% 
  rename(schools=school_count.x, high_salary_schools=school_count.y)

#creating column with % of schools with high salary
augmented_state_data_percent <- augmented_state_data %>% 
  mutate(high_salary_percent=high_salary_schools/schools) %>% 
  arrange(desc(high_salary_percent)) %>% 
  filter(high_salary_percent >= 0.3)

#previous tibble with viz
augmented_state_data_percent <- augmented_state_data %>% 
  mutate(high_salary_percent=high_salary_schools/schools) %>% 
  arrange(desc(high_salary_percent)) %>% 
  filter(high_salary_percent >= 0.3) %>% 
  ggplot() +
  geom_col(mapping=aes(x=state, y=high_salary_percent))

#extra
college %>% 
  mutate(rejection_rate=1-admission_rate) %>% 
  ggplot(mapping=aes(x=rejection_rate, y=median_debt, color=control)) +
  geom_smooth(se=FALSE) +
  ggtitle("Student Debt Varies with School Selectivity", subtitle="Source: US Department of Education") +
  theme(panel.grid=element_blank(), panel.background = element_blank()) +
  theme(legend.key=element_blank()) +
  xlab("Rejection Rate") +
  ylab("Median Debt (USD)") +
  xlim(0,1) +
  ylim(5000,45000)

