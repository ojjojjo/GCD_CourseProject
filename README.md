GCD_CourseProject README
=================
This dataset is pre-processed data from the sensor signals (accelerometer and gyroscope). The data structure is very complicated. Following the instructions and preliminary exploration of the datasets, the organization of the data and how it should be processed to meet the project instructions are decribed below.

## Data Structure

1. There are two parts of the data: the train datasets and the test datasets. 

2. The train datasets contains 70% of the subjects (N = 21) and the test datasets contains 30% of the subjects (N = 9).

3. The "Body" part of the data are contained in "X_train.txt" and "X_test.txt".

4. The variable names are described in "features.txt".

5. ID information is available through "subject_test.txt" and "subject_train.txt" for "X_train.txt" and "X_test.txt" respectively.

6. "y_test.txt" and "y_train.txt" provide information on the activity information pertain to "X_test" and "X_train", and the descriptions on the readable activity is available through "activity_labels.txt".

7. Datasets in the "Inertial Signal" folders are the original data that used to generate the varaibles in the main datasets. No variable names and descriptions are available for datasets in Inertial Signal folders. Therefore, these datasets are not included in further data processing

## Data Processing Procedures
1. Import "X_train.txt", "X_test.txt" and "features.txt". Label the variable names in X_train and X_test using variable names that are provided in features.txt.

2. Add ID information using cbind function to combine subject_train with X_train, as well as subject_test with X_test.

3. Add Activity information
3.1 Read "y_train.txt" and "y_test.txt", save them as factors, and relevel them using labels available through "activity_labels.txt"
3.2 Using cbind function to combine y_train with X_train, as well as y_test with X_train.


4. The whole dataset is obtained through combining X_train and X_test using rbind. They are stacked together because they each is a subset of the whole dataset, as described ealier, that they each contains data on a subset of subjects.

5. Extracts only the measurements on the mean and standard deviation for each measurement
5.1 Extracts variables that contains "mean" and "std" in the variable names using regular expressions
5.2 Examining the variable names extracted and removed irrelavant variables manually.

6. Appropriately labels the data set with descriptive activity names
6.1 remove all "." in the variable names using regular expressions. :)
6.2 Manually fix the errors in the new variable names

7. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
7.1 Remove variables that are not the main measurements for this dataset, which are on angle() measurements.
7.2 Melt the dataframe with id variables being "ID" and "Activity"
7.3 Get the tidy dataset by casting the dataframe taking the mean of each unique combination of "ID" and "Activity"
7.4 Save the tidy dataset in a ".txt" file.