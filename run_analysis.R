##  R SCRIPT CALLED RUN_ANALYSIS.R THAT DOES THE FOLLOWING:
## 1. MERGES THE TRAINING AND THE TEST SETS TO CREATE ONE DATA SET.
## 2. EXTRACTS ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT.
## 3. USES DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATA SET
## 4. APPROPRIATELY LABELS THE DATA SET WITH DESCRIPTIVE ACTIVITY NAMES.
## 5. CREATES A SECOND, INDEPENDENT TIDY DATA SET WITH THE AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT.

if (!require("dplyr")) {
  install.packages("dplyr")
}

if (!require("tidyr")) {
  install.packages("tidyr")
}

require("tidyr")
require("dplyr")

# LOAD ACTIVITY LABELS
activity_labels <- read.table("UCI_HAR_Dataset/activity_labels.txt",stringsAsFactors=FALSE)[,2]

# LOAD DATA COLUMN NAMES
features <- read.table("UCI_HAR_Dataset/features.txt",stringsAsFactors=FALSE)[,2]

# LOAD AND PROCESS X_TEST & Y_TEST DATA.
X_test <- read.table("UCI_HAR_Dataset/test/X_test.txt",stringsAsFactors=FALSE)
y_test <- read.table("UCI_HAR_Dataset/test/y_test.txt",stringsAsFactors=FALSE)
subject_test <- read.table("UCI_HAR_Dataset/test/subject_test.txt",stringsAsFactors=FALSE)
names(X_test) = features

# APPROPRIATELY LABEL THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES.
# FIX BODYBODY NAMING ERROR IN FEATURES_INFO.TXT
# CHANGE T TO TIME,
# CHANGE F TO FREQUENCY,
# CHANGE MEAN() TO MEAN AND STD() TO STDDEV
# REMOVE UNNECESSARY DASHES
names(X_test) <- gsub("^f", "Frequency", names(X_test))
names(X_test) <- gsub("^t", "Time", names(X_test))
names(X_test) <- gsub("-mean\\(\\)", "Mean", names(X_test))
names(X_test) <- gsub("-std\\(\\)", "StdDev", names(X_test))
names(X_test) <- gsub("-", "", names(X_test))
names(X_test) <- gsub("BodyBody", "Body", names(X_test))

# LOAD ACTIVITY LABELS
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# LOAD AND PROCESS X_TRAIN & Y_TRAIN DATA.
X_train <- read.table("UCI_HAR_Dataset/train/X_train.txt",stringsAsFactors=FALSE)
y_train <- read.table("UCI_HAR_Dataset/train/y_train.txt",stringsAsFactors=FALSE)
subject_train <- read.table("UCI_HAR_Dataset/train/subject_train.txt")
names(X_train) = features

# SAME NAME IMPROVEMENTS FOR X_train AS THERE WERE FOR X_test
names(X_train) <- gsub("BodyBody", "Body", names(X_train))
names(X_train) <- gsub("^f", "Frequency", names(X_test))
names(X_train) <- gsub("^t", "Time", names(X_train))
names(X_train) <- gsub("-mean\\(\\)", "Mean", names(X_train))
names(X_train) <- gsub("-std\\(\\)", "StdDev", names(X_train))
names(X_train) <- gsub("-", "", names(X_train))

# CONSTRUCT REGULAR EXPRESSION THE MEASUREMENTS ON THE NON XYZ,
# NON TIME RELATED, MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT.
extract_features <- grepl("^f.*mean\\(\\)$|^f.*std\\(\\)$",features)

# EXTRACT ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT
# IN BOTH X_TRAIN AND X_TEST
X_test = X_test[,extract_features]
X_train = X_train[,extract_features]

# LOAD ACTIVITY DATA
y_train[,2] = activity_labels[y_train[,1]]

# CREATE THE DESCRIPTIVE NAMES
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# BIND DATA USING FILTERED TEST AND TRAIN DATA
test_data <- data.frame(subject_test, y_test, X_test, stringsAsFactors=FALSE)
train_data <- data.frame(subject_train, y_train, X_train, stringsAsFactors=FALSE)

# MERGE FILTERED TEST AND TRAIN DATA
compdata = rbind(test_data, train_data)

# NO LONGER NEED ACTIVITY_ID
compdata$Activity_ID <- NULL

id_labels   = c("subject", "Activity_Label")
data_labels = setdiff(colnames(compdata), id_labels)

# USE gather FUNCTION FROM tidyr to CONVERT DATA TO LONG
indices <- match(data_labels, names(compdata))
gath_data <- gather(compdata, "variable", "value", indices)

# USING PLYR AND CHAINING TO GET MEANS BY DATA VARIABLES
tidy_dplyr <- gath_data %>% group_by(subject, Activity_Label, variable) %>% summarize(value = mean(value, na.rm = TRUE))

# CONVERT TO PLAIN OLD DATA.FRAME
tidy_dplyr <- as.data.frame(tidy_dplyr)

# WRITE OUTPUT TO TEXT FILE
write.table(tidy_dplyr, file = "tidy_data.txt")

#chk_data <- read.table("tidy_data.txt", sep = " ", header = TRUE)
#print(head(chk_data))








