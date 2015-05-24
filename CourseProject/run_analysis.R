#!/usr/bin/Rscript

library("utils")

# download file, remove existing directory first

dataset_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
root_dir <- "./tmp/"
dataset_dir <- paste(root_dir, "UCI HAR Dataset/", sep="")

PrepareData <- function () {

    dataset_zip <- paste(root_dir, "dataset.zip", sep="")

    unlink(root_dir, recursive = TRUE, force = TRUE)

    dir.create(path=root_dir)
    download.file(dataset_url, destfile = dataset_zip, method = "wget")

    unzip(dataset_zip, exdir=root_dir)
}

# load text file into R table

LoadData <- function () {

    l <- read.table(paste(dataset_dir, "activity_labels.txt", sep = ""), header = FALSE)
    f <- read.table(paste(dataset_dir, "features.txt", sep = ""), header = FALSE)

    xtr <- read.table(paste(dataset_dir, "train/X_train.txt", sep = ""), header = FALSE)
    ytr <- read.table(paste(dataset_dir, "train/y_train.txt", sep = ""), header = FALSE)
    sutr <- read.table(paste(dataset_dir, "train/subject_train.txt", sep = ""), header = FALSE)

    xte <- read.table(paste(dataset_dir, "test/X_test.txt", sep = ""), header = FALSE)
    yte <- read.table(paste(dataset_dir, "test/y_test.txt", sep = ""), header = FALSE)
    ste <- read.table(paste(dataset_dir, "test/subject_test.txt", sep = ""), header = FALSE)

    # fix column name for feature vectors (step 4)

    f_names <- as.vector(f$V2)
    colnames(xtr) <- f_names
    colnames(xte) <- f_names

    list("label" = l, "features" = f, "x_train" = xtr, "y_train" = ytr,
         "subject" = sutr, "x_test" = xte, "y_test" = yte, "subject_test" = ste) 
}

# 1. Merges the training and the test sets to create one data set.
# [feature], subject, label

MergeData <- function(dataset_table) {

    training <- cbind(dataset_table$x_train, dataset_table$subject, dataset_table$y_train)
    testing <- cbind(dataset_table$x_test, dataset_table$subject_test, dataset_table$y_test)
    merged <- rbind(training, testing)
   
    new_col_name <- colnames(training)
    new_col_name[length(new_col_name)-1] <- "subject"
    new_col_name[length(new_col_name)] <- "label"
    colnames(merged) <- new_col_name

    return(merged)
}

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

ExtractMeanStd <- function(dataset_table, merged) {

    mean_col <- grep('-mean\\(\\)', dataset_table$feature$V2)
    std_col <- grep('-std\\(\\)', dataset_table$feature$V2)
    total_col <- sort(c(mean_col, std_col, ncol(merged)-1, ncol(merged)))
    return(merged[,total_col])
}

# 3. Uses descriptive activity names to name the activities in the data set

AddActivityNames <- function(dataset_table, merged) {

    activity_names <- merge(x=extracted_mean_std, y=dataset_table$label, by.x = "label", by.y = "V1")
    colnames(activity_names)[which(colnames(activity_names) == "V2")] <- 'activityName'
    return(activity_names)
}

# 4. Appropriately labels the data set with descriptive variable names -> done during data loading stage

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

AverageNumber <- function(activity_names) {

    no_activity_names <- activity_names[, names(activity_names) != c("activityName")]
    aggregated_avg_number <- aggregate(no_activity_names, list(subject=no_activity_names$subject, activity=no_activity_names$label), mean)[,1:ncol(no_activity_names-2)]
    return(aggregated_avg_number)
}

Submit <- function(average_number) {
    write.table(x = average_number, file="./submit.txt", row.name=FALSE)
}

PrepareData()
dataset_table <- LoadData()
merged <- MergeData(dataset_table)
extracted_mean_std <- ExtractMeanStd(dataset_table, merged)
with_activity_names <-AddActivityNames(dataset_table, extracted_mean_std)
average_number <- AverageNumber(with_activity_names)
Submit(average_number)

