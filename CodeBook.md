Course Project Code Book
========================

Source of the original data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Original description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The attached R script (run_analysis.R) performs the following steps which were part of the course project involving tidying up a data set.

* Merges the training and test sets along with the descriptive names of the measurements in order to create one data set. The result  is a 10299 x 564 data frame.
  The row dimension results from the fact that there were 10299 observations across subjects and activities. The column dimension results from the fact that were 561 
  measurements taken per observation along with the column names "subject", "Activity_ID" and "Activity_Label". Since the Activity_Label column and the Activity_ID column 
  both represented the same variable with the former being in words and the latter being codes, Activity_ID was removed from the final merged data set.

* The script reads the column names representing the measurements  and extracts only the measurements where the name contained f in the first character and ended 
  in either mean or std and did not contain X, Y, or Z at the end. The resulted in a 10299 x 8 data frame because only 8 out of the 561 measurements met 
  the filter. All measurements are floating point numbers in the range (-1, 1).

* The script also appropriately labels the data set with descriptive names
  All column names were modified so that names starting with "f" were changed so that "Frequency" replaced "f". 
  All column names were modified so that names starting with "t" were changed so that "Time" replaced "t". 
  All dashes existing in any column names were removed.
  A typo in the column name containing "BodyBody" instead of "Body" was changed to "Body".

  The previous 3 steps resulted in the following merged data set.

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

* Finally, the final merged data set in the previous step was used as the input and a tidy data set called "tidy__data.txt" was
  created as a text file. The tidy data set contains the mean of each measurement for each "subject Activity_Label" grouping.  
  The corresponding R object based on tidy_data.txt can be created using the R code "tidy_data <- read.table("tidy_data.txt", header = TRUE)". 
  The dimension of the resulting data frame  is 180x10. The row dimension results from the fact that there are 30 subjects with each subject performing 6 activities. 
  The column dimension results from the fact that there 2 columns representing subject and Activity_Label respectively and 8 other columns representing the mean 
  measurements for the particular "subject Activity_Label" grouping.
 
