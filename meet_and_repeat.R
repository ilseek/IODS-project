#meet_and_r.epeat.R data wrangling exercise
Ilse Ekman 8.12.2019

#Loading the datasets:

library(tidyr)
library(dplyr)

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')

#Exploring the data:

names(BPRS)
str(BPRS)
summary(BPRS)


names(RATS)
str(RATS)
summary(RATS)

#Changing categorical variables to factors:

BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

#Converting the datasets to long form:

#And adding the week variable to BPRS:

BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))


#And adding the time variable to RATS:

RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD,3,4))) 

#Comparison of the wide and long forms of the datasets:

glimpse(BPRS)
head(BPRS)
tail(BPRS)

glimpse(BPRSL)
head(BPRSL)
tail(BPRSL)

glimpse(RATS)
head(RATS)
tail(RATS)

glimpse(RATSL)
head(RATSL)
tail(RATSL)

#Write the datasets to files:

setwd("~/IODS-project")
write.csv(RATSL,file = "RATSL.csv")
write.csv(BPRSL,file = "BPRSL.csv")

read.csv("BPRSL.csv")
read.csv("RATSL.csv")
