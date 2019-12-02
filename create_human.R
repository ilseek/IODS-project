#create_human.R data
Ilse Ekman 
The dataset originates from the United Nations Development Programme. The data contains the human development indices and their components estimated by the Human Development Report Office (HDRO). 
Source of data: http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt


human <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt")

names(human)
str(human)
dim(human)
summary(human)

library(stringr)
str(human$GNI)
str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric

complete.cases(human)
data.frame(human[-1], comp = complete.cases(human))
human_ <- filter(human, complete.cases(human))

tail(human, 10)
last <- nrow(human) - 7
human_ <- human[1:last, ]
rownames(human) <- human$Country

dim(human)
