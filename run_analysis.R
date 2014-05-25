####GCD: Course Project####
getwd()


#####Data Exploration#####
features <- read.table("./GCD/GCD_CourseProject/UCI HAR Dataset/features.txt")
names(features)
str(features)
summary(features)
head(features)
features[30:40,]

subject_test <- read.table(
  "./GCD/GCD_CourseProject/UCI HAR Dataset/test/subject_test.txt")
str(subject_test[,1])
summary(subject_test)
b <- subject_test[,1]
class(b)
table(b)
unique(b)

subject_train <- read.table(
  "./GCD/GCD_CourseProject/UCI HAR Dataset/train/subject_train.txt")
str(subject_train)
c <- subject_train[,1]
str(c)
unique(c)
table(c)


X_test <- read.table(
  "./GCD/GCD_CourseProject/UCI HAR Dataset/test/X_test.txt")
dim(X_test)
head(X_test)

X_train <- read.table(
  "./GCD/GCD_CourseProject/UCI HAR Dataset/train/X_train.txt")
str(X_train)

y_test <- read.table(
  "./GCD/GCD_CourseProject/UCI HAR Dataset/test/y_test.txt")
str(y_test)
head(y_test)
unique(y_test[,1])

y_train <- read.table(
  "./GCD/GCD_CourseProject/UCI HAR Dataset/train/y_train.txt")
str(y_train)
head(y_train)
unique(y_train[,1])

total_acc_z_train <- read.table(
  "./GCD/GCD_CourseProject/UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt")
dim(total_acc_z_train)

######Data Preparation#########

#Step 1: Read Data
# Read Variable Names
features <- read.table(
  "./GCD/GCD_CourseProject/UCI HAR Dataset/features.txt")
# Read X_test and X_train
X_test.raw <- read.table(
  "./GCD/GCD_CourseProject/UCI HAR Dataset/test/X_test.txt")
X_train.raw <- read.table(
  "./GCD/GCD_CourseProject/UCI HAR Dataset/train/X_train.txt")

X_test <- X_test.raw
X_train <- X_train.raw


#Label the variables in X_test and X_train 
#using Variable names in features.txt

VariableNames <- as.character(features[,2])
names(X_test) <- VariableNames
names(X_train) <- VariableNames

names(X_test)
names(X_train)

dim(X_test)
dim(X_train)

#Step2: IDing X_test and X_train 
#       using Subject_test.txt and Subject_train.txt respectively

#import subject_test.txt and subject_train.txt
subject_test <- read.table(
  "./GCD/GCD_CourseProject/UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table(
  "./GCD/GCD_CourseProject/UCI HAR Dataset/train/subject_train.txt")

dim(subject_test)
ID_test <- subject_test[,1]
ID_train <- subject_train[,1]
str(ID_test)
str(ID_train)
dim(X_test)
dim(X_train)

X_test.IDed <- data.frame(cbind(ID_test, X_test))
X_train.IDed <- data.frame(cbind(ID_train, X_train))


#Step3: replace integers in y_test and y_train
#        using "activity_labels.txt"

## import "activity_labels.txt"
activity_labels <- read.table(
  "./GCD/GCD_CourseProject/UCI HAR Dataset/activity_labels.txt")
as.character(activity_labels[,2])

## import "y_test.txt" and "y_train.txt"
y_test <- read.table(
  "./GCD/GCD_CourseProject/UCI HAR Dataset/test/y_test.txt")
y_train <- read.table(
  "./GCD/GCD_CourseProject/UCI HAR Dataset/train/y_train.txt")

str(y_test)
str(y_train)

y_test.factor <- factor(as.character(y_test[,1]), 
                        labels = as.character(activity_labels[,2]))
y_test.factor


y_train.factor <- factor(as.character(y_train[,1]), 
                         labels = as.character(activity_labels[,2]))
y_train.factor

#Step4: Merging X_test with y_test, X_train with y_train
X_train.ID.y <- data.frame(cbind(X_train.IDed, y_train.factor))
X_test.ID.y <- data.frame(cbind(X_test.IDed, y_test.factor))

names(X_train.ID.y)
names(X_test.ID.y)

##Step5: Data in the "Inertial Signal" Folder
# The inertial data is the original sensor data 
#   that all the rest of the data was generated from. 
# It is part of the original data from the people 
#  who created the data, but not relevant to this assignment.

#Step6: Merges the training and the test sets to create one data set.

#step 6.1
# Datasets to be merged: X_train.ID.y and X_test.ID.y
names(X_train.ID.y)
names(X_test.ID.y)
table(X_test.ID.y[,1])
table(X_train.ID.y[,1])

ID.test.unique <- unique(X_test.ID.y[,1])
ID.train.unique <- unique(X_train.ID.y[,1])

ID.test.unique %in% ID.train.unique

length(c(ID.test.unique, ID.train.unique))

#Step 6.2
# Examining the two datasets, 
#  each dataset contains data from a subset of subjects,
#  and each subject in both datasets were measured 
#    on the same sets of variables.
# Therefore, it is reasonable to stack/row_bind the two datasets.

# Step6.2.1 Examing Variable Names of both datasets, 
#             making sure both datasets have the same variable names.

which(!(names(X_train.ID.y) %in% names(X_test.ID.y))) #the n th variable that has different variable names

# Rename the first variable as "ID" and the last variable as "Activity"
names(X_train.ID.y)[c(1,563)] <- c("ID", "Activity")
names(X_test.ID.y)[c(1,563)] <- c("ID", "Activity")

# number of the variables that have different variable names
sum(!(names(X_train.ID.y) %in% names(X_test.ID.y)))

X_all.ID.y <- data.frame(rbind(X_train.ID.y, X_test.ID.y))
dim(X_all.ID.y)

#Step 7: Extracts only the measurements on the mean and standard deviation for each measurement. 

# Find variable names that contains the characters 
#  "mean" or "std"

# MEAN
MeanVarIndex <- grep("[Mm][Ee][Aa][Nn]", names(X_all.ID.y), 
                     value = FALSE)

#  Examining the Variable names to determine its eligibility
names(X_all.ID.y)[MeanVarIndex]
#  Variables that are about Mean Frequecies should not be included 
#   because it is not the mean for the measurement
#  Find out the Variables that have "Freq" in their names.

freqindex <- grep("Freq", names(X_all.ID.y)[MeanVarIndex], 
                  value = FALSE)
#  remove row index of variable names that contains "Freq"
MeanVarIndex.clean <- MeanVarIndex[-freqindex]
#  Check the remaining index representing the eiligble variables
names(X_all.ID.y)[MeanVarIndex.clean]

# STD
StdVarIndex <- grep("[Ss][Tt][Dd]", names(X_all.ID.y), 
                    value = FALSE)

# Examining the variables names on standard deviation are eligible
names(X_all.ID.y)[StdVarIndex]

# Extracts the index for columns to be extracted, plus for ID and activity
ColIndex <- c(1, MeanVarIndex.clean, StdVarIndex, 563) 

MSD.ID.y <- X_all.ID.y[ ,ColIndex]
names(MSD.ID.y)

# Rename the dataframe using appropriate variable names
names(MSD.ID.y)

#    Removing all "."
NewVariableName1 <- gsub("\\.{1,3}", "", names(MSD.ID.y))
NewVariableName1

#    The 32nd, 33rd, and 34th Variable names contains a repitition of Body
#    Removing one occurrance of "Body"
NewVariableName2 <- gsub("BodyBody", "Body", NewVariableName1)
NewVariableName2[32:34]
NewVariableName2

#    Renaming the dataframe using the new variable names
names(MSD.ID.y) <- NewVariableName2
names(MSD.ID.y)

# The dataframe "MSD.ID.y" includes only the measurements 
#   on the mean and standard deviation for each measurement and
#   the variables are labeled appropriately


#Step 8: Creates a second, independent tidy data set 
#          with the average of each variable 
#          for each activity and each subject. 

#Step 8.1: Selection of Variables.
#  Variables are selected based on information provided 
#    by "features_info.txt" document. 
#  Variables on angle() measurements are dropped 
#    because those are obtained 
#    by averaging the signals in a signal window sample.
#  Other Variables that are in "MSD.ID.y" are kept.

#  Get the column index of variables that are on angle() measurements
angleIndex <- grep("angle", names(MSD.ID.y), value = FALSE)

#  Remove the angle() measurements
MSD.ID.y.clean <- MSD.ID.y[, -angleIndex]

#  Check the variable names making sure 
#    that the angle() measurements are removed
names(MSD.ID.y.clean)

#  Creating the tidy dataset
names(MSD.ID.y)
#     Melt the dataframe, id variables are "ID" and "Activity"
MSD.ID.y.melted <- melt(MSD.ID.y.clean, id=c("ID","Activity"))
names(MSD.ID.y.melted)
dim(MSD.ID.y.melted)

#     Cast the dataframe and creating the dataframe
tidydataset <- dcast(MSD.ID.y.melted, ID + Activity ~ variable, mean)
names(tidydataset)
write.table(tidydataset, file = "./GCD/GCD_CourseProject/tidydataset.txt")



