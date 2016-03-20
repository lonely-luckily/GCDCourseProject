# Getting and Cleaning Data Course Project

This is the course project for the Getting and Cleaning Data Coursera course.

The R script, `run_analysis.R` is designed to prepare clear and tidy dataset from data of collected from the accelerometers from the Samsung Galaxy S smartphone.

Before using this script you should download the archive of the data and unpack it into your working directory. Please, do not rename files or folders - this version of script uses original names of files.

The code was designed to instantly interact with the user, so for passing every step of project (tasks), user should confirm the further execution. That's why every part of code is covered in function. The script does following tasks:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

All the actions that script performs also has shown directly in the script (in comments).

For correct using of this script you should have 'dplyr' package installed. Some other packages could cause problems during script execution. To prevent that is better to restart R before loading script (to clean workspace and loaded librarys).

To begin, load script and call "run_analysis" function without any arguments

The end result is shown in the file `UCI_HAR_Averages.txt`.
