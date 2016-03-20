## This script is designed to prepare clear and tidy dataset from data of collected 
## from the accelerometers from the Samsung Galaxy S smartphone. Before using 
## this script you should download the archive of the data and unpack it to your
## working directory. Please, do not rename files or folders - this version of  
## script uses original names of files.
##
## The code was designed to instantly interact with the user, so for passing 
## every step of project (tasks), user should confirm the further execution.
## Thats why every part of code is covered in function.
##
## For correct using of this script you should have 'dplyr' package
## installed.
## 
## To begin, load this script and call "run_analysis" function without any arguments
##


## Load nesessary librarys
library(dplyr)

##
## First function just provide greeting and start loading function

run_analysis <- function(){
    print("Please, put the folder with dataset into the working directory and then enter 'Y'")
    print("...")
    answer <- readline("Do you ready to continue? (Y/N): ")
    if (tolower(answer) == "y"){
        check_datasets()
    }
}


##
## The function checks existance of main folder of data and recall start function 
## if path is incorrect. In case of success, it load the next function that start
## to load and manipulate with data.
## 
check_datasets <- function(){
    if(file.exists("./UCI HAR Dataset") == FALSE){
        message("Warning! Dataset folder is not exist. Try again.")
        run_analysis()
    }else{
        load_datasets()
    }
}

## 
##
## This function load all the needed files, create two sets of data with
## descriptive variable name. So there we do Task 4.
##
## Note: We use '<<-' operator to make final dataset global inside the function
## 
load_datasets <- function(){
    ## Create vector of a variable name
    features <- read.csv("./UCI HAR Dataset/features.txt", header = FALSE, sep = " ")
    features <- features[,2]
    ## Make the variable names descriptive
    features <- gsub("\\()","",features)
    features <- gsub("-std$","StdDev",features)
    features <- gsub("-mean","Mean",features)
    features <- gsub("^(t)","time",features)
    features <- gsub("^(f)","freq",features)
    features <- gsub("([Gg]ravity)","Gravity",features)
    features <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",features)
    features <- gsub("[Gg]yro","Gyro",features)
    features <- gsub("AccMag","AccMagnitude",features)
    features <- gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",features)
    features <- gsub("JerkMag","JerkMagnitude",features)
    features <- gsub("GyroMag","GyroMagnitude",features)
    
    print("Now we loading train and test datasets. It can take a few minute. Please, wait...")
    
    ## Load and prepare train set
    xTrain <- read.table("./UCI HAR Dataset/train/x_train.txt", header = FALSE, col.names = features)
    yTrain <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE, col.names = 'activity')
    sbTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE, col.names = 'subject')
    train <<- data.frame(c(xTrain, yTrain, sbTrain))
    rm(xTrain, yTrain, sbTrain)   ## Cleaning workspace
    print("Train set has successfully loaded!")

    
    ## Load and prepare test set
    xTest <- read.table("./UCI HAR Dataset/test/x_test.txt", header = FALSE, col.names = features)
    yTest <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE, col.names = 'activity')
    sbTest <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE, col.names = 'subject')
    test <<- data.frame(c(xTest, yTest, sbTest))
    rm(xTest, yTest, sbTest)   ## Cleaning workspace
    print("Test set has successfully loaded!")
    
    ## Waiting of the user's action to come to the next step
    answer <- readline("Do you ready to continue (Task 1)? (Y/N): ")
    if (tolower(answer) == "y"){
        merge_datasets()
    }
}

## 
## This function merge both datasets (Task 1)
## 
merge_datasets <- function(){
    final <<- rbind(train, test)
    
    print("Both dataset successfully merged! Name of the final dataset is 'final'")
    answer <- readline("Do you ready to continue (Task 2)? (Y/N): ")
    if (tolower(answer) == "y"){
        extract_meanstd()
    }
}

## 
## This function extract from final dataset only measurements on the mean
## and standard deviation (Task 2)
## 
extract_meanstd <- function(){
    extract <<- select(final, subject:activity, contains("Mean"), contains("StdDev"))
    
    print("The dataset with only mean and standart deviation is ready! Name of the extracted dataset is 'extract'")
    answer <- readline("Do you ready to continue (Task 3-5)? (Y/N): ")
    if (tolower(answer) == "y"){
        new_dataset()
    }
}

## 
## This function make new tidy dataset with the descriptive variable names and 
## with the average of each variable for each activity and each subject.
## 
new_dataset <- function(){
    ## Rename activity variables
    activities <- c("walking", "walking upstairs", "walking downstairs", "siting", "standing", "laying")
    extract <- mutate(extract, activity = activities[activity])
    
    ## Create tidy dataset
    averages <<- extract %>% group_by(subject, activity) %>% summarise_each(funs(mean))
    
    ## Write out new dataset in the file
    write.table(averages, "UCI_HAR_Averages.txt", row.name=FALSE)
    print("File with the tidy dataset has created!")
    
    ## Write out variable names to create codebook
    write.table(names(averages), "CodeBook.md", row.name=FALSE, quote=FALSE)
    print("File with the variable names has created!")
    print("Done!")
}

## Now we finished