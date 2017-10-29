# BJNCourseraGCDWeek4Project
Coursera Getting and Cleaning Data Week 4 Project on Smartphone Human Activity Recognition

Human Activity Recognition Using Smartphones Dataset  v1.0
URL: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#

30 volunteers within an age bracket of 19-48 years were a part of experiment testing the activity recognition in a smartphone Samsung Galaxy S II on their waist.   The activities consisted of: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, and LAYING.

The data is from the phone's embedded accelerometer and gyroscope.  3 axis were captured: X,Y,and Z. 

The training data consists of 70% of the volunteers and the test data 30%. 

Data and CodeBook - For each record it is provided:
- X_train and X_test: A 561-feature vector with time and frequency domain variables. It's a large file that can be retrieved here: http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

- features.txt: A list of the 561 measures
	Note: t represents time, and f represents frequency
      1.	body = body movement
      2.	gravity = acceleration of gravity
      3.	std()=StandardDeviation
      4.	mean()=Mean
      5.	Acc=Accelerometer
      6.	Gyro=Gyroscope
      7.	Mag=Magnitude
      
-Y_train and Y_test: activity data. files than can be found using the link above.

- activity labels.txt: table showing the activity code and description

- subject_train.txt and subject_test.txt: An identifier of the subject (volunteer) who carried out the experiment.

- 'features_info.txt': An informational file with descriptions of  the variables used on the feature vector.

Script - run_analysis.R

Tidy Dataset - For each combination of Volunteer and Activity (180 rows), the mean of features representing the mean and standard deviation is calculated (69 columns).  The file: MeanData2.txt
