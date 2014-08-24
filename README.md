# Cleaning and tidying of the UCI HAR Dataset

This repo contains a single R script named `run_analysis.R` that can be used to convert into a tidy format the [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) from the [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/index.html).

## Prerequisites

The original data can be downloaded from [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

The script needs the `plyr` and `reshape2` R packages in the system.  
Execute `install.packages(c("plyr", "reshape2"))` from within an R session to fulfill this requirement.

## Script mechanics

The script should be run through the RScript command with any of the two invocations:

* `RScript run_analysis.R`
* `RScript run_analysis.R $ZIPFILE_NAME`

In the second format `$ZIPFILE_NAME` is the name of the dataset zip downloaded and copied into the current directory.  
In the first format, without `$ZIPFILE_NAME` given, the path is assumed to be `"getdata-projectfiles-UCI HAR Dataset.zip"`.

During execution the script creates three files:

* The `UCI HAR Dataset` subdirectory with the original dataset extracted into it (if it doesn't exist already)
* The `uci_har_data.txt` merged dataset from the original data with only the mean and standard deviation extracted for each measurement.
    * Note this is a temporary dataset halfway between the raw downloaded format and the target tidy format.
	* The usage and format is not described in this document. See the source code to get an idea of its content.
* The `uci_har_averages.txt` tidy dataset that is the main output of the analysis preparation.
    * Can be loaded back into R with `read.table("uci_har_averages.txt", header = TRUE)` for further analysis.
	* See the data description below.

## Code book

`uci_har_averages.txt` contains 66 * 30 * 6 = 11880 averaged measurements of 66 variables from 30 subjects and six activities.  
Each row is a 4-tuple of:

* **activity** &mdash; one of the six values:
    * laying
	* sitting
	* standing
	* walking
	* walking\_downstairs
	* walking\_upstairs
* **subject** &mdash; numeric value in the range of 1 to 30 (inclusive) designating the human subject's ID
* **variable** &mdash; variable name (see below)
* **average** &mdash; the average of variable for the given (subject, activity) pair

The tidied variables' names are converted from the original dataset zip. Only the ones with the mean and standard deviation aggregates are kept. In the tidy format they are made up of three parts:

* Domain name (either `time` or `freq`)
* Raw variable name
    * If 3-dimensional then the coordinate dimension (x, y, z) given as a suffix, separated by a period (.)
* Aggregate type (`mean` or `std`)

For the semantincs of the raw variable name refer to `README.txt` and it's accompanying code books `features_info.txt` and `features.txt`set (under the `UCI HAR Dataset` directory from the original dataset zip).

Full list of the variable names (and the original raw name):

* **time\_bodyacc.x\_mean** &mdash; `tBodyAcc-mean()-X`
* **time\_bodyacc.y\_mean** &mdash; `tBodyAcc-mean()-Y`
* **time\_bodyacc.z\_mean** &mdash; `tBodyAcc-mean()-Z`
* **time\_bodyacc.x\_std** &mdash; `tBodyAcc-std()-X`
* **time\_bodyacc.y\_std** &mdash; `tBodyAcc-std()-Y`
* **time\_bodyacc.z\_std** &mdash; `tBodyAcc-std()-Z`
* **time\_gravityacc.x\_mean** &mdash; `tGravityAcc-mean()-X`
* **time\_gravityacc.y\_mean** &mdash; `tGravityAcc-mean()-Y`
* **time\_gravityacc.z\_mean** &mdash; `tGravityAcc-mean()-Z`
* **time\_gravityacc.x\_std** &mdash; `tGravityAcc-std()-X`
* **time\_gravityacc.y\_std** &mdash; `tGravityAcc-std()-Y`
* **time\_gravityacc.z\_std** &mdash; `tGravityAcc-std()-Z`
* **time\_bodyaccjerk.x\_mean** &mdash; `tBodyAccJerk-mean()-X`
* **time\_bodyaccjerk.y\_mean** &mdash; `tBodyAccJerk-mean()-Y`
* **time\_bodyaccjerk.z\_mean** &mdash; `tBodyAccJerk-mean()-Z`
* **time\_bodyaccjerk.x\_std** &mdash; `tBodyAccJerk-std()-X`
* **time\_bodyaccjerk.y\_std** &mdash; `tBodyAccJerk-std()-Y`
* **time\_bodyaccjerk.z\_std** &mdash; `tBodyAccJerk-std()-Z`
* **time\_bodygyro.x\_mean** &mdash; `tBodyGyro-mean()-X`
* **time\_bodygyro.y\_mean** &mdash; `tBodyGyro-mean()-Y`
* **time\_bodygyro.z\_mean** &mdash; `tBodyGyro-mean()-Z`
* **time\_bodygyro.x\_std** &mdash; `tBodyGyro-std()-X`
* **time\_bodygyro.y\_std** &mdash; `tBodyGyro-std()-Y`
* **time\_bodygyro.z\_std** &mdash; `tBodyGyro-std()-Z`
* **time\_bodygyrojerk.x\_mean** &mdash; `tBodyGyroJerk-mean()-X`
* **time\_bodygyrojerk.y\_mean** &mdash; `tBodyGyroJerk-mean()-Y`
* **time\_bodygyrojerk.z\_mean** &mdash; `tBodyGyroJerk-mean()-Z`
* **time\_bodygyrojerk.x\_std** &mdash; `tBodyGyroJerk-std()-X`
* **time\_bodygyrojerk.y\_std** &mdash; `tBodyGyroJerk-std()-Y`
* **time\_bodygyrojerk.z\_std** &mdash; `tBodyGyroJerk-std()-Z`
* **time\_bodyaccmag\_mean** &mdash; `tBodyAccMag-mean()`
* **time\_bodyaccmag\_std** &mdash; `tBodyAccMag-std()`
* **time\_gravityaccmag\_mean** &mdash; `tGravityAccMag-mean()`
* **time\_gravityaccmag\_std** &mdash; `tGravityAccMag-std()`
* **time\_bodyaccjerkmag\_mean** &mdash; `tBodyAccJerkMag-mean()`
* **time\_bodyaccjerkmag\_std** &mdash; `tBodyAccJerkMag-std()`
* **time\_bodygyromag\_mean** &mdash; `tBodyGyroMag-mean()`
* **time\_bodygyromag\_std** &mdash; `tBodyGyroMag-std()`
* **time\_bodygyrojerkmag\_mean** &mdash; `tBodyGyroJerkMag-mean()`
* **time\_bodygyrojerkmag\_std** &mdash; `tBodyGyroJerkMag-std()`
* **freq\_bodyacc.x\_mean** &mdash; `fBodyAcc-mean()-X`
* **freq\_bodyacc.y\_mean** &mdash; `fBodyAcc-mean()-Y`
* **freq\_bodyacc.z\_mean** &mdash; `fBodyAcc-mean()-Z`
* **freq\_bodyacc.x\_std** &mdash; `fBodyAcc-std()-X`
* **freq\_bodyacc.y\_std** &mdash; `fBodyAcc-std()-Y`
* **freq\_bodyacc.z\_std** &mdash; `fBodyAcc-std()-Z`
* **freq\_bodyaccjerk.x\_mean** &mdash; `fBodyAccJerk-mean()-X`
* **freq\_bodyaccjerk.y\_mean** &mdash; `fBodyAccJerk-mean()-Y`
* **freq\_bodyaccjerk.z\_mean** &mdash; `fBodyAccJerk-mean()-Z`
* **freq\_bodyaccjerk.x\_std** &mdash; `fBodyAccJerk-std()-X`
* **freq\_bodyaccjerk.y\_std** &mdash; `fBodyAccJerk-std()-Y`
* **freq\_bodyaccjerk.z\_std** &mdash; `fBodyAccJerk-std()-Z`
* **freq\_bodygyro.x\_mean** &mdash; `fBodyGyro-mean()-X`
* **freq\_bodygyro.y\_mean** &mdash; `fBodyGyro-mean()-Y`
* **freq\_bodygyro.z\_mean** &mdash; `fBodyGyro-mean()-Z`
* **freq\_bodygyro.x\_std** &mdash; `fBodyGyro-std()-X`
* **freq\_bodygyro.y\_std** &mdash; `fBodyGyro-std()-Y`
* **freq\_bodygyro.z\_std** &mdash; `fBodyGyro-std()-Z`
* **freq\_bodyaccmag\_mean** &mdash; `fBodyAccMag-mean()`
* **freq\_bodyaccmag\_std** &mdash; `fBodyAccMag-std()`
* **freq\_bodybodyaccjerkmag\_mean** &mdash; `fBodyBodyAccJerkMag-mean()`
* **freq\_bodybodyaccjerkmag\_std** &mdash; `fBodyBodyAccJerkMag-std()`
* **freq\_bodybodygyromag\_mean** &mdash; `fBodyBodyGyroMag-mean()`
* **freq\_bodybodygyromag\_std** &mdash; `fBodyBodyGyroMag-std()`
* **freq\_bodybodygyrojerkmag\_mean** &mdash; `fBodyBodyGyroJerkMag-mean()`
* **freq\_bodybodygyrojerkmag\_std** &mdash; `fBodyBodyGyroJerkMag-std()`

#### Notes on variable naming

The `Editing Text Variables` lecture of the course has very strict restrictions on variable names, among else:

* Names of variables should be all lower case when possible
* Names of variables should be descriptive
* Names of variables should not have underscores or dots or white spaces

In my opinion these are unnecessarily restrictive for the current dataset:

* First of all it's very hard to argue that the original names could be made more descriptive. They already contain a lot of information that is intrinsic to the method of data collection and it would be awkward to change the names into something thats "more meaningful" when they already use a common terminology established by the original experimenters. In short, I don't think the data analyist should invent a new wholly new vocabulary just because at first glance `BodyBodyGyroJerkMag` doesn't look "nice". But `BodyBodyGyroJerkMag` is already documented in the original code book so there's no need to change it.
    * I nevertheless changed everything into lowercase so they look more streamlined.
* It could be argued that the three variable name components could be exploded into three variables of (domain, frequency, aggreation_method) but it's unclear whether it helps the analysis (again, it's a matter of how far we venture out from the vocabulary of the original dataset.
    * I nevertheless changed the `t` and `f` prefixes to a bit more descriptive naming so it's easier to scan the list of variables for the human eye.
* For the multi-dimensional names I chose the dot-separated prefixes because in my view these are components of a variable-group.


	
