#Ilse Ekman, 11.11.2019, This is regression and model validation exercise.

lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

dim(lrn14)
str(lrn14)
#The commands dim() and str()are good to figure out how your data looks like. 
#Dim() gives you the number of rows and columns in your data. In this case 183 rows or cases and 60 columns or variables.
#Str() returns the structure of data more in detail.Besides the number of observations and variables,it tells name of the vectors and data type.

deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
attitude_questions <- c("Da", "Db", "Dc", "Dd", "De", "Df", "Dg", "Dh", "Di","Dj")
gender <- c("Gender")
age <- c("Age")
points <- c("Points")

library(dplyr)

deep_columns <- select(lrn14, one_of(deep_questions))
surface_columns <- select(lrn14, one_of(surface_questions))
strategic_columns <- select(lrn14, one_of(strategic_questions))

lrn14$deep <- rowMeans(deep_columns)
lrn14$surf <- rowMeans(surface_columns)
lrn14$stra <- rowMeans(strategic_columns)

keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")

learning2014 <- select(lrn14, one_of(keep_columns))

learning2014$Attitude <- c(learning2014$Attitude) / 10
learning2014$Attitude

learning2014 <- filter(learning2014, Points > 0)

dim(learning2014)

setwd("~/IODS-project")

write.csv(learning2014,file = "learning2014.csv")

read.csv("learning2014.csv")

#Analysis of the data

read.csv("learning2014.csv")

dim(learning2014)
str(learning2014)

#This dataset has 166 observations with seven variables. 
#The different variables are: gender which is factor with two levels. 
#Attitude,deep, stra and surf are numeric variables.



##Graphical overview of the data

pairs(learning2014[-1], col = learning2014$gender)

#Correcting the names of the columns
colnames(learning2014)[7] <- "points"
colnames(learning2014)[2] <- "age"
colnames(learning2014)[3] <- "attitude"

pairs(learning2014[-1], col = learning2014$gender)
library(GGally)
p <- ggpairs(learning2014, mapping = aes(col = gender, alpha = 0.3), lower = list(combo = wrap("facethist", bins = 20)))
p

library(ggplot2)

p1 <- ggplot(learning2014, aes(x = attitude, y = points, col = gender))
p2 <- p1 + geom_point()
p2
p3 <- p2 + geom_smooth(method = "lm")
p3

#Summary of the data

summary(learning2014)

#Regression model

ggpairs(learning2014, lower = list(combo = wrap("facethist", bins = 20)))
my_model2 <- lm(points ~ attitude + stra + surf, data = learning2014)

#Summary of the multiple regression model
summary(my_model2)

#Because the "stra" and "surf" do not have statistically significant relationship with points, they are removed from the analysis.
my_model1 <- lm(points ~ attitude, data = learning2014)
summary(my_model1)


#Diagnostic plots

par(mfrow = c(2,2))
plot(my_model1, which = c(1,2,5))
