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

if (!require("tidyR")) {
  install.packages("tidyr")
}

require("data.table")
require("reshape2")
require("tidyr")

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
print(features[which(extract_features)])

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

compdata$Activity_ID <- NULL

id_labels   = c("subject", "Activity_Label")
data_labels = setdiff(colnames(compdata), id_labels)

print(head(id_labels))
print(head(data_labels))

# RESTRUCTURE INTO LONG FORM SO THAT AVERAGES CAN BE TAKEN OVER RESULTING FACTORS
melt_data  = melt(compdata, id = id_labels, measure.vars = data_labels)

# DO THE SAME RESTRUCTURING USING gather FROMM tidyr PACKAGE
indices <- match(data_labels, names(compdata))

gath_data <- gather(compdata, "variable", "value", indices)

#CONVERT FACTORS TO CHARACTER STRINGS
gath_data <- data.frame(gath_data[c(1,2)], variable = as.character(gath_data$variable), value = gath_data$value,stringsAsFactors=FALSE)
melt_data <- data.frame(melt_data[c(1,2)], variable = as.character(melt_data$variable), value = melt_data$value,stringsAsFactors=FALSE)
identical(melt_data, gath_data)

# A) NOW RUN DCAST TO GET SUBJECT, ACTIVITY MEANS
tidy_cast = dcast(melt_data, subject + Activity_Label ~ variable, mean)

# B) DO IT USING LAPPLY(SPLIT)
templist <- lapply(split(melt_data,list(melt_data$subject, melt_data$Activity_Label, melt_data$variable)), function(.df) {
                   browser()
                   datamatrix <- as.matrix(.df[,-1*c(1,2,3,4)])                   
                   variable_means <- mean(datamatrix, na.rm = TRUE)
                   avgDF <- data.frame(.df[1,c(1,2,3,4)], variable_means)
                   avgDF                        
                 })

tidy_split <- do.call(rbind, templist)

#C) DO THE SAME THING USING AGGREGATE
agg_data <- melt_data
agg_data$Activity_ID <- NULL
tidy_agg <- aggregate( agg_data[4], agg_data[-4], mean)

# D) DO THE SAME THING USING dplyr
tidy_dplyr <- melt_data %>% group_by(subject, Activity_Label, Activity_ID, variable) %>% summarize(value = mean(value, na.rm = TRUE))

tidy_dplyr <- as.data.frame(tidy_dplyr)

# E)  DO THE SAME THING USING data.table
dtbl <- data.table(melt_data)
print(head(dtbl))
tidy_dtbl <- dtbl[, mean(value), by = .(subject, Activity_Label,variable)]

#=============================================
print(head(tidy_agg))
print(head(tidy_cast))
print(head(tidy_split))
print(head(tidy_dplyr))
print(head(tidy_dtbl))

write.table(tidy_data, file = "tidy_data.txt")




