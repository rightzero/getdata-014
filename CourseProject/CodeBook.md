### CodeBook

* The raw data set is downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. This zip file contains both training and testing sets. Each observation comes with 561 sampled features, 1 subject identifier, and 1 activity label.

* Detailed descriptions of each feature can be found in the original zip file.

* There are six different activities used in the detest - WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, and LAYING

* The cleaning and transformation performed in R script includes

  * Merge training and testing data sets.
  * Associate each column with self-explanatory names
  * Add symbolic activity names into the main table by merging with an external label table
  * Eliminate unwanted columns and only keep columns related to mean and standard deviation
  * Average means and standard deviations by the group of each activity and each subject

* The final output data set contains 180 aggregated results
