######################################################################
# Tit: Exercise 
# Aut: jlcr
# Date: 20140618 
######################################################################


# 0. Download and unzip the data

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists("data")){
    dir.create("data")
    download.file(fileUrl, destfile = "data/Dataset.zip", method = "curl")
    unzip("data/Dataset.zip", exdir = "data/")
}

# 1. Merge the training and the test set

# create train set 

subject_train <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
y_train <- read.table("data/UCI HAR Dataset/train/y_train.txt")
x_train <- read.table("data/UCI HAR Dataset/train/X_train.txt")
train <- data.frame(id=subject_train[,1], y = y_train[,1], x_train,train=TRUE)

rm(subject_train, y_train, x_train, fileUrl)

# create test set 

subject_test <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
y_test <- read.table("data/UCI HAR Dataset/test/y_test.txt")
x_test <- read.table("data/UCI HAR Dataset/test/X_test.txt")
test <- data.frame(id=subject_test[,1], y = y_test[,1], x_test,train=FALSE)

rm(subject_test, y_test, x_test)


# join both

datos <- rbind(train,test)

# naming x variables

nombres <- read.table("data/UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
head(nombres)
datos[1:2,1:8]
names(datos)[3:563] <- nombres$V2

# 2. Extracts only the measurements on the mean and standard deviation for each measurement

# create 2 vector characters with names of variables with mean() and std() but 
# not meanFreq()
mean_variables <- grep("mean()", names(datos), value = TRUE, fixed = TRUE)
std_variables <- grep("std()", names(datos), value = TRUE, fixed = TRUE)

# We select columns id, y, train (TRUE if train, false if test) and variables 
# with mean and standard variables
datos <- datos[c("id","y",mean_variables, std_variables,"train")]

# 3. Uses descriptive activity names to name the activities in the data set
table(datos$y)
(activity_labels <- read.table("data/UCI HAR Dataset/activity_labels.txt"))
datos$y <- factor(datos$y, levels=1:6, labels=activity_labels$V2)

# 4. Appropriately labels the data set with descriptive variable names.

# naming x variables done before

names(datos)[1:2]
names(datos)[1:2] <- c("subject","activity")

# datos has 69 variables. subject, activity, 66 measurement variables and one variable
# indicating if the row is from train or testing data set

# write data

write.csv(datos,"data/tidydat1.txt")

# 5. Creates a second, independent tidy data set with
# the average of each variable for each activity and each subject. 

library(reshape2)
library(plyr)

dat.melt <- melt(datos,id.vars=c(1,2), measure.vars=3:68)
head(dat.melt)

dat.agg <- dcast(dat.melt, activity + subject ~ variable, mean, na.rm=TRUE) 
dat.agg[1:6,1:8]

# write tidy data 2

write.csv(dat.agg, "data/tidydat2.txt")
