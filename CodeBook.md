Course Project Code Book
========================

Source of the original data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Original description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The attached R script (run_analysis.R) performs the following steps which are an exercise for how to tidy up a data set.

* Merges the training and test sets along with the descriptive names of the measurements in order to create one data set. The result  is a 10299 x 564 data frame. 
  This is because there were 10299 observations and each observation contains 564 components because there were 561 measurements taken per observation along with the 
  columns subject, Activity_ID, and Activity_Label.

* The script also appropriately labels the data set with descriptive names
  All column names were modified so that names starting with f were changed so that Frequency replaced f. 
  All column names were modified so that names starting with t were changed so that Time replaced t. 
  All dashes existing in any column names were removed.
  Typos in the column name containing BodyBody was changed to Body.

* The script reads the column names representing the measurements  and extracts only the measurements where the name contained f in the first character and ended 
  in either mean or std and did not contain (XYZ) at the end. The resulted in a 10299 x 8 data frame because only 8 out of the 561 column names met 
  the filter. All measurements are floating point numbers in the range (-1, 1).

  The filter resulted in the following  data set.

 'data.frame':	10299 obs. of  10 variables:
  $ subject                       : int  2 2 2 2 2 2 2 2 2 2 ...
  $ Activity_Label                : chr  "STANDING" "STANDING" "STANDING" "STANDING" ...
  $ FrequencyBodyAccMagMean       : num  -0.791 -0.954 -0.976 -0.973 -0.978 ...
  $ FrequencyBodyAccMagStdDev     : num  -0.711 -0.96 -0.984 -0.982 -0.979 ...
  $ FrequencyBodyAccJerkMagMean   : num  -0.895 -0.945 -0.971 -0.972 -0.987 ...
  $ FrequencyBodyAccJerkMagStdDev : num  -0.896 -0.934 -0.97 -0.978 -0.99 ...
  $ FrequencyBodyGyroMagMean      : num  -0.771 -0.924 -0.975 -0.976 -0.977 ...
  $ FrequencyBodyGyroMagStdDev    : num  -0.797 -0.917 -0.974 -0.971 -0.97 ...
  $ FrequencyBodyGyroJerkMagMean  : num  -0.89 -0.952 -0.986 -0.986 -0.99 ...
  $ FrequencyBodyGyroJerkMagStdDev: num  -0.907 -0.938 -0.983 -0.986 -0.991 ...

* Finally, the script creates uses the data set in the previous step as the input and creates a summary data set called "tidy__data.txt" set. 
 The data set contains the mean of each measurement for each activity and each subject.  The R object created from this tidy_data.txt can be created using the 
 tidy_data <- read.table("tidy_data.txt", header = TRUE). The dimension of the resulting data frame  is 180x10  because there are 2 variables representing subject and 
 Activity_Label respectively and the other 8 variables representing the mean measurements for the particular "subject Activity_Label" grouping.
 