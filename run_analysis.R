#downloading and unzipping the downloaded file 
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="./Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir=".")

library(dplyr)
# Read the train tables into R
XTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
YTrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
subTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Read the test tables into R
XTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
YTest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Read the features, and activity label
Variables <- read.table("./UCI HAR Dataset/features.txt")
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# The following five steps are required by assignment
# in the module "Getting and Cleaning Data" week 4.

# 1: MERGE THE TRAINING AND TEST SETS TO CREATE ONE DATASET


XTotal <- rbind(XTest, XTrain)
YTotal <- rbind(YTest, YTrain)
subTotal <- rbind(subTest, subTrain)


# 2: EXTRACT ONLY THE MEAN AND STD FOR EACH MEASUREMENT


selectMeanStd <- Variables[grep("*mean\\(\\)*|*std\\(\\)*", Variables[ , 2]), ]
subsetX <- XTotal[ , selectMeanStd[ ,1]]

# 3: USE DESPCRIPTIVE NAMES TO NAME THE ACTIVITIES IN THE DATASET


colnames(YTotal) <- "NumericalActivityNames"
YTotal$DescriptiveActivityName <- activityLabels[YTotal[ ,1], 2]

# 4: APPROPRIATELY LABEL THE DATASET WITH VARIABLE NAMES


colnames(subsetX) <- selectMeanStd[,2]

# 5: CREATE A SECOND, INDEPENDENT TIDY DATASET WITH THE AVERAGE OF
# EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT


colnames(subTotal) <- "Subject"
TidyData <- cbind(subsetX, YTotal$DescriptiveActivityName, subTotal)
SummaryData = summarise_all(group_by(TidyData, YTotal$DescriptiveActivityName, Subject), funs(mean))
write.table(SummaryData, "./UCI HAR Dataset/TidyData.txt", row.names = FALSE)