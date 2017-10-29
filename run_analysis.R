#BJN Coursera Getting and Cleaning Data Week 4 Project
#You should create one R script called run_analysis.R that does the following.

#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

filesPath <- "C:/Users/Betsy/Documents/CD continuing education/2017/data science/RWorkingDirectory/RunAnalysis"
setwd(filesPath)
if(!file.exists("./data")){dir.create("./data")}
URL<-"http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")


#Load required packages

library(dplyr)
library(data.table)
library(tidyr)

#step 1: bring in data from extracted folder
filesPath <- "C:/Users/Betsy/Documents/CD continuing education/2017/data science/RWorkingDirectory/RunAnalysis/data/UCI HAR Dataset"
#training data note tr=training...70% of volunteers
tr <- read.table(file.path(filesPath,"train","X_train.txt"))
#data frame training data
dftr<-tbl_df(tr)
#subject training data ... volunteers
trsub <- read.table(file.path(filesPath,"train","subject_train.txt"))
#data frame subject training data
dftrsub<-tbl_df(trsub)
#subject activity data ...activity (walking, sitting, etc)
tract <- read.table(file.path(filesPath,"train","Y_train.txt"))
#data frame activity training data
dftract<-tbl_df(tract)
#to confirm combined dataset has the correct number of rows
print("number of rows for the training data:")
nrow(dftr)

#bring in test data....30% of volunteers
test <- read.table(file.path(filesPath,"test","X_test.txt"))
#data frame test data
dftest<-tbl_df(test)
#subject test data 
testsub <- read.table(file.path(filesPath,"test","subject_test.txt"))
#data frame subject test data
dftestsub<-tbl_df(testsub)
#subject activity data 
testact <- read.table(file.path(filesPath,"test","Y_test.txt"))
#data frame activity test data
dftestact<-tbl_df(testact)
#to confirm combined dataset has the correct number of rows
print("number of rows for the test data:")
nrow(dftest)


#####PROJECT GOAL 1#####
#step 2: merge the train & test data for each of the three datasets.  Same structure in each dataet, so v1 train = v1 test.
dataset<-rbind(dftr,dftest)
datasetsub<-rbind(dftrsub,dftestsub)
datasetact<-rbind(dftract,dftestact)
#confirm number of rows
print("dataset rows:")
nrow(dataset)
print("subject dataset rows (should match above):")
nrow(datasetsub)
print("activity dataset rows(should match above:")
nrow (datasetact)



#step 3: combine all 3 into one large dataset with readable columns
labels <- read.table(file.path(filesPath,"features.txt"))
#dataframe of labels
dflabels<-tbl_df(labels)
#apply the labels and include feature info
datalabelsuse<-setnames(dflabels,names(dflabels),c("featureNum","featureName"))
#apply human readable names to dataset columns
colnames(dataset)<-datalabelsuse$featureName
# subject data with readable col name
datasetsub <- plyr::rename(datasetsub, c("V1" = "Volunteer"))
#activities with readable columns
datasetact <- plyr::rename(datasetact, c("V1" = "activityNum"))
labelsact <- read.table(file.path(filesPath,"activity_labels.txt"))
#dataframe of activity labels
dflabelsact<-tbl_df(labelsact)
#apply human readable names to dataset columns
datalabelsuseact<-setnames(dflabelsact,names(dflabelsact),c("activityNum","activityName"))

#now that we have readable column labels, bind the subject and activity sets 
#there are no keys to perform a join (or in Excel-lingo, a lookup)...therefore assuming linear data in each table.  
#For example, row 1 in each table lines up.  Order is assumed to  be the same in each table.
datasubact<-cbind(datasetsub,datasetact)
#bind the info above with the dataset
datause<-cbind(datasubact,dataset)
dfdatause<-data.frame(datause)
# The following is for me to view the result for trial and error is getting it correct
#write.table(dfdatause,"TidyData2.txt",row.names=FALSE)



#####PROJECT GOAL 2#####
#step 4: identify cols representing mean and std
shortlist <- c("Volunteer", "activityNum", grep("mean\\(\\)|std\\(\\)",datalabelsuse$featureName,value=TRUE))
#assuming we do not want MeanFreq or gravityMean or BodyAccMean, balancing number is 66
check<-as.data.frame(table(shortlist))
print("count of fields should be 66 + 2 for Activity and Subject(Volunteer):")
nrow(check)

#put it all together to get the dataset we want to work with
datause2<-datause[, shortlist[shortlist %in% colnames(datause)]]
# The following is for me to view the result for trial and error is getting it correct
##write.table(datause2,"TidyData3.txt",row.names=FALSE)



#####PROJECT GOAL 3#####
#join dataset2 with activityName
datause3<-merge(labelsact, datause2, by.x = "activityNum", by.y = "activityNum")
# The following is for me to view the result for trial and error is getting it correct
##write.table(datause3,"TidyData4.txt",row.names=FALSE)

#####PROJECT GOAL 4#####
#create mapping from abbreviation to word, and find&replace in column header
#std()=StandardDeviation
names(datause3)<-gsub("std()", "StandardDeviation", names(datause3))
#mean()=Mean
names(datause3)<-gsub("mean()", "Mean", names(datause3))
#Acc=Accelerometer
names(datause3)<-gsub("Acc", "Accelerometer", names(datause3))
#this screws up this string "GravityAcc" become GravityAccelerometer which shoud be GravityAcceleration
names(datause3)<-gsub("GravityAccelerometer", "GravityAcceleration", names(datause3))
#Gyro=Gyroscope
names(datause3)<-gsub("Gyro", "Gyroscope", names(datause3))
#t=Time, but put the ^ for first character
names(datause3)<-gsub("^t", "Time", names(datause3))
#f=Frequency...use ^
names(datause3)<-gsub("^f", "Frequency", names(datause3))
#Mag=Magnitude
names(datause3)<-gsub("Mag", "Magnitude", names(datause3))



#####PROJECT GOAL 5#####
#rows: 30 Volunteer subjects and 6 activities = 180
#columns: 66 data measurements + 3 for Volunter, Activity Code, Activity Description
datausemean<-datause3 %>%
  group_by(Volunteer, activityName)%>%  summarise_all(funs(mean))
write.table(datausemean,"MeanData2.txt",row.names=FALSE)