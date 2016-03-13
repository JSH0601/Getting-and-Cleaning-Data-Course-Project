##This script will load and process elements of the UCI HAR Dataset.
##On completion of this script, the user will see a dataset containing the 
##average of each variable for each activity and each subject present in the 
##original UCI HAR Dataset

##also, verify that you have dplyr installed and it is loaded by using
##"library(dplyr"), and reshape2 by "library(reshape2)"

##Set working directory to the UCI HAR Dataset folder before beginning

##imports features.txt (the labels for all test variables)
features <- read.table("features.txt")

##imports activity_labels.txt (the activity labels for all recorded activities)
activitylabels <- read.table("activity_labels.txt")

##imports all test data
testsubject <- read.table('./test/subject_test.txt')
testactivity <- read.table('./test/y_test.txt')
testdata <- read.table('./test/X_test.txt')

##imports all training data
trainingsubject <- read.table('./train/subject_train.txt')
trainingactivity <- read.table('./train/y_train.txt')
trainingdata <- read.table('./train/X_train.txt')

##merges the activity values from each data set with the activity labels
##and converts the original variables into one column
testactivity <- merge(testactivity, activitylabels)
testactivity <- testactivity[,2]
trainingactivity <- merge(trainingactivity, activitylabels)
trainingactivity <- trainingactivity[,2]

##cbinds test and training data sets into single data sets for each partition
alltestdata <- cbind(testsubject, testactivity, testdata)
alltrainingdata <- cbind(trainingsubject, trainingactivity, trainingdata)

##adds names of variables to each dataset
featuresnames <- features$V2
featuresnames <- as.character(featuresnames)
allvariablenames <- c("subject", "activity", featuresnames)

names(alltestdata) <- allvariablenames
names(alltrainingdata) <- allvariablenames

##merges test and training data sets
allstudydata <- rbind(alltestdata, alltrainingdata)

##extracts mean and standard deviation columns from the combined data
substudydata <- subset(allstudydata, select = grep("mean|std", names(allstudydata)))
substudydata <- substudydata[,-grep("Freq", colnames(substudydata))]

##renames the new extracted table with appropriate variable names
names(substudydata) <- sub("Acc", "accelerometer", names(substudydata))
names(substudydata) <- sub("Gyro", "gyroscope", names(substudydata))
names(substudydata) <- sub("mag", "magnitude", names(substudydata))
names(substudydata) <- c(substudydata[,1:2], sub("t", "timed", names(substudydata[,3:40]), substudydata[,41:66]))
names(substudydata) <- c(substudydata[,1:40], sub("f", "fastfourier",names(substudydata[,41:66])))
names(substudydata) <- c(substudydata[,1:60], sub("Body", "", names(substudydata[,61:66])))
names(substudydata) <- sub("-", "", names(substudydata))
names(substudydata) <- sub("()", "", names(substudydata))

##creates a second data set to display the average of each variable for each
##activity and each subject
studydatameans <- melt(substudydata, id= substudydata[,1:2], measure.vars = substudydata[,3:66])
studydatameans <- dcast(studydatameans, activity ~ variable,mean)

##makes final data set available in Global Environment
studydatameans <<- studydatameans