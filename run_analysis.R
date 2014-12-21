##Zip file has already been unzipped into "UCI HAR Dataset" subfolder in ./data

data_path <- file.path("./data" , "UCI HAR Dataset")
path_files<-list.files(data_path, recursive=TRUE)
path_files

##STEP 1

data_activity_test  <- read.table(file.path(data_path, "test" , "Y_test.txt" ),header = FALSE)
data_activity_train <- read.table(file.path(data_path, "train", "Y_train.txt"),header = FALSE)
data_subject_train <- read.table(file.path(data_path, "train", "subject_train.txt"),header = FALSE)
data_subject_test  <- read.table(file.path(data_path, "test" , "subject_test.txt"),header = FALSE)
data_features_test  <- read.table(file.path(data_path, "test" , "X_test.txt" ),header = FALSE)
data_features_train <- read.table(file.path(data_path, "train", "X_train.txt"),header = FALSE)
str(data_activity_test)
str(data_activity_train)
str(data_subject_train)
str(data_subject_test)
str(data_features_test)
str(data_features_train)
data_subject <- rbind(data_subject_train, data_subject_test)
data_activity<- rbind(data_activity_train, data_activity_test)
data_features<- rbind(data_features_train, data_features_test)

##STEP 2
names(data_subject)<-c("subject")
names(data_activity)<- c("activity")

## STEP 3
data_featuresNames <- read.table(file.path(data_path, "features.txt"),head=FALSE)
names(data_features)<- data_featuresNames$V2
dataCombine <- cbind(data_subject, data_activity)
Data <- cbind(data_features, dataCombine)
subdata_featuresNames<-data_featuresNames$V2[grep("mean\\(\\)|std\\(\\)", data_featuresNames$V2)]
selectedNames<-c(as.character(subdata_featuresNames), "subject", "activity" )
newData<-subset(Data,select=selectedNames)
str(newData)

##STEP 4

activityLabels <- read.table(file.path(data_path, "activity_labels.txt"),header = FALSE)
head(newData$activity,30)
names(newData)<-gsub("^t", "time", names(newData))
names(newData)<-gsub("^f", "frequency", names(newData))
names(newData)<-gsub("Acc", "Accelerometer", names(newData))
names(newData)<-gsub("Gyro", "Gyroscope", names(newData))
names(newData)<-gsub("Mag", "Magnitude", names(newData))
names(newData)<-gsub("BodyBody", "Body", names(newData))
names(newData)

##STEP 5

library(plyr);
tidyData<-aggregate(. ~subject + activity, newData, mean)
tidyData<-tidyData[order(tidyData$subject,tidyData$activity),]
write.table(tidyData, file = "tidydata.txt",row.name=FALSE)


library(knitr)
knit2html("codebook.Rmd");
