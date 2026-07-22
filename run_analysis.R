# Getting and Cleaning Data Course Project
#
# Usage:
#   Rscript run_analysis.R
#
# The script downloads the UCI HAR archive when it is not already present,
# combines the train and test partitions, selects mean()/std() measurements,
# applies descriptive labels, and writes tidy_data.txt.

archive_url <- paste0(
  "https://d396qusza40orc.cloudfront.net/getdata/projectfiles/",
  "UCI%20HAR%20Dataset.zip"
)
archive_file <- "UCI_HAR_Dataset.zip"
extract_dir <- "data"
dataset_dir <- file.path(extract_dir, "UCI HAR Dataset")
output_file <- "tidy_data.txt"

if (!file.exists(archive_file)) {
  download.file(archive_url, archive_file, mode = "wb")
}

if (!dir.exists(dataset_dir)) {
  unzip(archive_file, exdir = extract_dir)
}

features <- read.table(
  file.path(dataset_dir, "features.txt"),
  col.names = c("feature_id", "feature_name"),
  stringsAsFactors = FALSE
)

activity_labels <- read.table(
  file.path(dataset_dir, "activity_labels.txt"),
  col.names = c("activity_id", "activity"),
  stringsAsFactors = FALSE
)

read_partition <- function(partition) {
  measurements <- read.table(
    file.path(dataset_dir, partition, paste0("X_", partition, ".txt")),
    check.names = FALSE
  )
  names(measurements) <- features$feature_name

  activity_id <- read.table(
    file.path(dataset_dir, partition, paste0("y_", partition, ".txt"))
  )[[1]]

  subject <- read.table(
    file.path(dataset_dir, partition, paste0("subject_", partition, ".txt"))
  )[[1]]

  data.frame(
    subject = subject,
    activity_id = activity_id,
    measurements,
    check.names = FALSE
  )
}

combined <- rbind(read_partition("train"), read_partition("test"))

# Select only variables whose feature names explicitly contain mean() or std().
# This intentionally excludes meanFreq() and angle variables that merely use a
# mean vector as one argument.
selected_names <- features$feature_name[
  grepl("-mean\\(\\)|-std\\(\\)", features$feature_name)
]

selected <- combined[, c("subject", "activity_id", selected_names)]

selected$activity <- activity_labels$activity[
  match(selected$activity_id, activity_labels$activity_id)
]
selected$activity_id <- NULL

make_descriptive <- function(x) {
  x <- sub("^t", "Time", x)
  x <- sub("^f", "Frequency", x)
  x <- gsub("BodyBody", "Body", x, fixed = TRUE)
  x <- gsub("Acc", "Accelerometer", x, fixed = TRUE)
  x <- gsub("Gyro", "Gyroscope", x, fixed = TRUE)
  x <- gsub("Jerk", "Jerk", x, fixed = TRUE)
  x <- gsub("Mag", "Magnitude", x, fixed = TRUE)
  x <- gsub("-mean()", "Mean", x, fixed = TRUE)
  x <- gsub("-std()", "StandardDeviation", x, fixed = TRUE)
  x <- gsub("-X", "AxisX", x, fixed = TRUE)
  x <- gsub("-Y", "AxisY", x, fixed = TRUE)
  x <- gsub("-Z", "AxisZ", x, fixed = TRUE)
  x
}

names(selected)[3:ncol(selected)] <- make_descriptive(
  names(selected)[3:ncol(selected)]
)

# Put identifiers first and create one row for every subject-activity pair.
selected <- selected[, c(
  "subject",
  "activity",
  setdiff(names(selected), c("subject", "activity"))
)]

tidy_data <- aggregate(
  . ~ subject + activity,
  data = selected,
  FUN = mean
)

activity_order <- activity_labels$activity
tidy_data$activity <- factor(tidy_data$activity, levels = activity_order)
tidy_data <- tidy_data[order(tidy_data$subject, tidy_data$activity), ]
tidy_data$activity <- as.character(tidy_data$activity)
row.names(tidy_data) <- NULL

write.table(
  tidy_data,
  file = output_file,
  sep = ",",
  row.names = FALSE,
  col.names = TRUE,
  quote = FALSE
)

message(
  "Created ", output_file, " with ", nrow(tidy_data), " rows and ",
  ncol(tidy_data), " columns."
)
