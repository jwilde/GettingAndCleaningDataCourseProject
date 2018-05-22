# this script takes the files provided on https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip as input
# the result after running the script are two variables data and mean_data, each of with is a data frame
# data holds a molten data frame of the training and test data provided
# mean_data holds a summarized data set with the average by subject and activity

# load necessary libraries
library(dplyr)
library(reshape2)
library(magrittr)

# Read all relevant files

## activities
activities<-read.table("activity_labels.txt")
colnames(activities)<-c("activity_id", "activity")

## features
features<-read.table("features.txt")

## training data
train_subject<-read.table("train/subject_train.txt")
train_label<- read.table("train/y_train.txt")
train_set <- read.table("train/X_train.txt")

## test data
test_subject <- read.table("test/subject_test.txt")
test_label <- read.table("test/y_test.txt")
test_set <- read.table("test/x_test.txt")


# merge data

## column bind training data

training_data<-cbind(train_subject, train_label, train_set)

## column bind test data
test_data <- cbind(test_subject, test_label, test_set)

# 1. Merges the training and the test sets to create one data set called data
# row bind training and test
data<-rbind(training_data, test_data)


# transform data

# 4. Appropriately labels the data set with descriptive variable names. 
# here we use the name of the features
colnames(data)<-c("subject", "activity_id", as.character(features$V2))

# we need to examine the column names, so we melt the data frame 
# => 4 columns: activity_id, subject, variable, value
data <- melt(data, id=c("activity_id", "subject"), measure.vars=as.character(features$V2)) 

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# we only want to analyze mean() and std(), 
# so we add a column only_mean_or_std holding as a binary variable, which checks if 'mean()' or 'std()' is part of the column name 
# we filter only TRUE and remove the new column afterwards
data <- data %>% mutate(variable=as.character(variable) ) %>% mutate(only_mean_or_std=grepl("mean\\(\\)|std\\(\\)", variable)) 
data <- data %>% filter(only_mean_or_std==TRUE) %>% select(-c(only_mean_or_std))

# 3. Uses descriptive activity names to name the activities in the data set
# merge with activity data frame for descriptive activities
data <- data%>%merge(activities)%>%select(-activity_id)

# 5. From the data set in step 4 (variable data), creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# cast the data and calculate mean
mean_data <- dcast(data, subject+activity~variable, value.var="value", fun.aggregate = mean)

# order data by subject and activity
mean_data <- arrange(mean_data, subject, activity)

# remove all variables not needed anymore
rm(train_subject, train_label, train_set, test_subject, test_label, test_set, training_data, test_data, features, activities )

# for submission only
write.table(mean_data, "tidy_data.txt", row.name=FALSE)
