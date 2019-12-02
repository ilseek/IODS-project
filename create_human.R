#create_human.R data
Ilse Ekman 
The dataset originates from the United Nations Development Programme. The data contains the human development indices and their components estimated by the Human Development Report Office (HDRO). 
Source of data: http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt


human <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt")

str(human)
dim(human)
