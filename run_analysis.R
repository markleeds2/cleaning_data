##  R SCRIPT CALLED RUN_ANALYSIS.R THAT DOES THE FOLLOWING:
## 1. MERGES THE TRAINING AND THE TEST SETS TO CREATE ONE DATA SET.
## 2. EXTRACTS ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT.
## 3. USES DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATA SET
## 4. APPROPRIATELY LABELS THE DATA SET WITH DESCRIPTIVE ACTIVITY NAMES.
## 5. CREATES A SECOND, INDEPENDENT TIDY DATA SET WITH THE AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT.

if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("reshape2")

# LOAD ACTIVITY LABELS
activity_labels <- read.table("UCI_HAR/activity_labels.txt",stringsAsFactors=FALSE)[,2]

# LOAD DATA COLUMN NAMES
features <- read.table("UCI_HAR/features.txt",stringsAsFactors=FALSE)[,2]

# LOAD AND PROCESS X_TEST & Y_TEST DATA.
X_test <- read.table("UCI_HAR/test/X_test.txt",stringsAsFactors=FALSE)
y_test <- read.table("UCI_HAR/test/y_test.txt",stringsAsFactors=FALSE)
subject_test <- read.table("UCI_HAR/test/subject_test.txt",stringsAsFactors=FALSE)
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
X_train <- read.table("UCI_HAR/train/X_train.txt",stringsAsFactors=FALSE)
y_train <- read.table("UCI_HAR/train/y_train.txt",stringsAsFactors=FALSE)
subject_train <- read.table("UCI_HAR/train/subject_train.txt")
names(X_train) = features

# SAME NAME IMPROVEMENTS FOR X_train AS THERE WERE FOR X_test
names(X_train) <- gsub("BodyBody", "Body", names(X_train))
names(X_train) <- gsub("^f", "Frequency", names(X_test))
names(X_train) <- gsub("^t", "Time", names(X_train))
names(X_train) <- gsub("-mean\\(\\)", "Mean", names(X_train))
names(X_train) <- gsub("-std\\(\\)", "StdDev", names(X_train))
names(X_train) <- gsub("-", "", names(X_train))

print(names(X_train))      

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

# BIND DATA USING FILTERED DATA
test_data <- data.frame(subject_test, y_test, X_test, stringsAsFactors=FALSE)
train_data <- data.frame(subject_train, y_train, X_train, stringsAsFactors=FALSE)

# MERGE TEST AND TRAIN DATA
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_Label","Activity_ID")
data_labels = setdiff(colnames(data), id_labels)

# RESTRUCTURE INTO LONG FORM SO THAT AVERAGES CAN BE TAKEN OVER RESULTING FACTORS
melt_data  = melt(data, id = id_labels, measure.vars = data_labels)

# NOW RUN DCAST TO GET AVERAGES
tidy_data = dcast(melt_data, subject + Activity_Label ~ variable, mean)

print(head(tidy_data))

# ALSO TRY OTHER FOUR METHODS
# LAPPLY, SPLIT
# AGGREGATE
# DPLYR
# DATA.TABLE      

write.table(tidy_data, file = "./tidy_data.txt")




