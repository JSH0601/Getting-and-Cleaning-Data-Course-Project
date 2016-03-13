---
title: "CodeBook.md"
author: "JSH0601"
date: "March 12, 2016"
output: html_document
---

Initially, the UCI HAR Dataset provided a large number of records in the test data. For this analysis, we were instructed to only look at the mean and standard deviation values from the original study.

The script contained in this repository runs an analysis to pull the mean and standard deviation values from the original study data, set them aside into their own data frame, rename them, and then create a separate data frame from them that included means of each variable.

---

The script takes the following steps (described in the comments) to make what is detailed above happen:
1. load the test and training data, as well as the activity names and variable names from the folders of the original data.
2. assign the variable and activity names to their applicable columns/records
3. merge this data into one data set for test data, and one for training data.
4. merge the test and training datasets into one data set for the entire study
5. extract the columns that contain the mean and standard deviation values for each variable
6. melt the extracted columns into a dataset that can then be converted, using dcast, into the desired data frame which details the means of each variable for each subject and each activity.
