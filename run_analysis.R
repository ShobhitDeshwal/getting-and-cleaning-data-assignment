
#download the file and unzip it
if (!file.exists("./data/week 4 assignment")) {dir.create("data/week 4 assignment")}
  tmp <- tempfile(fileext = ".zip")
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", tmp, quiet = TRUE, mode = "wb")
  unzip(tmp, exdir = "./data/week 4 assignment", junkpaths=T)
  unlink(tmp)


library(dplyr)

# load the data into R using read.table function for X_train, Y_train, Subtrain
# also perforn str() and head() on all of this to get a better insight of data tables arrangement
X_train <- read.table("./data/week 4 assignment/X_train.txt")
Y_train <- read.table("./data/week 4 assignment/Y_train.txt")
Sub_train <- read.table("./data/week 4 assignment/subject_train.txt")

# as above, perform the same funcitons on the test dataset and other word files provided in
#the zipfile.
X_test <- read.table("./data/week 4 assignment/X_test.txt")
Y_test <- read.table("./data/week 4 assignment/Y_test.txt")
Sub_test <- read.table("./data/week 4 assignment/subject_test.txt")


variable_names <- read.table("./data/week 4 assignment/features.txt")

activity_labels <- read.table("./data/week 4 assignment/activity_labels.txt")

# merge the datasets(train and test) to get the whole data which will be around 10299 observations,
# along the columns using rbind.
#Q1)-
X_total <- rbind(X_train, X_test)
Y_total <- rbind(Y_train, Y_test)
Sub_total <- rbind(Sub_train, Sub_test)

#search for variable mean and standard deviation(actual search strings are "mean" and "std",
# which you will get from reading variable.info). search the rows of variable_names and make   
# a subset of it( respective serial no so to easily be assigned to X_total column headers). 
#Q2)-
mn_sd_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]

# subset X_total for the selected variables, subset on the basis of column of X_total which is
# further subsetted on the basis of column 1 of selected_var because till now X_total don't 
# have column header as variable names but are as V1, V2.. so pass the column 1 and not 2 of
#selected_var
X_total <- X_total[,mn_sd_var[,1]]

#Q3 & Q4)-
# give the name "activity" to the existing column of Y_total
colnames(Y_total) <- "activity"
# give "subject" the column name to the Sub_total
colnames(Sub_total) <- "subject"
# this functin below will assign every column of X_total a header from respective selected_var
colnames(X_total)<- mn_sd_var[,2]

# create a column in Y_total and call it "activitylabel" and assign it value of the basis of
# levels of activity_labels data.table.
Y_total$activitylabel <- factor(Y_total$activity,levels = activity_labels[,1], labels = as.character(activity_labels[,2]))
activitylabel <- Y_total[,2]

#Q5)-
# bind the three i.e X_total, activitylabel, Sub_total by columns
total <- cbind(X_total, activitylabel, Sub_total)
# first group the data table by activity label and then subject and then perform mean function
# upon every column of it.
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(list(mean))
write.table(total_mean, file = "./data/week 4 assignment/tidydata.txt", row.names = FALSE)

