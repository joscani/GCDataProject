
GCDataProject
=============

Project for Getting and Cleaning Data course from coursera


## Explain run_Analysis.R

### Download data, join and naming x variables
First, we download and unzip the data into data directory. We create directory if it doesn't exist.

Create train data set using `data.frame` function to join subject_train vector, y_train vector and x_train data.frame. We do the same with test data set.

Join train data and test data using `rbind` function, `rbind` is using to combine data.frames or matrix with the same number of columns and put rows below other.


Naming x (or features) variables. Names of x variables are in features.txt file and we can use it to name our variables.

### Subset data selecting specific variables.

We select variables which mean and std. To do this task we create 2 character vector with names of this variable. We use `grep` function with some options

```
mean_variables <- grep("mean()", names(datos), value = TRUE, fixed = TRUE)
std_variables <- grep("std()", names(datos), value = TRUE, fixed = TRUE)
```
value=TRUE say to grep what return names (character) and fixed = TRUE is for select only pattern exactly. We find *mean()* but not *meanFreq()* 

Once we have the 2 character vectors we can subset data selecting columns id, y, mean_variables, std_variables and train variable. Train variable indicate where a row is from a train data set or a test data.set 

In order to clarify data.set we rename y variables like *activity* and labeling values 1,2,3,4,5,6 with WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING and
LAYING.

### Save data, and summarize

We save data in a tidy data set using `write.csv` function

We caculate means  of x variables by subject and activity and save this in a new data set. For this purpose we use `melt` and `dcast` function from `reshape2` package. Last we save this data set in a file using `write.csv` function.






