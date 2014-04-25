# You should create one R script called run_analysis.R that does the following. 
#
#  run_analysis.R
#
#
# - Merges the training and the test sets to create one data set.
# - Extracts only the measurements on the mean and standard deviation for each measurement. 
# - Uses descriptive activity names to name the activities in the data set
# - Appropriately labels the data set with descriptive activity names. 
# - Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
#

## file definitions
f_act_label <- "./activity_labels.txt"
f_features <- "./features.txt"
f_xtest <- "./test/X_test.txt"
f_ytest <- "./test/y_test.txt"
f_sub_test <- "./test/subject_test.txt"
f_xtrain <- "./train/X_train.txt"
f_ytrain <- "./train/y_train.txt"
f_sub_train <- "./train/subject_train.txt"

## read the files

# features for column names
df_features <- read.table(f_features, header = F, col.names = c("feature_id", "feature_label"))
# activity labels for id to label-cast
df_act_label <- read.table(f_act_label, header = F, col.names = c("activity_id", "activity_label"))

# set wanted column names
all_col_names <- tolower(gsub("|\\(|\\)", "", gsub("-", "_", df_features$feature_label)))
sub_col_names <- tolower(gsub("|\\(|\\)", "", gsub("-", "_", grep(".*mean\\(\\).*|.*std\\(\\).*", df_features$feature_label, value=TRUE))))


# read test-files with col.names
df_xtest <- read.table(f_xtest, header = F, col.names = all_col_names)       ## data
df_ytest <- read.table(f_ytest, header = F, col.names = "activity_id")     ## activity
df_sub_test <- read.table(f_sub_test, header = F, col.names = "subject_id") ## subject

# read train-files with col.names
df_xtrain <- read.table(f_xtrain, header = F, col.names = all_col_names)       ## data
df_ytrain <- read.table(f_ytrain, header = F, col.names = "activity_id")     ## activity
df_sub_train <- read.table(f_sub_train, header = F, col.names = "subject_id") ## subject

# get everything in one dataframe
df_complete <- rbind(cbind(df_sub_test, df_ytest, df_xtest), cbind(df_sub_train, df_ytrain, df_xtrain))
# and merge activity label based on activity_id to the dataframe
df_complete <- merge(df_complete, df_act_label, by.x = "activity_id", by.y = "activity_id", all = TRUE)

library(data.table)
## select only the needed columns
dt_part <- data.table(df_complete[, c("activity_label", "subject_id", sub_col_names)])
## calculate the mean for each column grouped by activity_label and subject_id 
dt_result <- dt_part[, lapply(.SD, mean), by=c("activity_label", "subject_id")]
## sort data to be readable
dt_result <- dt_result[with(dt_result, order(activity_label, subject_id)), ]


write.table(dt_result, "tidy_dataset.txt", row.names = FALSE)


