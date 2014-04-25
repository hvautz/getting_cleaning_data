## Introduction

This Readme describes the usage and contents of the R-script "run_analyses.R" for the first Peer Assessment of the Coursera - Getting and Cleaning Data Project - Course.

The purpose of this scipt is to automaticly process (tidy) a part of the given data, that was collected from the accelerometers of Samsung Galaxy S smartphones.

(Datasource: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

## Usage

- Download the datasource
- unzip the datasource
- place the R-Script in the created directory "UCI HAR Dataset"
- run the r-script

```
source("run_analyses.R")
```

## Implementation

### Cleaning Columnnames

The columnnames are stored in the file "features.txt" and are cleaned by the following steps:

- removed (,)
- replaced - with _
- all lower case


### Combining of test and training set

The datafiles for test and training-data are combined to one big dataset as following.
*(Filenames are equal, subdirectories are "test" and "train")*

- X_test.txt   (measurements)
- y_test.txt   (activity)
- subject_test.txt (subject)

The combination of each teast and training-set is done by adding subject and activity-data to the measurements (column-wise). Subsequently both combinations are bound row-wise.

Alle files are already read with the correct column names (determined by previous step) using parameter col.names.

### Merge activity labels

To provide a readable result dataset the activity-id had to be replaced with the corresponding activity-labels. Therefore the "activity_labels.txt"-File is merged with the current dataset.

```
merge(df_complete, df_act_label, by.x = "activity_id", by.y = "activity_id", all = TRUE)
```

### Datasubset

Only the measurements on the mean and standard deviation have to be processed.
Therefore the "features.txt"-file of the source-data was processed and only those records (columns) matching the following Pattern are used.

- *mean()
- *std()

The meanFreq() data is weighted and therefore not used.


### Calculation

The dataset, determined in the previous steps, is grouped by Activity and Subject.
For all remaining columns the mean is calculated.

```
dt_part[, lapply(.SD, mean), by=c("activity_label", "subject_id")]
```


### Result

The Script provides a tidy dataset by writing a text-file (tidy_dataset.txt). For better reading, the resultset is ordered by activity and subject.

