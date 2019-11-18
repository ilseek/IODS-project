"Ilse Ekman 18.11.2019, Exercise 3: Logistic regression"
"The data for the exercise is from [link](https://archive.ics.uci.edu/ml/datasets/Student+Performance) and it is about student achievements in Portuguese schools."


por <- read.csv("C:\\Users\\Ilse\\Desktop\\R course\\student-por.csv", sep = ";", header = TRUE)
str(por)
dim(por)
colnames(por)


math <- read.csv("C:\\Users\\Ilse\\Desktop\\R course\\student-mat.csv", sep = ";", header = TRUE)
str(math)
dim(math)
colnames(math)

library(dplyr)
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por"))
str(math_por)
dim(math_por)
colnames(math_por)

alc <- select(math_por, one_of(join_by))
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]
for(column_name in notjoined_columns) {
  two_columns <- select(math_por, starts_with(column_name))
  first_column <- select(two_columns, 1)[[1]]
  
  if(is.numeric(first_column)) {
    alc[column_name] <- round(rowMeans(two_columns))
  } else {
    alc[column_name] <- first_column
  }
}

glimpse(alc)

alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = alc_use > 2)

library(ggplot2)
g1 <- ggplot(data = alc, aes(x = high_use))
g1 + geom_bar()


glimpse(alc)

write.csv(alc,file = "alc.csv")

#Analysis

read.csv("alc.csv")

#Structure of the data:
str(alc)


#This data is a combined data from two datasets regarding the performance in mathematics and Portuguese language.
#The data has 382 observations of 35 variables.

#The names of the variables:
colnames(alc)

#The purpose of my analysis is to study the relationship between alcohol consumption and following four variables:
#1.sex: I hypothese that male students have higher consumption of alcohol.
#2.age: I hypothese that the older the student is the more they consume alcohol.
#3.goout: I hypothese that the more the student goes out with friends the bigger their alcohol consumption is.
#4.health: I hypothese that the current health status is worse in the students with higher alcohol consumption.

#Exploring the first hypothesis:
library(dplyr); library(ggplot2)

alc %>% group_by(sex, high_use) %>% summarise(count = n())

g1 <- ggplot(alc, aes(x = sex, y = alc_use))
g1 + geom_boxplot() + ylab("Alcohol usage")

#Exploring the second hypothesis:

alc %>% group_by(age, high_use) %>% summarise(count = n())

g2 <- ggplot(alc, aes(x = high_use, y = age))
g2 + geom_boxplot() + ylab("Age")

#Exploring the third hypothesis:

alc %>% group_by(goout, high_use) %>% summarise(count = n())

g3 <- ggplot(alc, aes(x = high_use, y = goout))
g3 + geom_boxplot() + ylab("Going out")

#Exploring the fourth hypothesis:

alc %>% group_by(health, high_use) %>% summarise(count = n())

g4 <- ggplot(alc, aes(x = high_use, y = health))
g4 + geom_boxplot() + ylab("Health")


#Exploring the variables with logistic regression:
m <- glm(high_use ~ sex + age + goout + health, data = alc, family = "binomial")
summary(m)
coef(m)

#To compute out odds ratios:
OR <- coef(m) %>% exp
#To compute out confidence intervals:
CI <- confint(m) %>% exp
cbind(OR, CI)

#To predict the probability of high alcohol usage:
probabilities <- predict(m, type = "response")
alc <- mutate(alc, probability = probabilities)
alc <- mutate(alc, prediction = probability > 0.5)
select(alc, failures, absences, sex, high_use, probability, prediction) %>% tail(10)
table(high_use = alc$high_use, prediction = alc$prediction)
