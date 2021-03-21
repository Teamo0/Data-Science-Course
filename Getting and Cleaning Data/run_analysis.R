# script to read in the samsung motion sensor data set, merge test and train data
# and save a tidy summary file with average variable values grouped by
# subject and activity

# install and load required packages
install.packages("sjmisc")
install.packages("utils")
library(sjmisc)
library(dplyr)
library(utils)

# read in all variables for train and test set
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# append activity and subject, merge train and test set
joint_train <- cbind(x_train,y_train, subject_train)
joint_test <- cbind(x_test,y_test, subject_test)
data <- rbind(joint_train,joint_test)

# read in features.txt and use for variable names
features <- read.table("UCI HAR Dataset/features.txt")
names(data) <- c(features$V2,"activity", "subject")
data$activity[data$activity == 1] <- "WALKING"
data$activity[data$activity == 2] <- "WALKING_UPSTAIRS"
data$activity[data$activity == 3] <- "WALKING_DOWNSTAIRS"
data$activity[data$activity == 4] <- "SITTING"
data$activity[data$activity == 5] <- "STANDING"
data$activity[data$activity == 6] <- "LAYING"

# extract only variables containing mean() and std()
mean_values <- grep("mean()",names(data))
std_values <- grep("std()",names(data))
extract <- tbl_df(data[c(mean_values,std_values,562,563)])

# group data by activity and subject, summarise using mean function
tidy_set <-extract %>% group_by(activity,subject) %>% summarize_all(mean)

# save tidy data set
write.table(tidy_set, "tidy_data.txt")