library(plyr)
library(reshape2)

# extract the original dataset if it hasn't been done already

if(file.exists("UCI HAR Dataset")) {
  message("dataset already extracted")
} else {
  argv <- commandArgs(TRUE)
  if(length(argv) > 1) {
    stop("need at most one command line parameter, for the dataset source zipfile name")
  }
  zipname <- ifelse(length(argv) == 0, "getdata-projectfiles-UCI HAR Dataset.zip", argv[1])
  # extract into a temporary directory first and then move it to the target
  # this is an attempt to make the extraction atomic (but it's not fully fool-proof)
  message("extracting dataset from file ", zipname[1], " into tmp directory")
  unzip(zipname, exdir = "tmp")
  message("move dataset from tmp to working directory")
  invisible(file.rename("tmp/UCI HAR Dataset", "UCI HAR Dataset"))
  invisible(file.remove("tmp"))
}

# read all the features names and set up a lookup map that indexes into the variables that we focus on later (means and standard deviations)

features.all <- read.table("UCI HAR Dataset/features.txt", colClasses = c("NULL", "character"))[[1]]
features.wanted.index <- grepl("-(mean|std)\\()", features.all)
features.wanted <- features.all[features.wanted.index]

# create a vector for the colClasses parameter of a later read.table invocation
# the variables that we don't need won't be read
# the variables we need will be read as character string -- this needs a bit more memory but keeps the same number format as the original so it's easier to troubleshoot
map <- c(`FALSE` = "NULL", `TRUE` = "character")
read.colClasses <- map[as.character(features.wanted.index)]

# clean the features names
# the requirement that everything be lowercase and no special characters in it is too strict for this dataset, because there's no need to invent another mapping for variables like "BodyAccJerk", as it should be already understood by the user of this data and this is how they are referred to in the documents
# although it makes sense to make the names more streamlined, so the structure of the name will be: {domain, variable name, statistics}
# domain can be time or freq -- this is so it's easier to scan quickly the names
# for variables with mulitple dimension the variable name is separated by a period from the name
# for example "fBodyAccJerk-mean()-Z" becomes "freq_BodyAccJerk.Z_mean" and "tBodyAccJerkMag-std()" becomes "time_BodyAccJerkMag-std"

# features.clean will contain the cleaned names
features.clean <- features.wanted
# remove the parentheses pair from the names
features.clean <- sub("\\(\\)", "", features.clean)
# put the "mean"/"std" strings to the end of the names
features.clean <- sub("^(.+)-(mean|std)-([XYZ])$", "\\1.\\3-\\2", features.clean)
# change the "f" and "t" prefixes into "freq" and "time" respectively
features.clean <- sub("^f", "freq-", features.clean)
features.clean <- sub("^t", "time-", features.clean)
# lowercase everything
features.clean <- tolower(features.clean)
# change periods (not-allowed in dataframe names) to underscores
features.clean <- gsub("-", "_", features.clean)

# read in a maping for the activity_label code to descriptive name conversion
activity_labels.names <- tolower(
  read.table("UCI HAR Dataset/activity_labels.txt",
             colClasses = c("NULL", "character"))[[1]]
)

# function that reads either the training or the testing original dataset
# merges into a single frame the needed variables, the (descriptive) activity labels and the subject id's
# also adds the dataset name ("train" or "test") as a constant column to the frame so later this can be identified
read.dataset <- function(dataset.name) {
  dataset.data_path     <- gsub("DATASET", dataset.name, "UCI HAR Dataset/DATASET/X_DATASET.txt")
  dataset.labels_path   <- gsub("DATASET", dataset.name, "UCI HAR Dataset/DATASET/y_DATASET.txt")
  dataset.subjects_path <- gsub("DATASET", dataset.name, "UCI HAR Dataset/DATASET/subject_DATASET.txt")
  print(
    system.time(
      dfrm <- read.table(dataset.data_path,
                         col.names = features.all,
                         colClasses = read.colClasses)))
  colnames(dfrm) <- features.clean
  activity_labels.coded <- read.table(dataset.labels_path)[[1]]
  activity_labels.pretty <- activity_labels.names[activity_labels.coded]
  cbind(dataset = dataset.name,
        subject = read.table(dataset.subjects_path)[[1]],
        activity = activity_labels.pretty,
        dfrm)
}

# execute the two datasets' reading and combine them into one big dataset
message("read testing dataset")
dfrm.test  <- read.dataset("test")
message("read training dataset")
dfrm.train <- read.dataset("train")
message("combine into one dataset")
dfrm <- rbind(dfrm.test, dfrm.train)

# write out the combined set into an intermediate file (useful for troubleshooting or further analysis)
# then read it back so we know everything is correct (and also the variables are converted properly into factors and numerics)
message("write combined dataset to uci_har_data.txt")
print(system.time(write.table(dfrm, "uci_har_data.txt", row.names = FALSE, quote = FALSE)))
message("read back combined dataset")
print(system.time(dfrm <- read.table("uci_har_data.txt", header = TRUE)))

# reshape the dataset into the expected tidy format and write out out to disk
message("create tidy dataset with averages")
tfrm <- ddply(dfrm, .(activity, subject), function(x) colMeans(x[4:69]))
tfrm <- melt(tfrm, .(activity, subject), value.name = "average")

message("write tidy dataset to uci_har_averages.txt")
write.table(tfrm, "uci_har_averages.txt", row.names = FALSE, quote = FALSE)

message("done.")