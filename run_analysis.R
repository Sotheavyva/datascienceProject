 
library(data.table)

# 1. read activity_labels
activity_labels <- read.table("../UCI HAR Dataset/activity_labels.txt")

# name the column name of activity_labels
names(activity_labels) <- c("Activity.Id","Activity")

# read fetures
feature_list <- read.table("../UCI HAR Dataset/features.txt")

# 2. Read test data 

# read subject_test
test_subjects <- read.table("../UCI HAR Dataset/test/subject_test.txt")

# name the column name of test_subjects
names(test_subjects) <- "Subject.Id"

# read X_test
test_dataset <- read.table("../UCI HAR Dataset/test/X_test.txt")

# name test_dataset with descriptive variable from the feature_list names
names(test_dataset) <- feature_list$V2

# read Y_test
test_activities<-read.table("../UCI HAR Dataset/test/Y_test.txt")

# rename the column name of test_activities
names(test_activities)<-"Activity.Id"

# bind the test data set per observations
testset <- cbind(test_subjects, test_dataset, test_activities)

# take only columns that include the word mean, std and Subject.Id, Activity.Id
sliced_testset <<- testset[,grepl("Subject.Id|Activity.Id|mean\\(\\)|std\\(\\)", colnames(testset))]

# add descriptive activity names to the activities in the test data set
final_testset <- merge(sliced_testset, activity_labels, all=TRUE)

# 3. read subject_train
train_subjects <- read.table("../UCI HAR Dataset/train/subject_train.txt")

# name the column name of train_subjects
names(train_subjects) <- "Subject.Id"

# read X_train
train_dataset <- read.table("../UCI HAR Dataset/train/X_train.txt")

# name train_dataset with descriptive variable from the feature_list names 
names(train_dataset) <- feature_list$V2

# read Y_train
train_activities <- read.table("../UCI HAR Dataset/train/Y_train.txt")

# rename the column name of train_activities
names(train_activities) <- "Activity.Id"

# bind the train data set per observations
trainset <- cbind(train_subjects, train_dataset, train_activities)

# take only columns that include the word mean, std and Subject.Id, Activity.Id
sliced_trainset <<- trainset[,grepl("Subject.Id|Activity.Id|mean\\(\\)|std\\(\\)", colnames(trainset))]

# Add descriptive activity names to the activities in the train data set
final_trainset <- merge(sliced_trainset, activity_labels, all=TRUE)

# merge test and train dataset 
data <- merge(final_testset,final_trainset,all=TRUE)

# load the library for reshaping data
library(reshape2)

# take the column names which will be aggregated
average_columns <- colnames(data[,3:68])

#melt the data
melted_data <- melt(data,id=c("Subject.Id","Activity"), measure.vars=average_columns)

#now cast the melted data set to produce the tidy dataset
tidy_dataset <- dcast(melted_data, Subject.Id + Activity ~ variable, mean)

# write the tidy dataset to the Data folder 
write.table(tidy_dataset, file = "tidydataset.txt", row.names = FALSE)


