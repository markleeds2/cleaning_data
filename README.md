cleaning_data
=========================

This is a github repository for all of the code written for the Coursera Getting and Cleaning Data Course Project given by Johns Hopkins University.
Note that only "CodeBook.md", "README.md", "run_analysis.R" and the ".gitignorefile" are contained in the repository. This is because when we tried 
to include the downloaded data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), we got a warning that we 
were exceeding the normal 50 Gigabyte limit. Therefore, the instructions that follow assume that run_analysis.R has the same parent directory as 
UCI_HAR_Dataset which is the directory obtained by unzipping the zipped file that was downloaded from the link (see below for more details on where 
this directory should reside).

## STEPS FOR CREATING AND CHECKING THE LONG FORM SUMMARY FILE: "tidy_data.txt"

* Unzip the source (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) into a directory on your local drive, say 
  "~/coursera/gcd_course/class_proj" in Linux or the analogous directory in Windows. This will result in a directory called "UCI HAR DataSet" 
  being created in the "class_proj" directory.

* Rename the created directory to "UCI_HAR_Dataset" so that the lack of underscores in the original directory does not cause any problems.
 
* Place the R code file "run_analysis.R" into "~/coursera/gcd_course/class_proj".

* Running the Code: In the RStudio source panel, type setwd("~/coursera/gcd_course/class_proj"), followed by: source("run_analysis.R") and
  run that code by clicking on the "Source" icon in the source panel.

* Checking the resulting text file: The file "tidy_data.txt" is created after "Source icon" is clicked in the previous step. One can  type 
  "summDF <- read.table("tidy_data.txt", sep = " ", header = TRUE)" in the RStudio source panel in order to read  the text file into an R data.frame 
  called summDF. summDF will be a 180x10 data.frame representing the long form of the tidy data . There are 30 subjects and 6 activities. 
  Thus, each "subject-Activity_Label" grouping  results in 180 rows. Similarly, the columns are "subject" "Activity_Label" "variable" "value" where 
  variable denotes the particular measurement description and value denotes the average value of that measurement.
