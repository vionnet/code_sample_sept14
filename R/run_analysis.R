library(sqldf)
#Set file URLs
#I am interpreting this instruction "the code should have a file run_analysis.R 
#in the main directory that can be run as long as the Samsung data is in 
#your working directory.can be run as long as the Samsung data is in your 
#working directory" as follows:
##The working directory contains activity_labels.txt, features.txt
##as well as the test and train folders that the test and training datasets.
curdir <- getwd()
testFileUrl <- paste(curdir, "/test", sep="")
trainFileUrl <- paste(curdir, "/train", sep="")

#Obtaining lists of text file names from the test and the training directories
testFN <- list.files(path = testFileUrl, pattern = "\\.txt$")
trainFN <- list.files(path = trainFileUrl, pattern = "\\.txt$")

#Obtaining the feature file
features <- read.table(paste(curdir, "features.txt", sep="/"))
#Only include features that have "mean()" or "std()" measures
sub_features <- sqldf("select V1, V2 
                       from features
                       where V2 like '%mean()%' or V2 like '%std()%'")
#Getting the activity label file
activity_labels <- read.table(paste(curdir, "activity_labels.txt", sep="/"))

#Combining text files in the test folder by column based on descriptions of
#the files. After this operation, we combine test subjects, test number, and 
#test feature into one dataset.
test_data = read.table(paste(testFileUrl, testFN[1], sep="/"))
for (i in 2:length(testFN)) {
      test_data <- cbind(test_data, read.table(paste(testFileUrl, testFN[i], sep="/")))
}
colnames(test_data)[1] <- "Subject"
colnames(test_data)[ncol(test_data)] <- "Test_No"

#Similar operation to obtain the training dataset.
train_data = read.table(paste(trainFileUrl, trainFN[1], sep="/"))
for (i in 2:length(trainFN)) {
      train_data <- cbind(train_data, read.table(paste(trainFileUrl, trainFN[i], sep="/")))
}
colnames(train_data)[1] <- "Subject"
colnames(train_data)[ncol(train_data)] <- "Test_No"

#Combining the test and the training data into one dataset.
#This addresses "1. Merges the training and the test sets to create one data set".
data <- rbind(test_data, train_data)

#Transform the combined data set so that test features (with name "V#")
#are in one column for each subject and test number.
library(reshape2)
mdata <- melt(data, id=c("Subject","Test_No"))

#Put a "V" in front of the feature number for merging.
sub_features[,1] <- paste("V", sub_features[,1],sep="")

#Merge the transformed(or melted) dataset with the sub_feature dataset
#for features in the sub_feature data.
#This addresses "2.Extracts only the measurements on the mean and standard deviation for each measurement."
ddata <- merge(mdata, sub_features, by.x="variable", by.y="V1", all=FALSE)

#Merge dataset above with activity labels to get activity names.
#This addresses "3.Uses descriptive activity names to name the activities in the data set"
ddata2 <- merge(ddata, activity_labels, by.x="Test_No", by.y="V1", all=FALSE)

#Change column names so that they are more descriptive.
#This addresses "4.Appropriately labels the data set with descriptive variable names."
colnames(ddata2)[5] <- c("Feature_Measurement")
colnames(ddata2)[6] <- c("Activity")

#Delete columns 1 and 2 as they are redundant. 
#Also re-order the columns (this is not necessary, but data looks nicer).
clean_data <- ddata2[,c(5,3,6,4)]

#Obtaining the average of each variable (feature) for each activity and each subject
#This addresses "6. Creates a second, independent tidy data set with the average of each variable for each activity and each subject."
tidy_data <- sqldf("select Feature_Measurement, Subject, Activity, avg(value) Average
                    from clean_data
                    group by Feature_Measurement, Subject, Activity
                    order by Feature_Measurement, Subject, Activity")

#create a txt file with write.table() using row.name=FALSE
write.table(tidy_data, file="./tidy_data.txt", row.names=FALSE)
