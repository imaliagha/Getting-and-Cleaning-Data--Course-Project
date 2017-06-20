setwd("C:/DATA Science/Course 2 assignement/UCI HAR Dataset")




subject_test <- read.table("./test/subject_test.txt")
X_test <- read.table("./test/X_test.txt")
Y_test <- read.table("./test/y_test.txt")

subject_train <- read.table("./train/subject_train.txt")
X_train <- read.table("./train/X_train.txt")
Y_train <- read.table("./train/y_train.txt")

# load lookup information
features <- read.table("features.txt")
colnames(features) <- c("featureId", "featureLabel")
activities <- read.table("activity_labels.txt")
colnames(activities) <- c("activityId", "activityLabel")
activities$activityLabel <- gsub("_", "", as.character(activities$activityLabel))
includedFeatures <- grep("-mean\\(\\)|-std\\(\\)", features$featureLabel)

# merge test and training data and then name them
subject <- rbind(subject_test, subject_train)
names(subject) <- "subjectId"
X <- rbind(X_test, X_train)
X <- X[, includedFeatures]
names(X) <- gsub("\\(|\\)", "", features$featureLabel[includedFeatures])
Y <- rbind(Y_test, Y_train)
names(Y) = "activityId"
activity <- merge(Y, activities, by="activityId")$activityLabel

# merge data frames of different columns to form one data table
data <- cbind(subject, X, activity)
write.table(data, "merged_tidy_data.txt")

# create a dataset grouped by subject and activity after applying standard deviation and average calculations
library(data.table)
dataDT <- data.table(data)
calculatedData<- dataDT[, lapply(.SD, mean), by=c("subjectId", "activity")]
write.table(calculatedData, "tidy.txt", row.names = FALSE, quote = FALSE)
